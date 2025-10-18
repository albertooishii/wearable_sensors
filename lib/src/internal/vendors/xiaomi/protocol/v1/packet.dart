// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Xiaomi SPP (Serial Port Profile) Packet V1 implementation
///
/// Based on Gadgetbridge XiaomiSppPacketV1.java
/// Used by Mi Band 8 Pro, Band 9, Band 9 Pro, and likely Band 10
///
/// Packet structure:
/// ```
/// [Preamble] [Channel] [Flags] [Length] [OpCode] [Serial] [DataType] [Payload] [Epilogue]
///    3 bytes   1 byte   1 byte  2 bytes  1 byte   1 byte    1 byte     N bytes   1 byte
/// ```
library;

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// SPP V1 Protocol constants
class XiaomiSppV1Constants {
  // Packet markers
  static const List<int> packetPreamble = [0xba, 0xdc, 0xfe];
  static const List<int> packetEpilogue = [0xef];

  // Channels
  static const int channelVersion = 0;
  static const int channelProtoRx = 1; // Device → Phone
  static const int channelProtoTx = 2; // Phone → Device
  static const int channelFitness = 3;
  static const int channelVoice = 4;
  static const int channelMass = 5;
  static const int channelOta = 7;

  // OpCodes
  static const int opcodeRead = 0;
  static const int opcodeSend = 2;

  // Data types
  static const int dataTypePlain = 0;
  static const int dataTypeEncrypted = 1;
  static const int dataTypeAuth = 2;
}

/// SPP V1 Channel enumeration
enum XiaomiSppChannel {
  version,
  protobufCommand,
  authentication,
  activity,
  data,
  unknown;

  /// Get raw channel number for TX (phone → device)
  int getRawChannelTx() {
    switch (this) {
      case XiaomiSppChannel.version:
        return XiaomiSppV1Constants.channelVersion;
      case XiaomiSppChannel.authentication:
      case XiaomiSppChannel.protobufCommand:
        return XiaomiSppV1Constants.channelProtoTx;
      case XiaomiSppChannel.activity:
        return XiaomiSppV1Constants.channelFitness;
      case XiaomiSppChannel.data:
        return XiaomiSppV1Constants.channelMass;
      default:
        return -1;
    }
  }

  /// Get raw channel number for RX (device → phone)
  int getRawChannelRx() {
    switch (this) {
      case XiaomiSppChannel.version:
        return XiaomiSppV1Constants.channelVersion;
      case XiaomiSppChannel.authentication:
      case XiaomiSppChannel.protobufCommand:
        return XiaomiSppV1Constants.channelProtoRx;
      case XiaomiSppChannel.activity:
        return XiaomiSppV1Constants.channelFitness;
      case XiaomiSppChannel.data:
        return XiaomiSppV1Constants.channelMass;
      default:
        return -1;
    }
  }

  /// Get data type for this channel
  int getDataType() {
    switch (this) {
      case XiaomiSppChannel.authentication:
        return XiaomiSppV1Constants.dataTypeAuth;
      case XiaomiSppChannel.version:
        return XiaomiSppV1Constants.dataTypePlain; // ✅ VERSION uses PLAIN!
      case XiaomiSppChannel.protobufCommand:
      case XiaomiSppChannel.data:
        return XiaomiSppV1Constants.dataTypeEncrypted;
      case XiaomiSppChannel.activity:
        return XiaomiSppV1Constants.dataTypePlain;
      default:
        return XiaomiSppV1Constants.dataTypePlain;
    }
  }

  /// Parse raw channel byte to enum
  static XiaomiSppChannel fromRawChannel(final int rawChannel) {
    switch (rawChannel & 0xff) {
      case XiaomiSppV1Constants.channelProtoRx:
      case XiaomiSppV1Constants.channelProtoTx:
        return XiaomiSppChannel.protobufCommand;
      case XiaomiSppV1Constants.channelFitness:
        return XiaomiSppChannel.activity;
      case XiaomiSppV1Constants.channelMass:
        return XiaomiSppChannel.data;
      case XiaomiSppV1Constants.channelVersion:
        return XiaomiSppChannel.version;
      default:
        return XiaomiSppChannel.unknown;
    }
  }
}

