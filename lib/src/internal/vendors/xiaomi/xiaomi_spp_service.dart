// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 Xiaomi SPP Service - Dream Incubator
// High-level service for Xiaomi SPP (Serial Port Profile) communication
// Transport-agnostic: works over both BLE (during auth) and BT_CLASSIC (for data)

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/spp_transport.dart';
import 'protocol/v2/handler.dart';
import 'protocol/v2/packet.dart'; // For SppV2Channel, AckPacket, DataPacket
import 'protocol/v1/packet.dart'; // For Version handshake
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/btclassic_spp_transport.dart'; // For type checking
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_auth_service.dart';
import 'package:wearable_sensors/src/internal/models/xiaomi_spp_config.dart';
import 'package:wearable_sensors/src/internal/utils/xiaomi_device_config_loader.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as proto;

/// SPP Connection State
enum SppConnectionState {
  disconnected,
  connecting,
  initializingSession, // V2 only: session handshake
  ready, // Ready for data transmission
  error,
}

/// Parse result for buffer processing (Gadgetbridge pattern)
enum _ParseResult {
  complete, // Packet processed successfully
  incomplete, // Need more bytes
  invalid, // Packet corrupted
}

/// Callback types for SPP events
typedef OnSppDataReceivedCallback = void Function(Uint8List data);
typedef OnSppStateChangedCallback = void Function(SppConnectionState state);
typedef OnSessionConfigReceivedCallback = Future<void> Function();

/// SPP Data Packet - Contains received data with device context
class SppDataPacket {
  SppDataPacket({
    required this.deviceId,
    required this.data,
    required this.timestamp,
    this.channel,
  });

  final String deviceId;
  final Uint8List data;
  final DateTime timestamp;
  final String? channel; // Channel name (e.g., 'protobuf_command', 'activity')
}

/// Xiaomi SPP Service
///
/// High-level wrapper for Xiaomi SPP communication.
/// Transport-agnostic: works over BLE (during auth) or BT_CLASSIC (for data).
/// Automatically detects SPP version (V1 or V2) and uses appropriate protocol.
///
/// **Usage with BLE transport (during authentication):**
/// ```dart
/// final transport = BleSppTransport(
///   deviceId: 'AA:BB:CC:DD:EE:FF',
///   bleService: bleService,
///   serviceUuid: '...',
///   writeCharacteristicUuid: '...',
///   readCharacteristicUuid: '...',
/// );
///
/// final sppService = XiaomiSppService(
///   transport: transport,
///   deviceType: 'smart_band_10',
/// );
///
/// await sppService.connect();
/// ```
///
/// **Usage with BT_CLASSIC transport (post-authentication):**
/// ```dart
/// final transport = BtClassicSppTransport(
///   deviceAddress: 'AA:BB:CC:DD:EE:FF',
///   btClassicService: btClassicService,
/// );
///
/// final sppService = XiaomiSppService(
///   transport: transport,
///   deviceType: 'smart_band_10',
///   encryptionKeys: authKeys,
/// );
///
/// await sppService.connect();
/// ```
class XiaomiSppService {
  XiaomiSppService({
    required this.transport,
    required this.deviceType,
    required this.deviceId, // Need deviceId for V2 handler commands
    this.encryptionKeys,
    this.authService, // ← For calling startEncryptedHandshake()
  });

  final SppTransport transport;
  final String deviceType;
  final String deviceId;
  EncryptionKeys? encryptionKeys; // ✅ Made mutable for session key updates
  final XiaomiAuthService? authService;

