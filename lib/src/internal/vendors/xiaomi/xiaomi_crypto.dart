// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 🔐 Xiaomi Crypto - Dream Incubator
// Implementación de funciones criptográficas para autenticación Xiaomi Smart Band 10
//
// Basado en: Gadgetbridge XiaomiAuthService.java
// Algoritmos: AES-CCM, HMAC-SHA256, AES-CTR

import 'dart:math' show Random;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

/// Servicio de criptografía para autenticación Xiaomi
///
/// Implementa:
/// - AES-CCM (Counter with CBC-MAC) para encriptación de mensajes
/// - HMAC-SHA256 para autenticación de mensajes
/// - AES-CTR (Counter Mode) para protocolo V2
class XiaomiCrypto {
  /// Compute HMAC-SHA256
  ///
  /// Usado en el handshake de autenticación para verificar integridad.
  ///
  /// **Ejemplo:**
  /// ```dart
  /// final hmac = XiaomiCrypto.hmacSHA256(key, data);
  /// ```
  static Uint8List hmacSHA256(final Uint8List key, final Uint8List input) {
    try {
      final hmac = HMac(SHA256Digest(), 64);
      hmac.init(KeyParameter(key));
      return hmac.process(input);
    } catch (e) {
      debugPrint('❌ Failed to compute HMAC-SHA256: $e');
      rethrow;
    }
  }

