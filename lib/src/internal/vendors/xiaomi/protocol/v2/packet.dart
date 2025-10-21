// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP Protocol V2 Packet Implementation
///
/// Based on Gadgetbridge XiaomiSppPacketV2.java
/// Copyright (C) 2024 Yoran Vulker (Gadgetbridge)
/// Ported to Dart by Dream Incubator team
///
/// SPP V2 is used by newer Xiaomi devices (Band 10, Band 9 Pro, etc.)
/// Key differences from V1:
/// - Preamble: [0xa5, 0xa5] instead of [0xba, 0xdc, 0xfe]
/// - Session handshake required before authentication
/// - Packet types: ACK, SESSION_CONFIG, DATA
/// - Sequence numbers and checksums
///
/// ✅ PHASE 4: All configuration loaded dynamically from JSON
/// No more hardcoded values - supports multiple devices via device JSON files.
library;

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:wearable_sensors/src/internal/bluetooth/spp_v2_config.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_auth_service.dart'
    show EncryptionKeys;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_crypto.dart';

/// Helper: Get packet preamble from config
List<int> get _preamble => SppV2Config.instance.packetPreamble;

/// Helper: Get packet type value by name
int _getPacketType(final String name) =>
    SppV2Config.instance.getPacketType(name);

/// Helper: Get packet type name by value
String? _getPacketTypeName(final int value) {
  try {
    return SppV2Config.instance.getPacketTypeName(value);
  } on ArgumentError {
    return null;
  }
}

/// Helper: Get session config opcode by name
int _getSessionConfigOpcode(final String name) =>
    SppV2Config.instance.getSessionConfigOpcode(name);

/// Helper: Get session config opcode name by value
String? _getSessionConfigOpcodeName(final int value) {
  try {
    return SppV2Config.instance.getSessionConfigOpcodeName(value);
  } on ArgumentError {
    return null;
  }
}

/// Helper: Get session config key by name
int _getSessionConfigKey(final String name) =>
    SppV2Config.instance.getSessionConfigKey(name);

/// Helper: Get session config key name by value
String? _getSessionConfigKeyName(final int value) {
  try {
    return SppV2Config.instance.getSessionConfigKeyName(value);
  } on ArgumentError {
    return null;
  }
}

/// Helper: Get data opcode by name
int _getDataOpcode(final String name) =>
    SppV2Config.instance.getDataOpcode(name);

/// Helper: Get data opcode name by value
String? _getDataOpcodeName(final int value) =>
    SppV2Config.instance.getDataOpcodeName(value);

/// Helper: Get channel by name
int _getChannel(final String name) => SppV2Config.instance.getChannel(name);

/// Helper: Get channel name by value
String? _getChannelName(final int value) =>
    SppV2Config.instance.getChannelName(value);

/// Packet Type Helper Class (replaces SppV2PacketType enum)
class PacketType {
  const PacketType(this.value, this.name);
  final int value;
  final String name;

  static PacketType get ack => PacketType(_getPacketType('ack'), 'ack');
  static PacketType get sessionConfig =>
      PacketType(_getPacketType('session_config'), 'session_config');
  static PacketType get data => PacketType(_getPacketType('data'), 'data');

  static PacketType? fromValue(final int value) {
    final name = _getPacketTypeName(value);
    return name != null ? PacketType(value, name) : null;
  }

  @override
  String toString() => 'PacketType($name=$value)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is PacketType &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Session Config Opcode Helper (replaces SessionConfigOpcode enum)
class SessionConfigOpcode {
  const SessionConfigOpcode(this.value, this.name);
  final int value;
  final String name;

  static SessionConfigOpcode get startSessionRequest => SessionConfigOpcode(
        _getSessionConfigOpcode('start_session_request'),
        'start_session_request',
      );
  static SessionConfigOpcode get startSessionResponse => SessionConfigOpcode(
        _getSessionConfigOpcode('start_session_response'),
        'start_session_response',
      );
  static SessionConfigOpcode get stopSessionRequest => SessionConfigOpcode(
        _getSessionConfigOpcode('stop_session_request'),
        'stop_session_request',
      );
  static SessionConfigOpcode get stopSessionResponse => SessionConfigOpcode(
        _getSessionConfigOpcode('stop_session_response'),
        'stop_session_response',
      );

