// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP V2 Protocol Handler
///
/// Handles SPP Protocol V2 communication for newer Xiaomi devices (Band 10, etc.)
///
/// Based on Gadgetbridge XiaomiSppProtocolV2.java
/// Key differences from V1:
/// - Session handshake required before authentication
/// - ACK packets must be sent for received DATA packets
/// - Sequence numbers track packet order
/// - Different packet structure (see packet.dart)
///
/// Usage:
/// ```dart
/// final handler = SppV2ProtocolHandler(bleService);
///
/// // 1. Initialize session
/// await handler.initializeSession(deviceId);
///
/// // 2. Wait for onSessionEstablished callback
/// handler.onSessionEstablished = () async {
///   // Start authentication
///   await handler.sendAuthData(authPayload);
/// };
///
/// // 3. Listen to incoming data
/// handler.onAuthDataReceived = (data) {
///   // Handle auth responses
/// };
/// ```
library;

import 'dart:async';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:flutter/foundation.dart';
import 'packet.dart';
import 'package:wearable_sensors/src/internal/bluetooth/spp_v2_config.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_auth_service.dart'; // Para EncryptionKeys
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;

/// Callback for session established event
typedef OnSessionEstablishedCallback = Future<void> Function();

/// Callback for received auth data
typedef OnAuthDataReceivedCallback = void Function(Uint8List data);

/// Callback for received system command responses (battery, device info, etc.)
typedef OnSystemCommandReceivedCallback = void Function(Uint8List data);

/// Callback for received protobuf data
typedef OnProtobufReceivedCallback = void Function(Uint8List data);

/// SPP V2 Protocol Handler
///
/// Manages SPP V2 session lifecycle, packet routing, and ACK management.
class SppV2ProtocolHandler {
  SppV2ProtocolHandler(this._bleService);
  final BleService _bleService;

  /// Sequence counter for outgoing packets
  int _sequenceNumber = 0;

  /// Session state
  bool _sessionInitialized = false;
  bool _sessionCallbackFired = false; // ✅ Prevent duplicate callbacks
  Map<int, Uint8List> _deviceSessionConfig =
      {}; // Changed from Map<SessionConfigKey, Uint8List>

  /// Encryption keys for SPP V2 encrypted commands
  EncryptionKeys? _encryptionKeys;

  /// Characteristic UUIDs (Band 10 specific)
  String _commandWriteUuid = '0000005F-0000-1000-8000-00805F9B34FB';
  String _commandReadUuid = '0000005E-0000-1000-8000-00805F9B34FB';
  String _serviceUuid = '0000FE95-0000-1000-8000-00805F9B34FB';

  /// Stream subscription for incoming data
  StreamSubscription<BleDataPacket>? _dataSubscription;

  /// Buffer for incomplete packets
  final List<int> _packetBuffer = [];

  // Callbacks
  OnSessionEstablishedCallback? onSessionEstablished;
  OnAuthDataReceivedCallback? onAuthDataReceived;
  OnSystemCommandReceivedCallback? onSystemCommandReceived;
  OnProtobufReceivedCallback? onProtobufReceived;

  /// Configure characteristic UUIDs (if different from defaults)
  void configureUuids({
    required final String serviceUuid,
    required final String commandWriteUuid,
    required final String commandReadUuid,
  }) {
    _serviceUuid = serviceUuid;
    _commandWriteUuid = commandWriteUuid;
    _commandReadUuid = commandReadUuid;
    debugPrint('🔧 SPP V2: UUIDs configured');
    debugPrint('   Service: $_serviceUuid');
    debugPrint('   Write: $_commandWriteUuid');
    debugPrint('   Read: $_commandReadUuid');
  }

  /// Configure encryption keys for SPP V2 encrypted communication
  ///
  /// Must be called after successful authentication to enable encrypted
  /// post-authentication commands.
  void setEncryptionKeys(final EncryptionKeys keys) {
    _encryptionKeys = keys;
    debugPrint('🔐 SPP V2: Encryption keys configured');
    debugPrint('   Encryption key: ${keys.encryptionKey.length} bytes');
    debugPrint('   Encryption nonce: ${keys.encryptionNonce.length} bytes');
    debugPrint('🔍 DEBUG: Keys stored in _encryptionKeys field');
  }

