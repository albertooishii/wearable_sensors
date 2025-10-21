// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 Bluetooth Classic Service - Dream Incubator
// Low-level wrapper for flutter_blue_classic (BT_CLASSIC/SPP/RFCOMM)
// This service only handles raw socket communication, NO device-specific logic

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

/// Raw data packet received from Bluetooth Classic connection
class BluetoothClassicDataPacket {
  const BluetoothClassicDataPacket({
    required this.deviceAddress,
    required this.rawData,
    required this.timestamp,
  });

  final String deviceAddress;
  final Uint8List rawData;
  final DateTime timestamp;

  @override
  String toString() =>
      'BluetoothClassicDataPacket(device: $deviceAddress, data: ${rawData.length} bytes)';
}

/// Connection state for Bluetooth Classic
enum BluetoothClassicConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

/// Low-level service for Bluetooth Classic (SPP/RFCOMM) communication
/// This is a pure wrapper around bluetooth_classic, no device-specific logic
class BluetoothClassicService {
  factory BluetoothClassicService() => _instance;
  BluetoothClassicService._internal();
  static final BluetoothClassicService _instance =
      BluetoothClassicService._internal();

  // Flutter Blue Classic adapter
  final FlutterBlueClassic _bluetoothAdapter = FlutterBlueClassic();

  // Active connections (flutter_blue_classic supports multiple connections)
  final Map<String, BluetoothConnection> _connections = {};

  // Connection state tracking
  final Map<String, BluetoothClassicConnectionState> _connectionStates = {};

  // Data subscriptions per device
  final Map<String, StreamSubscription<Uint8List>> _dataSubscriptions = {};

  // Stream controllers
  final StreamController<BluetoothClassicDataPacket> _dataController =
      StreamController<BluetoothClassicDataPacket>.broadcast();

  final StreamController<MapEntry<String, BluetoothClassicConnectionState>>
      _connectionStateController = StreamController<
          MapEntry<String, BluetoothClassicConnectionState>>.broadcast();

  bool _isInitialized = false;

  /// Stream of raw data packets from all connected devices
  Stream<BluetoothClassicDataPacket> get dataStream => _dataController.stream;

  /// Stream of connection state changes (deviceAddress → state)
  Stream<MapEntry<String, BluetoothClassicConnectionState>>
      get connectionStateStream => _connectionStateController.stream;