/// Xiaomi SPP V1 Packet
@immutable
class XiaomiSppPacketV1 {
  const XiaomiSppPacketV1({
    required this.channel,
    required this.rawChannel,
    required this.flag,
    required this.needsResponse,
    required this.opCode,
    required this.frameSerial,
    required this.dataType,
    required this.payload,
  });
  final XiaomiSppChannel channel;
  final int rawChannel;
  final bool flag;
  final bool needsResponse;
  final int opCode;
  final int frameSerial;
  final int dataType;
  final Uint8List payload;

  /// Encode packet to bytes
  ///
  /// [authService] - Optional encryption service (required if dataType == encrypted)
  /// [encryptionCounter] - Counter for encryption (auto-incremented)
  Uint8List encode({
    final Function(Uint8List)? encryptFn,
    final int? encryptionCounter,
  }) {
    final buffer = BytesBuilder();

    // Preamble: [0xba, 0xdc, 0xfe]
    buffer.add(XiaomiSppV1Constants.packetPreamble);

    // Channel byte (lower 4 bits)
    buffer.addByte(rawChannel & 0x0f);

    // Flags byte: bit 7 = flag, bit 6 = needsResponse
    int flagsByte = 0;
    if (flag) flagsByte |= 0x80;
    if (needsResponse) flagsByte |= 0x40;
    buffer.addByte(flagsByte);

    // Payload to encode (may need encryption)
    Uint8List encodedPayload = payload;

    // If encrypted and encryptFn provided
    if (dataType == XiaomiSppV1Constants.dataTypeEncrypted &&
        encryptFn != null) {
      // Prepend 2-byte encryption counter
      final counterBytes = Uint8List(2);
      final counter = encryptionCounter ?? 0;
      counterBytes[0] = counter & 0xff;
      counterBytes[1] = (counter >> 8) & 0xff;

      final dataWithCounter = Uint8List.fromList([...counterBytes, ...payload]);
      encodedPayload = encryptFn(dataWithCounter);
    }

    // Length: payload + 3 (opcode + serial + datatype)
    final length = encodedPayload.length + 3;
    buffer.addByte(length & 0xff);
    buffer.addByte((length >> 8) & 0xff);

    // OpCode, FrameSerial, DataType
    buffer.addByte(opCode & 0xff);
    buffer.addByte(frameSerial & 0xff);
    buffer.addByte(dataType & 0xff);

    // Payload
    buffer.add(encodedPayload);

    // Epilogue: [0xef]
    buffer.add(XiaomiSppV1Constants.packetEpilogue);

    return buffer.toBytes();
  }