  /// Initialize SPP V2 session with device
  ///
  /// Sends SESSION_CONFIG request (opcode=1, seq=0) and waits for response.
  /// Session must be established before any authentication can occur.
  ///
  /// Gadgetbridge reference (XiaomiSppProtocolV2.java:136):
  /// ```java
  /// public boolean initializeSession() {
  ///     final TransactionBuilder builder = support.commsSupport.createTransactionBuilder("send session config");
  ///     builder.write(XiaomiSppPacketV2.newSessionConfigPacketBuilder()
  ///             .setOpCode(OPCODE_START_SESSION_REQUEST)
  ///             .setSequenceNumber(0)
  ///             .build()
  ///             .encode(null));
  ///     builder.queue();
  ///     return false;  // Auth triggered by response
  /// }
  /// ```
  Future<void> initializeSession(final String deviceId) async {
    debugPrint('🔄 SPP V2: Initializing session...');

    // Start listening to incoming data BEFORE sending request
    _startListening(deviceId);

    // Build SESSION_CONFIG request WITH config parameters
    // Based on Gadgetbridge packet dump (XiaomiSppPacketV2.java:119-147)
    // ✅ CRITICAL: SESSION_CONFIG always uses seq=0 (hardcoded, doesn't increment counter)
    // Gadgetbridge: setSequenceNumber(0) for SESSION_CONFIG, counter starts at 0 for DATA packets
    final request = SessionConfigPacketBuilder()
        .setSequenceNumber(0) // ← ALWAYS 0, don't touch _sequenceNumber
        .setOpcode(SessionConfigOpcode.startSessionRequest)
        // VERSION (key=1): 01.00.00
        .addConfigByName('version', Uint8List.fromList([0x01, 0x00, 0x00]))
        // MAX_PACKET_SIZE (key=2): 0xFC00 = 64512 bytes
        .addConfigByName('max_packet_size', Uint8List.fromList([0x00, 0xFC]))
        // TX_WIN (key=3): 0x0020 = 32 frames
        .addConfigByName('tx_win', Uint8List.fromList([0x20, 0x00]))
        // SEND_TIMEOUT (key=4): 0x2710 = 10000ms
        .addConfigByName('send_timeout', Uint8List.fromList([0x10, 0x27]))
        .build();

    final encodedPacket = request.encode();
    debugPrint('📤 SPP V2: Sending SESSION_CONFIG request (seq=0)');
    debugPrint(
      '   Packet: ${encodedPacket.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    // Write to command_write characteristic
    await _bleService.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: _serviceUuid,
      characteristicUuid: _commandWriteUuid,
      data: encodedPacket,
      withoutResponse: true,
    );

    debugPrint('⏳ SPP V2: Waiting for SESSION_CONFIG response...');
  }

  /// Start listening to incoming BLE data
  void _startListening(final String deviceId) {
    debugPrint('👂 SPP V2: Starting data listener...');

    _dataSubscription?.cancel();
    _dataSubscription = _bleService.rawBleDataStream.listen(
      (final packet) {
        // 🔥 ULTRA-VERBOSE LOGGING para debugging
        debugPrint('═══════════════════════════════════════════════════');
        debugPrint('🔔 SPP V2: RAW BLE DATA RECEIVED');
        debugPrint('   Device: ${packet.deviceId}');
        debugPrint('   Characteristic: ${packet.characteristicUuid}');
        debugPrint('   Size: ${packet.rawData.length} bytes');
        debugPrint(
          '   Hex: ${packet.rawData.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
        );
        debugPrint('   Timestamp: ${DateTime.now().toIso8601String()}');
        debugPrint('═══════════════════════════════════════════════════');

        _handleRawData(deviceId, Uint8List.fromList(packet.rawData));
      },
      onError: (final error) {
        debugPrint('❌ SPP V2: Data stream error: $error');
      },
    );
  }

