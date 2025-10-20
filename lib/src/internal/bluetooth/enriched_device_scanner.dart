// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 🔍 Enriched Device Scanner - Dream Incubator
// Orchestrates BLE discovery + parallel connection enrichment
//
// Workflow:
// 1. Discovery Phase: Passive BLE scanning for ~5-7s
// 2. Enrichment Phase: Connect to each device in parallel
//    - Discover GATT services
//    - Read battery level
//    - Detect device type
//    - Disconnect
// 3. Progressive emission: WearableDevice objects as they're enriched

import 'dart:async';
import 'package:flutter/foundation.dart';

import '../adapters/device_adapter.dart';
import '../models/bluetooth_device.dart';
import '../storage/discovered_device_storage.dart';
import 'ble_service.dart';
import '../../api/models/wearable_device.dart';
import '../../api/models/gatt_service.dart';
import '../../api/models/device_types_loader.dart';
import '../../api/gatt_services_catalog.dart';

/// Enriched Device Scanner
///
/// Combines BLE discovery with parallel connection enrichment.
/// Emits WearableDevice objects as they're discovered and enriched.
///
/// **Usage:**
/// ```dart
/// final scanner = EnrichedDeviceScanner(
///   bleService: bleService,
///   discoveredDevicesStream: bleService.rawBleDevicesStream,
///   duration: Duration(seconds: 10),
///   parallelism: 3,
///   enrichmentTimeout: Duration(seconds: 7),
/// );
///
/// await scanner.start();
/// await for (final device in scanner.resultsStream) {
///   print('Found: ${device.name} (${device.discoveredServices.length} services)');
/// }
/// ```
class EnrichedDeviceScanner {
  /// Initialize the scanner
  EnrichedDeviceScanner({
    required this.bleService,
    required this.discoveredDevicesStream,
    this.duration = const Duration(seconds: 10),
    this.parallelism = 3,
    this.enrichmentTimeout = const Duration(seconds: 7),
  }) : assert(parallelism >= 1, 'Parallelism must be >= 1');

  /// BLE Service for device connectivity
  final BleService bleService;

  /// Stream of raw discovered devices from BLE scan
  final Stream<BluetoothDevice> discoveredDevicesStream;

  /// Total scan duration
  final Duration duration;

  /// Number of concurrent device enrichments
  final int parallelism;

  /// Timeout per device enrichment
  final Duration enrichmentTimeout;

  /// Results stream (enriched devices)
  late final StreamController<WearableDevice> _resultsController =
      StreamController<WearableDevice>.broadcast();

  /// Cache of devices being enriched or enriched
  final Map<String, Future<WearableDevice>> _enrichmentInProgress = {};

  /// Cache of enriched devices (avoid duplicates)
  final Set<String> _emittedDeviceIds = {};

  /// Queue of devices waiting for enrichment
  final List<BluetoothDevice> _enrichmentQueue = [];

  /// Active enrichment tasks (for concurrency limiting)
  int _activeEnrichments = 0;

  /// Subscription to discovery stream
  StreamSubscription<BluetoothDevice>? _discoverySubscription;

  /// Scan timer (to stop scanning after duration)
  Timer? _scanTimer;

  /// Whether scanner has been started
  bool _isRunning = false;

  /// Storage for discovered devices (optional, for persistence)
  DiscoveredDeviceStorage? _discoveredDeviceStorage;

  /// Set the discovered device storage (dependency injection)
  set discoveredDeviceStorage(DiscoveredDeviceStorage? storage) {
    _discoveredDeviceStorage = storage;
  }

  /// Public results stream (enriched devices)
  Stream<WearableDevice> get resultsStream => _resultsController.stream;

  /// List of all devices discovered so far (enriched or basic)
  final List<WearableDevice> _discoveredSoFar = [];

  /// Getter for discovered devices
  List<WearableDevice> get discoveredSoFar =>
      List.unmodifiable(_discoveredSoFar);

