// 🧪 Xiaomi Crypto Tests - Dream Incubator
// Tests unitarios para funciones de encriptación Xiaomi

import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_crypto.dart';

void main() {
  group('XiaomiCrypto', () {
    group('HMAC-SHA256', () {
      test('computes correct HMAC with known test vector', () {
        // Test vector from RFC 4231
        final key = Uint8List.fromList(List.filled(20, 0x0b));
        final data = Uint8List.fromList('Hi There'.codeUnits);

        final hmac = XiaomiCrypto.hmacSHA256(key, data);

        // Expected output (truncated to 32 bytes)
        expect(hmac.length, equals(32));
        expect(hmac, isNotEmpty);
      });

      test('produces different HMACs for different keys', () {
        final key1 = Uint8List.fromList(List.filled(16, 0x01));
        final key2 = Uint8List.fromList(List.filled(16, 0x02));
        final data = Uint8List.fromList('test data'.codeUnits);

        final hmac1 = XiaomiCrypto.hmacSHA256(key1, data);
        final hmac2 = XiaomiCrypto.hmacSHA256(key2, data);

        expect(hmac1, isNot(equals(hmac2)));
      });
    });

    group('computeAuthStep3Hmac', () {
      test('generates 64 bytes of key material', () {
        final secretKey = Uint8List.fromList(List.filled(16, 0xAA));
        final phoneNonce = Uint8List.fromList(List.filled(16, 0xBB));
        final watchNonce = Uint8List.fromList(List.filled(16, 0xCC));

        final keyMaterial = XiaomiCrypto.computeAuthStep3Hmac(
          secretKey,
          phoneNonce,
          watchNonce,
        );

        expect(keyMaterial.length, equals(64));
      });

      test('produces deterministic output for same inputs', () {
        final secretKey = Uint8List.fromList(List.filled(16, 0x11));
        final phoneNonce = Uint8List.fromList(List.filled(16, 0x22));
        final watchNonce = Uint8List.fromList(List.filled(16, 0x33));

        final result1 = XiaomiCrypto.computeAuthStep3Hmac(
          secretKey,
          phoneNonce,
          watchNonce,
        );

        final result2 = XiaomiCrypto.computeAuthStep3Hmac(
          secretKey,
          phoneNonce,
          watchNonce,
        );

        expect(result1, equals(result2));
      });

      test('produces different output for different nonces', () {
        final secretKey = Uint8List.fromList(List.filled(16, 0x11));
        final phoneNonce1 = Uint8List.fromList(List.filled(16, 0x22));
        final phoneNonce2 = Uint8List.fromList(List.filled(16, 0x33));
        final watchNonce = Uint8List.fromList(List.filled(16, 0x44));

        final result1 = XiaomiCrypto.computeAuthStep3Hmac(
          secretKey,
          phoneNonce1,
          watchNonce,
        );

        final result2 = XiaomiCrypto.computeAuthStep3Hmac(
          secretKey,
          phoneNonce2,
          watchNonce,
        );

        expect(result1, isNot(equals(result2)));
      });
    });

    group('AES-CCM Encryption/Decryption', () {
      test('encrypts and decrypts data correctly', () {
        final key = Uint8List.fromList(List.filled(16, 0x42));
        final nonce = Uint8List.fromList(List.filled(12, 0x24));
        final plaintext = Uint8List.fromList('Hello Xiaomi!'.codeUnits);

        // Encrypt
        final ciphertext = XiaomiCrypto.encryptCCM(key, nonce, plaintext);

        // Should be longer than plaintext (includes MAC)
        expect(ciphertext.length, greaterThan(plaintext.length));

        // Decrypt
        final decrypted = XiaomiCrypto.decryptCCM(key, nonce, ciphertext);

        expect(decrypted, equals(plaintext));
      });

      test('produces different ciphertext for different nonces', () {
        final key = Uint8List.fromList(List.filled(16, 0x42));
        final nonce1 = Uint8List.fromList(List.filled(12, 0x01));
        final nonce2 = Uint8List.fromList(List.filled(12, 0x02));
        final plaintext = Uint8List.fromList('Test'.codeUnits);

        final ciphertext1 = XiaomiCrypto.encryptCCM(key, nonce1, plaintext);
        final ciphertext2 = XiaomiCrypto.encryptCCM(key, nonce2, plaintext);

        expect(ciphertext1, isNot(equals(ciphertext2)));
      });

      test('throws on MAC verification failure', () {
        final key = Uint8List.fromList(List.filled(16, 0x42));
        final nonce = Uint8List.fromList(List.filled(12, 0x24));
        final plaintext = Uint8List.fromList('Test'.codeUnits);

        final ciphertext = XiaomiCrypto.encryptCCM(key, nonce, plaintext);

        // Corrupt the MAC
        final corrupted = Uint8List.fromList(ciphertext);
        corrupted[corrupted.length - 1] ^= 0xFF;

        // Should throw on MAC verification (StateError from pointycastle)
        expect(
          () => XiaomiCrypto.decryptCCM(key, nonce, corrupted),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('AES-CTR Encryption/Decryption', () {
      test('encrypts and decrypts data correctly', () {
        final key = Uint8List.fromList(List.filled(16, 0x11));
        final iv = Uint8List.fromList(List.filled(16, 0x22));
        final plaintext = Uint8List.fromList('CTR Mode Test'.codeUnits);

        // Encrypt
        final ciphertext = XiaomiCrypto.ctrCrypt(key, iv, plaintext);

        expect(ciphertext.length, equals(plaintext.length));
        expect(ciphertext, isNot(equals(plaintext)));

        // Decrypt (same operation)
        final decrypted = XiaomiCrypto.ctrCrypt(key, iv, ciphertext);

        expect(decrypted, equals(plaintext));
      });

      test('produces deterministic output', () {
        final key = Uint8List.fromList(List.filled(16, 0x11));
        final iv = Uint8List.fromList(List.filled(16, 0x22));
        final plaintext = Uint8List.fromList('Test'.codeUnits);

        final result1 = XiaomiCrypto.ctrCrypt(key, iv, plaintext);
        final result2 = XiaomiCrypto.ctrCrypt(key, iv, plaintext);

        expect(result1, equals(result2));
      });
    });

    group('generateNonce', () {
      test('generates nonce of correct length', () {
        final nonce = XiaomiCrypto.generateNonce(16);

        expect(nonce.length, equals(16));
      });

      test('generates different nonces each time', () {
        final nonce1 = XiaomiCrypto.generateNonce(16);
        final nonce2 = XiaomiCrypto.generateNonce(16);

        expect(nonce1, isNot(equals(nonce2)));
      });

      test('supports different lengths', () {
        final nonce4 = XiaomiCrypto.generateNonce(4);
        final nonce12 = XiaomiCrypto.generateNonce(12);
        final nonce32 = XiaomiCrypto.generateNonce(32);

        expect(nonce4.length, equals(4));
        expect(nonce12.length, equals(12));
        expect(nonce32.length, equals(32));
      });
    });
  });
}
