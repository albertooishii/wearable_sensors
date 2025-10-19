// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// 🎯 Centralized Xiaomi Device Detection
///
/// All Xiaomi device name patterns extracted from Gadgetbridge coordinators.
/// Single source of truth for device identification.
///
/// **Patterns from Gadgetbridge:**
/// - MiBand10Coordinator: Smart Band 10
/// - MiBand9Coordinator: Smart Band 9
/// - MiBand9ActiveCoordinator: Smart Band 9 Active
/// - MiBand8Coordinator: Smart Band 8
/// - MiBand8ProCoordinator: Smart Band 8 Pro
/// - MiBand8ActiveCoordinator: Smart Band 8 Active
/// - MiBand7Coordinator: Smart Band 7
/// - MiBand6Coordinator: Mi Band 6
class XiaomiDeviceDetection {
  XiaomiDeviceDetection._(); // Private constructor - utility class

  /// **Exact REGEX patterns for Xiaomi devices**
  ///
  /// Used by:
  /// - DeviceAdapter._isXiaomiDevice() - at discovery time
  /// - device_connection_manager._vendorFromDeviceName() - for vendor detection
  /// - SupportedDevicesConfig - for configuration management
  ///
  /// **Design:** Each pattern is precise to avoid false positives
  static final Map<String, RegExp> _xiaomiPatterns = {
    // Smart Band 10: "Xiaomi Smart Band 10 A1B2"
    'smart_band_10': RegExp(
      r'^Xiaomi Smart Band 10 [0-9A-F]{4}$',
      caseSensitive: false,
    ),

    // Smart Band 9: "Xiaomi Smart Band 9 A1B2"
    'smart_band_9': RegExp(
      r'^Xiaomi Smart Band 9 [0-9A-F]{4}$',
      caseSensitive: false,
    ),

    // Smart Band 9 Active: "Xiaomi Band 9 Active A1B2" or "Xiaomi Smart Band 9 Active A1B2"
    'smart_band_9_active': RegExp(
      r'^Xiaomi( Smart)? Band 9 Active [0-9A-F]{4}$',
      caseSensitive: false,
    ),

    // Smart Band 8: "Xiaomi Smart Band 8 A1B2"
    'smart_band_8': RegExp(
      r'^Xiaomi Smart Band 8 [A-Z0-9]{4}$',
      caseSensitive: false,
    ),

    // Smart Band 8 Pro: "Xiaomi Smart Band 8 Pro A1B2"
    'smart_band_8_pro': RegExp(
      r'^Xiaomi Smart Band 8 Pro [0-9A-F]{4}$',
      caseSensitive: false,
    ),

    // Smart Band 8 Active: "Xiaomi Band 8 Active A1B2" or "Xiaomi Smart Band 8 Active A1B2"
    'smart_band_8_active': RegExp(
      r'^Xiaomi( Smart)? Band 8 Active [A-Z0-9]{4}$',
      caseSensitive: false,
    ),
  };

  /// **Substring patterns for older Xiaomi models**
  ///
  /// These use simple string matching for compatibility with older models
  /// that don't follow the strict naming convention.
  static final List<String> _xiaomiSubstringPatterns = [
    // Smart Band 7
    'xiaomi smart band 7',
    // Mi Band 6
    'mi smart band 6',
    // Generic fallbacks
    'xiaomi',
    'mi band',
    'mi smart',
  ];

  /// ✅ Check if a device name matches Xiaomi exact patterns
  ///
  /// **Usage:**
  /// ```dart
  /// if (XiaomiDeviceDetection.matchesExactPattern('Xiaomi Smart Band 10 A1B2')) {
  ///   // Device is recognized Xiaomi model
  /// }
  /// ```
  static bool matchesExactPattern(String deviceName) {
    return _xiaomiPatterns.values.any(
      (pattern) => pattern.hasMatch(deviceName),
    );
  }

  /// ✅ Check if a device name is Xiaomi (exact + substring patterns)
  ///
  /// **Usage:**
  /// ```dart
  /// if (XiaomiDeviceDetection.isXiaomiDevice(deviceName)) {
  ///   // Handle Xiaomi-specific logic
  /// }
  /// ```
  static bool isXiaomiDevice(String deviceName) {
    final lowerName = deviceName.toLowerCase();

    // Try exact patterns first (more reliable)
    if (matchesExactPattern(deviceName)) {
      return true;
    }

    // Fallback to substring patterns
    return _xiaomiSubstringPatterns.any(
      (pattern) => lowerName.contains(pattern),
    );
  }

  /// ✅ Check if device requires Xiaomi SPP authentication
  ///
  /// **Note:** All recognized Xiaomi models require SPP auth
  /// (at least when unpaired).
  static bool requiresAuthKey(String deviceName) {
    return isXiaomiDevice(deviceName);
  }

  /// ✅ Get the matching pattern key for a device
  ///
  /// Returns the pattern key (e.g., 'smart_band_10') if found,
  /// or null if device doesn't match exact patterns.
  ///
  /// **Usage:**
  /// ```dart
  /// final patternKey = XiaomiDeviceDetection.getPatternKey('Xiaomi Smart Band 10 A1B2');
  /// // Returns 'smart_band_10'
  /// ```
  static String? getPatternKey(String deviceName) {
    for (final entry in _xiaomiPatterns.entries) {
      if (entry.value.hasMatch(deviceName)) {
        return entry.key;
      }
    }
    return null;
  }

  /// 📋 Get all available Xiaomi exact patterns
  ///
  /// Useful for testing or pattern verification.
  static Map<String, RegExp> getPatterns() {
    return Map.unmodifiable(_xiaomiPatterns);
  }

  /// 📋 Get all available substring patterns
  static List<String> getSubstringPatterns() {
    return List.unmodifiable(_xiaomiSubstringPatterns);
  }

  /// 🧪 Get description of what makes a device Xiaomi
  ///
  /// For debugging and user information.
  static String getDeviceDescription(String deviceName) {
    if (matchesExactPattern(deviceName)) {
      return '🎯 Exact Xiaomi device match (${getPatternKey(deviceName)})';
    }

    if (isXiaomiDevice(deviceName)) {
      return '✓ Xiaomi device (substring pattern match)';
    }

    return '✗ Not a recognized Xiaomi device';
  }
}
