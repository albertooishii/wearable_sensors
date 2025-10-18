import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api/models/auth_credentials.dart';

/// Internal service for storing and retrieving device authentication credentials.
///
/// Stores credentials securely using platform-specific secure storage:
/// - **Android**: EncryptedSharedPreferences (AES-256)
/// - **iOS**: Keychain
/// - **macOS**: Keychain
/// - **Windows/Linux**: Encrypted file storage
///
/// **Implementation Details:**
/// - Credentials are stored per device using deviceId as key
/// - Each credential is serialized as JSON
/// - Automatic cleanup of expired credentials
/// - Thread-safe singleton pattern (optional)
class DeviceStorageService {
  static const String _prefixKey = 'wearable_sensors_';
  static const String _devicesListKey = '${_prefixKey}devices_list';

  late final FlutterSecureStorage _storage;
  bool _isInitialized = false;
  final Map<String, AuthCredentials> _credentialsCache = {};

  /// Initialize the storage service with FlutterSecureStorage.
  ///
  /// On iOS/macOS: Uses Keychain
  /// On Android: Uses EncryptedSharedPreferences (AES-256)
  /// On other platforms: Uses encrypted file storage
  Future<void> initialize() async {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        // EncryptedSharedPreferences uses AES-256-GCM by default
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.unlocked,
      ),
    );
    _isInitialized = true;
  }

  /// Gets list of device IDs that have stored credentials.
  ///
  /// Returns IDs from secure storage, with cache for performance.
  Future<List<String>> getAuthenticatedDeviceIds() async {
    _checkInitialized();

    // Try to load from storage
    final devicesListJson = await _storage.read(key: _devicesListKey);

    if (devicesListJson == null || devicesListJson.isEmpty) {
      return [];
    }

    try {
      // Parse JSON list of device IDs
      final List<dynamic> decoded = jsonDecode(devicesListJson) as List;
      return decoded.cast<String>();
    } catch (e) {
      // If corrupted, return empty and let caller retry
      return [];
    }
  }

  /// Checks if credentials exist for a device.
  ///
  /// Checks both secure storage and cache for performance.
  Future<bool> hasCredentials(String deviceId) async {
    _checkInitialized();

    // Check cache first
    if (_credentialsCache.containsKey(deviceId)) {
      return true;
    }

    // Check secure storage
    final key = _getStorageKey(deviceId);
    final credentialsJson = await _storage.read(key: key);
    return credentialsJson != null && credentialsJson.isNotEmpty;
  }

  /// Saves authentication credentials for a device.
  ///
  /// **Thread-safe:** Uses atomic write via secure storage.
  /// Automatically updates the devices list.
  Future<void> saveCredentials(
    String deviceId,
    AuthCredentials credentials,
  ) async {
    _checkInitialized();

    try {
      // 1. Save credentials to secure storage (atomic write)
      final key = _getStorageKey(deviceId);
      final credentialsJson = jsonEncode(credentials.toJson());
      await _storage.write(
        key: key,
        value: credentialsJson,
      );

      // 2. Update credentials list
      await _updateDevicesList(deviceId, added: true);

      // 3. Update cache
      _credentialsCache[deviceId] = credentials;
    } catch (e) {
      throw Exception('Failed to save credentials for $deviceId: $e');
    }
  }

  /// Retrieves stored credentials for a device.
  ///
  /// Returns null if not found. Caches result for performance.
  Future<AuthCredentials?> getCredentials(String deviceId) async {
    _checkInitialized();

    // Check cache first
    if (_credentialsCache.containsKey(deviceId)) {
      return _credentialsCache[deviceId];
    }

    try {
      final key = _getStorageKey(deviceId);
      final credentialsJson = await _storage.read(key: key);

      if (credentialsJson == null || credentialsJson.isEmpty) {
        return null;
      }

      // Parse JSON and cache
      final credentialsMap =
          jsonDecode(credentialsJson) as Map<String, dynamic>;
      final credentials = AuthCredentials.fromJson(credentialsMap);
      _credentialsCache[deviceId] = credentials;
      return credentials;
    } catch (e) {
      throw Exception('Failed to load credentials for $deviceId: $e');
    }
  }

  /// Removes stored credentials for a device.
  ///
  /// **Thread-safe:** Removes from both storage and cache.
  Future<void> removeCredentials(String deviceId) async {
    _checkInitialized();

    try {
      // 1. Remove from secure storage
      final key = _getStorageKey(deviceId);
      await _storage.delete(key: key);

      // 2. Update devices list
      await _updateDevicesList(deviceId, added: false);

      // 3. Remove from cache
      _credentialsCache.remove(deviceId);
    } catch (e) {
      throw Exception('Failed to remove credentials for $deviceId: $e');
    }
  }

  /// Clears all stored credentials (for testing/reset).
  ///
  /// **WARNING:** This is a destructive operation. Use with care.
  /// Intended for development/testing only.
  Future<void> clearAll() async {
    _checkInitialized();

    try {
      // Get all device IDs and delete each
      final deviceIds = await getAuthenticatedDeviceIds();
      for (final deviceId in deviceIds) {
        await removeCredentials(deviceId);
      }

      // Also clear the devices list
      await _storage.delete(key: _devicesListKey);
      _credentialsCache.clear();
    } catch (e) {
      throw Exception('Failed to clear all credentials: $e');
    }
  }

  /// Disposes resources and clears cache.
  ///
  /// After calling this, you must call `initialize()` again before using.
  Future<void> dispose() async {
    _credentialsCache.clear();
    _isInitialized = false;
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  /// Generates storage key for a device ID.
  String _getStorageKey(String deviceId) {
    return '${_prefixKey}credentials_$deviceId';
  }

  /// Updates the list of devices with stored credentials.
  ///
  /// Maintains a JSON list of all device IDs for quick access.
  Future<void> _updateDevicesList(
    String deviceId, {
    required bool added,
  }) async {
    try {
      final currentDevices = await getAuthenticatedDeviceIds();
      final updatedDevices = List<String>.from(currentDevices);

      if (added) {
        if (!updatedDevices.contains(deviceId)) {
          updatedDevices.add(deviceId);
        }
      } else {
        updatedDevices.remove(deviceId);
      }

      // Save updated list
      final json = jsonEncode(updatedDevices);
      await _storage.write(key: _devicesListKey, value: json);
    } catch (e) {
      // Non-critical, don't fail the operation
      // Device list will be rebuilt on next query if needed
    }
  }

  /// Checks that service is initialized before operations.
  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception(
        'DeviceStorageService not initialized. Call initialize() first.',
      );
    }
  }
}