  /// Handle raw incoming BLE data
  ///
  /// Gadgetbridge processes packets in buffer to handle fragmentation.
  /// We do the same: accumulate bytes until we have a complete packet.
  void _handleRawData(final String deviceId, final Uint8List data) {
    try {
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('🔴🔴🔴 SPP V2 HANDLER: CALLED');
      debugPrint('   Device: $deviceId');
      debugPrint('   NEW data: ${data.length} bytes');
      debugPrint(
        '   NEW data HEX: ${data.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint('   Buffer BEFORE: ${_packetBuffer.length} bytes');
      debugPrint('═══════════════════════════════════════════════════');

      debugPrint(
        '🔧 SPP V2: Adding ${data.length} bytes to buffer (current: ${_packetBuffer.length})',
      );
      _packetBuffer.addAll(data);
      debugPrint('🔧 SPP V2: Buffer now has ${_packetBuffer.length} bytes');
      _processPacketBuffer(deviceId);
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Error handling raw data: $e');
    }
  }

  /// Process buffered data and extract complete packets
  void _processPacketBuffer(final String deviceId) {
    while (_packetBuffer.isNotEmpty) {
      // Try to decode packet
      final bufferBytes = Uint8List.fromList(_packetBuffer);
      final packet = SppV2Packet.decode(bufferBytes);

      if (packet == null) {
        // Not enough data for complete packet
        debugPrint(
          '🔍 SPP V2: Incomplete packet in buffer (${_packetBuffer.length} bytes)',
        );
        // Keep buffer and wait for more data
        break;
      }

      // Calculate packet size to remove from buffer
      final packetSize = _calculatePacketSize(bufferBytes);
      if (packetSize == -1) {
        // Invalid packet, clear buffer
        debugPrint('⚠️  SPP V2: Invalid packet, clearing buffer');
        _packetBuffer.clear();
        break;
      }

      // Remove processed packet from buffer
      _packetBuffer.removeRange(0, packetSize);
      debugPrint(
        '✂️  SPP V2: Removed $packetSize bytes from buffer (${_packetBuffer.length} remaining)',
      );

      // Handle the decoded packet
      _handlePacket(deviceId, packet);
    }
  }

  /// Calculate packet size from raw bytes
  ///
  /// SPP V2 packet structure:
  /// [0xa5, 0xa5] [type] [seq] [size_low] [size_high] [checksum_low] [checksum_high] [payload...]
  ///  2 bytes      1 byte 1 byte  1 byte     1 byte      1 byte         1 byte          N bytes
  ///
  /// Total size = 8 + payload_size
  int _calculatePacketSize(final Uint8List data) {
    if (data.length < 8) return -1;

    // Check preamble - dynamic from config
    final preamble = SppV2Config.instance.packetPreamble;
    if (data[0] != preamble[0] || data[1] != preamble[1]) {
      return -1;
    }

    // Extract payload size (bytes 4-5, little endian)
    final payloadSize = data[4] | (data[5] << 8);
    return 8 + payloadSize;
  }

  /// Handle decoded SPP V2 packet
  ///
  /// Routes packet to appropriate handler based on type.
  ///
  /// Gadgetbridge reference (XiaomiSppProtocolV2.java:103):
  /// ```java
  /// switch (decodedPacket.getPacketType()) {
  ///     case PACKET_TYPE_SESSION_CONFIG:
  ///         support.getAuthService().startEncryptedHandshake();
  ///         break;
  ///     case PACKET_TYPE_DATA:
  ///         support.onPacketReceived(dataPacket.getChannel(), payload);
  ///         sendAck(decodedPacket.getSequenceNumber());
  ///         break;
  ///     case PACKET_TYPE_ACK:
  ///         LOG.debug("receive ack for packet {}", seq);
  ///         break;
  /// }
  /// ```
  void _handlePacket(final String deviceId, final SppV2Packet packet) {
    debugPrint('📦 SPP V2: Handling packet: $packet');

    // Handle packet based on type (using equality since PacketType is now a class)
    if (packet.packetType == PacketType.sessionConfig) {
      _handleSessionConfig(deviceId, packet as SessionConfigPacket);
    } else if (packet.packetType == PacketType.data) {
      _handleDataPacket(deviceId, packet as DataPacket);
    } else if (packet.packetType == PacketType.ack) {
      debugPrint('📨 SPP V2: Received ACK for seq ${packet.sequenceNumber}');
      // TODO: Remove packet from retry queue if we implement retries
    } else {
      debugPrint('⚠️  SPP V2: Unknown packet type: ${packet.packetType}');
    }
  }

  /// Handle SESSION_CONFIG packet
  ///
  /// When we receive SESSION_CONFIG response (opcode=2), the session is established
  /// and we can proceed with authentication.
  void _handleSessionConfig(
    final String deviceId,
    final SessionConfigPacket packet,
  ) {
    debugPrint('📋 SPP V2: SESSION_CONFIG packet received');
    debugPrint('   Opcode: ${packet.opcode}');
    debugPrint('   Config items: ${packet.config.length}');

    if (packet.opcode == SessionConfigOpcode.startSessionResponse) {
      // Session established!
      _sessionInitialized = true;
      _deviceSessionConfig = packet.config;

      debugPrint('✅ SPP V2: Session established successfully!');
      debugPrint('   Device config:');
      for (final entry in packet.config.entries) {
        debugPrint('      ${entry.key}: ${entry.value}');
      }

      // ✅ Trigger callback ONLY ONCE (prevent duplicate calls)
      if (!_sessionCallbackFired) {
        _sessionCallbackFired = true;
        debugPrint('🔔 SPP V2: Triggering onSessionEstablished callback');
        onSessionEstablished?.call();
      } else {
        debugPrint(
          '⏭️  SPP V2: Session already established, skipping callback',
        );
      }
    } else if (packet.opcode == SessionConfigOpcode.stopSessionResponse) {
      debugPrint('🛑 SPP V2: Session stopped by device');
      _sessionInitialized = false;
    } else {
      debugPrint(
        '⚠️  SPP V2: Unexpected SESSION_CONFIG opcode: ${packet.opcode}',
      );
    }
  }

  /// Handle DATA packet
  ///
  /// DATA packets carry actual data (auth, protobuf commands, etc.).
  /// We must send ACK immediately after receiving.
  void _handleDataPacket(final String deviceId, final DataPacket packet) {
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📊 SPP V2: DATA PACKET RECEIVED');
    debugPrint('   Sequence: ${packet.sequenceNumber}');
    debugPrint('   Channel: ${packet.channel.name} (${packet.channel.value})');
    debugPrint('   Opcode: ${packet.opcode.name} (${packet.opcode.value})');
    debugPrint('   Encrypted: ${packet.encrypted}');
    debugPrint('   Payload: ${packet.payload.length} bytes');
    debugPrint(
      '   Payload hex: ${packet.payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );
    debugPrint('═══════════════════════════════════════════════════');

    // Send ACK immediately (Gadgetbridge does this)
    _sendAck(deviceId, packet.sequenceNumber);

    // Get decrypted payload
    final payload = packet.getDecryptedPayload();
    debugPrint('   Decrypted payload: ${payload.length} bytes');
    debugPrint(
      '   Decrypted hex: ${payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    // Route to appropriate handler based on channel (using equality since SppV2Channel is now a class)
    // ✅ SMART ROUTING: Parse Command protobuf to detect type and route correctly
    //    - Type 1 (AUTH) → onAuthDataReceived (during authentication)
    //    - Type 2 (SYSTEM) → onSystemCommandReceived (battery, device info, etc.)
    //    - Other types → onProtobufReceived (fallback)
    if (packet.channel == SppV2Channel.authentication ||
        packet.channel == SppV2Channel.protobufCommand) {
      try {
        // Try to parse as Command protobuf to detect type
        final command = pb.Command.fromBuffer(payload);
        final commandType = command.type;

        debugPrint(
          '🔐 SPP V2: Received protobuf Command (channel=${packet.channel.name}, type=$commandType)',
        );

        // Route based on command type
        if (commandType == 1) {
          // Type 1 = Authentication commands (phoneNonce, watchNonce, auth)
          debugPrint('   → Routing to AUTH handler');
          onAuthDataReceived?.call(payload);
        } else if (commandType == 2) {
          // Type 2 = System commands (battery, device info, clock, etc.)
          debugPrint('   → Routing to SYSTEM handler');
          onSystemCommandReceived?.call(payload);
        } else {
          // Other command types
          debugPrint('   → Routing to PROTOBUF handler (type=$commandType)');
          onProtobufReceived?.call(payload);
        }
      } on Exception catch (e) {
        // If not a valid Command protobuf, route to auth handler (legacy behavior)
        debugPrint('⚠️  SPP V2: Could not parse as Command protobuf: $e');
        debugPrint('   → Falling back to AUTH handler');
        onAuthDataReceived?.call(payload);
      }
    } else if (packet.channel == SppV2Channel.activity) {
      debugPrint('🏃 SPP V2: Activity data received (not yet handled)');
    } else if (packet.channel == SppV2Channel.data) {
      debugPrint('💾 SPP V2: Mass data received (not yet handled)');
    } else {
      debugPrint('⚠️  SPP V2: Unknown channel: ${packet.channel}');
    }
  }

  /// Send ACK packet
  ///
  /// ACK packets acknowledge receipt of DATA packets.
  /// They have no payload, just the sequence number.
  Future<void> _sendAck(final String deviceId, final int sequenceNumber) async {
    final ack = AckPacket(sequenceNumber: sequenceNumber);
    final encoded = ack.encode();

    debugPrint('📨 SPP V2: Sending ACK for seq $sequenceNumber');

    await _bleService.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: _serviceUuid,
      characteristicUuid: _commandWriteUuid,
      data: encoded,
      withoutResponse: true,
    );
  }

  /// Send DATA packet
  ///
  /// Used to send auth data, protobuf commands, etc.
  ///
  /// Parameters:
  /// - [channel]: Channel to send on (authentication, protobufCommand, etc.)
  /// - [payload]: Data to send
  /// - [encrypted]: Whether payload should be encrypted (default: false)
  Future<void> sendData(
    final String deviceId, {
    required final SppV2Channel channel,
    required final Uint8List payload,
    final bool encrypted = false,
  }) async {
    final currentSeq = _sequenceNumber;
    final packet = DataPacketBuilder()
        .setSequenceNumber(_sequenceNumber++)
        .setChannel(channel)
        .setPayload(payload)
        .setEncrypted(encrypted)
        .build();

    // 🔍 DEBUG: Check encryption keys before passing to packet.encode
    if (encrypted) {
      debugPrint('🔍 DEBUG: Encrypted packet requested, checking keys...');
      debugPrint('   _encryptionKeys available: ${_encryptionKeys != null}');
      if (_encryptionKeys != null) {
        debugPrint(
          '   Keys available - encryptionKey: ${_encryptionKeys!.encryptionKey.length} bytes',
        );
        debugPrint(
          '   Keys available - encryptionNonce: ${_encryptionKeys!.encryptionNonce.length} bytes',
        );
      }
    }

    final keysToPass = encrypted ? _encryptionKeys : null;
    debugPrint('🔍 DEBUG: Passing keys to encode(): ${keysToPass != null}');

    final encoded = packet.encode(encryptionKeys: keysToPass);

    // 🔴 TEST #15: LOGGING ULTRA DETALLADO DE ENVÍO
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📤📤📤 SPP V2: SENDING DATA PACKET');
    debugPrint('   Device: $deviceId');
    debugPrint('   Sequence Number: $currentSeq');
    debugPrint('   Channel: $channel');
    debugPrint('   Payload length: ${payload.length} bytes');
    debugPrint(
      '   Payload HEX: ${payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );
    debugPrint('   Encrypted: $encrypted');
    debugPrint('   ---');
    debugPrint('   ENCODED packet length: ${encoded.length} bytes');
    debugPrint(
      '   ENCODED packet HEX: ${encoded.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );
    debugPrint('   Service UUID: $_serviceUuid');
    debugPrint('   Characteristic UUID: $_commandWriteUuid');
    debugPrint('   Timestamp: ${DateTime.now().toIso8601String()}');
    debugPrint('═══════════════════════════════════════════════════');

    debugPrint('📤 SPP V2: Sending DATA packet (seq=$currentSeq)');
    debugPrint('   Channel: $channel');
    debugPrint('   Payload: ${payload.length} bytes');
    debugPrint('   Encrypted: $encrypted');

    await _bleService.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: _serviceUuid,
      characteristicUuid: _commandWriteUuid,
      data: encoded,
      withoutResponse: true,
    );

    debugPrint('✅ SPP V2: Write completed for seq=$currentSeq');
  }

  /// Stop session and cleanup
  Future<void> stopSession(final String deviceId) async {
    debugPrint('🛑 SPP V2: Stopping session...');

    // Send STOP_SESSION request
    final request = SessionConfigPacketBuilder()
        .setSequenceNumber(_sequenceNumber++)
        .setOpcode(SessionConfigOpcode.stopSessionRequest)
        .build();

    await _bleService.writeCharacteristic(
      deviceId: deviceId,
      serviceUuid: _serviceUuid,
      characteristicUuid: _commandWriteUuid,
      data: request.encode(),
      withoutResponse: true,
    );

    // Cleanup
    await dispose();
  }

  /// Dispose handler and cleanup resources
  Future<void> dispose() async {
    debugPrint('🔧 SPP V2: Disposing handler...');
    await _dataSubscription?.cancel();
    _dataSubscription = null;
    _packetBuffer.clear();
    _sessionInitialized = false;
    _sessionCallbackFired = false; // ✅ Reset callback flag
    _deviceSessionConfig.clear();
    _sequenceNumber = 0;
  }

  /// Reset handler state (for reconnection)
  void reset() {
    debugPrint('🔄 SPP V2: Resetting handler state...');
    _packetBuffer.clear();
    _sessionInitialized = false;
    _sessionCallbackFired = false; // ✅ Reset callback flag
    _deviceSessionConfig.clear();
    _sequenceNumber = 0;
  }

  // Getters
  bool get isSessionInitialized => _sessionInitialized;
  Map<int, Uint8List> get deviceSessionConfig =>
      _deviceSessionConfig; // Changed from Map<SessionConfigKey, Uint8List>
}