  /// Start the scan
  ///
  /// Subscribes to discovery stream and starts enrichment pipeline.
  /// Emits devices progressively as they're enriched.
  Future<void> start() async {
    if (_isRunning) {
      debugPrint('⚠️  EnrichedDeviceScanner already running');
      return;
    }

    _isRunning = true;
    debugPrint(
      '🔍 EnrichedDeviceScanner starting (duration: $duration, parallelism: $parallelism)',
    );

    try {
      // Subscribe to discovery stream
      _discoverySubscription = discoveredDevicesStream.listen(
        _onDeviceDiscovered,
        onError: (error) {
          debugPrint('❌ Discovery stream error: $error');
        },
        onDone: () {
          debugPrint('✅ Discovery stream completed');
        },
      );

      // Stop scanning after total duration
      _scanTimer = Timer(duration, _stopScanning);

      debugPrint('✅ EnrichedDeviceScanner started');
    } catch (e) {
      debugPrint('❌ EnrichedDeviceScanner start failed: $e');
      _isRunning = false;
      rethrow;
    }
  }

  /// Stop the scan and wait for pending enrichments
  Future<void> stop() async {
    debugPrint('🛑 EnrichedDeviceScanner stopping...');

    _isRunning = false;
    _scanTimer?.cancel();

    await _discoverySubscription?.cancel();
    _discoverySubscription = null;

    // Wait for any pending enrichments
    debugPrint(
      '⏳ Waiting for ${_enrichmentInProgress.length} pending enrichments...',
    );
    // Use eagerError: false to wait for all enrichments even if some fail
    // This prevents unhandled exceptions from propagating up
    await Future.wait(
      _enrichmentInProgress.values,
      eagerError: false,
    );

    await _resultsController.close();
    debugPrint('✅ EnrichedDeviceScanner stopped');
  }

  /// Called when a new device is discovered
  void _onDeviceDiscovered(BluetoothDevice device) {
    // 🚫 FILTER #1: Skip devices without valid name
    final name = device.name;
    final hasValidName = name.isNotEmpty && name != 'Unknown Device';
    if (!hasValidName) {
      debugPrint(
        '🚫 [EnrichedScanner] Skipping device without valid name: "$name" (${device.deviceId})',
      );
      return;
    }

    debugPrint('📱 Discovered: $name (${device.deviceId})');

    // ✅ CRITICAL: Skip if already emitted OR IN PROGRESS (by same or different name)
    // Prevents multiple enrichments of the same MAC address
    // Use MAC (deviceId) as stable identifier, not name (which can change)
    if (_emittedDeviceIds.contains(device.deviceId)) {
      debugPrint(
        '   ⏭️  Already processed (MAC: ${device.deviceId}), skipping',
      );
      return;
    }

    // 🔒 MARK AS IN PROGRESS IMMEDIATELY to prevent duplicate enrichments
    // This is critical because enrichment is async and same MAC can advertise
    // with different names during BLE scan
    _emittedDeviceIds.add(device.deviceId);

    // Add to enrichment queue
    _enrichmentQueue.add(device);

    // Process queue (respecting parallelism limit)
    _processEnrichmentQueue();
  }

  /// Process enrichment queue with parallelism limit
  void _processEnrichmentQueue() {
    while (_enrichmentQueue.isNotEmpty &&
        _activeEnrichments < parallelism &&
        _isRunning) {
      final device = _enrichmentQueue.removeAt(0);

      // Start enrichment in background
      final enrichmentFuture = _enrichDevice(device);

      // Track in-progress enrichment
      _enrichmentInProgress[device.deviceId] = enrichmentFuture;
      _activeEnrichments++;

      // Continue processing queue when this enrichment completes
      enrichmentFuture.then((_) {
        _activeEnrichments--;
        _enrichmentInProgress.remove(device.deviceId);
        _processEnrichmentQueue();
      }).catchError((error) {
        debugPrint('❌ Enrichment error: $error');
        _activeEnrichments--;
        _enrichmentInProgress.remove(device.deviceId);
        _processEnrichmentQueue();
      });
    }
  }

