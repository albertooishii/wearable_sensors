// Xiaomi SPP Parsers Barrel
//
// Device-specific parsers for Xiaomi Mi Band 9/10 over BT_CLASSIC SPP.
// Uses SPP V2 protocol with protobuf encoded commands.
//
// Note: SPP parsers handle multi-sensor data from protobuf commands.
//
// Usage:
// ```dart
// import 'package:wearable_sensors/src/internal/parsers/xiaomi_spp/xiaomi_spp_parsers.dart';
//
// // SPP protobuf parsers:
// final batterySample = XiaomiSppBatteryParser.parse(bytes);
// final statsSamples = XiaomiSppRealtimeStatsParser.parse(bytes);
// ```

library;

// Export Xiaomi SPP protobuf parsers
export 'battery_parser.dart';
export 'realtime_stats_parser.dart';
