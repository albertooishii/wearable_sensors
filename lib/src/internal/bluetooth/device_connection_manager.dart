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
import 'package:wearable_sensors/src/internal/bluetooth/biometric_data_reader.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_connection_orchestrator.dart';
import 'package:wearable_sensors/src/internal/models/bluetooth_device.dart';

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
///    manager.autoReconnectSavedDevices(); // Optional
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

  // Stream controller for aggregated connection states
  final StreamController<Map<String, ConnectionState>>
      _connectionStatesController =
      StreamController<Map<String, ConnectionState>>.broadcast();

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

  /// Connection states stream (all devices)
  Stream<Map<String, ConnectionState>> get connectionStatesStream =>
      _connectionStatesController.stream;

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
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️  DeviceConnectionManager already initialized');
      return;
    }

    debugPrint('🚀 Initializing DeviceConnectionManager...');

    // Initialize core services
    _bleService = BleService();
    await _bleService.initialize();

    _btClassicService = BluetoothClassicService();
    await _btClassicService.initialize();

    // 🔌 Load bonded/paired devices from system
    await _loadBondedDevices();

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
      final vendor = await _detectVendor(deviceId);
      debugPrint('   🔍 Detected vendor: $vendor');

      // 3. Create orchestrator (await because it initializes SppV2Config)
      final orchestrator = await _createOrchestrator(vendor);

      // 4. Initialize device state
      _deviceStates[deviceId] = WearableDevice(
        deviceId: deviceId,
        connectionState: ConnectionState.disconnected,
      );

      // ✅ 5. Subscribe to orchestrator streams (store subscriptions for cleanup)
      final subscriptions = <StreamSubscription<dynamic>>[];

      subscriptions.add(
        orchestrator.connectionStateStream.listen((final state) {
          _updateDeviceState(deviceId, connectionState: state);
          _emitConnectionStates();
        }),
      );

      subscriptions.add(
        orchestrator.batteryStream.listen((final battery) {
          _updateDeviceState(deviceId, batteryLevel: battery);
        }),
      );

      subscriptions.add(
        orchestrator.biometricDataStream.listen((final data) {
          _updateDeviceState(deviceId, lastDataTimestamp: data.timestamp);
        }),
      );

      subscriptions.add(
        orchestrator.errorStream.listen((final error) {
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

      // 8. Store in active connections
      _activeConnections[deviceId] = orchestrator;

      debugPrint('✅ DeviceConnectionManager: Device connected');
    } catch (e, stackTrace) {
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('❌ [DCM] connectAndAuthenticate() FAILED with exception:');
      debugPrint('   Exception: $e');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('Stack trace: $stackTrace');
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

      _emitConnectionStates();
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
  Stream<BluetoothDevice> get discoveredDevicesStream {
    return _bleService.rawBleDevicesStream;
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
    try {
      // Get bonded devices from BLE service
      final bondedDevices = await _bleService.getSystemDevices();

      // Convert BluetoothDevice (internal) to WearableDevice (public)
      return bondedDevices.map((btDevice) {
        return WearableDevice(
          deviceId: btDevice.deviceId,
          name: btDevice.name,
          macAddress: btDevice.deviceId,
          connectionState: ConnectionState.disconnected,
          isPairedToSystem: true,
          discoveredServices: btDevice.services,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ Failed to get bonded devices: $e');
      return []; // Return empty list on error
    }
  }

  /// Auto-reconnect to saved devices
  ///
  /// Called at app startup (optional, based on user settings).
  /// Loads saved devices and attempts to reconnect.
  Future<void> autoReconnectSavedDevices() async {
    debugPrint('🔄 Auto-reconnecting saved devices...');

    try {
      final savedDeviceIds = await _getSavedDeviceIds();

      if (savedDeviceIds.isEmpty) {
        debugPrint('   ℹ️  No saved devices found');
        return;
      }

      debugPrint('   📱 Found ${savedDeviceIds.length} saved devices');

      // Reconnect in parallel (fire & forget, don't block)
      for (final deviceId in savedDeviceIds) {
        // Ignore errors (device may be off/out of range)
        connectDevice(deviceId).catchError((final error) {
          debugPrint('   ⚠️  Auto-reconnect failed for $deviceId: $error');
        });
      }
    } on Exception catch (e) {
      debugPrint('❌ Auto-reconnect error: $e');
    }
  }

  /// Detect vendor from deviceId
  ///
  /// **Detection logic:**
  /// 1. Check saved metadata in SharedPreferences
  /// 2. Parse deviceId format (MAC address patterns)
  /// 3. Fallback to generic
  Future<DeviceVendor> _detectVendor(final String deviceId) async {
    // TODO: Implement proper vendor detection
    // For now, assume all devices are Xiaomi
    // In production:
    // - Check saved metadata (SharedPreferences)
    // - Parse MAC address OUI (first 3 bytes)
    // - Query device for manufacturer info
    return DeviceVendor.xiaomi;
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
        'assets/device_implementations/xiaomi_smart_band_10.json',
      );
      final deviceJson = jsonDecode(jsonString) as Map<String, dynamic>;

      SppV2Config.initialize(deviceJson);
      debugPrint('✅ SPP V2 config pre-initialized with default config');
    } on Exception catch (e) {
      debugPrint('⚠️ Failed to pre-initialize SPP V2 config: $e');
      // Don't fail here - XiaomiAuthService will initialize it later
    }
  }

  /// Get list of saved device IDs from storage
  Future<List<String>> _getSavedDeviceIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('saved_device_ids') ?? [];
  }

  /// Load bonded/paired devices from system and populate deviceStatesStream
  ///
  /// **Called during initialize()** to populate the "My Devices" section in UI.
  ///
  /// **Workflow:**
  /// 1. Get bonded devices from BLE service (via FlutterBluePlus.bondedDevices)
  /// 2. Convert to WearableDevice models with isPairedToSystem = true
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

      // Convert to WearableDevice and add to cache
      for (final btDevice in bondedDevices) {
        final deviceState = WearableDevice(
          deviceId: btDevice.deviceId,
          name: btDevice.name,
          macAddress: btDevice.deviceId,
          connectionState: ConnectionState.disconnected,
          isPairedToSystem: true,
          discoveredServices: btDevice.services,
        );

        _deviceStates[btDevice.deviceId] = deviceState;
        debugPrint(
          '   ✅ Added bonded device: ${deviceState.name} (${deviceState.deviceId})',
        );
      }

      // Emit to stream for UI
      _deviceStatesController.add(Map.unmodifiable(_deviceStates));
      debugPrint('✅ Bonded devices loaded and emitted to stream');
    } on Exception catch (e) {
      debugPrint('❌ Error loading bonded devices: $e');
    }
  }

  /// Emit current connection states to stream
  void _emitConnectionStates() {
    final states = connectionStates;
    _connectionStatesController.add(states);
  }

  /// Update device state and emit to deviceStatesStream
  void _updateDeviceState(
    final String deviceId, {
    final ConnectionState? connectionState,
    final int? batteryLevel,
    final DateTime? lastDataTimestamp,
    final ConnectionError? error,
    final String? deviceTypeId,
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
  /// **Result**: Updates deviceStatesStream automatically via stream listener
  Future<void> requestBatteryUpdate(final String deviceId) async {
    try {
      debugPrint(
        '🔋 [DCM] Requesting battery update via BiometricDataReader...',
      );
      debugPrint('   - deviceId: $deviceId');

      // ✅ Use BiometricDataReader for universal battery access
      final reader = BiometricDataReader();
      final batterySample = await reader.read(deviceId, SensorType.battery);

      if (batterySample != null) {
        final batteryLevel = batterySample.value as int?;
        if (batteryLevel != null) {
          debugPrint('   ✅ Battery received: $batteryLevel%');

          // Update device state (which emits to deviceStatesStream)
          _updateDeviceState(deviceId, batteryLevel: batteryLevel);
        } else {
          debugPrint('   ⚠️  Battery sample has null value');
        }
      } else {
        debugPrint('   ⚠️  Battery read returned null');
      }
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ requestBatteryUpdate failed: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

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

    await _connectionStatesController.close();
    await _deviceStatesController.close();

    _isInitialized = false;
    debugPrint('✅ DeviceConnectionManager disposed');
  }
}