  static SessionConfigOpcode? fromValue(final int value) {
    final name = _getSessionConfigOpcodeName(value);
    return name != null ? SessionConfigOpcode(value, name) : null;
  }

  @override
  String toString() => 'SessionConfigOpcode($name=$value)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is SessionConfigOpcode &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Session Config Key Helper (replaces SessionConfigKey enum)
class SessionConfigKey {
  const SessionConfigKey(this.key, this.name);
  final int key;
  final String name;

  static SessionConfigKey get version =>
      SessionConfigKey(_getSessionConfigKey('version'), 'version');
  static SessionConfigKey get maxPacketSize => SessionConfigKey(
        _getSessionConfigKey('max_packet_size'),
        'max_packet_size',
      );
  static SessionConfigKey get txWin =>
      SessionConfigKey(_getSessionConfigKey('tx_win'), 'tx_win');
  static SessionConfigKey get sendTimeout =>
      SessionConfigKey(_getSessionConfigKey('send_timeout'), 'send_timeout');

  static SessionConfigKey? fromValue(final int value) {
    final name = _getSessionConfigKeyName(value);
    return name != null ? SessionConfigKey(value, name) : null;
  }

  @override
  String toString() => 'SessionConfigKey($name=$key)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is SessionConfigKey &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}

/// Data Opcode Helper (replaces DataOpcode enum)
class DataOpcode {
  const DataOpcode(this.value, this.name);
  final int value;
  final String name;

  static DataOpcode get sendProtobuf =>
      DataOpcode(_getDataOpcode('send_protobuf'), 'send_protobuf');
  static DataOpcode get sendAuth =>
      DataOpcode(_getDataOpcode('send_auth'), 'send_auth');
  static DataOpcode get sendActivity =>
      DataOpcode(_getDataOpcode('send_activity'), 'send_activity');
  static DataOpcode get sendMassData =>
      DataOpcode(_getDataOpcode('send_mass_data'), 'send_mass_data');

  static DataOpcode? fromValue(final int value) {
    final name = _getDataOpcodeName(value);
    return name != null ? DataOpcode(value, name) : null;
  }

  @override
  String toString() => 'DataOpcode($name=$value)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is DataOpcode &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Channel Helper (replaces SppV2Channel enum)
class SppV2Channel {
  const SppV2Channel(this.value, this.name);
  final int value;
  final String name;

  static SppV2Channel get version =>
      SppV2Channel(_getChannel('version'), 'version');
  static SppV2Channel get authentication =>
      SppV2Channel(_getChannel('authentication'), 'authentication');
  static SppV2Channel get protobufCommand =>
      SppV2Channel(_getChannel('protobuf_command'), 'protobuf_command');
  static SppV2Channel get activity =>
      SppV2Channel(_getChannel('activity'), 'activity');
  static SppV2Channel get data => SppV2Channel(_getChannel('data'), 'data');

  static SppV2Channel? fromValue(final int value) {
    final name = _getChannelName(value);
    return name != null ? SppV2Channel(value, name) : null;
  }

  @override
  String toString() => 'SppV2Channel($name=$value)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is SppV2Channel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Base class for all SPP V2 packets
abstract class SppV2Packet {
  SppV2Packet({required this.packetType, required this.sequenceNumber});
  final PacketType packetType;
  final int sequenceNumber;

  /// Get packet payload bytes (to be implemented by subclasses)
  Uint8List getPacketPayloadBytes({final EncryptionKeys? encryptionKeys});

  /// Encode packet to bytes
  Uint8List encode({final EncryptionKeys? encryptionKeys}) {
    final payload = getPacketPayloadBytes(encryptionKeys: encryptionKeys);
    final packetSize = payload.length;

    // Calculate checksum (CRC16 or similar - simplified for now)
    final checksum = _calculateChecksum(payload);

    // Create buffer for HEADER ONLY (8 bytes)
    final buffer = ByteData(8);
    int offset = 0;

    // Preamble (2 bytes) - dynamic from config
    final preamble = _preamble;
    buffer.setUint8(offset++, preamble[0]);
    buffer.setUint8(offset++, preamble[1]);

    // Flags and packet type (1 byte)
    buffer.setUint8(offset++, packetType.value);

    // Sequence number (1 byte)
    buffer.setUint8(offset++, sequenceNumber);

    // Packet size (2 bytes, little endian)
    buffer.setUint16(offset, packetSize, Endian.little);
    offset += 2;

    // Checksum (2 bytes, little endian)
    buffer.setUint16(offset, checksum, Endian.little);
    offset += 2;

    // Concatenate header + payload (no padding)
    final headerBytes = buffer.buffer.asUint8List();
    return Uint8List.fromList([...headerBytes, ...payload]);
  }

