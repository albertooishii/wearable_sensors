// Generic BLE Parsers Barrel
//
// Standard Bluetooth SIG service parsers.
// Compatible with ALL BLE devices (Polar, Fitbit, Garmin, Xiaomi, etc).
//
// Usage:
// ```dart
// import 'package:dream_incubator/shared/parsers/generic/generic_parsers.dart';
//
// // All generic parsers available:
// final hrSample = GenericHeartRateParser.parse(bytes);
// final batterySample = GenericBatteryLevelParser.parse(bytes);
// ```

library;

export 'heart_rate_parser.dart';
export 'battery_level_parser.dart';
