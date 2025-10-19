import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;

import '../internal/bluetooth/device_connection_manager.dart';
import '../internal/bluetooth/biometric_data_reader.dart';
import '../internal/services/device_storage_service.dart';
import '../internal/storage/discovered_device_storage.dart';
import '../internal/storage/shared_preferences_discovered_device_storage.dart';
import '../internal/config/supported_devices_config.dart';
import '../internal/utils/device_implementation_loader.dart';
import '../internal/vendors/xiaomi/xiaomi_device_credentials.dart';
import '../internal/vendors/xiaomi/xiaomi_auth_service.dart'; // For EncryptionKeys
import 'enums/connection_state.dart';
import 'enums/device_filter.dart';
import 'enums/sensor_type.dart';
import 'exceptions/authentication_exception.dart';
import 'exceptions/connection_exception.dart';
import 'exceptions/wearable_exception.dart';
import 'models/auth_credentials.dart';
import 'models/bluetooth_status.dart';
import 'models/device_capabilities.dart';
import 'models/sensor_reading.dart';
import 'models/wearable_device.dart';

/// Main facade for the wearable_sensors package.
///
/// Provides a simple, unified API for discovering, connecting to, and
/// reading data from wearable devices across different vendors.
///
/// This is a singleton class - use the static methods to interact with devices.
/// The package handles all vendor-specific protocols, authentication, and
/// data parsing internally.
///
/// **Basic Usage:**
/// ```dart
/// // 1. Initialize the package
/// await WearableSensors.initialize();
///
/// // 2. Scan for devices (starts background discovery)
/// await WearableSensors.scan(duration: Duration(seconds: 15));
///
/// // 3. Listen to discovered devices via stream
/// WearableSensors.deviceStream(filter: DeviceFilter.nearby).listen((devices) {
///   for (final device in devices.values) {
///     print('Found: ${device.name}');
///   }
/// });
///
/// // 4. Connect to a device
/// final device = await WearableSensors.connect(deviceId);
/// print('Connected to: ${device.name}');
///
/// // 5. Read sensor data
/// final reading = await WearableSensors.read(deviceId, SensorType.heartRate);
/// print('Heart Rate: ${reading.value} ${reading.unit}');
///
/// // 6. Stream real-time data
/// final dataStream = WearableSensors.stream(deviceId, SensorType.heartRate);
/// await for (final reading in dataStream) {
///   print('HR: ${reading.value} bpm');
/// }
/// ```
///
/// **Device Authentication:**
/// Some devices (like Xiaomi Mi Bands) require authentication keys.
/// These are automatically stored after first successful authentication:
/// ```dart
/// // First time: provide auth key
/// await WearableSensors.connect(
///   deviceId,
///   credentials: AuthCredentials(authKey: 'your_key_hex'),
/// );
///
/// // Subsequent times: credentials loaded automatically
/// await WearableSensors.connect(deviceId);
/// ```
class WearableSensors {
  // Singleton pattern
  WearableSensors._();
  static WearableSensors? _instance;

  // Internal services (lazy-initialized)
  DeviceConnectionManager? _connectionManager;
  DeviceStorageService? _storageService;
  BiometricDataReader? _biometricReader;
  DiscoveredDeviceStorage? _discoveredDeviceStorage;

  // State tracking
  bool _isInitialized = false;
  final Map<String, StreamSubscription> _activeStreams = {};

  /// Internal getter for connection manager (creates if needed).
  DeviceConnectionManager get _manager {
    if (_connectionManager == null) {
      throw const WearableException(
        'WearableSensors not initialized. Call initialize() first.',
        code: 'NOT_INITIALIZED',
      );
    }
    return _connectionManager!;
  }

  /// Internal getter for biometric data reader (creates if needed).
  BiometricDataReader get _reader {
    _biometricReader ??= BiometricDataReader(); // Singleton
    return _biometricReader!;
  }

  /// Internal getter for storage service (creates if needed).
  DeviceStorageService get _storage {
    if (_storageService == null) {
      throw const WearableException(
        'WearableSensors not initialized. Call initialize() first.',
        code: 'NOT_INITIALIZED',
      );
    }
    return _storageService!;
  }