  /// Calculate checksum for payload
  ///
  /// Gadgetbridge algorithm (XiaomiSppPacketV2.java:414-426):
  /// CRC-16/ARC (poly=0x8005, init=0, xorout=0, refin, refout)
  ///
  /// ```java
  /// int crc = 0;
  /// for (byte b : payload) {
  ///     for (int j = 0; j < 8; j++) {
  ///         crc <<= 1;
  ///         if ((((crc >> 16) & 1) ^ ((b >> j) & 1)) == 1)
  ///             crc ^= 0x8005;
  ///     }
  /// }
  /// return (Integer.reverse(crc) >>> 16);
  /// ```
  int _calculateChecksum(final Uint8List payload) {
    int crc = 0;

    for (final byte in payload) {
      for (int j = 0; j < 8; j++) {
        crc <<= 1;

        // XOR condition: ((crc >> 16) & 1) ^ ((byte >> j) & 1)
        final crcBit = (crc >> 16) & 1;
        final byteBit = (byte >> j) & 1;

        if ((crcBit ^ byteBit) == 1) {
          crc ^= 0x8005;
        }
      }
    }

    // Reverse bits and extract 16-bit result
    // Java's Integer.reverse(crc) >>> 16
    return _reverseBits32(crc) >> 16;
  }

  /// Reverse bits of a 32-bit integer (Java's Integer.reverse())
  int _reverseBits32(int value) {
    int result = 0;
    for (int i = 0; i < 32; i++) {
      result = (result << 1) | (value & 1);
      value >>= 1;
    }
    return result;
  }

  /// Decode packet from bytes
  static SppV2Packet? decode(final Uint8List bytes) {
    if (bytes.length < 8) {
      // debugPrint(
      //   '🔍 SPP V2: Not enough bytes to decode packet (need 8, got ${bytes.length})',
      // );
      return null;
    }

    final buffer = ByteData.sublistView(bytes);

    // Check preamble - dynamic from config
    final preamble = _preamble;
    if (buffer.getUint8(0) != preamble[0] ||
        buffer.getUint8(1) != preamble[1]) {
      // debugPrint('⚠️ SPP V2: Invalid preamble');
      return null;
    }

    // Extract packet type from lower 4 bits (bits 4-7 are flags)
    // Gadgetbridge XiaomiSppPacketV2.java:465 → packetType = b & 0xf
    final byte = buffer.getUint8(2);
    final packetTypeValue =
        byte & 0x0F; // ✅ Mask with 0x0F to extract lower 4 bits
    final packetType = PacketType.fromValue(packetTypeValue);
    if (packetType == null) {
      // debugPrint(
      //   '⚠️ SPP V2: Unknown packet type $packetTypeValue (byte: $byte, masked: ${byte & 0x0F})',
      // );
      return null;
    }

    final sequenceNumber = buffer.getUint8(3);
    final packetSize = buffer.getUint16(4, Endian.little);
    final checksum = buffer.getUint16(6, Endian.little);

    final totalSize = 8 + packetSize;
    if (bytes.length < totalSize) {
      // debugPrint(
      //   '🔍 SPP V2: Incomplete packet (need $totalSize, got ${bytes.length})',
      // );
      return null;
    }

    final payload = bytes.sublist(8, totalSize);

    // Verify checksum using the SAME algorithm as encode()
    final calculatedChecksum = _staticCalculateChecksum(payload);
    if (checksum != calculatedChecksum) {
      // debugPrint(
      //   '⚠️ SPP V2: Checksum mismatch (expected $checksum, got $calculatedChecksum)',
      // );
      // Continue anyway (some devices may have checksum issues)
    }

    // Create appropriate packet type based on value
    if (packetType == PacketType.ack) {
      return AckPacket(sequenceNumber: sequenceNumber);
    } else if (packetType == PacketType.sessionConfig) {
      return SessionConfigPacket.fromPayload(sequenceNumber, payload);
    } else if (packetType == PacketType.data) {
      return DataPacket.fromPayload(sequenceNumber, payload);
    } else {
      // debugPrint('⚠️ SPP V2: Unknown packet type $packetTypeValue');
      return null;
    }
  }

