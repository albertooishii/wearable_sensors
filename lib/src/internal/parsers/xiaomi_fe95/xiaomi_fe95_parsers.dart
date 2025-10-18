// Xiaomi FE95 Parsers Barrel
//
// Device-specific parsers for Xiaomi Mi Band series (Mi Band 6/7/8).
// Uses proprietary Xiaomi service UUID 0xFE95.
//
// Note: Heart Rate and Battery Level parsers are STANDARD Bluetooth SIG protocols,
// so we re-export the generic parsers instead of duplicating code.
//
// Usage:
// ```dart
// import 'package:dream_incubator/shared/parsers/xiaomi_fe95/xiaomi_fe95_parsers.dart';
//
// // Standard BLE parsers (re-exported from generic):
// final hrSample = GenericHeartRateParser.parse(bytes);
// final batterySample = GenericBatteryLevelParser.parse(bytes);
//
// // Xiaomi proprietary parsers:
// final activitySample = XiaomiActivityDataParser.parse(bytes);
// final stepsSample = XiaomiRealtimeStepsParser.parse(bytes);
// final spo2Sample = XiaomiSpo2Parser.parse(bytes); // Future use
// ```

library;

// Re-export generic parsers for standard BLE protocols
// (Heart Rate 0x2A37 and Battery Level 0x2A19 are Bluetooth SIG standards)
export '../generic/heart_rate_parser.dart';
export '../generic/battery_level_parser.dart';

// Export Xiaomi proprietary parsers
export 'activity_data_parser.dart';
export 'realtime_steps_parser.dart';
export 'spo2_parser.dart';