  /// Enrich a single device
  ///
  /// Steps:
  /// 1. Connect to device
  /// 2. Discover GATT services
  /// 3. Read battery level
  /// 4. Detect device type
  /// 5. Disconnect
  /// 6. ONLY emit if fully enriched (has services discovered)
  ///
  /// **CRITICAL**: Only emit devices that are FULLY enriched.
  /// Do NOT emit partial/basic devices with 0 services.
  Future<WearableDevice> _enrichDevice(BluetoothDevice bleDevice) async {
    final deviceId = bleDevice.deviceId;
    final stopwatch = Stopwatch()..start();

    debugPrint('🔧 Enriching $deviceId (timeout: $enrichmentTimeout)...');

    try {
      // Create base device
      var enrichedDevice = await DeviceAdapter.fromInternal(bleDevice);

      // Perform full enrichment (services discovery is mandatory)
      try {
        enrichedDevice = await _enrichWithServices(enrichedDevice).timeout(
          enrichmentTimeout,
          onTimeout: () {
            // ❌ TIMEOUT = INCOMPLETE ENRICHMENT
            // Throw exception to skip emission
            throw TimeoutException(
              'Service enrichment timeout after ${stopwatch.elapsedMilliseconds}ms',
              enrichmentTimeout,
            );
          },
        );
      } catch (e) {
        // ❌ ENRICHMENT FAILED
        debugPrint('❌ Service enrichment failed for $deviceId: $e');
        debugPrint('   Device type: ${bleDevice.runtimeType}');
        debugPrint('   Device paired: ${bleDevice.paired}');
        debugPrint('   Device isSystemDevice: ${bleDevice.isSystemDevice}');

        // � CRITICAL CHANGE: Emit bonded/paired devices EVEN IF enrichment fails
        // This ensures paired devices from Android system are always shown
        if (bleDevice.paired || bleDevice.isSystemDevice) {
          debugPrint(
            '✅ BONDED DEVICE: Emitting $deviceId despite enrichment failure '
            '(paired=${bleDevice.paired}, isSystemDevice=${bleDevice.isSystemDevice})',
          );

          // Create minimal device object with what we have
          var partialDevice = await DeviceAdapter.fromInternal(bleDevice);
          partialDevice = partialDevice.copyWith(
            discoveredServices: [], // No services enriched
            lastDiscoveredAt: DateTime.now(),
          );

          // ✅ EMIT bonded device even with no services
          // (deviceId already in _emittedDeviceIds since _onDeviceDiscovered())
          _discoveredSoFar.add(partialDevice);
          if (!_resultsController.isClosed) {
            _resultsController.add(partialDevice);
          }

          return partialDevice;
        }

        // 🚫 For non-bonded devices, still skip if enrichment fails
        debugPrint(
          '🚫 Skipping $deviceId (enrichment failed, NOT a bonded device)',
        );
        rethrow;
      }

      stopwatch.stop();

      // ✅ ONLY EMIT IF FULLY ENRICHED (has services)
      if (enrichedDevice.discoveredServices.isEmpty) {
        debugPrint(
          '🚫 Skipping $deviceId (enriched but NO services discovered)',
        );
        throw Exception('Device enrichment produced 0 services for $deviceId');
      }

      debugPrint(
        '✅ Enriched $deviceId in ${stopwatch.elapsedMilliseconds}ms '
        '(${enrichedDevice.discoveredServices.length} services)',
      );

      // 💾 Save enriched device to storage BEFORE emission
      if (_discoveredDeviceStorage != null) {
        try {
          final deviceToSave = enrichedDevice.copyWith(
            lastDiscoveredAt: DateTime.now(),
          );
          await _discoveredDeviceStorage!.saveDevice(deviceToSave);
          debugPrint(
            '💾 [EnrichedScanner] Saved fully enriched device to storage',
          );
        } catch (e) {
          debugPrint('⚠️ [EnrichedScanner] Error saving device: $e');
          // Non-critical error, continue anyway
        }
      }

      // ✅ EMIT enriched device (guaranteed to have services)
      // (deviceId already in _emittedDeviceIds since _onDeviceDiscovered())
      _discoveredSoFar.add(enrichedDevice);

      if (!_resultsController.isClosed) {
        _resultsController.add(enrichedDevice);
      }

      return enrichedDevice;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to enrich $deviceId: $e');
      debugPrint('Stack trace: $stackTrace');

      // 🚫 DO NOT EMIT: Device enrichment failed or incomplete
      debugPrint(
        '🚫 Device $deviceId NOT emitted (enrichment incomplete/failed)',
      );

      // Throw to satisfy Future contract and prevent further processing
      throw Exception('Device enrichment failed for $deviceId');
    }
  }