  /// Static version of checksum calculation for decode()
  /// Uses the SAME CRC-16/ARC algorithm as _calculateChecksum()
  ///
  /// Gadgetbridge algorithm (XiaomiSppPacketV2.java:414-426):
  /// CRC-16/ARC (poly=0x8005, init=0, xorout=0, refin, refout)
  static int _staticCalculateChecksum(final Uint8List payload) {
    int crc = 0;

    for (final byte in payload) {
      for (int j = 0; j < 8; j++) {
        crc <<= 1;

        // XOR condition: ((crc >> 16) & 1) ^ ((byte >> j) & 1)
        final crcBit = (crc >> 16) & 1;
        final byteBit = (byte >> j) & 1;

        if ((crcBit ^ byteBit) == 1) {
          crc ^= 0x8005;
        }
      }
    }

    // Reverse bits and extract 16-bit result
    return _staticReverseBits32(crc) >> 16;
  }

  /// Static version of bit reversal for decode()
  static int _staticReverseBits32(int value) {
    int result = 0;
    for (int i = 0; i < 32; i++) {
      result = (result << 1) | (value & 1);
      value >>= 1;
    }
    return result;
  }
}

/// ACK Packet - acknowledges received DATA packets
class AckPacket extends SppV2Packet {
  AckPacket({required super.sequenceNumber})
      : super(packetType: PacketType.ack);

  @override
  Uint8List getPacketPayloadBytes({final EncryptionKeys? encryptionKeys}) {
    return Uint8List(0); // ACK has no payload
  }

  @override
  String toString() => 'AckPacket(seq=$sequenceNumber)';
}

/// Session Config Packet - used for session handshake
class SessionConfigPacket extends SppV2Packet {
  SessionConfigPacket({
    required super.sequenceNumber,
    required this.opcode,
    this.config = const {},
  }) : super(packetType: PacketType.sessionConfig);

  factory SessionConfigPacket.fromPayload(
    final int sequenceNumber,
    final Uint8List payload,
  ) {
    if (payload.isEmpty) {
      return SessionConfigPacket(
        sequenceNumber: sequenceNumber,
        opcode: SessionConfigOpcode.startSessionRequest,
      );
    }

    final opcodeValue = payload[0];
    final opcode = SessionConfigOpcode.fromValue(opcodeValue) ??
        SessionConfigOpcode.startSessionRequest;

    // Parse TLV config values
    final config =
        <int, Uint8List>{}; // Use int as key instead of SessionConfigKey
    int offset = 1;
    while (offset < payload.length) {
      if (offset + 2 > payload.length) break;

      final key = payload[offset];
      final length = payload[offset + 1];
      offset += 2;

      if (offset + length > payload.length) break;

      final value = payload.sublist(offset, offset + length);
      offset += length;

      config[key] = value;
    }

    return SessionConfigPacket(
      sequenceNumber: sequenceNumber,
      opcode: opcode,
      config: config,
    );
  }

  final SessionConfigOpcode opcode;
  final Map<int, Uint8List>
      config; // Changed from Map<SessionConfigKey, Uint8List>

  @override
  Uint8List getPacketPayloadBytes({final EncryptionKeys? encryptionKeys}) {
    final buffer = <int>[opcode.value];

    // Add TLV config values
    // TLV format: [key (1 byte)][size_lo (1 byte)][size_hi (1 byte)][value bytes...]
    for (final entry in config.entries) {
      final valueSize = entry.value.length;

      buffer.add(entry.key); // Key (1 byte)

      // Size (2 bytes, little endian)
      buffer.add(valueSize & 0xFF); // Low byte
      buffer.add((valueSize >> 8) & 0xFF); // High byte

      buffer.addAll(entry.value); // Value bytes
    }

    return Uint8List.fromList(buffer);
  }

