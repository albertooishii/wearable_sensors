import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v1/packet.dart';

void main() {
  group('XiaomiSppPacketV1', () {
    test('encode - plain data packet', () {
      final builder = XiaomiSppPacketV1Builder()
        ..setChannel(XiaomiSppChannel.activity)
        ..setOpCode(XiaomiSppV1Constants.opcodeSend)
        ..setFrameSerial(42)
        ..setPayload(Uint8List.fromList([0x01, 0x02, 0x03, 0x04]));

      final packet = builder.build();
      final encoded = packet.encode();

      // Verify structure
      expect(encoded.sublist(0, 3), equals([0xba, 0xdc, 0xfe])); // Preamble
      expect(encoded[3], equals(3)); // Channel fitness
      expect(encoded[4] & 0x80, equals(0x80)); // Flag = true
      expect(
        encoded[5],
        equals(7),
      ); // Length = 4 payload + 3 headers (little-endian low byte)
      expect(encoded[6], equals(0)); // Length high byte
      expect(encoded[7], equals(XiaomiSppV1Constants.opcodeSend));
      expect(encoded[8], equals(42)); // Frame serial
      expect(encoded[9], equals(XiaomiSppV1Constants.dataTypePlain));
      expect(
        encoded.sublist(10, 14),
        equals([0x01, 0x02, 0x03, 0x04]),
      ); // Payload
      expect(encoded[14], equals(0xef)); // Epilogue
    });

    test('encode - version request packet', () {
      final builder = XiaomiSppPacketV1Builder()
        ..setChannel(XiaomiSppChannel.version)
        ..setOpCode(XiaomiSppV1Constants.opcodeRead)
        ..setFrameSerial(0)
        ..setNeedsResponse(true)
        ..setPayload(Uint8List(0));

      final packet = builder.build();
      final encoded = packet.encode();

      expect(encoded.sublist(0, 3), equals([0xba, 0xdc, 0xfe])); // Preamble
      expect(encoded[3], equals(0)); // Channel version
      expect(encoded[4] & 0xc0, equals(0xc0)); // Flag=true, needsResponse=true
      expect(encoded[7], equals(XiaomiSppV1Constants.opcodeRead));
      expect(encoded.last, equals(0xef)); // Epilogue
    });

    test('decode - valid packet', () {
      // Create a known packet: [ba dc fe] [03] [80] [0700] [02] [2a] [00] [01020304] [ef]
      final rawBytes = Uint8List.fromList([
        0xba, 0xdc, 0xfe, // Preamble
        0x03, // Channel fitness
        0x80, // Flags: flag=true
        0x07, 0x00, // Length = 7 (4 payload + 3 headers)
        0x02, // OpCode = SEND
        0x2a, // FrameSerial = 42
        0x00, // DataType = PLAIN
        0x01, 0x02, 0x03, 0x04, // Payload
        0xef, // Epilogue
      ]);

      final decoded = XiaomiSppPacketV1.decode(rawBytes);

      expect(decoded, isNotNull);
      expect(decoded!.channel, equals(XiaomiSppChannel.activity));
      expect(decoded.rawChannel, equals(3));
      expect(decoded.flag, isTrue);
      expect(decoded.needsResponse, isFalse);
      expect(decoded.opCode, equals(0x02));
      expect(decoded.frameSerial, equals(42));
      expect(decoded.dataType, equals(XiaomiSppV1Constants.dataTypePlain));
      expect(decoded.payload, equals([0x01, 0x02, 0x03, 0x04]));
    });

    test('decode - invalid preamble', () {
      final rawBytes = Uint8List.fromList([
        0xff, 0xff, 0xff, // Wrong preamble
        0x03, 0x80, 0x07, 0x00, 0x02, 0x2a, 0x00,
        0x01, 0x02, 0x03, 0x04,
        0xef,
      ]);

      final decoded = XiaomiSppPacketV1.decode(rawBytes);
      expect(decoded, isNull);
    });

    test('decode - packet too short', () {
      final rawBytes = Uint8List.fromList([0xba, 0xdc, 0xfe, 0x03]);
      final decoded = XiaomiSppPacketV1.decode(rawBytes);
      expect(decoded, isNull);
    });

    test('decode - invalid epilogue', () {
      final rawBytes = Uint8List.fromList([
        0xba, 0xdc, 0xfe,
        0x03, 0x80, 0x07, 0x00, 0x02, 0x2a, 0x00,
        0x01, 0x02, 0x03, 0x04,
        0xff, // Wrong epilogue
      ]);

      final decoded = XiaomiSppPacketV1.decode(rawBytes);
      expect(decoded, isNull);
    });

    test('encode with encryption', () {
      // Mock encryption function (just XOR with 0xAA for testing)
      Uint8List mockEncrypt(final Uint8List data) {
        return Uint8List.fromList(data.map((final b) => b ^ 0xaa).toList());
      }

      final builder = XiaomiSppPacketV1Builder()
        ..setChannel(XiaomiSppChannel.protobufCommand)
        ..setOpCode(XiaomiSppV1Constants.opcodeSend)
        ..setFrameSerial(5)
        ..setPayload(Uint8List.fromList([0x11, 0x22, 0x33, 0x44]));

      final packet = builder.build();
      final encoded = packet.encode(
        encryptFn: mockEncrypt,
        encryptionCounter: 10,
      );

      // Verify encrypted packet structure
      expect(encoded.sublist(0, 3), equals([0xba, 0xdc, 0xfe])); // Preamble
      expect(encoded[3], equals(2)); // Channel proto_tx
      expect(encoded[9], equals(XiaomiSppV1Constants.dataTypeEncrypted));

      // Payload should be encrypted (counter + data XOR 0xaa)
      // Counter = [0x0a, 0x00], Data = [0x11, 0x22, 0x33, 0x44]
      // XOR result: [0xa0, 0xaa, 0xbb, 0x88, 0x99, 0xee]
      final expectedEncrypted = [0xa0, 0xaa, 0xbb, 0x88, 0x99, 0xee];
      expect(encoded.sublist(10, 16), equals(expectedEncrypted));
      expect(encoded.last, equals(0xef)); // Epilogue
    });

    test('roundtrip - encode then decode', () {
      final original = XiaomiSppPacketV1Builder()
        ..setChannel(XiaomiSppChannel.version)
        ..setOpCode(XiaomiSppV1Constants.opcodeRead)
        ..setFrameSerial(123)
        ..setNeedsResponse(true)
        ..setPayload(Uint8List.fromList([0xaa, 0xbb, 0xcc]));

      final packet = original.build();
      final encoded = packet.encode();
      final decoded = XiaomiSppPacketV1.decode(encoded);

      expect(decoded, isNotNull);
      expect(decoded!.channel, equals(packet.channel));
      expect(decoded.opCode, equals(packet.opCode));
      expect(decoded.frameSerial, equals(packet.frameSerial));
      expect(decoded.needsResponse, equals(packet.needsResponse));
      expect(decoded.payload, equals(packet.payload));
    });

    test('channel getRawChannelTx', () {
      expect(XiaomiSppChannel.version.getRawChannelTx(), equals(0));
      expect(XiaomiSppChannel.protobufCommand.getRawChannelTx(), equals(2));
      expect(XiaomiSppChannel.authentication.getRawChannelTx(), equals(2));
      expect(XiaomiSppChannel.activity.getRawChannelTx(), equals(3));
      expect(XiaomiSppChannel.data.getRawChannelTx(), equals(5));
    });

    test('channel fromRawChannel', () {
      expect(
        XiaomiSppChannel.fromRawChannel(0),
        equals(XiaomiSppChannel.version),
      );
      expect(
        XiaomiSppChannel.fromRawChannel(1),
        equals(XiaomiSppChannel.protobufCommand),
      );
      expect(
        XiaomiSppChannel.fromRawChannel(2),
        equals(XiaomiSppChannel.protobufCommand),
      );
      expect(
        XiaomiSppChannel.fromRawChannel(3),
        equals(XiaomiSppChannel.activity),
      );
      expect(XiaomiSppChannel.fromRawChannel(5), equals(XiaomiSppChannel.data));
      expect(
        XiaomiSppChannel.fromRawChannel(99),
        equals(XiaomiSppChannel.unknown),
      );
    });
  });
}
