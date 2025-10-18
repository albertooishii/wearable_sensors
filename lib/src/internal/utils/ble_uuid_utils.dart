// � Wearable Sensors Package - BLE UUID Utilities
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

/// BLE UUID utility functions
///
/// Simple utility class for BLE UUID operations.
/// Replaces the complex BleCapabilitiesMap with minimal footprint.
///
/// **Purpose:**
/// - Convert short UUIDs to full UUIDs (Bluetooth SIG standard)
/// - Normalize UUIDs for comparison
///
/// **Example:**
/// ```dart
/// final fullUuid = BleUuidUtils.expandUuid('180D');
/// // Returns: '0000180D-0000-1000-8000-00805F9B34FB'
/// ```
class BleUuidUtils {
  BleUuidUtils._(); // Private constructor - static class only

  /// 🌐 Bluetooth SIG Base UUID
  ///
  /// All Bluetooth SIG assigned UUIDs follow this pattern:
  /// 0000XXXX-0000-1000-8000-00805F9B34FB
  ///
  /// Where XXXX is the 16-bit assigned number.
  static const String _baseUuid = '0000-1000-8000-00805F9B34FB';

  /// ✅ Expand short UUID to full UUID
  ///
  /// Converts 16-bit UUIDs (4 hex chars) to full 128-bit UUIDs.
  ///
  /// **Examples:**
  /// - `'180D'` → `'0000180D-0000-1000-8000-00805F9B34FB'` (Heart Rate)
  /// - `'180F'` → `'0000180F-0000-1000-8000-00805F9B34FB'` (Battery)
  /// - `'FE95'` → `'0000FE95-0000-1000-8000-00805F9B34FB'` (Xiaomi)
  ///
  /// **Non-standard UUIDs:**
  /// - If UUID is already full (contains '-'), returns as-is
  /// - If UUID is 8 hex chars, prepends base UUID parts
  ///
  /// **Parameters:**
  /// - [shortUuid]: 4 or 8 hex character UUID (case-insensitive)
  ///
  /// **Returns:**
  /// Full 128-bit UUID string in standard format
  static String expandUuid(final String shortUuid) {
    // Remove any existing hyphens and convert to uppercase
    final cleaned = shortUuid.replaceAll('-', '').toUpperCase();

    // If already full UUID (32 hex chars), format and return
    if (cleaned.length == 32) {
      return _formatFullUuid(cleaned);
    }

    // If 4 hex chars (16-bit UUID) - standard Bluetooth SIG
    if (cleaned.length == 4) {
      return '0000$cleaned-$_baseUuid';
    }

    // If 8 hex chars (32-bit UUID) - less common but valid
    if (cleaned.length == 8) {
      return '$cleaned-$_baseUuid';
    }

    // Invalid UUID format - return as-is (caller should handle)
    return shortUuid;
  }

  /// 🔍 Normalize UUID for comparison
  ///
  /// Removes hyphens and converts to lowercase for consistent comparison.
  ///
  /// **Example:**
  /// ```dart
  /// final uuid1 = BleUuidUtils.normalizeUuid('0000180D-0000-1000-8000-00805F9B34FB');
  /// final uuid2 = BleUuidUtils.normalizeUuid('180D');
  /// // Both can be compared after expansion + normalization
  /// ```
  ///
  /// **Parameters:**
  /// - [uuid]: UUID string in any format
  ///
  /// **Returns:**
  /// Normalized UUID (no hyphens, lowercase)
  static String normalizeUuid(final String uuid) {
    return uuid.replaceAll('-', '').toLowerCase();
  }

  /// 📐 Format full UUID with hyphens
  ///
  /// Internal helper to format 32 hex char string to standard UUID format:
  /// XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  ///
  /// **Parameters:**
  /// - [cleanedUuid]: 32 hex character string (no hyphens)
  ///
  /// **Returns:**
  /// Formatted UUID with hyphens
  static String _formatFullUuid(final String cleanedUuid) {
    return '${cleanedUuid.substring(0, 8)}-'
        '${cleanedUuid.substring(8, 12)}-'
        '${cleanedUuid.substring(12, 16)}-'
        '${cleanedUuid.substring(16, 20)}-'
        '${cleanedUuid.substring(20, 32)}';
  }

  /// ✅ Check if UUID is short format (16-bit)
  ///
  /// **Example:**
  /// ```dart
  /// BleUuidUtils.isShortUuid('180D'); // true
  /// BleUuidUtils.isShortUuid('0000180D-0000-1000-8000-00805F9B34FB'); // false
  /// ```
  static bool isShortUuid(final String uuid) {
    final cleaned = uuid.replaceAll('-', '');
    return cleaned.length == 4;
  }

  /// ✅ Check if UUID is full format (128-bit)
  ///
  /// **Example:**
  /// ```dart
  /// BleUuidUtils.isFullUuid('0000180D-0000-1000-8000-00805F9B34FB'); // true
  /// BleUuidUtils.isFullUuid('180D'); // false
  /// ```
  static bool isFullUuid(final String uuid) {
    final cleaned = uuid.replaceAll('-', '');
    return cleaned.length == 32;
  }

  /// 🔄 Convert UUID to short format if possible
  ///
  /// Extracts 16-bit UUID from full Bluetooth SIG UUID.
  /// Only works for UUIDs following Bluetooth SIG pattern.
  ///
  /// **Example:**
  /// ```dart
  /// BleUuidUtils.toShortUuid('0000180D-0000-1000-8000-00805F9B34FB');
  /// // Returns: '180D'
  /// ```
  ///
  /// **Returns:**
  /// - Short UUID if it's a Bluetooth SIG UUID
  /// - Original UUID if it's a custom 128-bit UUID
  static String toShortUuid(final String uuid) {
    final cleaned = normalizeUuid(uuid);

    // Check if it matches Bluetooth SIG base pattern
    if (cleaned.length == 32 && cleaned.endsWith('0000100080005f9b34fb')) {
      // Extract the 16-bit portion (first 8 chars, skip leading zeros)
      return cleaned.substring(4, 8).toUpperCase();
    }

    // Not a standard Bluetooth SIG UUID - return original in UPPERCASE
    return uuid.toUpperCase();
  }
}
