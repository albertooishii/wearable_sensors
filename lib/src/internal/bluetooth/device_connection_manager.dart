// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:wearable_sensors/wearable_sensors.dart';
// 🌐 Device Connection Manager - Dream Incubator
// Vendor-agnostic coordinator for ALL device connections
//
// Responsibilities:
// - Initialize connection system at app startup
// - Manage multiple device connections (Map<deviceId, orchestrator>)
// - Auto-reconnect saved devices
// - Detect vendor from deviceId and create appropriate orchestrator
// - Provide unified streams for UI/background services

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wearable_sensors/src/internal/bluetooth/vendor_orchestrator.dart';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:wearable_sensors/src/internal/bluetooth/bluetooth_classic_service.dart';
import 'package:wearable_sensors/src/internal/bluetooth/spp_v2_config.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_connection_orchestrator.dart';
import 'package:wearable_sensors/src/internal/models/bluetooth_device.dart';
import 'package:wearable_sensors/src/internal/utils/xiaomi_device_detection.dart';
import 'package:wearable_sensors/src/internal/adapters/device_adapter.dart';
import '../storage/discovered_device_storage.dart';

/// Vendor detection result
enum DeviceVendor { xiaomi, fitbit, apple, generic, unknown }

/// Device Connection Manager - Singleton
///
/// **Vendor-agnostic coordinator** for all device connections.
///
/// **Workflow:**
/// 1. **App Startup (main.dart):**
///    ```dart
///    final manager = DeviceConnectionManager();
///    await manager.initialize();
///    ```
///
/// 2. **UI Connect:**
///    ```dart
///    await DeviceConnectionManager.instance.connectDevice(deviceId);
///    ```
///
/// 3. **Background Service:**
///    ```dart
///    await manager.ensureConnected(deviceId);
///    manager.getBiometricStream(deviceId).listen(...);
///    ```
///
/// **Based on:** Gadgetbridge's DeviceSupportFactory pattern
class DeviceConnectionManager {
  factory DeviceConnectionManager() => _instance;
  DeviceConnectionManager._internal();
  static final DeviceConnectionManager _instance =
      DeviceConnectionManager._internal();

  // Core services (injected during initialize)
  late final BleService _bleService;
  late final BluetoothClassicService _btClassicService;

  // Active connections (deviceId → orchestrator)
  final Map<String, VendorOrchestrator> _activeConnections = {};

  // ✅ Stream subscriptions per device (to cancel on disconnect/reconnect)
  final Map<String, List<StreamSubscription<dynamic>>> _streamSubscriptions =
      {};

  // Storage for discovered devices (bonded device enrichment)
  DiscoveredDeviceStorage? _discoveredDeviceStorage;

  // Stream controller for device states (UI consumption)
  final StreamController<Map<String, WearableDevice>> _deviceStatesController =
      StreamController<Map<String, WearableDevice>>.broadcast();

  // Current device states cache
  final Map<String, WearableDevice> _deviceStates = {};

  bool _isInitialized = false;

  /// Public getter for instance
  static DeviceConnectionManager get instance => _instance;

  /// Public getter for BleService (needed for WearableSensors.getBluetoothStatus())
  BleService get bleService => _bleService;

  /// Device states stream (all devices) - For UI consumption
  ///
  /// This stream emits unified device state including:
  /// - Connection state (connecting, connected, streaming, error)
  /// - Battery level (0-100%, null if unavailable)
  /// - Last biometric data timestamp
  Stream<Map<String, WearableDevice>> get deviceStatesStream =>
      _deviceStatesController.stream;

  /// Get current connection states (synchronous)
  Map<String, ConnectionState> get connectionStates => Map.unmodifiable(
        _activeConnections.map(
          (final id, final orch) => MapEntry(id, orch.currentState),
        ),
      );

  /// Get current device states (synchronous) - For UI consumption
  Map<String, WearableDevice> get deviceStates =>
      Map.unmodifiable(_deviceStates);

  /// Get active orchestrators (for advanced usage like battery stream subscription)
  ///
  /// **Internal use only** - Used by BiometricIntegrationService to subscribe to
  /// batteryStream from BT_CLASSIC orchestrators for bonded devices.
  Map<String, VendorOrchestrator> get activeConnections =>
      Map.unmodifiable(_activeConnections);

