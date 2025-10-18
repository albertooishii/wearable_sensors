import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as xiaomi_proto;

void main() {
  test('Command PhoneNonce serialization/parsing', () {
    // Create 16-byte nonce
    final nonce = Uint8List.fromList(
      List<int>.generate(16, (final i) => i + 1),
    );

    final phoneNonce = xiaomi_proto.PhoneNonce()..nonce = nonce;
    final auth = xiaomi_proto.Auth()..phoneNonce = phoneNonce;

    final cmd = xiaomi_proto.Command()
      ..type = 1
      ..subtype = 26
      ..auth = auth;

    final bytes = cmd.writeToBuffer();

    final parsed = xiaomi_proto.Command.fromBuffer(Uint8List.fromList(bytes));

    expect(parsed.type, equals(1));
    expect(parsed.subtype, equals(26));
    expect(parsed.hasAuth(), isTrue);
    expect(parsed.auth.hasPhoneNonce(), isTrue);
    expect(parsed.auth.phoneNonce.nonce.length, equals(16));
    expect(parsed.auth.phoneNonce.nonce, equals(nonce));
  });
}