  /// Internal getter for discovered device storage (creates if needed).
  DiscoveredDeviceStorage get _discoveredStorage {
    if (_discoveredDeviceStorage == null) {
      throw const WearableException(
        'WearableSensors not initialized. Call initialize() first.',
        code: 'NOT_INITIALIZED',
      );
    }
    return _discoveredDeviceStorage!;
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initializes the wearable_sensors package.
  ///
  /// Must be called before any other methods. This sets up internal services,
  /// loads saved device credentials, and prepares the Bluetooth adapter.
  ///
  /// **Parameters:**
  /// - [forceReset]: If true, clears all saved devices and starts fresh (default: false)
  ///
  /// **Returns:** `true` if initialization succeeded, `false` otherwise.
  ///
  /// **Throws:**
  /// - [WearableException] if Bluetooth is not available on this device
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.initialize();
  /// ```
  static Future<bool> initialize({bool forceReset = false}) async {
    _instance ??= WearableSensors._();

    if (_instance!._isInitialized && !forceReset) {
      return true; // Already initialized
    }

    try {
      // Initialize internal services
      _instance!._connectionManager = DeviceConnectionManager();
      _instance!._storageService = DeviceStorageService();
      _instance!._discoveredDeviceStorage =
          SharedPreferencesDiscoveredDeviceStorage();

      await _instance!._discoveredDeviceStorage!.initialize();
      
      // ✅ Pass discovered device storage to connection manager (for bonded device enrichment)
      await _instance!._connectionManager!.initialize(
        discoveredDeviceStorage: _instance!._discoveredDeviceStorage,
      );
      await _instance!._storageService!.initialize();

      if (forceReset) {
        await _instance!._storageService!.clearAll();
        await _instance!._discoveredDeviceStorage!.cleanupAll();
      }

      _instance!._isInitialized = true;
      return true;
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to initialize wearable_sensors: $e',
        code: 'INIT_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Checks if the package has been initialized.
  static bool get isInitialized => _instance?._isInitialized ?? false;

  // ============================================================
  // BLUETOOTH STATUS
  // ============================================================

  /// Gets the current Bluetooth system status.
  ///
  /// Returns information about Bluetooth availability, whether it's enabled,
  /// permission status, and any errors that may prevent device operations.
  ///
  /// **Returns:** [BluetoothStatus] with current Bluetooth state.
  ///
  /// **Example:**
  /// ```dart
  /// final status = await WearableSensors.getBluetoothStatus();
  ///
  /// if (!status.isEnabled) {
  ///   print('Please enable Bluetooth');
  /// } else if (!status.hasPermissions) {
  ///   print('Bluetooth permissions not granted');
  /// } else if (status.isReady) {
  ///   print('Ready to scan and connect');
  /// }
  /// ```
  static Future<BluetoothStatus> getBluetoothStatus() async {
    _ensureInitialized();

    try {
      // Get internal Bluetooth connection state from BleService
      final internalState = _instance!._manager.bleService.connectionState;

      // Convert internal BluetoothConnectionState to public BluetoothStatus
      return BluetoothStatus(
        isEnabled: internalState.isBluetoothEnabled,
        isAvailable: internalState.isBluetoothAvailable,
        hasPermissions: internalState.hasPermissions,
        isScanning: internalState.isScanning,
        errorMessage: internalState.errorMessage,
      );
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to get Bluetooth status: $e',
        code: 'BLUETOOTH_STATUS_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Stream of Bluetooth status changes.
  ///
  /// Emits a new [BluetoothStatus] whenever the Bluetooth state changes
  /// (e.g., user enables/disables Bluetooth, permissions granted, etc.).
  ///
  /// **Example:**
  /// ```dart
  /// WearableSensors.bluetoothStatusStream.listen((status) {
  ///   if (status.isReady) {
  ///     print('Bluetooth ready!');
  ///   } else {
  ///     print('Issue: ${status.statusMessage}');
  ///   }
  /// });
  /// ```
  static Stream<BluetoothStatus> get bluetoothStatusStream {
    _ensureInitialized();

    // Convert internal stream to public stream
    return _instance!._manager.bleService.connectionStateStream.map(
      (internalState) => BluetoothStatus(
        isEnabled: internalState.isBluetoothEnabled,
        isAvailable: internalState.isBluetoothAvailable,
        hasPermissions: internalState.hasPermissions,
        isScanning: internalState.isScanning,
        errorMessage: internalState.errorMessage,
      ),
    );
  }

  // ============================================================
  // DEVICE DISCOVERY
  // ============================================================

  /// Starts a background scan for nearby wearable devices.
  ///
  /// This method initiates a Bluetooth scan. Discovered devices will be emitted to
  /// [deviceStream] automatically.
  ///
  /// **Separation of Concerns:**
  /// - `scan()` = Action: Initiates background discovery
  /// - `deviceStream(filter: DeviceFilter.nearby)` = Consumer: Receives discovered devices
  ///
  /// **Parameters:**
  /// - [duration]: How long to scan (default: 10 seconds)
  ///
  /// **Returns:** `true` if scan started successfully.
  ///
  /// **Throws:**
  /// - [WearableException] if Bluetooth is disabled or scanning fails
  ///
  /// **Example:**
  /// ```dart
  /// // Start scan
  /// await WearableSensors.scan(duration: Duration(seconds: 15));
  ///
  /// // Listen to results via deviceStream
  /// WearableSensors.deviceStream(
  ///   filter: DeviceFilter.nearby,
  ///   enrich: true, // Only emit fully enriched devices (with services)
  /// ).listen((devices) {
  ///   for (final device in devices.values) {
  ///     print('Found: ${device.name} (${device.discoveredServices.length} services)');
  ///   }
  /// });
  /// ```
  static Future<bool> scan({
    Duration duration = const Duration(seconds: 10),
  }) async {
    _ensureInitialized();

    try {
      debugPrint(
        '📡 [WearableSensors] Starting background scan (${duration.inSeconds}s)',
      );

      // Start BLE scanning in background via DeviceConnectionManager
      await _instance!._manager.startScanning(timeout: duration);

      debugPrint('✅ [WearableSensors] Scan started successfully');
      return true;
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to start scan: $e',
        code: 'SCAN_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // DEVICE MANAGEMENT
  // ============================================================

  /// Gets list of devices that have been authenticated with this app.
  ///
  /// These devices have stored authentication credentials and can be
  /// connected to without providing credentials again.
  ///
  /// **Returns:** List of authenticated device IDs.
  ///
  /// **Example:**
  /// ```dart
  /// final authenticated = await WearableSensors.getAuthenticatedDevices();
  /// print('You have ${authenticated.length} authenticated devices');
  /// ```
  static Future<List<String>> getAuthenticatedDevices() async {
    _ensureInitialized();
    return await _instance!._storage.getAuthenticatedDeviceIds();
  }

  /// Checks if a specific device has stored authentication credentials.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to check
  ///
  /// **Returns:** `true` if credentials are stored, `false` otherwise.
  ///
  /// **Example:**
  /// ```dart
  /// if (await WearableSensors.isDeviceAuthenticated(deviceId)) {
  ///   print('Can connect without providing credentials');
  /// }
  /// ```
  static Future<bool> isDeviceAuthenticated(String deviceId) async {
    _ensureInitialized();
    return await _instance!._storage.hasCredentials(deviceId);
  }

  /// Removes stored authentication credentials for a device.
  ///
  /// After calling this, you'll need to provide credentials again on next connect.
  /// This does NOT unpair the device at the system level.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to forget
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.forgetDevice(deviceId);
  /// print('Device credentials removed');
  /// ```
  static Future<void> forgetDevice(String deviceId) async {
    _ensureInitialized();

    try {
      // Disconnect if currently connected
      final connectionState = _instance!._manager.getConnectionState(deviceId);
      if (connectionState?.isConnected ?? false) {
        await _instance!._manager.disconnectDevice(deviceId);
      }

      // Remove stored credentials
      await _instance!._storage.removeCredentials(deviceId);
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to forget device $deviceId: $e',
        code: 'FORGET_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // CONNECTION MANAGEMENT
  // ============================================================

  /// Connects to a wearable device.
  ///
  /// If the device requires authentication and credentials are not stored,
  /// you must provide them via [credentials] parameter.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID (MAC address or UUID)
  /// - [credentials]: Authentication credentials (optional if already stored)
  /// - [timeout]: Connection timeout (default: 30 seconds)
  /// - [autoReconnect]: Enable auto-reconnect on connection loss (default: true)
  ///
  /// **Returns:** [WearableDevice] with updated connection state.
  ///
  /// **Throws:**
  /// - [ConnectionException] if connection fails
  /// - [AuthenticationException] if authentication fails
  ///
  /// **Example:**
  /// ```dart
  /// // First time (with credentials)
  /// final device = await WearableSensors.connect(
  ///   deviceId,
  ///   credentials: AuthCredentials(authKey: 'your_key'),
  /// );
  ///
  /// // Subsequent times (credentials auto-loaded)
  /// final device = await WearableSensors.connect(deviceId);
  /// ```
  static Future<WearableDevice> connect(
    String deviceId, {
    AuthCredentials? credentials,
    Duration timeout = const Duration(seconds: 30),
    bool autoReconnect = true,
  }) async {
    _ensureInitialized();

    try {
      // Load stored credentials if not provided
      AuthCredentials? effectiveCredentials = credentials;
      effectiveCredentials ??=
          await _instance!._storage.getCredentials(deviceId);

      // Store credentials for future use (before connecting)
      // Note: Orchestrator auto-loads credentials via XiaomiAuthService.loadSavedCredentials()
      if (effectiveCredentials != null) {
        await _instance!._storage
            .saveCredentials(deviceId, effectiveCredentials);
      }

      // Connect via DeviceConnectionManager
      await _instance!._manager.connectDevice(deviceId);

      // Get device state after connection
      final deviceState = _instance!._manager.deviceStates[deviceId];
      if (deviceState == null) {
        throw ConnectionException(
          'Device connected but state not available',
          code: 'DEVICE_STATE_UNAVAILABLE',
          deviceId: deviceId,
        );
      }

      return deviceState;
    } on AuthenticationException {
      rethrow; // Pass through authentication errors
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to connect to device $deviceId: $e',
        code: 'CONNECTION_FAILED',
        cause: e,
        stackTrace: stackTrace,
        deviceId: deviceId,
      );
    }
  }

  /// Disconnects from a wearable device.
  ///
  /// This does NOT remove stored authentication credentials.
  /// Use [forgetDevice] to remove credentials.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to disconnect
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.disconnect(deviceId);
  /// ```
  static Future<void> disconnect(String deviceId) async {
    _ensureInitialized();

    try {
      // Cancel any active sensor streams
      await _cancelStreamsForDevice(deviceId);

      // Disconnect via DeviceConnectionManager
      await _instance!._manager.disconnectDevice(deviceId);
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to disconnect from device $deviceId: $e',
        code: 'DISCONNECTION_FAILED',
        cause: e,
        stackTrace: stackTrace,
        deviceId: deviceId,
        isConnectionAttempt: false,
      );
    }
  }

  /// Unpairs (unbonds) a device at the system level and removes app credentials.
  ///
  /// This is more thorough than [disconnect] or [forgetDevice] - it removes
  /// the device from system Bluetooth settings entirely and deletes all stored credentials.
  ///
  /// **What gets deleted:**
  /// - System Bluetooth bond (Android/Linux only via flutter_blue_plus.removeBond())
  /// - XiaomiDeviceCredentials (authKey)
  /// - EncryptionKeys (session keys)
  /// - GATT cache (Android only)
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to unpair
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.unpair(deviceId);
  /// ```
  static Future<void> unpair(String deviceId) async {
    _ensureInitialized();

    try {
      debugPrint('🗑️ [WearableSensors] Unpairing device: $deviceId');

      // 1. Disconnect if connected
      final connectionState = _instance!._manager.getConnectionState(deviceId);
      if (connectionState?.isConnected ?? false) {
        debugPrint('   📴 Disconnecting device first...');
        await disconnect(deviceId);
      }

      // 2. Remove system-level Bluetooth bond (Android/Linux only)
      try {
        final bleDevice =
            _instance!._manager.bleService.getBluetoothDevice(deviceId);
        await bleDevice.removeBond();
        debugPrint('   ✅ System Bluetooth bond removed');
      } catch (e) {
        debugPrint('   ⚠️ Could not remove bond (may not be bonded): $e');
        // Non-critical: Continue with credential cleanup
      }

      // 3. Clear GATT cache (Android only)
      try {
        final bleDevice =
            _instance!._manager.bleService.getBluetoothDevice(deviceId);
        await bleDevice.clearGattCache();
        debugPrint('   ✅ GATT cache cleared');
      } catch (e) {
        debugPrint('   ⚠️ Could not clear GATT cache: $e');
        // Non-critical: Continue with credential cleanup
      }

      // 4. Delete XiaomiDeviceCredentials (authKey)
      await deleteDeviceCredentials(deviceId);
      debugPrint('   ✅ Device credentials deleted');

      // 5. Delete EncryptionKeys (session keys)
      await EncryptionKeys.delete(deviceId);
      debugPrint('   ✅ Encryption keys deleted');

      // 6. ✅ NEW: Delete from discovered device storage (permanent cache)
      // This removes saved services/enrichment data for this device
      try {
        // The deviceId is typically the MAC address, try to delete directly
        final wasDeleted =
            await _instance!._discoveredStorage.deleteDevice(deviceId);
        if (wasDeleted) {
          debugPrint(
            '   ✅ Removed from discovered device storage ($deviceId)',
          );
        }
      } catch (e) {
        debugPrint('   ⚠️ Could not remove from storage: $e');
        // Non-critical: Continue
      }

      debugPrint('✅ [WearableSensors] Device unpaired successfully');
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to unpair device $deviceId: $e',
        code: 'UNPAIR_FAILED',
        cause: e,
        stackTrace: stackTrace,
        deviceId: deviceId,
      );
    }
  }

  /// Gets the current connection state of a device.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to check
  ///
  /// **Returns:** Current [ConnectionState].
  ///
  /// **Example:**
  /// ```dart
  /// final state = await WearableSensors.connectionStatus(deviceId);
  /// if (state.isConnected) {
  ///   print('Device is connected');
  /// }
  /// ```
  static Future<ConnectionState> connectionStatus(String deviceId) async {
    _ensureInitialized();

    try {
      final internalState = _instance!._manager.getConnectionState(deviceId);
      if (internalState == null) {
        return ConnectionState.disconnected; // Default for unknown devices
      }
      return internalState; // ConnectionState is already public type
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to get connection status for $deviceId: $e',
        code: 'STATUS_CHECK_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Stream of devices filtered by type (bonded, nearby, saved, or all).
  ///
  /// This is the unified streaming API for device discovery and monitoring.
  /// All devices flow through this single stream with configurable filtering.
  ///
  /// **Parameters:**
  /// - [filter]: Which devices to stream (bonded, nearby, saved, all)
  /// - [enrich]: Whether to enrich devices with GATT services (default: true)
  ///
  /// **Returns:** `Stream<Map<String, WearableDevice>>` where keys are device IDs.
  ///
  /// **Example:**
  /// ```dart
  /// // Listen to bonded devices
  /// WearableSensors.deviceStream(filter: DeviceFilter.bonded)
  ///   .listen((deviceMap) {
  ///     for (final device in deviceMap.values) {
  ///       print('${device.name}: ${device.statusText}');
  ///     }
  ///   });
  ///
  /// // Listen to nearby devices during scan
  /// WearableSensors.deviceStream(filter: DeviceFilter.nearby)
  ///   .listen((deviceMap) {
  ///     print('Found ${deviceMap.length} nearby devices');
  ///   });
  ///
  /// // Listen to all devices
  /// WearableSensors.deviceStream(filter: DeviceFilter.all)
  ///   .listen((allDevices) {
  ///     // Your device list is always up to date
  ///   });
  /// ```
  ///
  /// **Filter Behavior:**
  /// - `DeviceFilter.bonded`: System-paired devices (may be empty if paired elsewhere)
  /// - `DeviceFilter.nearby`: Devices found during active scan (temporary, cleared when scan stops)
  /// - `DeviceFilter.saved`: Devices previously connected and enriched (persistent history)
  /// - `DeviceFilter.all`: All of the above (union of bonded + nearby + saved)
  ///
  /// **Enrichment Behavior:**
  /// - If `enrich=true` and device is nearby (not bonded/saved):
  ///   - Only emits once device has discovered services (fully enriched)
  ///   - This prevents showing incomplete devices during discovery phase
  /// - If `enrich=false` or device is bonded/saved:
  ///   - Emits immediately (may have 0 services initially)
  ///
  /// **Name Filtering:**
  /// - If `skipUnnamed=true` (default):
  ///   - Discovered devices without names or "Unknown Device": FILTERED OUT
  ///   - Bonded devices without names: SHOWN (user should see their bonded devices)
  /// - If `skipUnnamed=false`:
  ///   - All devices shown regardless of name
  ///
  /// **Real-time Updates:**
  /// Stream emits whenever ANY device changes (connection, battery, properties, etc.)
  static Stream<Map<String, WearableDevice>> deviceStream({
    required DeviceFilter filter,
    bool enrich = true,
    bool skipUnnamed = true,
  }) async* {
    _ensureInitialized();

    await for (final allDevices in _instance!._manager.deviceStatesStream) {
      // Filter devices based on criteria
      final filtered = <String, WearableDevice>{};

      for (final entry in allDevices.entries) {
        final device = entry.value;

        // Check if device matches the filter FIRST
        final matches = filter.matches(
          isPairedToSystem: device.isPairedToSystem,
          isSavedDevice: device.isSavedDevice,
          isNearby: device.isNearby,
        );

        if (!matches) {
          continue;
        }

        // Filter by name ONLY for discovered devices if skipUnnamed=true
        if (skipUnnamed && device.isNearby && !device.isPairedToSystem) {
          // For discovered (nearby) devices, skip if:
          // - Name is null/empty
          // - Name is "Unknown Device"
          final hasValidName = device.name != null &&
              device.name!.isNotEmpty &&
              device.name != 'Unknown Device';
          if (!hasValidName) {
            continue; // Skip unnamed/unknown discovered devices
          }
        }
        // For bonded devices (isPairedToSystem=true): ALWAYS show them,
        // even without names (user intentionally bonded)

        // Filter by enrichment status if enrich=true
        if (enrich && device.isNearby && !device.isPairedToSystem) {
          // For discovered (nearby) devices, only emit if fully enriched
          if (device.discoveredServices.isEmpty) {
            continue; // Wait until services are discovered
          }
        }

        // Device passed all filters - include it
        filtered[entry.key] = device;
      }

      yield filtered;
    }
  }

  // ============================================================
  // SENSOR DATA READING
  // ============================================================

  /// Reads a single sensor value from a device.
  ///
  /// This is a one-time read. For continuous monitoring, use [stream] instead.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to read from
  /// - [sensorType]: Which sensor to read
  ///
  /// **Returns:** [SensorReading] with the current value.
  ///
  /// **Throws:**
  /// - [ConnectionException] if device is not connected
  /// - [WearableException] if sensor is not supported or read fails
  ///
  /// **Example:**
  /// ```dart
  /// final reading = await WearableSensors.read(
  ///   deviceId,
  ///   SensorType.heartRate,
  /// );
  /// print('Heart Rate: ${reading.value} ${reading.displayUnit}');
  /// ```
  static Future<SensorReading> read(
    String deviceId,
    SensorType sensorType,
  ) async {
    _ensureInitialized();

    try {
      // Read via BiometricDataReader (now uses SensorType directly)
      final sample = await _instance!._reader.read(deviceId, sensorType);

      if (sample == null) {
        throw WearableException(
          'No ${sensorType.displayName} data available from device',
          code: 'NO_DATA_AVAILABLE',
        );
      }

      // Convert BiometricSample to SensorReading
      return SensorReading(
        deviceId: deviceId,
        sensorType: sensorType,
        value: sample.value,
        timestamp: sample.timestamp,
        unit: sensorType.unit,
        quality: null, // BiometricSample doesn't include quality
        metadata: sample.metadata,
      );
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to read ${sensorType.displayName} from $deviceId: $e',
        code: 'READ_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Streams multiple sensor types from a device simultaneously.
  ///
  /// Returns a single stream that emits [SensorReading] from all requested sensors.
  /// This is more efficient than creating multiple [stream()] subscriptions and
  /// merging them manually.
  ///
  /// **IMPORTANT:** You must cancel the stream subscription when done to avoid
  /// resource leaks.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to stream from
  /// - [sensorTypes]: List of sensor types to monitor simultaneously
  ///
  /// **Returns:** Stream of [SensorReading] objects from all sensors.
  ///
  /// **Throws:**
  /// - [ConnectionException] if device is not connected
  /// - [WearableException] if no sensors are supported or streaming fails
  ///
  /// **Example:**
  /// ```dart
  /// final sensors = [
  ///   SensorType.heartRate,
  ///   SensorType.accelerometerX,
  ///   SensorType.steps,
  ///   SensorType.battery,
  /// ];
  ///
  /// WearableSensors.streamMultiple(deviceId, sensors).listen((reading) {
  ///   print('${reading.sensorType.name}: ${reading.value}');
  /// });
  /// ```
  static Stream<SensorReading> streamMultiple(
    String deviceId,
    List<SensorType> sensorTypes,
  ) async* {
    _ensureInitialized();

    if (sensorTypes.isEmpty) {
      throw const WearableException(
        'sensorTypes list cannot be empty',
        code: 'INVALID_PARAMETER',
      );
    }

    try {
      // Create controller for merged stream
      final mergedController = StreamController<SensorReading>();
      final subscriptions = <StreamSubscription<SensorReading>>[];

      // Subscribe to each sensor type
      for (final sensorType in sensorTypes) {
        try {
          final sampleStream =
              _instance!._reader.subscribe(deviceId, sensorType);

          // Convert BiometricSample stream to SensorReading stream
          final readingStream = sampleStream.map(
            (sample) => SensorReading(
              deviceId: deviceId,
              sensorType: sensorType,
              value: sample.value,
              timestamp: sample.timestamp,
              unit: sensorType.unit,
              quality: null,
              metadata: sample.metadata,
            ),
          );

          // Subscribe and forward to merged stream
          final subscription = readingStream.listen(
            (reading) => mergedController.add(reading),
            onError: (error) {
              debugPrint('⚠️ Error in ${sensorType.name} stream: $error');
              // Don't propagate errors from individual sensors
            },
          );

          subscriptions.add(subscription);

          // Track this stream for cleanup
          final streamKey = '$deviceId:${sensorType.name}';
          _instance!._activeStreams[streamKey] = subscription;
        } catch (e) {
          debugPrint('⚠️ Failed to subscribe to ${sensorType.name}: $e');
          // Continue with other sensors
        }
      }

      if (subscriptions.isEmpty) {
        throw WearableException(
          'No sensor streams available for device $deviceId',
          code: 'NO_STREAMS',
        );
      }

      // Yield readings from merged stream
      await for (final reading in mergedController.stream) {
        yield reading;
      }

      // Cleanup when stream ends
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
      for (final sensorType in sensorTypes) {
        _instance!._activeStreams.remove('$deviceId:${sensorType.name}');
      }
      await mergedController.close();
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to stream multiple sensors from $deviceId: $e',
        code: 'STREAM_MULTIPLE_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Streams continuous sensor data from a device.
  ///
  /// Returns a stream that emits new readings as they arrive from the device.
  /// The stream automatically handles reconnection if the connection is lost.
  ///
  /// **IMPORTANT:** You must cancel the stream subscription when done to avoid
  /// resource leaks. The package tracks active streams and cancels them on
  /// disconnect, but explicit cancellation is recommended.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to stream from
  /// - [sensorType]: Which sensor to stream
  /// - [samplingRate]: Desired sampling rate in Hz (device may not support exact rate)
  ///
  /// **Returns:** Stream of [SensorReading] objects.
  ///
  /// **Throws:**
  /// - [ConnectionException] if device is not connected
  /// - [WearableException] if sensor is not supported or streaming fails
  ///
  /// **Example:**
  /// ```dart
  /// final subscription = WearableSensors.stream(
  ///   deviceId,
  ///   SensorType.heartRate,
  /// ).listen((reading) {
  ///   print('HR: ${reading.value} bpm');
  /// });
  ///
  /// // Later: cancel to stop streaming
  /// await subscription.cancel();
  /// ```
  static Stream<SensorReading> stream(
    String deviceId,
    SensorType sensorType, {
    double? samplingRate,
  }) async* {
    _ensureInitialized();

    try {
      // Subscribe via BiometricDataReader (now uses SensorType directly)
      final sampleStream = _instance!._reader.subscribe(deviceId, sensorType);

      // Track this stream for cleanup
      final streamKey = '$deviceId:${sensorType.name}';
      final subscription = sampleStream.listen(null);
      _instance!._activeStreams[streamKey] = subscription;

      // Convert BiometricSample stream to SensorReading stream
      await for (final sample in sampleStream) {
        yield SensorReading(
          deviceId: deviceId,
          sensorType: sensorType,
          value: sample.value,
          timestamp: sample.timestamp,
          unit: sensorType.unit,
          quality: null, // BiometricSample doesn't include quality
          metadata: sample.metadata,
        );
      }

      // Remove from active streams when done
      _instance!._activeStreams.remove(streamKey);
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to stream ${sensorType.displayName} from $deviceId: $e',
        code: 'STREAM_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // DEVICE INFORMATION
  // ============================================================

  /// Gets the capabilities of a device.
  ///
  /// Returns information about what sensors and features the device supports.
  /// Device must be connected to query capabilities.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to query
  ///
  /// **Returns:** [DeviceCapabilities] object.
  ///
  /// **Example:**
  /// ```dart
  /// final caps = await WearableSensors.getCapabilities(deviceId);
  /// if (caps.supportsSensor(SensorType.heartRateVariability)) {
  ///   print('Device supports HRV monitoring');
  /// }
  /// ```
  static Future<DeviceCapabilities> getCapabilities(String deviceId) async {
    _ensureInitialized();

    try {
      // 1. Get device state to find deviceTypeId
      final deviceState = _instance!._manager.deviceStates[deviceId];
      if (deviceState == null) {
        throw WearableException(
          'Device not found: $deviceId',
          code: 'DEVICE_NOT_FOUND',
        );
      }

      // 2. Check if device type is known (not 'unknown')
      if (deviceState.deviceTypeId == 'unknown') {
        throw const WearableException(
          'Device type unknown - connect device first to discover capabilities',
          code: 'DEVICE_TYPE_UNKNOWN',
        );
      }

      // 3. Load device implementation JSON
      final deviceImpl = await DeviceImplementationLoader.load(
        deviceState.deviceTypeId,
      );

      // 4. Extract supported data types from JSON
      final supportedDataTypes = deviceImpl.getSupportedDataTypes();

      // 5. Match data_types with SensorType.internalDataType
      final supportedSensors = <SensorType>{};
      for (final dataType in supportedDataTypes) {
        // Find SensorType where internalDataType matches
        for (final sensorType in SensorType.values) {
          if (sensorType.internalDataType == dataType) {
            supportedSensors.add(sensorType);
            break;
          }
        }
      }

      return DeviceCapabilities(supportedSensors: supportedSensors);
    } catch (e, stackTrace) {
      if (e is WearableException) rethrow;

      throw WearableException(
        'Failed to get capabilities for $deviceId: $e',
        code: 'CAPABILITIES_QUERY_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets the current state of a device.
  ///
  /// Returns comprehensive device information including connection status,
  /// battery level, last seen time, etc.
  ///
  /// **Parameters:**
  /// - [deviceId]: The device ID to query
  ///
  /// **Returns:** [WearableDevice] with current state.
  ///
  /// **Example:**
  /// ```dart
  /// final device = await WearableSensors.getDeviceState(deviceId);
  /// print('Battery: ${device.batteryText}');
  /// print('Status: ${device.statusText}');
  /// ```
  static Future<WearableDevice> getDeviceState(String deviceId) async {
    _ensureInitialized();

    try {
      final deviceState = _instance!._manager.deviceStates[deviceId];
      if (deviceState == null) {
        throw WearableException(
          'Device state not available for $deviceId',
          code: 'DEVICE_STATE_UNAVAILABLE',
        );
      }
      return deviceState; // WearableDevice is already public type
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to get device state for $deviceId: $e',
        code: 'DEVICE_STATE_QUERY_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // DEVICE SUPPORT INFORMATION
  // ============================================================

  /// Checks if a device is supported by the package based on its name.
  ///
  /// This is a quick pattern-match check that doesn't require device connection.
  /// Use this to filter scan results or validate device names before attempting connection.
  ///
  /// **Parameters:**
  /// - [deviceName]: The advertised device name (e.g., "Xiaomi Smart Band 10 A1B2")
  ///
  /// **Returns:** `true` if the device is recognized and supported.
  ///
  /// **Example:**
  /// ```dart
  /// if (WearableSensors.isDeviceSupported('Xiaomi Smart Band 10 A1B2')) {
  ///   print('This device is supported!');
  /// }
  /// ```
  static bool isDeviceSupported(String deviceName) {
    // Import here to avoid circular dependency
    // ignore: library_private_types_in_public_api
    return SupportedDevicesConfig.isSupported(deviceName);
  }

  /// Gets detailed information about a supported device by name.
  ///
  /// Returns device metadata including display name, whether authentication
  /// is required, and authentication protocol details. Returns `null` if
  /// the device is not supported.
  ///
  /// **Parameters:**
  /// - [deviceName]: The advertised device name
  ///
  /// **Returns:** Map with device info, or `null` if unsupported.
  ///
  /// **Example:**
  /// ```dart
  /// final info = await WearableSensors.getDeviceInfo('Xiaomi Smart Band 10 A1B2');
  /// if (info != null) {
  ///   print('Display Name: ${info['displayName']}');
  ///   print('Requires Auth: ${info['requiresAuth']}');
  ///   print('Protocol: ${info['authProtocol']}');
  /// }
  /// ```
  static Future<Map<String, dynamic>?> getDeviceInfo(String deviceName) async {
    // Import here to avoid circular dependency
    // ignore: library_private_types_in_public_api
    final config = await SupportedDevicesConfig.detectDevice(deviceName);

    if (config == null) return null;

    return {
      'deviceType': config.deviceType,
      'displayName': config.displayName,
      'requiresAuth': config.requiresAuth,
      'authProtocol': config.authProtocol,
      'notes': config.notes,
    };
  }

  /// Gets a list of all supported device models.
  ///
  /// **Parameters:**
  /// - [vendor]: Optional vendor filter ('xiaomi', 'fitbit', etc.)
  ///
  /// **Returns:** List of display names for supported devices.
  ///
  /// **Example:**
  /// ```dart
  /// // All devices
  /// final all = await WearableSensors.getSupportedDevices();
  ///
  /// // Only Xiaomi devices
  /// final xiaomi = await WearableSensors.getSupportedDevices(vendor: 'xiaomi');
  /// ```
  static Future<List<String>> getSupportedDevices({String? vendor}) async {
    // Import here to avoid circular dependency
    // ignore: library_private_types_in_public_api
    if (vendor?.toLowerCase() == 'xiaomi') {
      return await SupportedDevicesConfig.getSupportedXiaomiModels();
    }

    return await SupportedDevicesConfig.getAllSupportedModels();
  }

  // ============================================================
  // DEVICE CREDENTIALS MANAGEMENT
  // ============================================================

  /// Saves authentication credentials for a device.
  ///
  /// Stores the credentials securely (encrypted storage) for future use.
  /// Typically called after user extracts authKey from Mi Fitness or similar.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address (format: "AA:BB:CC:DD:EE:FF")
  /// - [authKey]: Hex string authentication key
  /// - [authenticationType]: Protocol type (defaults to 'xiaomi_spp')
  ///
  /// **Example:**
  /// ```dart
  /// // After extracting authKey from Mi Fitness ZIP
  /// await WearableSensors.saveDeviceCredentials(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   authKey: 'a1b2c3d4e5f6...',
  /// );
  /// ```
  ///
  /// **Throws:**
  /// - [WearableException] if deviceId or authKey is empty
  static Future<void> saveDeviceCredentials({
    required String deviceId,
    required String authKey,
    String authenticationType = 'xiaomi_spp',
  }) async {
    if (deviceId.isEmpty) {
      throw const WearableException(
        'Device ID cannot be empty',
        code: 'INVALID_DEVICE_ID',
      );
    }

    if (authKey.isEmpty) {
      throw const WearableException(
        'AuthKey cannot be empty',
        code: 'INVALID_AUTH_KEY',
      );
    }

    // Use internal Xiaomi credentials storage
    // This wraps flutter_secure_storage with vendor-specific logic
    final credentials = XiaomiDeviceCredentials(
      deviceId: deviceId,
      authKey: authKey,
    );

    await credentials.save();

    debugPrint(
      '✅ [WearableSensors] Credentials saved for device $deviceId (type: $authenticationType)',
    );

    // ✅ UPDATE device state: credentials saved → requiresAuthentication=false
    // This notifies the connection manager that the device no longer needs auth
    try {
      _instance?._manager.updateDeviceAuthenticationState(
        deviceId,
        requiresAuthentication: false,
      );
      debugPrint(
        '✅ [WearableSensors] Updated device state: requiresAuthentication=false for $deviceId',
      );
    } catch (e) {
      debugPrint('⚠️ [WearableSensors] Error updating device state: $e');
      // Non-critical: credentials were still saved successfully
    }
  }

  /// Retrieves authentication credentials for a device.
  ///
  /// Returns the stored credentials if they exist, or `null` if no credentials
  /// are found for this device.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  ///
  /// **Returns:** [AuthCredentials] or `null` if not found.
  ///
  /// **Example:**
  /// ```dart
  /// final credentials = await WearableSensors.getDeviceCredentials(deviceId);
  /// if (credentials != null) {
  ///   print('AuthKey: ${credentials.authKey}');
  /// }
  /// ```
  static Future<AuthCredentials?> getDeviceCredentials(String deviceId) async {
    if (deviceId.isEmpty) return null;

    // Load from internal Xiaomi credentials storage (static method)
    final xiaomiCredentials = await XiaomiDeviceCredentials.load(deviceId);

    if (xiaomiCredentials == null) return null;

    return AuthCredentials(
      authKey: xiaomiCredentials.authKey,
      userId: xiaomiCredentials.userId,
      vendorSpecific: {
        'vendor': 'xiaomi',
        'protocol': 'xiaomi_spp',
      },
    );
  }

  /// Checks if credentials exist for a device.
  ///
  /// Fast check without loading the full credentials.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  ///
  /// **Returns:** `true` if credentials exist, `false` otherwise.
  ///
  /// **Example:**
  /// ```dart
  /// if (await WearableSensors.hasDeviceCredentials(deviceId)) {
  ///   print('Device already has credentials stored');
  /// }
  /// ```
  static Future<bool> hasDeviceCredentials(String deviceId) async {
    final credentials = await getDeviceCredentials(deviceId);
    return credentials != null && credentials.hasAuthKey;
  }

  /// Deletes stored credentials for a device.
  ///
  /// Removes the credentials from secure storage. Useful when user wants to
  /// re-pair a device or clear stored authentication data.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.deleteDeviceCredentials(deviceId);
  /// print('Credentials deleted');
  /// ```
  static Future<void> deleteDeviceCredentials(String deviceId) async {
    if (deviceId.isEmpty) return;

    // Use static delete method
    await XiaomiDeviceCredentials.delete(deviceId);

    debugPrint(
      '🗑️ [WearableSensors] Credentials deleted for device $deviceId',
    );
  }

  // ============================================================
  // INTERNAL HELPERS
  // ============================================================

  /// Ensures the package is initialized, throws if not.
  static void _ensureInitialized() {
    if (_instance == null || !_instance!._isInitialized) {
      throw const WearableException(
        'WearableSensors not initialized. Call initialize() first.',
        code: 'NOT_INITIALIZED',
      );
    }
  }

  /// Cancels all active sensor streams for a device.
  static Future<void> _cancelStreamsForDevice(String deviceId) async {
    final keysToRemove = <String>[];

    for (final entry in _instance!._activeStreams.entries) {
      if (entry.key.startsWith('$deviceId:')) {
        await entry.value.cancel();
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _instance!._activeStreams.remove(key);
    }
  }

  /// Disposes all resources (for testing/cleanup).
  ///
  /// **WARNING:** Only call this when shutting down the app completely.
  /// After calling this, you must call [initialize] again before using
  /// any other methods.
  static Future<void> dispose() async {
    if (_instance == null) return;

    // Cancel all active streams
    for (final subscription in _instance!._activeStreams.values) {
      await subscription.cancel();
    }
    _instance!._activeStreams.clear();

    // Disconnect all devices via DeviceConnectionManager
    for (final deviceId in _instance!._manager.deviceStates.keys) {
      await _instance!._manager.disconnectDevice(deviceId);
    }

    // Dispose services
    await _instance!._storageService?.dispose();

    _instance!._isInitialized = false;
    _instance = null;
  }
}