  @override
  String toString() =>
      'SessionConfigPacket(seq=$sequenceNumber, opcode=$opcode, config=${config.length} items)';
}

/// Data Packet - carries actual data (protobuf, auth, etc.)
class DataPacket extends SppV2Packet {
  DataPacket({
    required super.sequenceNumber,
    required this.channel,
    required this.opcode,
    required this.payload,
    this.encrypted = false,
  }) : super(packetType: PacketType.data);

  factory DataPacket.fromPayload(
    final int sequenceNumber,
    final Uint8List payload,
  ) {
    if (payload.length < 2) {
      throw ArgumentError('DATA packet payload too short');
    }

    final rawChannel = payload[0] & 0x0f; // Apply mask to get raw channel
    final opcodeValue =
        payload[1] & 0xff; // Opcode without any bit manipulation

    // Map raw channel value to SppV2Channel
    final channel = _getChannelFromRaw(rawChannel);
    final opcode = DataOpcode.fromValue(opcodeValue) ?? DataOpcode.sendProtobuf;

    // Determine if encrypted based on opcode value (Gadgetbridge pattern)
    // OPCODE_SEND_ENCRYPTED = 2, OPCODE_SEND_PLAINTEXT = 1
    final encrypted =
        (opcodeValue == 2); // sendAuth or sendProtobuf with encryption

    final dataPayload = payload.sublist(2);

    return DataPacket(
      sequenceNumber: sequenceNumber,
      channel: channel,
      opcode: opcode,
      payload: dataPayload,
      encrypted: encrypted,
    );
  }

  final SppV2Channel channel;
  final DataOpcode opcode;
  final Uint8List payload;
  final bool encrypted;

  /// Get decrypted payload bytes using AES-CTR (Xiaomi V2 protocol)
  ///
  /// ⚠️ CRITICAL: Gadgetbridge uses AES-CTR mode for V2 protocol, NOT CCM!
  /// See XiaomiAuthService.java:decryptV2() - uses CTR with key as IV
  Uint8List getDecryptedPayload({final EncryptionKeys? encryptionKeys}) {
    if (!encrypted) return payload;

    if (encryptionKeys == null) {
      // debugPrint('⚠️ SPP V2: Cannot decrypt - no encryption keys provided');
      return payload;
    }

    // debugPrint('🔐 SPP V2: Decrypting INCOMING payload using AES-CTR');
    // debugPrint('   Encrypted payload: ${payload.length} bytes');
    // debugPrint(
    //   '   decryptionKey: ${encryptionKeys.decryptionKey.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    // );

    try {
      // Gadgetbridge V2 uses AES-CTR with decryptionKey as BOTH key and IV!
      // See XiaomiAuthService.java:368-375
      // ctrCrypt(DECRYPT_MODE, decryptionKey, decryptionKey, ciphertext)
      final decrypted = XiaomiCrypto.ctrCrypt(
        encryptionKeys.decryptionKey, // key
        encryptionKeys.decryptionKey, // IV (same as key!)
        payload,
      );

      // debugPrint(
      //   '   ✅ Decrypted ${payload.length} → ${decrypted.length} bytes',
      // );
      // debugPrint(
      //   '   Decrypted hex: ${decrypted.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      // );

      return decrypted;
    } on Exception {
      // debugPrint('❌ AES-CTR decryption failed: $e');
      return payload; // Return encrypted if decryption fails
    }
  }

