// Copyright (c) 2025 Alberto Oishii
// SPDX-License-Identifier: MPL-2.0
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at http://mozilla.org/MPL/2.0/.

import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';

// ========== BARREL IMPORTS ==========
// Import complete device parser sets via barrel files
// Note: xiaomi_fe95_parsers.dart re-exports generic parsers, so we don't need
// to import generic_parsers.dart separately
import 'xiaomi_fe95/xiaomi_fe95_parsers.dart';
import 'xiaomi_spp/battery_parser.dart'; // SPP protobuf parsers (Mi Band 9/10)
import 'xiaomi_spp/realtime_stats_parser.dart'; // SPP realtime stats (HR, movement)

// Future devices:
// import 'polar_h10/polar_h10_parsers.dart';
// import 'fitbit_sense/fitbit_sense_parsers.dart';

/// Centralized BLE Parser Registry
///
/// Provides unified access to all device-specific and generic BLE parsers.
/// Uses barrel pattern for clean imports - one barrel per device type.
///
/// **Parser Types**:
/// - **Single-sample parsers**: Return `BiometricSample?` (one sensor per message)
/// - **Multi-sample parsers**: Return `List<BiometricSample>?` (multiple sensors per message)
///
/// Usage:
/// ```dart
/// // Single-sample parser
/// final parser = ParserRegistry.getParser('xiaomi_activity_data');
/// if (parser != null) {
///   final sample = parser(bytes);
/// }
///
/// // Multi-sample parser
/// final multiParser = ParserRegistry.getMultiParser('xiaomi_spp_realtime_stats');
/// if (multiParser != null) {
///   final samples = multiParser(bytes);
///   for (final sample in samples) {
///     // Process each sensor
///   }
/// }
///
/// // Check if parser exists
/// if (ParserRegistry.hasParser('generic_heart_rate')) {
///   // ...
/// }
///
/// // List all parsers for a device
/// final xiaomiParsers = ParserRegistry.getParsersByDevice('xiaomi');
/// ```
///
/// Adding a new parser:
/// 1. Create parser file in appropriate device folder
/// 2. Export it in the device's barrel file
/// 3. Add entry to _parsers or _multiParsers map below
///
/// Adding a new device:
/// 1. Create folder: lib/shared/parsers/{device_name}/
/// 2. Create parsers in that folder
/// 3. Create barrel: {device_name}_parsers.dart
/// 4. Import barrel and add entries to _parsers map
class ParserRegistry {
  // ========== SINGLE-SAMPLE PARSER REGISTRY ==========
  // Map of parser name → parser function (returns one BiometricSample)
  static final Map<String, BiometricSample? Function(List<int>)> _parsers = {
    // ===== Generic BLE Parsers (Standard Bluetooth SIG) =====
    'generic_heart_rate': GenericHeartRateParser.parse,
    'generic_battery_level': GenericBatteryLevelParser.parse,

    // ===== Xiaomi FE95 Parsers (Mi Band 6/7/8 - BLE characteristics) =====
    // Note: HR and Battery use generic parsers (standard BLE protocols)
    'xiaomi_heart_rate': GenericHeartRateParser.parse, // Reuses generic
    'xiaomi_battery_level': GenericBatteryLevelParser.parse, // Reuses generic
    'xiaomi_activity_data': XiaomiActivityDataParser.parse, // Proprietary
    'xiaomi_realtime_steps': XiaomiRealtimeStepsParser.parse, // Proprietary
    'xiaomi_spo2': XiaomiSpo2Parser.parse, // Proprietary (Future use only)
    // ===== Xiaomi SPP Parsers (Mi Band 9/10 - BT_CLASSIC protobuf) =====
    'xiaomi_spp_battery': XiaomiSppBatteryParser.parse, // ✅ Protobuf battery
    // ===== Future: Polar H10 Parsers =====
    // 'polar_heart_rate': PolarHeartRateParser.parse,
    // 'polar_ecg': PolarEcgParser.parse,

    // ===== Future: Fitbit Sense Parsers =====
    // 'fitbit_heart_rate': FitbitHeartRateParser.parse,
    // 'fitbit_eda': FitbitEdaParser.parse,
  };

  // ========== MULTI-SAMPLE PARSER REGISTRY ==========
  // Map of parser name → multi-parser function (returns List<BiometricSample>)
  // Used for parsers that return multiple sensor readings in one message
  static final Map<String, List<BiometricSample>? Function(List<int>)>
      _multiParsers = {
    // ===== Xiaomi SPP Multi-Sensor Parsers =====
    'xiaomi_spp_realtime_stats':
        XiaomiSppRealtimeStatsParser.parse, // ✅ HR, movement, steps, calories
  };

  /// Get single-sample parser function by name
  ///
  /// Returns null if parser not found.
  ///
  /// Example:
  /// ```dart
  /// final parser = ParserRegistry.getParser('xiaomi_activity_data');
  /// if (parser != null) {
  ///   final sample = parser(bytes);
  /// }
  /// ```
  static BiometricSample? Function(List<int>)? getParser(final String name) {
    return _parsers[name];
  }

  /// Get multi-sample parser function by name
  ///
  /// Returns null if parser not found.
  ///
  /// Example:
  /// ```dart
  /// final parser = ParserRegistry.getMultiParser('xiaomi_spp_realtime_stats');
  /// if (parser != null) {
  ///   final samples = parser(bytes);
  ///   for (final sample in samples) {
  ///     print('${sample.dataType}: ${sample.value}');
  ///   }
  /// }
  /// ```
  static List<BiometricSample>? Function(List<int>)? getMultiParser(
    final String name,
  ) {
    return _multiParsers[name];
  }

  /// Check if parser exists (single or multi)
  ///
  /// Example:
  /// ```dart
  /// if (ParserRegistry.hasParser('generic_heart_rate')) {
  ///   // Parser available
  /// }
  /// ```
  static bool hasParser(final String name) =>
      _parsers.containsKey(name) || _multiParsers.containsKey(name);

  /// Check if parser is multi-sample type
  static bool isMultiParser(final String name) =>
      _multiParsers.containsKey(name);

  /// Get all available parser names (single + multi)
  ///
  /// Returns list of all registered parser names.
  static List<String> get availableParsers => [
        ..._parsers.keys,
        ..._multiParsers.keys,
      ];

  /// Get parsers by device type prefix (single + multi)
  ///
  /// Example:
  /// ```dart
  /// final xiaomiParsers = ParserRegistry.getParsersByDevice('xiaomi');
  /// // Returns: ['xiaomi_heart_rate', 'xiaomi_battery_level', 'xiaomi_spp_realtime_stats', ...]
  /// ```
  static List<String> getParsersByDevice(final String devicePrefix) {
    final single = _parsers.keys.where(
      (final String key) => key.startsWith('${devicePrefix}_'),
    );
    final multi = _multiParsers.keys.where(
      (final String key) => key.startsWith('${devicePrefix}_'),
    );
    return [...single, ...multi];
  }

  /// Get all generic (device-agnostic) parsers
  ///
  /// Returns list of parser names starting with 'generic_'.
  static List<String> get genericParsers {
    return getParsersByDevice('generic');
  }

  /// Get count of registered parsers (single + multi)
  static int get parserCount => _parsers.length + _multiParsers.length;

  /// Get count of parsers by device (single + multi)
  ///
  /// Example:
  /// ```dart
  /// final count = ParserRegistry.getDeviceParserCount('xiaomi');
  /// // Returns: 6
  /// ```
  static int getDeviceParserCount(final String devicePrefix) {
    return getParsersByDevice(devicePrefix).length;
  }
}
