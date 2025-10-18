// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📦 Xiaomi Device Credentials - Dream Incubator
// Modelo para almacenar credenciales de autenticación Xiaomi

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Credenciales de autenticación para dispositivos Xiaomi
///
/// Almacena:
/// - `authKey`: Secret key (16 bytes hex) para encriptación
/// - `userId`: User ID numérico (10 dígitos) para dispositivos plaintext
///
/// **Storage:** Usa flutter_secure_storage para persistir credenciales de forma segura
class XiaomiDeviceCredentials {
  XiaomiDeviceCredentials({
    required this.deviceId,
    required this.authKey,
    this.userId = '0000000000',
  });

  final String deviceId;
  final String authKey; // Hex string (32 chars) o "0x..." (34 chars)
  final String userId; // Numeric string (10 digits)

  // Secure storage instance
  static const _storage = FlutterSecureStorage();

  /// Convert authKey hex string to bytes
  ///
  /// **Formato soportado:**
  /// - "0x1234567890abcdef..." (34 chars con prefijo)
  /// - "1234567890abcdef..." (32 chars sin prefijo)
  ///
  /// **Output:** 16 bytes
  Uint8List get authKeyBytes {
    try {
      final cleanKey = authKey.trim();
      final hexString =
          cleanKey.startsWith('0x') ? cleanKey.substring(2) : cleanKey;

      if (hexString.length != 32) {
        throw FormatException(
          'Auth key must be 32 hex chars (got ${hexString.length})',
        );
      }

      final bytes = Uint8List(16);
      for (var i = 0; i < 16; i++) {
        final hex = hexString.substring(i * 2, i * 2 + 2);
        bytes[i] = int.parse(hex, radix: 16);
      }

      return bytes;
    } catch (e) {
      debugPrint('❌ Failed to parse authKey: $e');
      rethrow;
    }
  }

  /// Validate authKey format
  ///
  /// **Valid formats:**
  /// - Hex string: 32 chars (e.g., "1234567890abcdef...")
  /// - Hex string with prefix: 34 chars (e.g., "0x1234567890abcdef...")
  /// - Numeric userId: 10 digits (for plaintext devices)
  static bool isValidAuthKey(final String authKey) {
    final trimmed = authKey.trim();

    // Hex format (with or without 0x)
    if (trimmed.length == 32 ||
        (trimmed.startsWith('0x') && trimmed.length == 34)) {
      final hexPart = trimmed.startsWith('0x') ? trimmed.substring(2) : trimmed;
      return RegExp(r'^[0-9a-fA-F]{32}$').hasMatch(hexPart);
    }

    // Numeric userId format (plaintext devices)
    if (RegExp(r'^\d{1,10}$').hasMatch(trimmed)) {
      return true;
    }

    return false;
  }

  /// Save credentials to secure storage
  ///
  /// **Storage keys:**
  /// - `xiaomi_authkey_{deviceId}` → authKey hex string
  /// - `xiaomi_userid_{deviceId}` → userId numeric string
  Future<void> save() async {
    try {
      await _storage.write(key: 'xiaomi_authkey_$deviceId', value: authKey);
      await _storage.write(key: 'xiaomi_userid_$deviceId', value: userId);
      debugPrint('✅ Saved Xiaomi credentials for device: $deviceId');
    } catch (e) {
      debugPrint('❌ Failed to save Xiaomi credentials: $e');
      rethrow;
    }
  }

  /// Load credentials from secure storage
  ///
  /// **Returns:** XiaomiDeviceCredentials o null si no existe
  static Future<XiaomiDeviceCredentials?> load(final String deviceId) async {
    try {
      final authKey = await _storage.read(key: 'xiaomi_authkey_$deviceId');
      final userId =
          await _storage.read(key: 'xiaomi_userid_$deviceId') ?? '0000000000';

      if (authKey == null) {
        debugPrint('⚠️ No authKey found for device: $deviceId');
        return null;
      }

      return XiaomiDeviceCredentials(
        deviceId: deviceId,
        authKey: authKey,
        userId: userId,
      );
    } on Exception catch (e) {
      debugPrint('❌ Failed to load Xiaomi credentials: $e');
      return null;
    }
  }

  /// Delete credentials from secure storage
  static Future<void> delete(final String deviceId) async {
    try {
      await _storage.delete(key: 'xiaomi_authkey_$deviceId');
      await _storage.delete(key: 'xiaomi_userid_$deviceId');
      debugPrint('🗑️ Deleted Xiaomi credentials for device: $deviceId');
    } on Exception catch (e) {
      debugPrint('❌ Failed to delete Xiaomi credentials: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'XiaomiDeviceCredentials(deviceId: $deviceId, '
        'authKey: $authKey, userId: $userId)';
  }
}