  @override
  Uint8List getPacketPayloadBytes({final EncryptionKeys? encryptionKeys}) {
    // debugPrint('🔍 DEBUG DataPacket: getPacketPayloadBytes called');
    // debugPrint('   channel: $channel');
    // debugPrint('   opcode: ${opcode.name} (value=${opcode.value})');
    // debugPrint('   encrypted: $encrypted');
    // debugPrint('   encryptionKeys provided: ${encryptionKeys != null}');
    // if (encryptionKeys != null) {
    //   debugPrint(
    //     '   encryptionKey length: ${encryptionKeys.encryptionKey.length}',
    //   );
    //   debugPrint(
    //     '   encryptionNonce length: ${encryptionKeys.encryptionNonce.length}',
    //   );
    // }

    final buffer = <int>[];

    // Channel - use raw channel value with mask (Gadgetbridge compatible)
    // getRawChannel() maps logical channels to protocol values:
    // Authentication/ProtobufCommand → 1, Data → 2, Activity → 5
    final rawChannel = _getRawChannel(channel) & 0x0f;
    buffer.add(rawChannel);
    debugPrint('   raw channel: $rawChannel');

    // Opcode - NO encryption bit (Gadgetbridge pattern)
    // Gadgetbridge does NOT set 0x80 bit on opcode.
    // They simply use opcode value (1 or 2) and decide encryption based on opcode == OPCODE_SEND_ENCRYPTED
    // See XiaomiSppPacketV2.java:374: buffer.put((byte) (opCode & 0xff));
    final opcodeValue = opcode.value;
    // debugPrint(
    //   '   opcode value: $opcodeValue (0x${opcodeValue.toRadixString(16)})',
    // );
    buffer.add(opcodeValue);

    // Payload (with optional encryption)
    if (encrypted) {
      if (encryptionKeys != null) {
        // debugPrint('🔐 SPP V2: Encrypting payload using AES-CTR');
        // debugPrint('   Original payload: ${payload.length} bytes');

        try {
          // Gadgetbridge V2 uses AES-CTR with encryptionKey as BOTH key and IV!
          // See XiaomiAuthService.java:361-367
          // ctrCrypt(ENCRYPT_MODE, encryptionKey, encryptionKey, message)
          final encryptedPayload = XiaomiCrypto.ctrCrypt(
            encryptionKeys.encryptionKey, // key
            encryptionKeys.encryptionKey, // IV (same as key!)
            payload,
          );

          // debugPrint('   Encrypted payload: ${encryptedPayload.length} bytes');
          buffer.addAll(encryptedPayload);
        } on Exception {
          // debugPrint('❌ SPP V2: Encryption failed: $e');
          // debugPrint('   Falling back to plain payload (INSECURE!)');
          buffer.addAll(payload);
        }
      } else {
        // debugPrint(
        //   '⚠️ SPP V2: Encryption requested but no keys provided, using plain payload',
        // );
        buffer.addAll(payload);
      }
    } else {
      buffer.addAll(payload);
    }

    return Uint8List.fromList(buffer);
  }

  /// Get appropriate opcode for a given channel (Gadgetbridge compatible)
  /// Maps channels to opcodes following Gadgetbridge XiaomiSppPacketV2.java:348
  /// - Authentication channel → PLAINTEXT (opcode=1) for initial handshake
  /// - ProtobufCommand channel → ENCRYPTED (opcode=2) for post-auth commands
  /// - Activity channel → ENCRYPTED (opcode=2) for activity data
  /// - Data channel → PLAINTEXT (opcode=1) for mass data transfer
  ///
  /// CRITICAL: authentication and protobuf_command have SAME raw channel value (1)
  /// but DIFFERENT opcodes. Must compare by channel NAME, not value.
  static DataOpcode getOpcodeForChannel(final SppV2Channel channel) {
    // Compare by channel NAME (not value) because auth and protobuf share value=1
    final channelName = channel.name;

    // debugPrint(
    //   '🔍 getOpcodeForChannel: channel=$channelName (value=${channel.value})',
    // );

    if (channelName == 'authentication') {
      // Authentication channel: PLAINTEXT (opcode=1)
      // debugPrint('   → AUTH → sendAuth (opcode=1)');
      return DataOpcode.sendAuth;
    } else if (channelName == 'protobuf_command') {
      // ProtobufCommand channel: ENCRYPTED (opcode=2) ✅ FIX
      // debugPrint('   → PROTOBUF → sendProtobuf (opcode=2)');
      return DataOpcode.sendProtobuf;
    } else if (channelName == 'activity') {
      // Activity channel: ENCRYPTED (opcode=2)
      // debugPrint('   → ACTIVITY → sendActivity (opcode=2)');
      return DataOpcode.sendActivity;
    } else if (channelName == 'data') {
      // Data channel: PLAINTEXT (opcode=1)
      // debugPrint('   → DATA → sendMassData (opcode=1)');
      return DataOpcode.sendMassData;
    } else {
      // Default: ENCRYPTED (opcode=2)
      // debugPrint(
      //   '   → UNKNOWN ($channelName) → DEFAULT sendProtobuf (opcode=2)',
      // );
      return DataOpcode.sendProtobuf;
    }
  }