  /// Initialize connection system
  ///
  /// **Must be called in main.dart before runApp()**
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   final manager = DeviceConnectionManager();
  ///   await manager.initialize();
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  Future<void> initialize({
    DiscoveredDeviceStorage? discoveredDeviceStorage,
  }) async {
    if (_isInitialized) {
      debugPrint('⚠️  DeviceConnectionManager already initialized');
      return;
    }

    debugPrint('🚀 Initializing DeviceConnectionManager...');

    // Store discovered device storage (for bonded device enrichment)
    _discoveredDeviceStorage = discoveredDeviceStorage;

    // Initialize core services
    _bleService = BleService();
    await _bleService.initialize();

    _btClassicService = BluetoothClassicService();
    await _btClassicService.initialize();

    // 🔌 Load bonded/paired devices from system
    await _loadBondedDevices();

    // 🔍 Subscribe to discovered devices stream (populate _deviceStates as devices are found)
    // This ensures discovered devices are enriched and emitted via deviceStatesStream
    discoveredDevicesStream.listen(
      (_) {
        // asyncMap in discoveredDevicesStream handles enrichment + emission
        // Just need to consume the stream to trigger the asyncMap
      },
      onError: (error) {
        debugPrint('❌ Error in discoveredDevicesStream: $error');
      },
    );

    _isInitialized = true;
    debugPrint('✅ DeviceConnectionManager initialized');
  }

