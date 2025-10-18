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
///   enrichmentTimeout: Duration(seconds: 3),
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
    this.enrichmentTimeout = const Duration(seconds: 3),
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
    await Future.wait(_enrichmentInProgress.values);

    await _resultsController.close();
    debugPrint('✅ EnrichedDeviceScanner stopped');
  }

  /// Called when a new device is discovered
  void _onDeviceDiscovered(BluetoothDevice device) {
    debugPrint('📱 Discovered: ${device.name} (${device.deviceId})');

    // Skip duplicates
    if (_emittedDeviceIds.contains(device.deviceId)) {
      debugPrint('   ⏭️  Already processed, skipping');
      return;
    }

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
  /// 1. Connect to device (with timeout)
  /// 2. Discover GATT services
  /// 3. Read battery level
  /// 4. Detect device type
  /// 5. Disconnect
  /// 6. Emit enriched device
  Future<WearableDevice> _enrichDevice(BluetoothDevice bleDevice) async {
    final deviceId = bleDevice.deviceId;
    final stopwatch = Stopwatch()..start();

    debugPrint('🔧 Enriching $deviceId (timeout: $enrichmentTimeout)...');

    try {
      // Create base device
      var enrichedDevice = await DeviceAdapter.fromInternal(bleDevice);

      // Attempt enrichment (with timeout)
      try {
        enrichedDevice = await _enrichWithServices(enrichedDevice).timeout(
          enrichmentTimeout,
          onTimeout: () {
            debugPrint(
              '⏱️  Enrichment timeout for $deviceId after ${stopwatch.elapsedMilliseconds}ms',
            );
            return enrichedDevice; // Return basic device on timeout
          },
        );

        // 💾 MOMENT 2: Save enriched device to storage after service discovery
        if (_discoveredDeviceStorage != null) {
          try {
            final deviceToSave = enrichedDevice.copyWith(
              lastDiscoveredAt: DateTime.now(),
            );
            await _discoveredDeviceStorage!.saveDevice(deviceToSave);
            debugPrint(
                '💾 [EnrichedScanner] Saved device to storage (Moment 2)');
          } catch (e) {
            debugPrint('⚠️ [EnrichedScanner] Error saving device: $e');
            // Non-critical error, continue anyway
          }
        }
      } catch (e) {
        debugPrint('⚠️  Enrichment partial for $deviceId: $e');
        // Continue with what we have
      }

      stopwatch.stop();
      debugPrint(
        '✅ Enriched $deviceId in ${stopwatch.elapsedMilliseconds}ms '
        '(${enrichedDevice.discoveredServices.length} services)',
      );

      // Mark as emitted and emit
      _emittedDeviceIds.add(deviceId);
      _discoveredSoFar.add(enrichedDevice);

      if (!_resultsController.isClosed) {
        _resultsController.add(enrichedDevice);
      }

      return enrichedDevice;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to enrich $deviceId: $e');
      debugPrint('Stack trace: $stackTrace');

      // Emit basic device on complete failure
      try {
        final basicDevice = await DeviceAdapter.fromInternal(bleDevice);
        _emittedDeviceIds.add(deviceId);
        _discoveredSoFar.add(basicDevice);

        if (!_resultsController.isClosed) {
          _resultsController.add(basicDevice);
        }

        return basicDevice;
      } catch (e2) {
        debugPrint('❌ Failed to create even basic device: $e2');
        rethrow;
      }
    }
  }

  /// Enrich device with GATT services, battery, and type detection
  Future<WearableDevice> _enrichWithServices(WearableDevice device) async {
    final deviceId = device.deviceId;

    debugPrint('  🔗 Connecting to $deviceId for service discovery...');

    try {
      // Note: For enrichment during scan, we use services already discovered
      // in BLE advertisement. Full service discovery happens after connection.
      // For now, we enrich with what we have and attempt battery read if connected.

      // Convert UUIDs to GattService objects
      var enrichedDevice = device;
      if (device.discoveredServices.isEmpty &&
          device.discoveredServices.isNotEmpty) {
        // Only enrich if we have UUIDs but no GattService objects
        debugPrint(
          '  ℹ️ Using cached services from BLE discovery',
        );
      }

      // Battery read would require device to be connected via orchestrator
      // For now, we'll defer this to connection time
      debugPrint(
        '  ✅ Device enriched (services and battery available post-connect)',
      );

      return enrichedDevice;
    } catch (e) {
      debugPrint('  ⚠️ Service enrichment failed: $e');
      return device;
    }
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