  /// Compute Auth Step 3 HMAC (Xiaomi-specific key derivation)
  ///
  /// Este es el paso crítico del handshake que deriva las claves de
  /// encriptación/desencriptación desde el secretKey y los nonces.
  ///
  /// **Output (64 bytes):**
  /// - Bytes 0-15: Decryption Key
  /// - Bytes 16-31: Encryption Key
  /// - Bytes 32-35: Decryption Nonce
  /// - Bytes 36-39: Encryption Nonce
  ///
  /// **Algoritmo:**
  /// 1. HMAC-SHA256(phoneNonce + watchNonce) → hmacKeyBytes
  /// 2. HKDF-like derivation con "miwear-auth" como info
  /// 3. Output: 64 bytes de key material
  static Uint8List computeAuthStep3Hmac(
    final Uint8List secretKey,
    final Uint8List phoneNonce,
    final Uint8List watchNonce,
  ) {
    try {
      final miwearAuthBytes = Uint8List.fromList('miwear-auth'.codeUnits);

      // 🔍 DEBUG: Log ALL inputs to computeAuthStep3Hmac
      debugPrint('🔍 computeAuthStep3Hmac - INPUTS:');
      debugPrint(
        '   secretKey: ${secretKey.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint(
        '   phoneNonce: ${phoneNonce.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint(
        '   watchNonce: ${watchNonce.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Step 1: Initial HMAC con phoneNonce + watchNonce
      final combinedNonces = Uint8List.fromList([...phoneNonce, ...watchNonce]);
      debugPrint(
        '   combinedNonces (phoneNonce + watchNonce): ${combinedNonces.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      final hmac = HMac(SHA256Digest(), 64);
      hmac.init(KeyParameter(combinedNonces));
      final hmacKeyBytes = hmac.process(secretKey);

      debugPrint(
        '   hmacKeyBytes (step1): ${hmacKeyBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Step 2: Re-initialize HMAC con la key derivada
      hmac.init(KeyParameter(hmacKeyBytes));

      // Step 3: HKDF-like expansion para generar 64 bytes
      final output = Uint8List(64);
      var tmp = Uint8List(0);
      var b = 1;
      var i = 0;

      while (i < output.length) {
        hmac.reset();
        hmac.update(tmp, 0, tmp.length);
        hmac.update(miwearAuthBytes, 0, miwearAuthBytes.length);
        hmac.updateByte(b);
        tmp = hmac.process(Uint8List(0));

        for (var j = 0; j < tmp.length && i < output.length; j++, i++) {
          output[i] = tmp[j];
        }
        b++;
      }

      debugPrint('🔍 computeAuthStep3Hmac - OUTPUT (64 bytes):');
      debugPrint(
        '   output: ${output.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint(
        '   decryptionKey [0-15]: ${output.sublist(0, 16).map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
      debugPrint(
        '   encryptionKey [16-31]: ${output.sublist(16, 32).map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      return output;
    } catch (e) {
      debugPrint('❌ Failed to compute Auth Step 3 HMAC: $e');
      rethrow;
    }
  }

  /// Encrypt data using AES-CCM (Counter with CBC-MAC)
  ///
  /// Usado para encriptar comandos protobuf durante la comunicación autenticada.
  ///
  /// **Parámetros:**
  /// - [key]: AES key (16 bytes)
  /// - [nonce]: Nonce único por paquete (12 bytes)
  /// - [payload]: Datos a encriptar
  /// - [macSizeBits]: Tamaño del MAC en bits (default: 32 bits = 4 bytes)
  ///
  /// **Output:** Ciphertext + MAC (authentication tag)
  static Uint8List encryptCCM(
    final Uint8List key,
    final Uint8List nonce,
    final Uint8List payload, {
    final int macSizeBits = 32,
  }) {
    try {
      final cipher = CCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        macSizeBits,
        nonce,
        Uint8List(0), // No associated data
      );
      cipher.init(true, params); // true = encrypt mode

      return cipher.process(payload);
    } catch (e) {
      debugPrint('❌ AES-CCM encryption failed: $e');
      rethrow;
    }
  }

  /// Decrypt data using AES-CCM
  ///
  /// **Parámetros:**
  /// - [key]: AES key (16 bytes)
  /// - [nonce]: Nonce del paquete (12 bytes)
  /// - [encryptedPayload]: Ciphertext + MAC
  /// - [checkMac]: Si verificar el MAC (default: true)
  ///
  /// **Output:** Plaintext decrypted
  ///
  /// **Throws:** Exception si MAC verification falla
  static Uint8List decryptCCM(
    final Uint8List key,
    final Uint8List nonce,
    final Uint8List encryptedPayload, {
    final bool checkMac = true,
  }) {
    try {
      final macSizeBits = checkMac ? 32 : 0;
      final actualEncryptedLength =
          checkMac ? encryptedPayload.length : encryptedPayload.length - 4;

      final cipher = CCMBlockCipher(AESEngine());
      final params = AEADParameters(
        KeyParameter(key),
        macSizeBits,
        nonce,
        Uint8List(0),
      );
      cipher.init(false, params); // false = decrypt mode

      final encryptedData = encryptedPayload.sublist(0, actualEncryptedLength);
      return cipher.process(encryptedData);
    } catch (e) {
      debugPrint('❌ AES-CCM decryption failed: $e');
      rethrow;
    }
  }

  /// Encrypt/Decrypt using AES-CTR (Counter Mode) for protocol V2
  ///
  /// **Nota:** En CTR mode, encryption y decryption son la misma operación.
  ///
  /// **Parámetros:**
  /// - [key]: AES key (16 bytes)
  /// - [iv]: Initialization vector (16 bytes)
  /// - [data]: Datos a encriptar/desencriptar
  ///
  /// **Uso en Xiaomi V2:**
  /// ```dart
  /// // Encrypt: IV = encryptionKey, Key = encryptionKey
  /// final ciphertext = ctrCrypt(encryptionKey, encryptionKey, plaintext);
  ///
  /// // Decrypt: IV = decryptionKey, Key = decryptionKey
  /// final plaintext = ctrCrypt(decryptionKey, decryptionKey, ciphertext);
  /// ```
  static Uint8List ctrCrypt(
    final Uint8List key,
    final Uint8List iv,
    final Uint8List data,
  ) {
    try {
      final cipher = CTRStreamCipher(AESEngine());
      final params = ParametersWithIV(KeyParameter(key), iv);
      cipher.init(true, params); // CTR mode doesn't distinguish encrypt/decrypt

      return cipher.process(data);
    } catch (e) {
      debugPrint('❌ AES-CTR encryption/decryption failed: $e');
      rethrow;
    }
  }

  /// Generate secure random nonce
  ///
  /// Usado para generar phoneNonce en el inicio del handshake.
  ///
  /// **Ejemplo:**
  /// ```dart
  /// final phoneNonce = XiaomiCrypto.generateNonce(16);
  /// ```
  static Uint8List generateNonce(final int length) {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(256));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom.nextBytes(length);
  }
}