  /// Decode packet from bytes
  static XiaomiSppPacketV1? decode(final Uint8List packet) {
    if (packet.length < 11) {
      debugPrint(
        'XiaomiSppPacketV1: Packet too short (${packet.length} bytes)',
      );
      return null;
    }

    final buffer = ByteData.sublistView(packet);
    int offset = 0;

    // Verify preamble
    final preamble = packet.sublist(0, 3);
    if (!listEquals(preamble, XiaomiSppV1Constants.packetPreamble)) {
      debugPrint(
        'XiaomiSppPacketV1: Invalid preamble: expected [ba dc fe], got [${preamble.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}]',
      );
      return null;
    }
    offset += 3;

    // Channel
    final rawChannel = buffer.getUint8(offset++);
    final channel = XiaomiSppChannel.fromRawChannel(rawChannel);

    // Flags
    final flagsByte = buffer.getUint8(offset++);
    final flag = (flagsByte & 0x80) != 0;
    final needsResponse = (flagsByte & 0x40) != 0;

    // Length (little-endian)
    final length = buffer.getUint16(offset, Endian.little);
    offset += 2;

    final payloadLength = length - 3; // Subtract opcode, serial, datatype
    final totalPacketSize = 3 +
        1 +
        1 +
        2 +
        length +
        1; // preamble + channel + flags + length + payload+headers + epilogue

    if (packet.length < totalPacketSize) {
      debugPrint(
        'XiaomiSppPacketV1: Incomplete packet (expected $totalPacketSize, got ${packet.length})',
      );
      return null;
    }

    // OpCode, Serial, DataType
    final opCode = buffer.getUint8(offset++);
    final frameSerial = buffer.getUint8(offset++);
    final dataType = buffer.getUint8(offset++);

    // Payload
    final payload = packet.sublist(offset, offset + payloadLength);
    offset += payloadLength;

    // Verify epilogue
    final epilogue = packet.sublist(offset, offset + 1);
    if (!listEquals(epilogue, XiaomiSppV1Constants.packetEpilogue)) {
      debugPrint(
        'XiaomiSppPacketV1: Invalid epilogue: expected [ef], got [${epilogue.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}]',
      );
      return null;
    }

    return XiaomiSppPacketV1(
      channel: channel,
      rawChannel: rawChannel,
      flag: flag,
      needsResponse: needsResponse,
      opCode: opCode,
      frameSerial: frameSerial,
      dataType: dataType,
      payload: payload,
    );
  }

  /// Decrypt payload if encrypted
  Uint8List getDecryptedPayload({final Function(Uint8List)? decryptFn}) {
    if (dataType == XiaomiSppV1Constants.dataTypeEncrypted &&
        decryptFn != null) {
      final decrypted = decryptFn(payload);
      // Skip first 2 bytes (encryption counter)
      if (decrypted.length > 2) {
        return decrypted.sublist(2);
      }
      return decrypted;
    }
    return payload;
  }

  @override
  String toString() {
    return 'XiaomiSppPacketV1('
        'channel=$channel, '
        'rawChannel=$rawChannel, '
        'flag=$flag, '
        'needsResponse=$needsResponse, '
        'opCode=0x${opCode.toRadixString(16)}, '
        'frameSerial=0x${frameSerial.toRadixString(16)}, '
        'dataType=0x${dataType.toRadixString(16)}, '
        'payloadSize=${payload.length})';
  }
}

/// Builder for XiaomiSppPacketV1
class XiaomiSppPacketV1Builder {
  XiaomiSppChannel _channel = XiaomiSppChannel.unknown;
  bool _flag = true;
  bool _needsResponse = false;
  int _opCode = XiaomiSppV1Constants.opcodeSend;
  int _frameSerial = 0;
  int _dataType = XiaomiSppV1Constants.dataTypeEncrypted;
  Uint8List _payload = Uint8List(0);

  XiaomiSppPacketV1Builder setChannel(final XiaomiSppChannel channel) {
    _channel = channel;
    // Auto-set dataType based on channel
    _dataType = channel.getDataType();
    return this;
  }

  XiaomiSppPacketV1Builder setFlag(final bool flag) {
    _flag = flag;
    return this;
  }

  XiaomiSppPacketV1Builder setNeedsResponse(final bool needsResponse) {
    _needsResponse = needsResponse;
    return this;
  }

  XiaomiSppPacketV1Builder setOpCode(final int opCode) {
    _opCode = opCode;
    return this;
  }

  XiaomiSppPacketV1Builder setFrameSerial(final int frameSerial) {
    _frameSerial = frameSerial;
    return this;
  }

  XiaomiSppPacketV1Builder setDataType(final int dataType) {
    _dataType = dataType;
    return this;
  }

  XiaomiSppPacketV1Builder setPayload(final Uint8List payload) {
    _payload = payload;
    return this;
  }

  XiaomiSppPacketV1 build() {
    final rawChannel = _channel.getRawChannelTx();
    return XiaomiSppPacketV1(
      channel: _channel,
      rawChannel: rawChannel,
      flag: _flag,
      needsResponse: _needsResponse,
      opCode: _opCode,
      frameSerial: _frameSerial,
      dataType: _dataType,
      payload: _payload,
    );
  }
}