  /// Connect to a device (vendor detection automatic)
  ///
  /// **Workflow:**
  /// 1. Detect vendor from deviceId
  /// 2. Create appropriate orchestrator (Xiaomi, Fitbit, etc.)
  /// 3. Connect and authenticate
  /// 4. Store in active connections
  ///
  /// **Throws:** Exception if connection fails
  Future<void> connectDevice(final String deviceId) async {
    if (!_isInitialized) {
      throw Exception('DeviceConnectionManager not initialized');
    }

    debugPrint('🔌 DeviceConnectionManager: Connecting $deviceId');

    try {
      // 1. Check if already connected
      if (_activeConnections.containsKey(deviceId)) {
        final existing = _activeConnections[deviceId]!;

        // 🔥 FIX: Always verify real Bluetooth connection status
        // Orchestrator state can be stale if connection dropped silently
        final btClassic = BluetoothClassicService();
        final isReallyConnected = btClassic.isConnected(deviceId);

        if ((existing.currentState == ConnectionState.connected ||
                existing.currentState == ConnectionState.streaming) &&
            isReallyConnected) {
          debugPrint('   ℹ️  Device already connected (verified)');
          return;
        }

        // Remove stale/zombie orchestrator
        debugPrint(
          '   🧹 Removing stale orchestrator - state: ${existing.currentState}, realConnection: $isReallyConnected',
        );
        await existing.disconnect();
        _activeConnections.remove(deviceId);

        // ✅ Cancel previous stream subscriptions
        await _cancelStreamSubscriptions(deviceId);
      }

      // 2. Detect vendor
      // Try to get device name from BLE service for improved detection
      String? deviceName;
      try {
        final btDevice = await _bleService.getBluetoothDeviceAsync(deviceId);
        deviceName =
            btDevice.platformName.isNotEmpty ? btDevice.platformName : null;
        if (deviceName != null) {
          debugPrint('   📱 Device name: $deviceName');
        }
      } catch (e) {
        debugPrint('   ⚠️  Could not get device name: $e');
      }

      final vendor = await _detectVendor(deviceId, deviceName);
      debugPrint('   🔍 Detected vendor: $vendor');

      // 3. Create orchestrator (await because it initializes SppV2Config)
      final orchestrator = await _createOrchestrator(vendor);

      // 4. Initialize device state
      _deviceStates[deviceId] = WearableDevice(
        deviceId: deviceId,
        connectionState: ConnectionState.disconnected,
      );

      // 🔴 FIX: Add orchestrator to _activeConnections BEFORE subscribing
      // This ensures that when state changes come in, _activeConnections is populated
      // so that _emitConnectionStates() has data to emit
      _activeConnections[deviceId] = orchestrator;

      // ✅ 5. Subscribe to orchestrator streams (store subscriptions for cleanup)
      // All updates go through _updateDeviceState() which emits to _deviceStatesController
      // NO emitting to legacy _connectionStatesController (not exposed in public API)
      final subscriptions = <StreamSubscription<dynamic>>[];

      subscriptions.add(
        orchestrator.connectionStateStream.listen((final state) {
          debugPrint('📡 [DCM] Connection state changed: $state');
          _updateDeviceState(deviceId, connectionState: state);
          // ✅ _updateDeviceState() emits to _deviceStatesController
          // 🚫 NO _emitConnectionStates() - that's internal legacy stream
        }),
      );

      subscriptions.add(
        orchestrator.batteryStream.listen((final battery) {
          debugPrint('🔋 [DCM] Battery updated: $battery%');
          _updateDeviceState(deviceId, batteryLevel: battery);
        }),
      );

      subscriptions.add(
        orchestrator.biometricDataStream.listen((final data) {
          debugPrint('📊 [DCM] Biometric data received at ${data.timestamp}');
          _updateDeviceState(deviceId, lastDataTimestamp: data.timestamp);
        }),
      );

      subscriptions.add(
        orchestrator.errorStream.listen((final error) {
          debugPrint('⚠️ [DCM] Device error: ${error.message}');
          _updateDeviceState(deviceId, error: error);
        }),
      );

      // Store subscriptions for cleanup
      _streamSubscriptions[deviceId] = subscriptions;

      // 6. Connect
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('🔗 [DCM] Calling orchestrator.connectAndAuthenticate()');
      await orchestrator.connectAndAuthenticate(deviceId);
      debugPrint('✅ [DCM] connectAndAuthenticate() COMPLETED successfully');
      debugPrint('═══════════════════════════════════════════════════');

      // 7. ✅ Update device state with discovered device type
      // This is set during orchestrator initialization and ensures
      // BiometricDataReader can use it even in SPP mode (no BLE services)
      debugPrint('🔍 [DCM] After successful connectAndAuthenticate:');
      debugPrint(
        '   - orchestrator.discoveredDeviceTypeId: ${orchestrator.discoveredDeviceTypeId}',
      );
      if (orchestrator.discoveredDeviceTypeId != null) {
        debugPrint(
          '   ✅ Updating deviceTypeId to: ${orchestrator.discoveredDeviceTypeId}',
        );
        _updateDeviceState(
          deviceId,
          deviceTypeId: orchestrator.discoveredDeviceTypeId,
        );
      } else {
        debugPrint('   ⚠️ discoveredDeviceTypeId is null, skipping update');
      }

      // ✅ Orchestrator already stored in _activeConnections before subscriptions
      // (see step 4 above - moved before subscribing for stream emission)

      debugPrint('✅ DeviceConnectionManager: Device connected');
    } on Exception catch (e, stackTrace) {
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('❌ [DCM] connectAndAuthenticate() FAILED with exception:');
      debugPrint('   Exception: $e');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('Stack trace: $stackTrace');

      // ✅ NEW: Detect if error is authentication-related (missing credentials)
      // Mark device with requiresAuthentication = true so UI can show "Authenticate" button
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('no credentials found') ||
          errorString.contains('authentication failed') ||
          errorString.contains('authentication required')) {
        debugPrint(
          '🔑 [DCM] Authentication error detected - marking device as requiresAuthentication=true',
        );

        // Detect authentication method based on vendor
        final vendor = await _detectVendor(deviceId, null);
        final authMethod = vendor == DeviceVendor.xiaomi
            ? AuthenticationType.xiaomiSpp
            : AuthenticationType.unknown;

        debugPrint(
          '🔑 [DCM] Auth method detected: $authMethod (vendor: $vendor)',
        );

        _updateDeviceState(
          deviceId,
          requiresAuthentication: true,
          authenticationMethod: authMethod,
          connectionState: ConnectionState.disconnected,
        );
      }

      rethrow;
    }
  }

  /// Disconnect from a device
  Future<void> disconnectDevice(final String deviceId) async {
    debugPrint('📴 DeviceConnectionManager: Disconnecting $deviceId');

    final orchestrator = _activeConnections[deviceId];
    if (orchestrator == null) {
      debugPrint('   ⚠️  Device not found in active connections');
      return;
    }

    try {
      // ✅ Cancel stream subscriptions first
      await _cancelStreamSubscriptions(deviceId);

      await orchestrator.disconnect();
      await orchestrator.dispose();
      _activeConnections.remove(deviceId);

      // ✅ CRITICAL FIX: NO eliminar el WearableDevice, solo actualizarlo a disconnected
      // Esto preserva isPairedToSystem=true para que el botón muestre "Conectar" (no "Autenticar")
      _updateDeviceState(
        deviceId,
        connectionState: ConnectionState.disconnected,
        // ℹ️ Preserva isPairedToSystem, deviceTypeId, name, etc. del estado actual
      );
      debugPrint(
        '   ✅ WearableDevice updated to disconnected (isPairedToSystem preserved)',
      );

      debugPrint('🔍 [STREAM_UPDATE] About to emit stream after disconnect');
      debugPrint('   - deviceId: $deviceId');
      debugPrint('   - _deviceStates.length: ${_deviceStates.length}');
      debugPrint('   - _deviceStates.keys: ${_deviceStates.keys.toList()}');

      // ✅ Emit to deviceStatesStream (single source of truth)
      // 🚫 NO _emitConnectionStates() - that's internal legacy stream
      _deviceStatesController.add(Map.unmodifiable(_deviceStates));
      debugPrint(
        '✅ DeviceConnectionManager: Device disconnected + stream emitted',
      );
    } on Exception catch (e) {
      debugPrint('❌ DeviceConnectionManager: Disconnect error: $e');
      rethrow;
    }
  }

  /// Ensure device is connected (for background services)
  ///
  /// Connects if not already connected, otherwise returns immediately.
  Future<void> ensureConnected(final String deviceId) async {
    final orchestrator = _activeConnections[deviceId];

    if (orchestrator != null &&
        (orchestrator.currentState == ConnectionState.connected ||
            orchestrator.currentState == ConnectionState.streaming)) {
      debugPrint('   ✅ Device already connected');
      return;
    }

    debugPrint('🔄 Ensuring connection for $deviceId...');
    await connectDevice(deviceId);
  }

  /// Get biometric data stream for a specific device
  Stream<BiometricData>? getBiometricStream(final String deviceId) {
    final orchestrator = _activeConnections[deviceId];
    return orchestrator?.biometricDataStream;
  }

  /// Get connection state for a specific device
  ConnectionState? getConnectionState(final String deviceId) {
    return _activeConnections[deviceId]?.currentState;
  }

  // ============================================================
  // DEVICE DISCOVERY (delegated to BleService)
  // ============================================================

  /// Start scanning for nearby BLE devices
  ///
  /// Delegates to BleService for device discovery.
  /// Subscribe to [discoveredDevicesStream] to receive scan results.
  ///
  /// **Usage:**
  /// ```dart
  /// manager.discoveredDevicesStream.listen((device) {
  ///   print('Found: ${device.name}');
  /// });
  /// await manager.startScanning(timeout: Duration(seconds: 10));
  /// ```
  Future<void> startScanning({Duration timeout = const Duration(seconds: 30)}) {
    return _bleService.startScanning(timeout: timeout);
  }

  /// Stop ongoing BLE scan
  Future<void> stopScanning() {
    return _bleService.stopScanning();
  }

  /// Stream of discovered devices during active scan
  ///
  /// Broadcast stream that emits devices as they're found.
  /// Subscribe before calling [startScanning].
  ///
  /// ✅ CRITICAL: Also emits discovered devices to [deviceStatesStream]
  /// so UI receives them in real-time via WearableSensors.deviceStates
  ///
  /// **Enrichment:** Each discovered device is enriched using DeviceAdapter
  /// which includes service UUIDs, device type detection, and auth method detection.
  Stream<BluetoothDevice> get discoveredDevicesStream {
    return _bleService.rawBleDevicesStream.asyncMap((btDevice) async {
      final deviceId = btDevice.deviceId;

      debugPrint(
        '🔍 [discoveredDevicesStream] Processing: ${btDevice.name} ($deviceId)',
      );

      // Only process if not already in _deviceStates (avoid duplicates)
      if (!_deviceStates.containsKey(deviceId)) {
        debugPrint('   🆕 New device, enriching...');
        try {
          // ✅ Use DeviceAdapter.fromInternal() to enrich device
          // storage: null = discovered device (no saved copy lookup)
          final enrichedDevice = await DeviceAdapter.fromInternal(
            btDevice,
            storage: null,
          );
          _deviceStates[deviceId] = enrichedDevice;
          debugPrint('   ✅ Enriched discovered device: ${btDevice.name}');
          debugPrint(
            '      - Services: ${enrichedDevice.discoveredServices.length}',
          );
        } catch (e, stackTrace) {
          debugPrint('   ⚠️  Error enriching device $deviceId: $e');
          debugPrint('   Stack trace: $stackTrace');
          // Fallback: create basic device without enrichment
          // ⚠️ Only emit if enrichment fails AND device type is unsupported
          // This ensures we don't emit broken devices
          final basicDevice = WearableDevice(
            deviceId: deviceId,
            name: btDevice.name,
            macAddress: deviceId,
            connectionState: ConnectionState.disconnected,
            isPairedToSystem: false,
            isNearby: true, // ✅ Always true for discovered devices
            discoveredServices: [],
            lastDiscoveredAt: DateTime.now(),
          );
          _deviceStates[deviceId] = basicDevice;
          debugPrint('   📌 Created fallback basic device for $deviceId');
        }

        // Emit updated deviceStates to UI
        debugPrint(
          '   📡 Emitting ${_deviceStates.length} total devices to deviceStatesStream:',
        );
        for (final device in _deviceStates.values) {
          debugPrint(
            '      - ${device.name}: isPaired=${device.isPairedToSystem}, isNearby=${device.isNearby}, services=${device.discoveredServices.length}',
          );
        }
        _deviceStatesController.add(Map.unmodifiable(_deviceStates));
      } else {
        debugPrint('   ⏭️  Device already in _deviceStates, skipping');
      }

      return btDevice;
    });
  }

  /// Check if a device is bonded at system level
  ///
  /// **Usage:**
  /// ```dart
  /// final isBonded = await manager.isDeviceBonded(deviceId);
  /// ```
  Future<bool> isDeviceBonded(String deviceId) {
    return _bleService.isDeviceBonded(deviceId);
  }

  /// Gets list of devices bonded at system level
  ///
  /// Returns devices that are paired through OS Bluetooth settings.
  /// These devices may still require app-level authentication to connect.
  ///
  /// **Usage:**
  /// ```dart
  /// final bonded = await manager.getBondedDevices();
  /// for (final device in bonded) {
  ///   print('Bonded: ${device.name}');
  /// }
  /// ```
  Future<List<WearableDevice>> getBondedDevices() async {
    debugPrint('🔍 [DCM] getBondedDevices() called');
    try {
      // Get bonded devices from BLE service
      debugPrint('🔍 [DCM] Calling _bleService.getSystemDevices()...');
      final bondedDevices = await _bleService.getSystemDevices();
      debugPrint('🔍 [DCM] Got ${bondedDevices.length} bonded device(s)');

      // Convert BluetoothDevice (internal) to WearableDevice (public) using DeviceAdapter
      // This includes enrichment: services, device type, auth method
      final wearableDevices = <WearableDevice>[];
      for (final btDevice in bondedDevices) {
        try {
          debugPrint(
            '🔍 [DCM] Enriching: ${btDevice.name} (${btDevice.deviceId})',
          );
          // ✅ Use DeviceAdapter.fromInternal() to enrich device
          // storage: _discoveredDeviceStorage = bonded device (try loading saved copy)
          final enrichedDevice = await DeviceAdapter.fromInternal(
            btDevice,
            storage: _discoveredDeviceStorage,
          );
          wearableDevices.add(enrichedDevice);
          debugPrint(
            '   ✅ Device Type: ${enrichedDevice.deviceTypeId}',
          );
        } catch (e) {
          debugPrint(
            '   ⚠️  Error enriching device ${btDevice.deviceId}: $e',
          );
          // Fallback: create basic device without enrichment
          wearableDevices.add(
            WearableDevice(
              deviceId: btDevice.deviceId,
              name: btDevice.name,
              macAddress: btDevice.deviceId,
              connectionState: ConnectionState.disconnected,
              isPairedToSystem: true,
              discoveredServices: [],
            ),
          );
        }
      }

      debugPrint('✅ [DCM] Returning ${wearableDevices.length} WearableDevices');
      return wearableDevices;
    } catch (e, stackTrace) {
      debugPrint('❌ [DCM] Failed to get bonded devices: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return []; // Return empty list on error
    }
  }

  /// Detect vendor from deviceId and device name
  ///
  /// **Detection logic:**
  /// 1. Check saved metadata in SharedPreferences
  /// 2. Try to detect from device name (REGEX patterns like Gadgetbridge)
  /// 3. Try to detect from MAC address OUI (first 3 bytes)
  /// 4. Fallback to generic
  Future<DeviceVendor> _detectVendor(
    final String deviceId, [
    final String? deviceName,
  ]) async {
    // Step 1: Check saved metadata in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedVendor = prefs.getString('device_vendor_$deviceId');
    if (savedVendor != null) {
      debugPrint('   📦 Vendor from cache: $savedVendor');
      return _vendorFromString(savedVendor);
    }

    // Step 2: Try to detect from device name (REGEX like Gadgetbridge)
    if (deviceName != null && deviceName.isNotEmpty) {
      debugPrint('   🔍 Attempting device name detection: "$deviceName"');
      final vendor = _vendorFromDeviceName(deviceName);
      if (vendor != DeviceVendor.unknown) {
        debugPrint('   ✅ Vendor from device name: $deviceName → $vendor');
        // Save for future use
        await prefs.setString('device_vendor_$deviceId', vendor.toString());
        return vendor;
      }
    }

    // Step 3: Try to detect from MAC address OUI (first 3 bytes)
    // MAC format: "XX:XX:XX:XX:XX:XX" or "XXXXXXXXXXXX"
    try {
      final oui = _extractOui(deviceId);
      if (oui != null) {
        final vendor = _vendorFromOui(oui);
        if (vendor != DeviceVendor.unknown) {
          debugPrint('   🏷️  Vendor from OUI: $oui → $vendor');
          // Save for future use
          await prefs.setString('device_vendor_$deviceId', vendor.toString());
          return vendor;
        }
      }
    } catch (e) {
      debugPrint('   ⚠️  MAC OUI detection failed: $e');
    }

    // Fallback: Default to generic (no assumption about Xiaomi)
    debugPrint('   ❓ Vendor unknown, using generic');
    return DeviceVendor.generic;
  }

  /// Extract OUI (Organizationally Unique Identifier) from MAC address
  /// Returns first 3 octets in uppercase (e.g., "00:22:4F" or "00224F")
  String? _extractOui(String macAddress) {
    // Handle both formats: "00:22:4F:XX:XX:XX" and "00224FxxxxXX"
    final cleanMac =
        macAddress.replaceAll(':', '').replaceAll('-', '').toUpperCase();

    if (cleanMac.length >= 6) {
      return cleanMac.substring(0, 6);
    }

    return null;
  }

  /// Detect vendor from MAC address OUI (first 3 bytes)
  /// References:
  /// - https://standards.ieee.org/develop/regauth/oui/
  /// - Common wearable vendor OUIs
  DeviceVendor _vendorFromOui(String oui) {
    // Xiaomi Mi Band OUI list (non-exhaustive)
    const xiaomiOuis = {
      '00224F', // Early Mi Band models
      '34CE00', // Mi Band 3/4/5/6
      'EC39F5', // Mi Band 6/7
      '5856FF', // Mi Band 8
      '98EF05', // Mi Band variants
      'B4B59D', // Mi Band regional variants
      '0434C3', // Mi Band 10 (and newer models)
    };

    if (xiaomiOuis.contains(oui)) {
      return DeviceVendor.xiaomi;
    }

    // Apple Watch / AirPods OUI
    const appleOuis = {
      '001A86',
      '001F5B',
      '0019B5',
      '00156D',
    };

    if (appleOuis.contains(oui)) {
      return DeviceVendor.apple;
    }

    // Fitbit OUI
    const fitbitOuis = {
      '000704',
      '9CC3B0',
      '9CA5DE',
    };

    if (fitbitOuis.contains(oui)) {
      return DeviceVendor.fitbit;
    }

    return DeviceVendor.unknown;
  }

  /// Detect vendor from device name using REGEX patterns (from Gadgetbridge)
  ///
  /// **Xiaomi patterns extracted from Gadgetbridge coordinators:**
  /// - Smart Band 10: `^Xiaomi Smart Band 10 [0-9A-F]{4}$` (MiBand10Coordinator)
  /// - Smart Band 9: `^Xiaomi Smart Band 9 [0-9A-F]{4}$` (MiBand9Coordinator)
  /// - Smart Band 9 Active: `^Xiaomi( Smart)? Band 9 Active [0-9A-F]{4}$` (MiBand9ActiveCoordinator)
  /// - Smart Band 8: `^Xiaomi Smart Band 8 [A-Z0-9]{4}$` (MiBand8Coordinator)
  /// - Smart Band 8 Pro: `^Xiaomi Smart Band 8 Pro [0-9A-F]{4}$` (MiBand8ProCoordinator)
  /// - Smart Band 8 Active: `^Xiaomi( Smart)? Band 8 Active [A-Z0-9]{4}$` (MiBand8ActiveCoordinator)
  /// - Smart Band 7: `Xiaomi Smart Band 7` (MiBand7Coordinator - substring match)
  /// - Mi Band 6: `Mi Smart Band 6` (MiBand6Coordinator - substring match)
  /// Detect vendor from device name using centralized Xiaomi detection
  ///
  /// Uses XiaomiDeviceDetection for all Xiaomi patterns (from Gadgetbridge).
  /// Can be extended for other vendors (Fitbit, Apple, Garmin, etc.).
  DeviceVendor _vendorFromDeviceName(String deviceName) {
    // ✅ Use centralized Xiaomi detection
    if (XiaomiDeviceDetection.isXiaomiDevice(deviceName)) {
      return DeviceVendor.xiaomi;
    }

    // TODO: Add other vendors
    // if (FitbitDeviceDetection.isFitbitDevice(deviceName)) {
    //   return DeviceVendor.fitbit;
    // }

    return DeviceVendor.unknown;
  }

  /// Convert string back to DeviceVendor enum (for SharedPreferences)
  DeviceVendor _vendorFromString(String vendor) {
    switch (vendor) {
      case 'DeviceVendor.xiaomi':
        return DeviceVendor.xiaomi;
      case 'DeviceVendor.fitbit':
        return DeviceVendor.fitbit;
      case 'DeviceVendor.apple':
        return DeviceVendor.apple;
      case 'DeviceVendor.generic':
        return DeviceVendor.generic;
      default:
        return DeviceVendor.unknown;
    }
  }

  /// Create orchestrator for a specific vendor
  Future<VendorOrchestrator> _createOrchestrator(
    final DeviceVendor vendor,
  ) async {
    switch (vendor) {
      case DeviceVendor.xiaomi:
        // ✅ Pre-initialize SppV2Config before creating orchestrator
        // This prevents "SppV2Config not initialized" errors
        await _initializeSppV2ConfigIfNeeded();

        return XiaomiConnectionOrchestrator(
          bleService: _bleService,
          btClassicService: _btClassicService,
        );

      // TODO: Add other vendors
      // case DeviceVendor.fitbit:
      //   return FitbitConnectionOrchestrator(...);

      default:
        throw Exception('Unsupported vendor: $vendor');
    }
  }

  /// Initialize SppV2Config if not already done (Xiaomi devices only)
  Future<void> _initializeSppV2ConfigIfNeeded() async {
    // Check if already initialized
    if (SppV2Config.isInitialized) {
      return;
    }

    debugPrint('📋 Pre-initializing SPP V2 config for Xiaomi devices...');

    try {
      // Load default Xiaomi device JSON (Band 10 as reference)
      // Individual devices will reload their specific config during auth
      final jsonString = await rootBundle.loadString(
        'packages/wearable_sensors/assets/device_implementations/xiaomi_smart_band_10.json',
      );
      final deviceJson = jsonDecode(jsonString) as Map<String, dynamic>;

      SppV2Config.initialize(deviceJson);
      debugPrint('✅ SPP V2 config pre-initialized with default config');
    } on Exception catch (e) {
      debugPrint('⚠️ Failed to pre-initialize SPP V2 config: $e');
      // Don't fail here - XiaomiAuthService will initialize it later
    }
  }

  /// Load bonded/paired devices from system and populate deviceStatesStream
  ///
  /// **Called during initialize()** to populate the "My Devices" section in UI.
  ///
  /// **Workflow:**
  /// 1. Get bonded devices from BLE service (via FlutterBluePlus.bondedDevices)
  /// 2. Enrich each device with DeviceAdapter (services, device type, auth method)
  /// 3. Add to _deviceStates cache
  /// 4. Emit to deviceStatesStream for UI consumption
  Future<void> _loadBondedDevices() async {
    try {
      debugPrint('🔌 Loading bonded devices from system...');

      // Get bonded devices from BLE service
      final bondedDevices = await _bleService.getSystemDevices();

      if (bondedDevices.isEmpty) {
        debugPrint('   ℹ️  No bonded devices found');
        // Still emit empty state to trigger UI update
        _deviceStatesController.add(Map.unmodifiable(_deviceStates));
        return;
      }

      debugPrint('   📱 Found ${bondedDevices.length} bonded device(s)');

      // Convert to WearableDevice using DeviceAdapter (includes enrichment)
      for (final btDevice in bondedDevices) {
        try {
          debugPrint(
            '   🔄 Enriching device: ${btDevice.name} (${btDevice.deviceId})',
          );

          // ✅ Use DeviceAdapter.fromInternal() to enrich device
          // storage: _discoveredDeviceStorage = bonded device (try loading saved copy)
          final enrichedDevice = await DeviceAdapter.fromInternal(
            btDevice,
            storage: _discoveredDeviceStorage,
          );
          _deviceStates[btDevice.deviceId] = enrichedDevice;

          debugPrint('   ✅ Enriched device: ${btDevice.name}');
          debugPrint(
            '      - Services: ${enrichedDevice.discoveredServices.length}',
          );
          debugPrint('      - Device Type: ${enrichedDevice.deviceTypeId}');
        } catch (e, stackTrace) {
          debugPrint('   ⚠️  Error enriching device ${btDevice.deviceId}: $e');
          debugPrint('   Stack trace: $stackTrace');
          // Fallback: create basic device without enrichment
          final basicDevice = WearableDevice(
            deviceId: btDevice.deviceId,
            name: btDevice.name,
            macAddress: btDevice.deviceId,
            connectionState: ConnectionState.disconnected,
            isPairedToSystem: true,
            discoveredServices: [],
          );
          _deviceStates[btDevice.deviceId] = basicDevice;
          debugPrint(
            '   📌 Created fallback basic device for ${btDevice.deviceId}',
          );
        }
      }

      // Emit to stream for UI
      debugPrint(
        '   📡 Emitting ${_deviceStates.length} bonded devices to deviceStatesStream',
      );
      for (final device in _deviceStates.values) {
        debugPrint(
          '      - ${device.name}: isPaired=${device.isPairedToSystem}, isNearby=${device.isNearby}, services=${device.discoveredServices.length}',
        );
      }
      _deviceStatesController.add(Map.unmodifiable(_deviceStates));
      debugPrint('✅ Bonded devices loaded and emitted to stream');
    } on Exception catch (e) {
      debugPrint('❌ Error loading bonded devices: $e');
    }
  }

  /// Update device state and emit to deviceStatesStream
  /// 🔐 Update device state when credentials are saved (public API)
  ///
  /// Called by WearableSensors.saveDeviceCredentials() to notify that
  /// credentials have been saved and requiresAuthentication should be false.
  void updateDeviceAuthenticationState(
    final String deviceId, {
    required final bool requiresAuthentication,
  }) {
    _updateDeviceState(
      deviceId,
      requiresAuthentication: requiresAuthentication,
    );
  }

  void _updateDeviceState(
    final String deviceId, {
    final ConnectionState? connectionState,
    final int? batteryLevel,
    final DateTime? lastDataTimestamp,
    final ConnectionError? error,
    final String? deviceTypeId,
    final bool? requiresAuthentication,
    final AuthenticationType? authenticationMethod,
  }) {
    final currentState = _deviceStates[deviceId] ??
        WearableDevice(
          deviceId: deviceId,
          connectionState: ConnectionState.disconnected,
        );

    final newState = currentState.copyWith(
      connectionState: connectionState,
      batteryLevel: batteryLevel,
      lastDataTimestamp: lastDataTimestamp,
      error: error != null
          ? ConnectionException(
              error.message,
              code: error.errorCode,
              deviceId: error.deviceId,
            )
          : null,
      deviceTypeId: deviceTypeId,
      requiresAuthentication: requiresAuthentication,
      authenticationMethod: authenticationMethod,
    );

    // ✅ Only emit if state actually changed (uses WearableDevice.==)
    if (currentState == newState) {
      // No cambios reales, no emitir stream
      debugPrint('🔍 [_updateDeviceState] No changes detected, skipping emit');
      return;
    }

    debugPrint('🔍 [_updateDeviceState] State changed:');
    debugPrint('   - currentState.deviceTypeId: ${currentState.deviceTypeId}');
    debugPrint('   - newState.deviceTypeId: ${newState.deviceTypeId}');
    debugPrint(
      '   - currentState.connectionState: ${currentState.connectionState}',
    );
    debugPrint('   - newState.connectionState: ${newState.connectionState}');
    debugPrint('   ✅ emitting deviceStatesStream');

    _deviceStates[deviceId] = newState;
    _deviceStatesController.add(Map.unmodifiable(_deviceStates));
  }

  /// 🔋 PUBLIC API: Request battery level update for device
  ///
  /// ✅ **USES BiometricDataReader**: Universal data access layer
  ///
  /// Forces battery read NOW (instead of waiting for polling).
  /// Used by UI when displaying already-connected devices.
  ///
  /// **Routing**:
  /// - Xiaomi SPP V2 → via protobuf command
  /// - BLE devices → via characteristic 0x2A19
  /// - Auto-detects transport based on device implementation
  ///
  /// Cancel stream subscriptions for a device
  Future<void> _cancelStreamSubscriptions(final String deviceId) async {
    final subscriptions = _streamSubscriptions[deviceId];
    if (subscriptions == null || subscriptions.isEmpty) {
      return;
    }

    debugPrint(
      '🧹 Canceling ${subscriptions.length} stream subscriptions for $deviceId',
    );
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    _streamSubscriptions.remove(deviceId);
  }

  /// Dispose all resources
  Future<void> dispose() async {
    debugPrint('🧹 Disposing DeviceConnectionManager...');

    // Cancel all stream subscriptions
    for (final deviceId in _streamSubscriptions.keys.toList()) {
      await _cancelStreamSubscriptions(deviceId);
    }

    // Disconnect all devices
    final deviceIds = _activeConnections.keys.toList();
    for (final deviceId in deviceIds) {
      await disconnectDevice(deviceId);
    }

    await _deviceStatesController.close();

    _isInitialized = false;
    debugPrint('✅ DeviceConnectionManager disposed');
  }
}