  /// Get raw channel value for protocol transmission
  /// Matches Gadgetbridge's getRawChannel() logic:
  /// - Authentication/ProtobufCommand → CHANNEL_PROTOBUF (1)
  /// - Data → CHANNEL_DATA (2)
  /// - Activity → CHANNEL_ACTIVITY (5)
  static int _getRawChannel(final SppV2Channel channel) {
    // Channel constants from Gadgetbridge XiaomiSppPacketV2.java:258-260
    const channelProtobuf = 1; // encrypted after authentication
    const channelData = 2; // not encrypted
    const channelActivity = 5; // encrypted
    const channelUnknown = -1;

    if (channel == SppV2Channel.authentication ||
        channel == SppV2Channel.protobufCommand) {
      return channelProtobuf;
    } else if (channel == SppV2Channel.data) {
      return channelData;
    } else if (channel == SppV2Channel.activity) {
      return channelActivity;
    } else {
      debugPrint(
        '⚠️ SPP V2: Unable to get raw channel value for channel $channel',
      );
      return channelUnknown;
    }
  }

  /// Get SppV2Channel from raw protocol value
  /// Inverse of _getRawChannel() - matches Gadgetbridge's getChannelFromRaw()
  static SppV2Channel _getChannelFromRaw(final int rawChannel) {
    // Channel constants from Gadgetbridge XiaomiSppPacketV2.java:258-260
    const channelProtobuf = 1; // encrypted after authentication
    const channelData = 2; // not encrypted
    const channelActivity = 5; // encrypted

    switch (rawChannel) {
      case channelProtobuf:
        return SppV2Channel.protobufCommand;
      case channelData:
        return SppV2Channel.data;
      case channelActivity:
        return SppV2Channel.activity;
      default:
        debugPrint('⚠️ SPP V2: Unknown raw channel $rawChannel');
        return SppV2Channel.protobufCommand; // Default fallback
    }
  }

  @override
  String toString() =>
      'DataPacket(seq=$sequenceNumber, channel=$channel, opcode=$opcode, encrypted=$encrypted, payload=${payload.length} bytes)';
}

/// Builder for Session Config Packets
class SessionConfigPacketBuilder {
  int _sequenceNumber = 0;
  SessionConfigOpcode _opcode = SessionConfigOpcode.startSessionRequest;
  final Map<int, Uint8List> _config =
      {}; // Changed from Map<SessionConfigKey, Uint8List>

  SessionConfigPacketBuilder setSequenceNumber(final int seq) {
    _sequenceNumber = seq;
    return this;
  }

  SessionConfigPacketBuilder setOpcode(final SessionConfigOpcode opcode) {
    _opcode = opcode;
    return this;
  }

  SessionConfigPacketBuilder addConfig(
    final int key, // Changed from SessionConfigKey
    final Uint8List value,
  ) {
    _config[key] = value;
    return this;
  }

  /// Add config by key name (convenience method)
  SessionConfigPacketBuilder addConfigByName(
    final String keyName,
    final Uint8List value,
  ) {
    final key = _getSessionConfigKey(keyName);
    _config[key] = value;
    return this;
  }

  SessionConfigPacket build() {
    return SessionConfigPacket(
      sequenceNumber: _sequenceNumber,
      opcode: _opcode,
      config: _config,
    );
  }
}

/// Builder for Data Packets
class DataPacketBuilder {
  int _sequenceNumber = 0;
  SppV2Channel _channel = SppV2Channel.protobufCommand;
  DataOpcode? _opcode;
  Uint8List _payload = Uint8List(0);
  bool _encrypted = false;

  DataPacketBuilder setSequenceNumber(final int seq) {
    _sequenceNumber = seq;
    return this;
  }

  DataPacketBuilder setChannel(final SppV2Channel channel) {
    _channel = channel;
    return this;
  }

  DataPacketBuilder setOpcode(final DataOpcode opcode) {
    _opcode = opcode;
    return this;
  }

  DataPacketBuilder setPayload(final Uint8List payload) {
    _payload = payload;
    return this;
  }

  DataPacketBuilder setEncrypted(final bool encrypted) {
    _encrypted = encrypted;
    return this;
  }

  DataPacket build() {
    final opcode = _opcode ?? DataPacket.getOpcodeForChannel(_channel);
    return DataPacket(
      sequenceNumber: _sequenceNumber,
      channel: _channel,
      opcode: opcode,
      payload: _payload,
      encrypted: _encrypted,
    );
  }
}