  /// Update encryption keys after NONCE handshake
  /// CRITICAL: Must be called after deriving new session keys
  void updateEncryptionKeys(final EncryptionKeys newKeys) {
    encryptionKeys = newKeys;
    debugPrint('🔐 SPP: Encryption keys updated with fresh session keys');
    debugPrint(
      '   encryptionNonce: ${newKeys.encryptionNonce.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );
  }

  // SPP protocol components
  SppProtocolVersion _sppVersion = SppProtocolVersion.v1;
  XiaomiAuthConfig? _sppConfig;
  SppV2ProtocolHandler? _sppV2Handler;

  // Protocol state
  SppConnectionState _state = SppConnectionState.disconnected;
  // TODO: Implement frame and encryption counters for V1 protocol
  // int _frameCounter = 0;
  // int _encryptionCounter = 0;

  // Stream subscriptions
  StreamSubscription<Uint8List>? _dataSubscription;

  // Callbacks
  OnSppDataReceivedCallback? onDataReceived;
  OnSppStateChangedCallback? onStateChanged;
  OnSessionConfigReceivedCallback? onSessionConfigReceived;

  // ✅ Data stream controller for exposing received data
  final StreamController<SppDataPacket> _dataStreamController =
      StreamController<SppDataPacket>.broadcast();

  /// Stream of received SPP data packets (for realtime stats, etc.)
  Stream<SppDataPacket> get dataStream => _dataStreamController.stream;

  // ✅ Buffer acumulativo para BT_CLASSIC (Gadgetbridge pattern)
  // Acumula bytes fragmentados del socket antes de parsear packets
  final BytesBuilder _buffer = BytesBuilder();

  // Request/Response routing for protobuf commands
  final Map<int, Completer<proto.Command>> _pendingRequests = {};
  int _requestIdCounter = 0;

  /// Mapping between SPP V2 sequence numbers and request IDs
  ///
  /// Critical for BT_CLASSIC routing: sequence numbers are auto-generated
  /// by DataPacketBuilder, while requestIds are tracked here for timeouts.
  final Map<int, int> _sequenceToRequestId = {};

  /// SPP V2 sequence number counter (Gadgetbridge pattern)
  /// Must increment for each DATA packet sent
  int _sppV2SequenceCounter = 0;

  /// Track expected command type+subtype for each requestId
  /// Used for intelligent response routing when device doesn't echo seq correctly
  final Map<int, String> _requestIdToExpectedCommand = {};

  // Version handshake tracking
  final Map<int, Completer<bool>> _pendingVersionRequests = {};
  int _versionRequestIdCounter = 0;

  /// Current SPP connection state
  SppConnectionState get state => _state;

  /// Current SPP protocol version
  SppProtocolVersion get protocolVersion => _sppVersion;

  /// Check if connected and ready
  bool get isReady {
    // Must be in ready state AND have a connected transport
    if (_state != SppConnectionState.ready) {
      return false;
    }

    // Verify transport is actually connected
    if (!transport.isConnected) {
      debugPrint(
        '⚠️ SPP isReady=false: transport not connected (state=$_state)',
      );
      return false;
    }

    return true;
  }

  /// Get device ID for V2 handler operations
  String get _deviceId => deviceId;

  /// Connect to device and initialize SPP session
  Future<bool> connect() async {
    try {
      // Reset counters and pending requests on new connection
      _requestIdCounter = 0;
      _versionRequestIdCounter = 0;
      _sppV2SequenceCounter = 0; // ✅ Reset sequence counter
      _sequenceToRequestId.clear();
      _requestIdToExpectedCommand.clear(); // ✅ Clear command signature tracking
      _pendingRequests.clear();
      _pendingVersionRequests.clear();
      debugPrint('🔄 SPP: Reset all counters and pending requests');

      _updateState(SppConnectionState.connecting);

      // 1. Load SPP configuration
      await _loadSppConfig();

      // 2. Initialize transport (BLE or BT_CLASSIC)
      await transport.initialize();

      if (!transport.isConnected) {
        debugPrint('❌ SPP: Transport failed to connect');
        _updateState(SppConnectionState.error);
        return false;
      }

      debugPrint('✅ SPP: Transport connected and ready');

      // 4. Start listening to incoming data
      _startListening();

      // 5. Initialize protocol-specific session
      if (_sppVersion == SppProtocolVersion.v2) {
        await _initializeV2Session();
      } else {
        // V1 doesn't need session initialization
        _updateState(SppConnectionState.ready);
      }

      return true;
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ SPP: Connection failed: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(SppConnectionState.error);
      return false;
    }
  }

  /// Disconnect from device
  Future<void> disconnect() async {
    debugPrint('📡 SPP: Disconnecting...');

    // Cancel data subscription
    await _dataSubscription?.cancel();
    _dataSubscription = null;

    // Close data stream controller
    await _dataStreamController.close();

    // Dispose V2 handler if exists
    await _sppV2Handler?.dispose();
    _sppV2Handler = null;

    // Disconnect transport
    await transport.dispose();

    _updateState(SppConnectionState.disconnected);
    debugPrint('✅ SPP: Disconnected');
  }

  /// Send raw command data via SPP
  Future<bool> sendCommand(final Uint8List data) async {
    if (!isReady) {
      debugPrint('⚠️ SPP: Cannot send command, not ready (state: $_state)');
      return false;
    }

    try {
      if (_sppVersion == SppProtocolVersion.v2) {
        // V2: Use protocol handler (TODO: integrate with transport)
        // await _sppV2Handler!.sendData(...)
        debugPrint('⚠️ SPP V2: sendCommand not fully implemented yet');
        return false;
      } else {
        // V1: Send directly via transport
        return await transport.sendData(data);
      }
    } on Exception catch (e) {
      debugPrint('❌ SPP: Failed to send command: $e');
      return false;
    }
  }

  /// Send encrypted command (requires encryption keys)
  Future<bool> sendEncryptedCommand({
    required final int commandType,
    required final Uint8List payload,
  }) async {
    if (encryptionKeys == null) {
      debugPrint('⚠️ SPP: Cannot send encrypted command, no keys available');
      return false;
    }

    // TODO: Implement encryption logic using XiaomiSppPacketV1 or V2
    debugPrint('⚠️ SPP: sendEncryptedCommand not fully implemented yet');
    return false;
  }

  /// Send protobuf Command and wait for response
  ///
  /// This is the main method for BT_CLASSIC protobuf communication with bonded devices.
  /// Uses SPP V2 protocol with DATA packets on protobufCommand channel.
  ///
  /// **Usage:**
  /// ```dart
  /// final request = createBatteryRequest();
  /// final response = await sppService.sendProtobufCommand(
  ///   command: request,
  ///   timeout: Duration(seconds: 5),
  /// );
  ///
  /// if (response != null) {
  ///   final batteryLevel = parseBatteryFromCommand(response);
  /// }
  /// ```
  ///
  /// **Fire-and-forget commands (no response expected):**
  /// ```dart
  /// final startStats = createRealtimeStatsStartRequest();
  /// await sppService.sendProtobufCommand(
  ///   command: startStats,
  ///   expectsResponse: false, // ← No waiting
  /// );
  /// ```
  ///
  /// Returns null if:
  /// - Service not ready
  /// - Timeout exceeded (only if expectsResponse=true)
  /// - Device disconnected
  /// - Invalid response
  Future<proto.Command?> sendProtobufCommand({
    required final proto.Command command,
    final Duration timeout = const Duration(seconds: 5),
    final bool?
        encrypted, // ← NEW: Allow overriding encryption (null = auto-detect)
    final bool expectsResponse =
        true, // ← NEW: Set false for fire-and-forget commands
  }) async {
    if (!isReady) {
      debugPrint(
        '⚠️ SPP: Cannot send protobuf command, not ready (state: $_state)',
      );
      return null;
    }

    try {
      // Generate unique request ID for response routing
      final requestId = _requestIdCounter++;
      final completer = Completer<proto.Command>();

      // Store pending request
      _pendingRequests[requestId] = completer;

      // Encode Command to protobuf bytes
      final commandBytes = command.writeToBuffer();

      /*debugPrint('═══════════════════════════════════════════════════');
      debugPrint('📤 SPP: Sending protobuf command');
      debugPrint('   Request ID: $requestId');
      debugPrint('   Command type: ${command.type}');
      debugPrint('   Command subtype: ${command.subtype}');
      debugPrint('   Payload size: ${commandBytes.length} bytes');
      debugPrint(
        '   Payload hex: ${commandBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint('═══════════════════════════════════════════════════');*/

      // For BT_CLASSIC with SPP V2, encode as DATA packet and send via transport
      if (transport is BtClassicSppTransport &&
          _sppVersion == SppProtocolVersion.v2) {
        // ✅ Determine encryption: explicit override or auto-detect
        final shouldEncrypt = encrypted ?? (encryptionKeys != null);

        if (!shouldEncrypt) {
          debugPrint(
            '🔓 SPP: Sending UNENCRYPTED protobuf command (encrypted=false)',
          );
          debugPrint('   This is expected for NONCE handshake commands');
        } else {
          debugPrint('🔐 SPP: Sending ENCRYPTED protobuf command');
        }

        // Build SPP V2 DATA packet
        // CRITICAL: Use incrementing sequence number (Gadgetbridge pattern)
        final sequenceNumber = _sppV2SequenceCounter++;
        final dataPacket = DataPacketBuilder()
            .setSequenceNumber(sequenceNumber) // ✅ Set explicit sequence
            .setChannel(SppV2Channel.protobufCommand)
            .setPayload(Uint8List.fromList(commandBytes))
            .setEncrypted(shouldEncrypt) // ✅ MUST be encrypted with auth keys
            .build();

        // Store mapping: sequence → requestId for response routing
        _sequenceToRequestId[sequenceNumber] = requestId;

        // ✅ CRITICAL FIX: Also store expected command type+subtype for intelligent fallback
        // This allows matching responses by command signature when seq numbers are wrong
        final commandSignature = '${command.type}:${command.subtype}';
        _requestIdToExpectedCommand[requestId] = commandSignature;

        final packetBytes = dataPacket.encode(encryptionKeys: encryptionKeys);

        /*debugPrint(
          '   📦 Encoded as SPP V2 DATA packet: ${packetBytes.length} bytes',
        );
        debugPrint('   Sequence: $sequenceNumber → RequestID: $requestId');
        debugPrint(
          '   Packet hex: ${packetBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
        );*/

        // Send via transport
        await transport.sendData(packetBytes);
      } else if (_sppV2Handler != null) {
        // For BLE, use V2 handler
        await _sppV2Handler!.sendData(
          _deviceId,
          channel: SppV2Channel.protobufCommand,
          payload: Uint8List.fromList(commandBytes),
        );
      } else {
        debugPrint('⚠️ SPP: No handler available for sending');
        _pendingRequests.remove(requestId);
        return null;
      }

      // ✅ Fire-and-forget: Return immediately without waiting for response
      if (!expectsResponse) {
        debugPrint(
          '🔥 SPP: Fire-and-forget command sent (requestId=$requestId)',
        );
        _pendingRequests.remove(
          requestId,
        ); // Clean up, we won't wait for response
        return null; // Indicates success but no response expected
      }

      // Wait for response with timeout
      final response = await completer.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('⏱️ SPP: Command timeout (requestId=$requestId)');
          _pendingRequests.remove(requestId);
          throw TimeoutException('Protobuf command timeout');
        },
      );

      // debugPrint('✅ SPP: Received response for requestId=$requestId');
      return response;
    } on TimeoutException {
      debugPrint('❌ SPP: Protobuf command timed out');
      return null;
    } on Exception catch (e) {
      debugPrint('❌ SPP: Failed to send protobuf command: $e');
      return null;
    }
  }

  /// Send command via authentication channel (for NONCE handshake)
  ///
  /// This is specifically for authentication commands like NONCE that must
  /// go through the authentication channel, not the protobuf_command channel.
  ///
  /// Used during encrypted handshake for session nonce negotiation.
  Future<proto.Command?> sendAuthenticationCommand({
    required final proto.Command command,
    final Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!isReady) {
      debugPrint(
        '⚠️ SPP: Cannot send auth command, not ready (state: $_state)',
      );
      return null;
    }

    try {
      // Generate unique request ID for response routing
      final requestId = _requestIdCounter++;
      final completer = Completer<proto.Command>();

      // Store pending request
      _pendingRequests[requestId] = completer;

      // Encode Command to protobuf bytes
      final commandBytes = command.writeToBuffer();

      /*debugPrint('═══════════════════════════════════════════════════');
      debugPrint('📤 SPP: Sending AUTHENTICATION command');
      debugPrint('   Request ID: $requestId');
      debugPrint('   Command type: ${command.type}');
      debugPrint('   Command subtype: ${command.subtype}');
      debugPrint('   Payload size: ${commandBytes.length} bytes');
      debugPrint('   🔓 Channel: AUTHENTICATION (not protobuf_command)');
      debugPrint('═══════════════════════════════════════════════════');*/

      // For BT_CLASSIC with SPP V2, encode as DATA packet with authentication channel
      if (transport is BtClassicSppTransport &&
          _sppVersion == SppProtocolVersion.v2) {
        // CRITICAL: Use incrementing sequence number (Gadgetbridge pattern)
        final sequenceNumber = _sppV2SequenceCounter++;
        final dataPacket = DataPacketBuilder()
            .setSequenceNumber(sequenceNumber)
            .setChannel(
              SppV2Channel.authentication,
            ) // ← AUTHENTICATION channel!
            .setPayload(Uint8List.fromList(commandBytes))
            .setEncrypted(false) // ← NONCE must be unencrypted
            .build();

        // Store mapping: sequence → requestId for response routing
        _sequenceToRequestId[sequenceNumber] = requestId;

        final packetBytes = dataPacket.encode(encryptionKeys: encryptionKeys);

        /*debugPrint(
          '   📦 Encoded as SPP V2 DATA packet: ${packetBytes.length} bytes',
        );
        debugPrint('   Sequence: $sequenceNumber → RequestID: $requestId');
        debugPrint(
          '   Packet hex: ${packetBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
        );*/

        // Send via transport
        await transport.sendData(packetBytes);
      } else if (_sppV2Handler != null) {
        // For BLE, use V2 handler with authentication channel
        await _sppV2Handler!.sendData(
          _deviceId,
          channel: SppV2Channel.authentication,
          payload: Uint8List.fromList(commandBytes),
        );
      } else {
        debugPrint('⚠️ SPP: No handler available for sending');
        _pendingRequests.remove(requestId);
        return null;
      }

      // Wait for response with timeout
      final response = await completer.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('⏱️ SPP: Auth command timeout (requestId=$requestId)');
          _pendingRequests.remove(requestId);
          throw TimeoutException('Authentication command timeout');
        },
      );

      //debugPrint('✅ SPP: Received auth response for requestId=$requestId');
      return response;
    } on TimeoutException {
      debugPrint('❌ SPP: Authentication command timed out');
      return null;
    } on Exception catch (e) {
      debugPrint('❌ SPP: Failed to send auth command: $e');
      return null;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await disconnect();
  }

  // Private methods

  Future<void> _loadSppConfig() async {
    try {
      _sppConfig = await XiaomiDeviceConfigLoader.loadAuthConfig(deviceType);
      _sppVersion = _sppConfig!.sppProtocol.defaultVersion;
      debugPrint('✅ SPP: Config loaded (version: $_sppVersion)');
    } on Exception catch (e) {
      debugPrint('⚠️ SPP: Failed to load config, using V1: $e');
      _sppVersion = SppProtocolVersion.v1;
    }
  }

  Future<void> _initializeV2Session() async {
    _updateState(SppConnectionState.initializingSession);

    try {
      // For BT_CLASSIC transport, we MUST send Version handshake first
      // This is CRITICAL - device won't respond to commands without it
      if (transport is BtClassicSppTransport) {
        debugPrint(
          '🔧 SPP V2: BT_CLASSIC transport - sending Version handshake...',
        );

        final versionReceived = await _sendVersionHandshake();

        if (!versionReceived) {
          debugPrint(
            '❌ SPP V2: Version handshake failed - device not responding',
          );
          _updateState(SppConnectionState.error);
          return;
        }

        debugPrint('✅ SPP V2: Version handshake complete');

        // NOW send SESSION_CONFIG request (per Gadgetbridge flow)
        debugPrint('📤 SPP V2: Sending SESSION_CONFIG request...');
        final sessionConfigSent = await _sendSessionConfigRequest();

        if (!sessionConfigSent) {
          debugPrint('❌ SPP V2: SESSION_CONFIG request failed');
          _updateState(SppConnectionState.error);
          return;
        }

        debugPrint(
          '✅ SPP V2: SESSION_CONFIG request sent, waiting for response',
        );
        // State will be updated to 'ready' when we receive SESSION_CONFIG response
        return;
      }

      // For BLE transport, we need to do session handshake
      // TODO: Create SppV2ProtocolHandler instance for BLE
      // TODO: Configure UUIDs from device implementation
      // TODO: Initialize session
      // TODO: Wait for session established callback

      debugPrint('⚠️ SPP V2: BLE session initialization not yet implemented');
      _updateState(SppConnectionState.ready);
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Session initialization failed: $e');
      _updateState(SppConnectionState.error);
      rethrow;
    }
  }

  /// Send Version handshake packet (unencrypted)
  ///
  /// This MUST be sent before any encrypted commands on BT_CLASSIC.
  /// Based on Gadgetbridge XiaomiSppSupport.java lines 72-81
  Future<bool> _sendVersionHandshake() async {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📤 SPP: SENDING VERSION HANDSHAKE (UNENCRYPTED)');
    debugPrint('═══════════════════════════════════════════════════');

    // ⏰ CRITICAL: Wait for BT_CLASSIC to stabilize
    // Mi Band 10 sometimes needs time after socket connection
    debugPrint('⏰ Waiting 1 second for BT_CLASSIC to stabilize...');
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('✅ Wait complete, proceeding with handshake');

    final versionCompleter = Completer<bool>();
    final requestId = _versionRequestIdCounter++;

    debugPrint('🆔 Request ID: $requestId');

    // Store completer for response
    _pendingVersionRequests[requestId] = versionCompleter;

    try {
      // Build unencrypted Version packet (V1 protocol)
      debugPrint('🔧 Building V1 Version packet...');
      final versionPacket = XiaomiSppPacketV1Builder()
          .setChannel(XiaomiSppChannel.version)
          .setNeedsResponse(true)
          .setOpCode(XiaomiSppV1Constants.opcodeRead)
          .setFrameSerial(requestId & 0xff)
          .setDataType(
            XiaomiSppV1Constants.dataTypePlain,
          ) // ✅ PLAIN = unencrypted
          .setPayload(Uint8List(0)) // Empty payload
          .build();

      debugPrint('✅ Packet built: $versionPacket');

      // Encode WITHOUT encryption (encryptFn = null)
      debugPrint('🔧 Encoding packet (no encryption)...');
      final packetBytes = versionPacket.encode();

      debugPrint('✅ Encoded ${packetBytes.length} bytes:');
      debugPrint(
        '   HEX: ${packetBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint('   DEC: ${packetBytes.join(' ')}');

      // Send via transport
      debugPrint('📡 Sending via BT_CLASSIC transport...');
      final sent = await transport.sendData(packetBytes);

      if (!sent) {
        debugPrint('❌ FAILED: Transport.sendData() returned false');
        debugPrint('═══════════════════════════════════════════════════');
        return false;
      }

      debugPrint('✅ Packet sent successfully, waiting for response...');
      debugPrint('⏰ Timeout: 5 seconds');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('');

      // Wait for response with timeout
      final received = await versionCompleter.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('');
          debugPrint('⏱️⏱️⏱️ VERSION HANDSHAKE TIMEOUT ⏱️⏱️⏱️');
          debugPrint('Device did NOT respond within 5 seconds');
          debugPrint('This means device is ignoring our Version packet');
          debugPrint('');
          return false;
        },
      );

      if (received) {
        debugPrint('');
        debugPrint('✅✅✅ VERSION HANDSHAKE SUCCESS ✅✅✅');
        debugPrint('');
      }

      return received;
    } on Exception catch (e) {
      debugPrint('❌ SPP: Failed to send Version handshake: $e');
      return false;
    } finally {
      _pendingVersionRequests.remove(requestId);
    }
  }

  /// Send SESSION_CONFIG request (SPP V2 only)
  ///
  /// Per Gadgetbridge XiaomiSppProtocolV2.java:137-147
  /// This must be sent AFTER Version handshake on BT_CLASSIC
  Future<bool> _sendSessionConfigRequest() async {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📤 SPP V2: SENDING SESSION_CONFIG REQUEST');
    debugPrint('═══════════════════════════════════════════════════');

    try {
      // Build SESSION_CONFIG packet with START_SESSION_REQUEST opcode
      // Based on Gadgetbridge XiaomiSppPacketV2.java lines 119-147
      final sessionPacket = SessionConfigPacketBuilder()
          .setSequenceNumber(0)
          .setOpcode(SessionConfigOpcode.startSessionRequest)
          .build();

      debugPrint('✅ SESSION_CONFIG packet built');

      // Encode packet (no encryption for SESSION_CONFIG)
      final packetBytes = sessionPacket.encode();

      debugPrint('✅ Encoded ${packetBytes.length} bytes:');
      debugPrint(
        '   HEX: ${packetBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Send via BT_CLASSIC transport
      debugPrint('📡 Sending via BT_CLASSIC transport...');
      final sent = await transport.sendData(packetBytes);

      if (!sent) {
        debugPrint('❌ FAILED: Transport.sendData() returned false');
        debugPrint('═══════════════════════════════════════════════════');
        return false;
      }

      debugPrint('✅ SESSION_CONFIG request sent successfully');
      debugPrint('   → Waiting for SESSION_CONFIG response from device');
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('');

      return true;
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to send SESSION_CONFIG: $e');
      debugPrint('═══════════════════════════════════════════════════');
      return false;
    }
  }

  void _startListening() {
    _dataSubscription = transport.dataStream.listen(
      (final data) {
        _handleIncomingData(data);
      },
      onError: (final error) {
        debugPrint('❌ SPP: Data stream error: $error');
        _updateState(SppConnectionState.error);
      },
      cancelOnError: false,
    );
  }

  void _handleIncomingData(final Uint8List data) {
    // debugPrint('📥 SPP: Received ${data.length} bytes');
    // debugPrint(
    //   '   Raw hex: ${data.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    // );

    // ✅ GADGETBRIDGE PATTERN: Acumular bytes en buffer
    // Socket puede enviar datos fragmentados, necesitamos buffer acumulativo
    _buffer.add(data);

    // Procesar buffer para extraer packets completos
    _processBuffer();

    final bufferSizeAfter = _buffer.length;
    // Only log if buffer still has data (incomplete packet scenario)
    if (bufferSizeAfter > 0) {
      // debugPrint(
      //   '   ⚠️ Buffer has $bufferSizeAfter bytes remaining (incomplete packet)',
      // );
      // final remaining = _buffer.toBytes();
      // debugPrint(
      //   '      Hex: ${remaining.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      // );
    }
  }

  /// Procesa buffer acumulativo para extraer packets completos
  ///
  /// Based on Gadgetbridge XiaomiSppSupport.processBuffer()
  /// Loop continuo que intenta parsear packets del buffer hasta que:
  /// - Buffer está vacío
  /// - Packet incompleto (esperar más bytes)
  /// - Packet inválido (buscar siguiente preamble)
  void _processBuffer() {
    int loopIteration = 0;
    while (true) {
      loopIteration++;
      final bufferBytes = _buffer.toBytes();

      if (bufferBytes.isEmpty) {
        // Buffer fully processed - normal condition
        break; // Nothing to process
      }

      // debugPrint(
      //   '🔍 SPP: Processing iteration #$loopIteration (${bufferBytes.length} bytes)',
      // );
      if (loopIteration > 10) {
        // debugPrint(
        //   '⚠️ SPP: Too many iterations (suspected infinite loop), breaking',
        // );
        break;
      }

      // ✅ FIRST: Check if this is a Version handshake response (V1 packet)
      // Version uses V1 protocol even for V2 devices
      // Guard: Only attempt V1 decode if buffer starts with V1 preamble [ba dc fe]
      XiaomiSppPacketV1? v1Packet;
      if (bufferBytes.length >= 3 &&
          bufferBytes[0] == 0xBA &&
          bufferBytes[1] == 0xDC &&
          bufferBytes[2] == 0xFE) {
        v1Packet = XiaomiSppPacketV1.decode(bufferBytes);
      }
      if (v1Packet != null && v1Packet.channel == XiaomiSppChannel.version) {
        // debugPrint('📦 SPP V1: Received Version handshake response');
        // debugPrint('   OpCode: 0x${v1Packet.opCode.toRadixString(16)}');
        // debugPrint('   FrameSerial: ${v1Packet.frameSerial}');

        // Complete the FIRST pending Version request
        if (_pendingVersionRequests.isNotEmpty) {
          final requestId = _pendingVersionRequests.keys.first;
          final completer = _pendingVersionRequests.remove(requestId);

          if (completer != null && !completer.isCompleted) {
            // debugPrint(
            //   '✅ Accepting Version response (device frameSerial=${v1Packet.frameSerial})',
            // );
            completer.complete(true);
          }
        }

        // Remove processed packet from buffer
        // V1 packets have variable size, calculate from packet structure
        // Header: 3 (preamble) + 1 (channel) + 1 (flags) + 2 (length) + 1 (opcode) + 1 (serial) + 1 (dataType)
        // = 10 bytes + payload.length + 1 (epilogue)
        final packetSize = 11 + v1Packet.payload.length;
        _skipBufferBytes(packetSize);
        continue; // Process next packet
      }

      // For BT_CLASSIC with SPP V2, decode packets from buffer
      if (transport is BtClassicSppTransport &&
          _sppVersion == SppProtocolVersion.v2) {
        final parseResult = _processSppV2Packet(bufferBytes);

        if (parseResult == _ParseResult.incomplete) {
          // debugPrint('   ⏸️ Packet incomplete, waiting for more bytes');
          break; // Wait for more data
        } else if (parseResult == _ParseResult.invalid) {
          debugPrint('   ❌ Invalid packet, skipping bytes');
          _skipBufferBytes(1); // Skip 1 byte and try again
          continue;
        } else {
          // parseResult == complete, packet was processed
          // _processSppV2Packet() already removed bytes from buffer
          continue; // Process next packet
        }
      }

      // For BLE or V1, try to parse as protobuf Command directly
      try {
        final command = proto.Command.fromBuffer(bufferBytes);

        debugPrint('📦 SPP: Parsed protobuf Command (BLE/V1)');
        debugPrint('   Type: ${command.type}');

        // Route response to waiting request (FIFO)
        if (_pendingRequests.isNotEmpty) {
          final requestId = _pendingRequests.keys.first;
          final completer = _pendingRequests.remove(requestId);
          if (completer != null && !completer.isCompleted) {
            completer.complete(command);
            debugPrint('✅ SPP: Routed response to requestId=$requestId');
          }
        }

        // Clear buffer after processing
        _buffer.clear();
        break;
      } on Exception catch (e) {
        debugPrint('⚠️ SPP: Could not parse as Command: $e');
        onDataReceived?.call(bufferBytes);

        // Emit to data stream
        _dataStreamController.add(
          SppDataPacket(
            deviceId: deviceId,
            data: bufferBytes,
            timestamp: DateTime.now(),
            channel: 'protobuf_command', // SPP V1 default channel
          ),
        );

        _buffer.clear();
        break;
      }
    }
  }

  /// Process SPP V2 packet from buffer
  ///
  /// Returns ParseResult indicating if packet was:
  /// - complete: Packet processed, removed from buffer
  /// - incomplete: Need more bytes
  /// - invalid: Packet corrupted
  _ParseResult _processSppV2Packet(final Uint8List bufferBytes) {
    try {
      // Try to decode SPP V2 packet
      final packet = SppV2Packet.decode(bufferBytes);

      if (packet == null) {
        // Could not decode - might be incomplete or invalid
        // Check if we have at least the header
        if (bufferBytes.length < 8) {
          return _ParseResult.incomplete; // Need at least 8 bytes for header
        }

        // Check preamble
        if (bufferBytes[0] != 0xA5 || bufferBytes[1] != 0xA5) {
          return _ParseResult.invalid; // Invalid preamble
        }

        // Has valid preamble but decode failed - probably incomplete
        return _ParseResult.incomplete;
      }

      // Packet decoded successfully
      // debugPrint('📦 SPP V2: Decoded ${packet.packetType}');

      // Handle SESSION_CONFIG packets (FIRST - per Gadgetbridge flow)
      if (packet is SessionConfigPacket) {
        debugPrint(
          '📦 SPP V2: Received SESSION_CONFIG, opcode=${packet.opcode}',
        );

        // If this is START_SESSION_RESPONSE, device is ready
        if (packet.opcode == SessionConfigOpcode.startSessionResponse) {
          debugPrint('');
          debugPrint('✅✅✅ SESSION_CONFIG RESPONSE RECEIVED ✅✅✅');
          debugPrint('   → Device sent START_SESSION_RESPONSE');
          debugPrint('');

          // Update state to ready BEFORE handshake
          _updateState(SppConnectionState.ready);

          // ✅ GADGETBRIDGE PATTERN: Trigger callback for encrypted handshake
          // Orchestrator will call authService.startEncryptedHandshake()
          // This avoids timing issues with authService recreation
          if (onSessionConfigReceived != null) {
            debugPrint(
              '   🔐 Notifying orchestrator to start encrypted handshake...',
            );
            // ⚠️ CRITICAL: Execute callback but ONLY ONCE
            // Some transports (BT_CLASSIC) may deliver duplicate packets
            // Calling once prevents duplicate NONCE handshake attempts
            final callback = onSessionConfigReceived;
            onSessionConfigReceived =
                null; // ← Clear callback to prevent re-execution
            // Execute async callback without blocking packet processing
            unawaited(callback?.call() ?? Future.value());
          } else {
            debugPrint(
              '   ⚠️ No onSessionConfigReceived callback, handshake skipped',
            );
          }
        }

        // ✅ FIX: Read packet size from header (bytes 4-5, little endian)
        // Header structure: [preamble(2)][type(1)][seq(1)][size(2)][checksum(2)]
        final payloadSize = bufferBytes[4] | (bufferBytes[5] << 8);
        final packetSize = 8 + payloadSize;

        debugPrint(
          '   📏 Packet size: header(8) + payload($payloadSize) = $packetSize bytes',
        );
        _skipBufferBytes(packetSize);
        return _ParseResult.complete;
      }

      // Handle ACK packets
      if (packet is AckPacket) {
        final sequenceNumber = packet.sequenceNumber;
        debugPrint('📨 SPP V2: Received ACK for seq $sequenceNumber');

        final requestId = _sequenceToRequestId[sequenceNumber];
        if (requestId != null) {
          debugPrint('   ✅ ACK for requestId=$requestId');
        }

        // Remove ACK from buffer
        // ACK packets are always 8 bytes (header only, no payload)
        _skipBufferBytes(8);
        return _ParseResult.complete;
      }

      // Handle DATA packets
      if (packet is DataPacket) {
        final sequenceNumber = packet.sequenceNumber;
        final channel = packet.channel;
        // final isEncrypted = packet.encrypted;

        // debugPrint(
        //   '📦 SPP V2: DATA packet seq=$sequenceNumber, channel=$channel, encrypted=$isEncrypted',
        // );

        // Decrypt payload if encrypted
        final payload = packet.getDecryptedPayload(
          encryptionKeys: encryptionKeys,
        );

        // debugPrint('   Payload: ${payload.length} bytes');
        // debugPrint(
        //   '   Payload hex: ${payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
        // );

        // Only attempt to parse protobuf Command when the channel is
        // protobuf_command. Activity/data channels carry different payload
        // encodings and should NOT be blindly parsed as Command objects.
        if (channel == SppV2Channel.protobufCommand) {
          // Parse protobuf Command from payload
          try {
            final command = proto.Command.fromBuffer(payload);

            // debugPrint(
            //   '   ✅ Parsed Command: type=${command.type}, subtype=${command.subtype}',
            // );

            // Check if this is a realtime stats event (unsolicited)
            final isRealtimeStatsEvent =
                command.type == 8 && command.subtype == 47;

            if (isRealtimeStatsEvent) {
              // debugPrint(
              //   '   🎯 REALTIME STATS EVENT DETECTED! (type=8, subtype=47)',
              // );
            }

            // ✅ FIX: Match response to request by sequence number (not FIFO)
            // This ensures responses arrive in correct order, even if packets are delayed
            if (!isRealtimeStatsEvent) {
              // ✅ PRIMARY: Try to match by sequence number
              final requestId = _sequenceToRequestId[sequenceNumber];

              if (requestId != null) {
                // ✅ EXACT MATCH: Found by sequence number
                final completer = _pendingRequests.remove(requestId);
                _sequenceToRequestId.remove(sequenceNumber);
                _requestIdToExpectedCommand.remove(requestId); // ✅ Cleanup

                if (completer != null && !completer.isCompleted) {
                  completer.complete(command);
                  // debugPrint(
                  //   '✅ SPP: Completed requestId=$requestId (matched by seq=$sequenceNumber)',
                  // );
                }
              } else {
                // ⚠️ FALLBACK: Device responded with different seq than expected
                // This can happen with buggy devices that don't echo the exact seq
                // Try intelligent fallback: match by command type+subtype signature
                // debugPrint(
                //   '⚠️ SPP: No exact seq match for seq=$sequenceNumber, trying intelligent fallback',
                // );

                // Build signature of received command
                final responseSignature = '${command.type}:${command.subtype}';
                // debugPrint('   📋 Response signature: $responseSignature');

                // Search pending requests for matching expected command
                int? matchingRequestId;
                for (final entry in _requestIdToExpectedCommand.entries) {
                  if (entry.value == responseSignature &&
                      _pendingRequests.containsKey(entry.key)) {
                    matchingRequestId = entry.key;
                    // debugPrint(
                    //   '   ✅ Found matching pending request: requestId=$matchingRequestId expects $responseSignature',
                    // );
                    break;
                  }
                }

                if (matchingRequestId != null) {
                  // Found matching request by command signature
                  final matchingCompleter = _pendingRequests.remove(
                    matchingRequestId,
                  );
                  _requestIdToExpectedCommand.remove(matchingRequestId);
                  _sequenceToRequestId.remove(sequenceNumber);

                  // debugPrint(
                  //   '   → Using signature match: seq=$sequenceNumber → requestId=$matchingRequestId',
                  // );

                  if (matchingCompleter != null &&
                      !matchingCompleter.isCompleted) {
                    matchingCompleter.complete(command);
                    // debugPrint(
                    //   '✅ SPP: Completed requestId=$matchingRequestId (matched by command signature)',
                    // );
                  }
                } else {
                  // No match found - last resort FIFO fallback
                  // debugPrint(
                  //   '   ⚠️  No signature match found, trying FIFO as last resort',
                  // );

                  if (_pendingRequests.isNotEmpty) {
                    final fallbackRequestId = _pendingRequests.keys.first;
                    final fallbackCompleter = _pendingRequests.remove(
                      fallbackRequestId,
                    );
                    _requestIdToExpectedCommand.remove(fallbackRequestId);
                    _sequenceToRequestId.remove(sequenceNumber);

                    // debugPrint(
                    //   '   → Using FIFO fallback: matched seq=$sequenceNumber to requestId=$fallbackRequestId',
                    // );

                    if (fallbackCompleter != null &&
                        !fallbackCompleter.isCompleted) {
                      fallbackCompleter.complete(command);
                      debugPrint(
                        '✅ SPP: Completed requestId=$fallbackRequestId (matched by FIFO fallback)',
                      );
                    }
                  }
                  // Note: If no pending requests, it's OK - unsolicited device message
                  // These are normal (e.g., HR updates, sleep data) and don't need fallback
                }
              }
            }

            // ✅ CRITICAL: Send ACK back to device (Gadgetbridge pattern)
            _sendAck(sequenceNumber);

            // Emit ALL commands to data stream (for realtime stats events, etc.)
            // Subscribers can filter by command type/subtype
            _dataStreamController.add(
              SppDataPacket(
                deviceId: deviceId,
                data: payload,
                timestamp: DateTime.now(),
                channel: channel.name, // Include channel information
              ),
            );
          } on Exception catch (e) {
            debugPrint('⚠️ SPP: Failed to parse Command: $e');
            onDataReceived?.call(payload);

            // Emit to data stream
            _dataStreamController.add(
              SppDataPacket(
                deviceId: deviceId,
                data: payload,
                timestamp: DateTime.now(),
                channel: channel.name, // Include channel information
              ),
            );
          }
        } else {
          // Non-protobuf channels (activity, data, etc.) - do not attempt
          // protobuf parsing. Emit raw decrypted payload to subscribers so
          // higher-level parsers (e.g., activity parsers) can handle it.
          debugPrint(
            '   ℹ️  Received non-protobuf channel ($channel), emitting raw payload',
          );
          onDataReceived?.call(payload);
          _dataStreamController.add(
            SppDataPacket(
              deviceId: deviceId,
              data: payload,
              timestamp: DateTime.now(),
              channel: channel.name,
            ),
          );
        }

        // ✅ FIX: Read packet size from header (bytes 4-5, little endian)
        final payloadSize = bufferBytes[4] | (bufferBytes[5] << 8);
        final packetSize = 8 + payloadSize;
        _skipBufferBytes(packetSize);
        return _ParseResult.complete;
      }

      // Unknown packet type
      debugPrint('⚠️ SPP V2: Unknown packet type ${packet.packetType}');
      // Skip minimal packet size (8 bytes header)
      _skipBufferBytes(8);
      return _ParseResult.complete;
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Error processing packet: $e');
      return _ParseResult.invalid;
    }
  }

  /// Skip bytes from buffer (Gadgetbridge pattern)
  void _skipBufferBytes(final int count) {
    final bufferBytes = _buffer.toBytes();
    _buffer.clear();

    if (count >= bufferBytes.length) {
      // Entire buffer cleared - normal after processing a packet
      return;
    }

    // Keep remaining bytes
    final remaining = bufferBytes.sublist(count);
    _buffer.add(remaining);
    // Only log if significant amount remaining (multi-packet scenario)
    if (remaining.isNotEmpty) {
      debugPrint('   ✂️ ${remaining.length} bytes queued for next iteration');
    }
  }

  /// Send ACK packet to device (Gadgetbridge pattern)
  ///
  /// CRITICAL: Must send ACK when we receive DATA packets
  /// Otherwise device may resend or timeout
  void _sendAck(final int sequenceNumber) {
    try {
      // Build ACK packet using builder from protocol/v2/packet.dart
      final ackPacket = AckPacket(sequenceNumber: sequenceNumber);
      final ackBytes = ackPacket.encode();

      // debugPrint('📤 SPP V2: Sending ACK for seq $sequenceNumber');
      transport.sendData(ackBytes);
    } catch (_) {
      // debugPrint('❌ SPP V2: Failed to send ACK');
    }
  }

  void _updateState(final SppConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      onStateChanged?.call(newState);
      debugPrint('📡 SPP: State changed → $newState');
    }
  }
}
