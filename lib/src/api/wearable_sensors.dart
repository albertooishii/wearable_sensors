import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;

import '../internal/adapters/device_adapter.dart';
import '../internal/bluetooth/device_connection_manager.dart';
import '../internal/bluetooth/biometric_data_reader.dart';
import '../internal/bluetooth/enriched_device_scanner.dart';
import '../internal/services/device_storage_service.dart';
import '../internal/config/supported_devices_config.dart';
import '../internal/utils/device_implementation_loader.dart';
import '../internal/vendors/xiaomi/xiaomi_device_credentials.dart';
import '../internal/vendors/xiaomi/xiaomi_auth_service.dart'; // For EncryptionKeys
import 'enums/connection_state.dart';
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
/// // 2. Scan for devices
/// final stream = WearableSensors.scan(duration: Duration(seconds: 10));
/// await for (final device in stream) {
///   print('Found: ${device.name}');
/// }
///
/// // 3. Connect to a device
/// final device = await WearableSensors.connect(deviceId);
/// print('Connected to: ${device.name}');
///
/// // 4. Read sensor data
/// final reading = await WearableSensors.read(deviceId, SensorType.heartRate);
/// print('Heart Rate: ${reading.value} ${reading.unit}');
///
/// // 5. Stream real-time data
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

      await _instance!._connectionManager!.initialize();
      await _instance!._storageService!.initialize();

      if (forceReset) {
        await _instance!._storageService!.clearAll();
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

  /// Scans for nearby wearable devices.
  ///
  /// Returns a stream of discovered devices. Devices may appear multiple times
  /// as RSSI (signal strength) updates are received.
  ///
  /// **Parameters:**
  /// - [duration]: How long to scan (default: 10 seconds)
  /// - [filterByServices]: Only return devices advertising these BLE service UUIDs
  ///
  /// **Returns:** Stream of [WearableDevice] objects as they're discovered.
  ///
  /// **Throws:**
  /// - [WearableException] if Bluetooth is disabled or scanning fails
  ///
  /// **Example:**
  /// ```dart
  /// final stream = WearableSensors.scan(duration: Duration(seconds: 10));
  /// await for (final device in stream) {
  ///   print('Found: ${device.name} (${device.rssi} dBm)');
  /// }
  /// ```
  static Stream<WearableDevice> scan({
    Duration duration = const Duration(seconds: 10),
    List<String>? filterByServices,
    bool enriched = false,
    int parallelism = 3,
    Duration enrichmentTimeout = const Duration(seconds: 3),
  }) async* {
    _ensureInitialized();

    try {
      if (enriched) {
        // ✅ ENRICHED SCAN: Connect to each device to get full info
        yield* _scanEnriched(
          duration: duration,
          parallelism: parallelism,
          enrichmentTimeout: enrichmentTimeout,
          filterByServices: filterByServices,
        );
      } else {
        // ✅ BASIC SCAN: Fast BLE discovery only (no connections)
        yield* _scanBasic(
          duration: duration,
          filterByServices: filterByServices,
        );
      }
    } catch (e, stackTrace) {
      throw ConnectionException(
        'Failed to scan for devices: $e',
        code: 'SCAN_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Basic BLE scan - Fast discovery without enrichment
  static Stream<WearableDevice> _scanBasic({
    required Duration duration,
    List<String>? filterByServices,
  }) async* {
    debugPrint('📡 Starting BASIC scan (${duration.inSeconds}s)...');

    try {
      // Start scanning via DeviceConnectionManager
      await _instance!._manager.startScanning(timeout: duration);

      // Listen to discovered devices stream
      await for (final bleDevice
          in _instance!._manager.discoveredDevicesStream) {
        // Apply service filter if provided (post-scan filtering)
        if (filterByServices != null && filterByServices.isNotEmpty) {
          final hasRequestedService = bleDevice.services.any(
            (serviceUuid) =>
                filterByServices.contains(serviceUuid.toLowerCase()),
          );

          if (!hasRequestedService) {
            continue;
          }
        }

        yield await DeviceAdapter.fromInternal(bleDevice);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Basic scan failed: $e');
      throw ConnectionException(
        'Basic scan failed: $e',
        code: 'BASIC_SCAN_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Enriched scan - Discovers devices with full info (services, battery, type)
  static Stream<WearableDevice> _scanEnriched({
    required Duration duration,
    required int parallelism,
    required Duration enrichmentTimeout,
    List<String>? filterByServices,
  }) async* {
    debugPrint(
      '🔍 Starting ENRICHED scan (${duration.inSeconds}s, parallelism: $parallelism)...',
    );

    late EnrichedDeviceScanner scanner;

    try {
      // Import the scanner
      scanner = EnrichedDeviceScanner(
        bleService: _instance!._manager.bleService,
        discoveredDevicesStream:
            _instance!._manager.bleService.rawBleDevicesStream,
        duration: duration,
        parallelism: parallelism,
        enrichmentTimeout: enrichmentTimeout,
      );

      // Start scanner
      await scanner.start();

      // Emit enriched devices
      await for (final enrichedDevice in scanner.resultsStream) {
        // Apply filter if provided
        if (filterByServices != null && filterByServices.isNotEmpty) {
          final hasRequestedService = enrichedDevice.discoveredServices.any(
            (service) => filterByServices.contains(service.uuid.toLowerCase()),
          );

          if (!hasRequestedService) {
            continue;
          }
        }

        yield enrichedDevice;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Enriched scan failed: $e');
      throw ConnectionException(
        'Enriched scan failed: $e',
        code: 'ENRICHED_SCAN_FAILED',
        cause: e,
        stackTrace: stackTrace,
      );
    } finally {
      await scanner.dispose();
    }
  }

  /// Stream of all discovered devices during active scan.
  ///
  /// This is a broadcast stream that emits devices as they're found.
  /// Subscribe to this stream before calling [scan()].
  ///
  /// **Example:**
  /// ```dart
  /// WearableSensors.discoveredDevices().listen((device) {
  ///   print('Discovered: ${device.name}');
  /// });
  ///
  /// WearableSensors.scan(); // Start scanning
  /// ```
  static Stream<WearableDevice> discoveredDevices() async* {
    _ensureInitialized();
    await for (final bleDevice in _instance!._manager.discoveredDevicesStream) {
      yield await DeviceAdapter.fromInternal(bleDevice);
    }
  }

  /// Gets list of devices that are bonded (paired) at the system level.
  ///
  /// These devices have been paired through the OS Bluetooth settings,
  /// not necessarily through this app. They may still require app-level
  /// authentication to actually connect and read data.
  ///
  /// **Returns:** List of system-bonded [WearableDevice] objects.
  ///
  /// **Example:**
  /// ```dart
  /// final bonded = await WearableSensors.getBondedDevices();
  /// for (final device in bonded) {
  ///   print('Bonded: ${device.name}');
  /// }
  /// ```
  static Future<List<WearableDevice>> getBondedDevices() async {
    _ensureInitialized();

    try {
      // Get bonded devices from DeviceConnectionManager
      final bondedDevices = await _instance!._manager.getBondedDevices();
      return bondedDevices;
    } catch (e, stackTrace) {
      throw WearableException(
        'Failed to get bonded devices: $e',
        code: 'BONDED_DEVICES_FAILED',
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

  /// Stream of connection state changes for all devices.
  ///
  /// Emits a map of deviceId → ConnectionState whenever any device's
  /// connection state changes.
  ///
  /// **Example:**
  /// ```dart
  /// WearableSensors.allConnectionStates.listen((states) {
  ///   states.forEach((deviceId, state) {
  ///     print('$deviceId: ${state.displayName}');
  ///   });
  /// });
  /// ```
  static Stream<Map<String, ConnectionState>> get allConnectionStates {
    _ensureInitialized();
    return _instance!._manager.connectionStatesStream;
    // ConnectionState is already public type, no adapter needed
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