  /// Connects to a device with exponential backoff retry logic.
  /// Handles error 133 (GATT error) with automatic retries.
  ///
  /// Retry strategy:
  /// - Attempt 1: immediate
  /// - Attempt 2: wait 500ms, then retry
  /// - Attempt 3: wait 1000ms, then retry
  /// - If all fail, rethrow the error
  Future<void> _connectWithRetry(
    String deviceId, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxAttempts) {
      try {
        attempt++;
        await bleService.connectDevice(deviceId);
        return; // Success
      } catch (e) {
        final errorMsg = e.toString();
        final isGattError = errorMsg.contains('133') ||
            errorMsg.contains('GATT') ||
            errorMsg.contains('Gatt error') ||
            errorMsg.contains('gatt error');

        if (isGattError && attempt < maxAttempts) {
          debugPrint(
            '  ⚠️  GATT error 133 on attempt $attempt/$maxAttempts - '
            'retrying in ${delay.inMilliseconds}ms',
          );
          await Future.delayed(delay);
          // Exponential backoff: 500ms → 1000ms → 2000ms
          delay = Duration(milliseconds: delay.inMilliseconds * 2);
        } else {
          // Non-GATT error or final attempt
          rethrow;
        }
      }
    }
  }

  /// Enrich device with GATT services, battery, and type detection
  ///
  /// Full enrichment process:
  /// 1. Connect to device (with retry logic for error 133)
  /// 2. Discover GATT services
  /// 3. Convert to GattService objects using GattServicesCatalog
  /// 4. Auto-detect device type from services using DeviceTypesLoader
  /// 5. Disconnect
  /// 6. Return enriched device with deviceTypeId and icon/color set
  Future<WearableDevice> _enrichWithServices(WearableDevice device) async {
    final deviceId = device.deviceId;

    debugPrint('  🔗 Connecting to $deviceId for service discovery...');

    try {
      // STEP 1: Connect to device (with retry logic for error 133)
      await _connectWithRetry(deviceId);
      debugPrint('  ✅ Connected to $deviceId');

      // STEP 2: Discover GATT services
      final discoveredServiceUuids =
          await bleService.discoverServices(deviceId);
      debugPrint(
        '  📡 Discovered ${discoveredServiceUuids.length} services: $discoveredServiceUuids',
      );

      // STEP 3: Convert service UUIDs to GattService objects using catalog
      final enrichedServices = <GattService>[];
      for (final serviceUuid in discoveredServiceUuids) {
        try {
          // Extract short UUID (e.g., "180D" from full UUID)
          final shortUuid = GattServicesCatalog.extractShortUuid(serviceUuid);

          // Look up service definition in catalog
          final catalogService =
              await GattServicesCatalog.getService(shortUuid);

          if (catalogService != null) {
            // Service found in catalog
            enrichedServices.add(catalogService);
            debugPrint('    ✓ ${catalogService.name} ($shortUuid)');
          } else {
            // Service not in catalog, create generic entry
            final genericService = GattService(
              uuid: shortUuid,
              name: 'Unknown Service',
              description: 'Service $shortUuid not in registry',
              category: 'vendor',
              iconName: 'help_outline',
              colorName: 'grey',
              isGeneric: false,
            );
            enrichedServices.add(genericService);
            debugPrint('    ? Unknown service $shortUuid (not in catalog)');
          }
        } catch (e) {
          debugPrint('    ⚠️ Error processing service $serviceUuid: $e');
          // Continue with next service
          continue;
        }
      }

      debugPrint('  📋 Enriched ${enrichedServices.length} services');

      // STEP 3.5: Read battery level from Battery Service (0x180F)
      int? batteryLevel;
      try {
        // Check for Battery Service - handle case-insensitive UUIDs
        final hasBatteryService = discoveredServiceUuids.any((uuid) {
          final lowercaseUuid = uuid.toLowerCase();
          return lowercaseUuid == '180f' ||
              lowercaseUuid == '0000180f-0000-1000-8000-00805f9b34fb';
        });

        if (hasBatteryService) {
          // Battery Service found, try to read battery level (0x2A19)
          final batteryBytes = await bleService.readCharacteristic(
            deviceId: deviceId,
            serviceUuid: '180F',
            characteristicUuid: '2A19',
          );

          if (batteryBytes != null && batteryBytes.isNotEmpty) {
            // Battery level is first byte (0-100%)
            batteryLevel = batteryBytes[0];
            debugPrint('  🔋 Battery level: $batteryLevel%');
          } else {
            debugPrint('  ⚠️ Battery Service found but no data available');
          }
        } else {
          debugPrint('  ℹ️ No Battery Service (0x180F) discovered');
        }
      } catch (e) {
        debugPrint('  ⚠️ Failed to read battery: $e (non-critical)');
        // Continue without battery level - not critical
      }

      // STEP 4: Auto-detect device type from discovered services
      String detectedTypeId = 'unknown';
      try {
        // Import DeviceTypesLoader for detection
        final typeLoader = _getDeviceTypeLoader();
        final detectedType = await typeLoader.detectDeviceType(
          discoveredServiceUuids,
        );
        detectedTypeId = detectedType.id;
        debugPrint(
          '  🎯 Auto-detected device type: ${detectedType.name} (id: $detectedTypeId)',
        );
      } catch (e) {
        debugPrint('  ⚠️ Device type detection failed: $e (using "unknown")');
        detectedTypeId = 'unknown';
      }

      // STEP 5: Create enriched device with discovered services AND detected type
      var enrichedDevice = device.copyWith(
        discoveredServices:
            enrichedServices.isNotEmpty ? enrichedServices : null,
        deviceTypeId: detectedTypeId,
        batteryLevel: batteryLevel,
      );

      // STEP 6: Disconnect after enrichment
      try {
        await bleService.disconnectDevice(deviceId);
        debugPrint('  👋 Disconnected from $deviceId after enrichment');
      } catch (e) {
        debugPrint('  ⚠️ Error disconnecting: $e (non-critical)');
      }

      debugPrint(
        '  ✅ Device enriched (${enrichedServices.length} services, type: $detectedTypeId)',
      );

      return enrichedDevice;
    } catch (e) {
      debugPrint('  ⚠️ Service enrichment failed: $e');
      // Try to disconnect on error
      try {
        await bleService.disconnectDevice(deviceId);
      } catch (_) {
        // Ignore disconnect errors
      }
      rethrow; // Re-throw to trigger failure handling in _enrichDevice
    }
  }

  /// Helper to get DeviceTypesLoader instance
  DeviceTypesLoader _getDeviceTypeLoader() {
    return DeviceTypesLoader();
  }

  /// Stop scanning (called by timer)
  Future<void> _stopScanning() async {
    if (!_isRunning) return;

    debugPrint('⏱️  Scan duration reached, stopping discovery...');
    await stop();
  }

  /// Dispose scanner resources
  Future<void> dispose() async {
    await stop();
  }
}