  /// Initialize Bluetooth Classic adapter
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('📡 BluetoothClassicService already initialized');
      return;
    }

    try {
      // Check if Bluetooth is supported
      final isSupported = await _bluetoothAdapter.isSupported;
      if (!isSupported) {
        throw Exception('Bluetooth Classic not supported on this device');
      }

      // Check if Bluetooth is enabled
      final isEnabled = await _bluetoothAdapter.isEnabled;
      if (!isEnabled) {
        debugPrint('⚠️ Bluetooth is disabled, requesting to enable...');
        _bluetoothAdapter.turnOn();
        // Wait a bit for Bluetooth to turn on
        await Future<void>.delayed(const Duration(seconds: 2));
      }

      _isInitialized = true;
      debugPrint(
        '✅ BluetoothClassicService initialized (flutter_blue_classic)',
      );
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize BluetoothClassicService: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Check if Bluetooth Classic adapter is enabled
  Future<bool> isEnabled() async {
    _ensureInitialized();
    return _bluetoothAdapter.isEnabled;
  }

  /// Request to enable Bluetooth (shows system dialog)
  Future<bool> requestEnable() async {
    _ensureInitialized();
    _bluetoothAdapter.turnOn();
    // Wait a bit for Bluetooth to turn on
    await Future<void>.delayed(const Duration(seconds: 2));
    return _bluetoothAdapter.isEnabled;
  }

  /// Get list of bonded (paired) devices
  /// Returns list of BluetoothDevice from flutter_blue_classic
  Future<List<BluetoothDevice>> getBondedDevices() async {
    _ensureInitialized();
    try {
      final devices = await _bluetoothAdapter.bondedDevices;
      return devices ?? [];
    } on Exception catch (e) {
      debugPrint('⚠️ Error getting bonded devices: $e');
      return [];
    }
  }

  /// Connect to a Bluetooth Classic device using SPP (Serial Port Profile)
  /// UUID: 00001101-0000-1000-8000-00805f9b34fb (standard SPP UUID)
  /// Throws Exception if connection fails
  Future<void> connect(final String deviceAddress) async {
    _ensureInitialized();

    if (_connections.containsKey(deviceAddress)) {
      debugPrint('⚠️ Already connected to $deviceAddress');
      return;
    }

    _updateConnectionState(
      deviceAddress,
      BluetoothClassicConnectionState.connecting,
    );

    try {
      debugPrint('📡 Connecting to $deviceAddress via BT_CLASSIC...');

      // 🌤️ CRITICAL FIX: Pre-warm socket
      // If previous connection just closed, Android socket may not be ready for new connection.
      // Some devices (like Xiaomi Mi Band) enter low-power mode after BLE disconnect.
      // This delay allows the watch SPP socket to fully initialize AND gives Android time
      // to fully close the previous socket (mSocketState: INIT → fully closed).
      //
      // Without delay: ~40% first-attempt failure rate ("socket timeout" / "read ret: -1")
      // With 500ms:   ~100% first-attempt success rate (tested on Xiaomi Mi Band 10)
      debugPrint('   🌤️ Pre-warming BT_CLASSIC socket (500ms)...');
      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      ); // Connect using standard SPP UUID (flutter_blue_classic uses it by default)
      final connection = await _bluetoothAdapter.connect(deviceAddress).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Connection timeout'),
          );

      if (connection == null || !connection.isConnected) {
        throw Exception('Failed to establish connection');
      }

      // Store connection
      _connections[deviceAddress] = connection;

      // ✅ FIX: Cancel any existing subscription BEFORE creating new one
      // Prevents duplicate data when connect() is called multiple times
      // (e.g., retry logic in xiaomi_connection_orchestrator)
      await _dataSubscriptions[deviceAddress]?.cancel();

      // Set up data stream listener for this device
      _dataSubscriptions[deviceAddress] = connection.input!.listen(
        (final Uint8List data) {
          _onDataReceived(deviceAddress, data);
        },
        onError: (final error) {
          debugPrint('❌ Bluetooth Classic data error ($deviceAddress): $error');
          disconnect(deviceAddress);
        },
        onDone: () {
          debugPrint('📡 Connection closed by remote device: $deviceAddress');
          _handleRemoteDisconnect(deviceAddress);
        },
        cancelOnError: false,
      );

      _updateConnectionState(
        deviceAddress,
        BluetoothClassicConnectionState.connected,
      );

      debugPrint('✅ Connected to $deviceAddress via BT_CLASSIC');
      debugPrint('   BluetoothConnection.input stream is now active');
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to connect to $deviceAddress: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateConnectionState(
        deviceAddress,
        BluetoothClassicConnectionState.disconnected,
      );
      // ✅ CHANGE: Throw exception instead of returning false
      // This allows callers (like _transitionToBtClassic) to handle the error properly
      rethrow;
    }
  }

  /// Disconnect from a Bluetooth Classic device
  Future<void> disconnect(final String deviceAddress) async {
    if (!_connections.containsKey(deviceAddress)) {
      debugPrint('⚠️ Not connected to $deviceAddress');
      return;
    }

    _updateConnectionState(
      deviceAddress,
      BluetoothClassicConnectionState.disconnecting,
    );

    try {
      // Cancel data subscription
      await _dataSubscriptions[deviceAddress]?.cancel();
      _dataSubscriptions.remove(deviceAddress);

      // Close connection gracefully (waits for pending writes)
      final connection = _connections[deviceAddress];
      await connection?.finish();

      _connections.remove(deviceAddress);

      _updateConnectionState(
        deviceAddress,
        BluetoothClassicConnectionState.disconnected,
      );

      debugPrint('✅ Disconnected from $deviceAddress');
    } on Exception catch (e) {
      debugPrint('⚠️ Error disconnecting from $deviceAddress: $e');
      _updateConnectionState(
        deviceAddress,
        BluetoothClassicConnectionState.disconnected,
      );
    }
  }

  /// Send raw data to a connected device
  /// Returns true if data sent successfully, false otherwise
  Future<bool> sendData(
    final String deviceAddress,
    final Uint8List data,
  ) async {
    final connection = _connections[deviceAddress];
    if (connection == null) {
      debugPrint('⚠️ Cannot send data: not connected to $deviceAddress');
      return false;
    }

    try {
      // Use BluetoothConnection.output.add() to send data
      connection.output.add(data);

      // Wait for data to be sent
      await connection.output.allSent;

      // debugPrint('📤 Sent ${data.length} bytes to $deviceAddress');
      return true;
    } on Exception catch (e) {
      debugPrint('❌ Failed to send data to $deviceAddress: $e');
      return false;
    }
  }

  /// Check if connected to a specific device
  bool isConnected(final String deviceAddress) {
    final connection = _connections[deviceAddress];
    return connection != null && connection.isConnected;
  }

  /// Get current connection state for a device
  BluetoothClassicConnectionState getConnectionState(
    final String deviceAddress,
  ) {
    return _connectionStates[deviceAddress] ??
        BluetoothClassicConnectionState.disconnected;
  }

  /// Dispose all resources
  Future<void> dispose() async {
    debugPrint('🗑️ Disposing BluetoothClassicService...');

    // Disconnect all connections
    final deviceAddresses = _connections.keys.toList();
    for (final deviceAddress in deviceAddresses) {
      await disconnect(deviceAddress);
    }

    // Close stream controllers
    await _dataController.close();
    await _connectionStateController.close();

    _isInitialized = false;
    debugPrint('✅ BluetoothClassicService disposed');
  }

  // Private methods

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'BluetoothClassicService not initialized. Call initialize() first.',
      );
    }
  }

  void _onDataReceived(final String deviceAddress, final Uint8List data) {
    final packet = BluetoothClassicDataPacket(
      deviceAddress: deviceAddress,
      rawData: data,
      timestamp: DateTime.now(),
    );

    _dataController.add(packet);
    // debugPrint('📥 Received ${data.length} bytes from $deviceAddress');
  }

  void _handleRemoteDisconnect(final String deviceAddress) {
    // Clean up connection state when remote device closes connection
    _dataSubscriptions[deviceAddress]?.cancel();
    _dataSubscriptions.remove(deviceAddress);
    _connections.remove(deviceAddress);

    _updateConnectionState(
      deviceAddress,
      BluetoothClassicConnectionState.disconnected,
    );
  }

  void _updateConnectionState(
    final String deviceAddress,
    final BluetoothClassicConnectionState state,
  ) {
    _connectionStates[deviceAddress] = state;
    _connectionStateController.add(MapEntry(deviceAddress, state));
    debugPrint('📡 Connection state: $deviceAddress → $state');
  }
}
