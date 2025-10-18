import 'dart:typed_data';

import 'package:flutter/rendering.dart';

import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import '../../models/biometric_sample.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;

/// Parser for Xiaomi SPP Realtime Stats (multi-sensor data)
///
/// Handles periodic realtime statistics from Xiaomi Band 9/10:
/// - Heart rate (HR)
/// - Steps (cumulative)
/// - Movement intensity (activity proxy via unknown3)
/// - Calories
/// - Standing hours
///
/// **Protocol**: SPP Protobuf (Command type=8, subtype=47)
/// **Frequency**: ~1 sample/second when enabled
/// **Multi-sensor**: Returns List&lt;BiometricSample&gt; (one per sensor)
///
/// Example usage:
/// ```dart
/// // Parse incoming realtime stats event
/// final samples = XiaomiSppRealtimeStatsParser.parse(sppBytes);
///
/// // Process each sensor
/// for (final sample in samples) {
///   switch (sample.dataType) {
///     case BleDataTypes.heartRate:
///       // HR data (BPM)
///       break;
///     case BleDataTypes.movement:
///       // Movement intensity proxy
///       break;
///   }
/// }
/// ```
class XiaomiSppRealtimeStatsParser {
  /// Parse realtime stats from SPP protobuf bytes
  ///
  /// Returns List&lt;BiometricSample&gt; with multiple sensors, or null if:
  /// - Invalid protobuf format
  /// - Command is not type=8, subtype=47
  /// - No realTimeStats field present
  /// - All sensor values are zero/invalid
  static List<BiometricSample>? parse(final List<int> bytes) {
    try {
      // 1. Parse protobuf Command
      final command = pb.Command.fromBuffer(Uint8List.fromList(bytes));

      // 2. Validate command type (Health service, realtime event)
      if (command.type != 8 || command.subtype != 47) {
        // Not a realtime stats event
        return null;
      }

      // 3. Extract RealTimeStats
      if (!command.hasHealth() || !command.health.hasRealTimeStats()) {
        return null;
      }

      final stats = command.health.realTimeStats;
      final timestamp = DateTime.now();
      final samples = <BiometricSample>[];

      // 4. Parse Heart Rate (most critical for lucid dreaming)
      if (stats.hasHeartRate() && stats.heartRate > 10) {
        // Ignore HR <= 10 (invalid/measuring)
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.heartRate.toDouble(),
            sensorType: SensorType.heartRate,
            metadata: {
              'unit': 'bpm',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'valid': stats.heartRate >= 40 && stats.heartRate <= 220,
            },
          ),
        );
      }

      // 5. Parse Movement Intensity (via unknown3 - activity proxy)
      // This field increases during physical activity (Gadgetbridge finding)
      if (stats.hasUnknown3() && stats.unknown3 > 0) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.unknown3.toDouble(),
            sensorType: SensorType.movement,
            metadata: {
              'unit': 'arbitrary',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'note': 'activity_intensity_proxy',
            },
          ),
        );
      }

      // 6. Parse Steps (cumulative during session)
      if (stats.hasSteps() && stats.steps > 0) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.steps.toDouble(),
            sensorType: SensorType.steps,
            metadata: {
              'unit': 'count',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'cumulative': true, // Important: not delta, absolute count
            },
          ),
        );
      }

      // 7. Parse Calories (bonus data)
      if (stats.hasCalories() && stats.calories > 0) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.calories.toDouble(),
            sensorType: SensorType.calories,
            metadata: {
              'unit': 'kcal',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'cumulative': true,
            },
          ),
        );
      }

      // 8. Parse Standing Hours (bonus data) - No SensorType equivalent, use unknown
      if (stats.hasStandingHours() && stats.standingHours > 0) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.standingHours.toDouble(),
            sensorType: SensorType.unknown,
            metadata: {
              'unit': 'hours',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'data_type_name': 'standing_hours',
            },
          ),
        );
      }

      // 9. Return null if no valid samples
      return samples.isEmpty ? null : samples;
    } on Exception catch (e) {
      // Invalid protobuf or parsing error
      debugPrint('Error parsing Xiaomi SPP realtime stats: $e');
      return null;
    }
  }

  /// Validate if heart rate is physiologically valid
  ///
  /// Typical resting HR: 40-100 BPM
  /// Typical max HR: 180-220 BPM
  static bool isValidHeartRate(final double hr) {
    return hr >= 40 && hr <= 220;
  }

  /// Classify heart rate zone (for sleep stage detection)
  ///
  /// Returns:
  /// - 'very_low': < 50 BPM (deep sleep likely)
  /// - 'low': 50-60 BPM (light sleep)
  /// - 'normal': 60-80 BPM (awake resting)
  /// - 'elevated': 80-100 BPM (light activity/REM)
  /// - 'high': > 100 BPM (activity/stress)
  static String classifyHeartRateZone(final double hr) {
    if (hr < 50) return 'very_low';
    if (hr < 60) return 'low';
    if (hr < 80) return 'normal';
    if (hr < 100) return 'elevated';
    return 'high';
  }

  /// Calculate movement level from intensity value
  ///
  /// Based on Gadgetbridge observations:
  /// - 0: No movement (deep sleep)
  /// - 1-5: Minimal movement (light sleep)
  /// - 6-15: Moderate movement (REM/restless)
  /// - 16+: High movement (awake)
  ///
  /// Note: These thresholds are estimates, needs calibration with real data
  static String classifyMovementLevel(final double intensity) {
    if (intensity == 0) return 'none';
    if (intensity <= 5) return 'minimal';
    if (intensity <= 15) return 'moderate';
    return 'high';
  }

  /// Detect if user is likely awake based on steps delta
  ///
  /// If steps increased in last sample, user is probably awake
  static bool isLikelyAwake({
    required final double currentSteps,
    required final double? previousSteps,
  }) {
    if (previousSteps == null) return false;
    return currentSteps > previousSteps;
  }
}
