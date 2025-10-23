import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'dart:math';

import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import '../../models/biometric_sample.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;

/// 🎯 Movement Filter: Smooths binary movement detection using mode window
///
/// Problem: Raw movement detection produces false positives during transitions
/// (e.g., 0→1→0 within 1-5 seconds during sleep onset/offset)
///
/// Solution: Apply a sliding mode window to the binary movement stream
/// - Window size 20: Requires sustained movement for ~20 readings (~100 seconds)
/// - Only flips to 1 if majority of recent readings show movement
///
/// NOTE: This is a sensor-level filter for movement normalization.
/// Sleep phase determination (awake/sleeping) is handled by application layer
/// (dream_incubator SleepStateClassifier) after collecting sufficient data.
class _MovementFilter {
  final int windowSize;
  final List<int> _buffer = [];

  _MovementFilter({this.windowSize = 20})
      : assert(windowSize > 0, 'Window size must be positive');

  /// Add a new movement reading and return smoothed value
  /// Returns: 1 if majority of window shows movement, 0 otherwise
  int apply(int movementBinary) {
    assert(
      movementBinary == 0 || movementBinary == 1,
      'Movement must be binary (0 or 1)',
    );

    _buffer.add(movementBinary);

    // Keep buffer at max size
    if (_buffer.length > windowSize) {
      _buffer.removeAt(0);
    }

    // Need at least half the window filled before filtering
    if (_buffer.length < windowSize) {
      // Before window is full, return the current value
      return movementBinary;
    }

    // Calculate mode (most common value)
    int count0 = 0;
    int count1 = 0;

    for (final val in _buffer) {
      if (val == 0) {
        count0++;
      } else {
        count1++;
      }
    }

    // Return 1 if majority are 1s, otherwise 0
    return count1 > count0 ? 1 : 0;
  }

  /// Reset filter
  void reset() {
    _buffer.clear();
  }
}

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

/// Singleton to track previous values for change detection and HRV calculation
///
/// NOTE: State machine logic (CONFIRMING_AWAKE → SLEEP_CONFIRMED) has been moved
/// to dream_incubator's SleepStateClassifier for better separation of concerns.
/// This tracker now focuses on:
/// - Raw binary movement detection (changed any of steps/calories/unknown3)
/// - HRV calculation from HR history
class _RealtimeStatsTracker {
  static final _RealtimeStatsTracker _instance =
      _RealtimeStatsTracker._internal();

  factory _RealtimeStatsTracker() {
    return _instance;
  }

  _RealtimeStatsTracker._internal();

  int? previousUnknown3;
  int? previousSteps;
  int? previousUnknown5;
  int? previousCalories;

  // ✨ Track HR history for HRV calculation
  final List<int> _hrHistory = [];
  static const int _maxHrHistorySize = 120; // ~2 minutes at 1Hz

  // 🎯 Movement filter for smoothing binary detection
  // Window of 20 readings (~100 seconds) to eliminate false positives
  final _MovementFilter _movementFilter = _MovementFilter(windowSize: 20);

  bool isUnknown3Updated(int current) {
    final updated = previousUnknown3 != current;
    previousUnknown3 = current;
    return updated;
  }

  bool isStepsUpdated(int current) {
    final updated = previousSteps != current;
    previousSteps = current;
    return updated;
  }

  bool isUnknown5Updated(int current) {
    final updated = previousUnknown5 != current;
    previousUnknown5 = current;
    return updated;
  }

  bool isCaloriesUpdated(int current) {
    final updated = previousCalories != current;
    previousCalories = current;
    return updated;
  }

  /// Detect if movement has changed (binary detector, no state machine)
  /// Returns: 1 if ANY of (steps, calories, unknown3) changed, 0 otherwise
  /// Applies smoothing filter to reduce false positives during transitions
  int detectMovementChange({
    required int currentSteps,
    required int currentCalories,
    required int currentUnknown3,
  }) {
    // First call: initialize previous values
    if (previousSteps == null) {
      previousSteps = currentSteps;
      previousCalories = currentCalories;
      previousUnknown3 = currentUnknown3;
      debugPrint('   📊 MOVEMENT: Initialized (assume awake)');
      return 1; // Assume awake at startup
    }

    // Detect if any value changed (raw binary)
    final rawMovement = (currentSteps != previousSteps ||
            currentCalories != previousCalories ||
            currentUnknown3 != previousUnknown3)
        ? 1
        : 0;

    // Apply smoothing filter (mode window of 20 readings ~100 seconds)
    final smoothed = _movementFilter.apply(rawMovement);

    // Debug log when movement state changes
    final previousSmoothed = _movementFilter._buffer.length >= 2
        ? (_movementFilter._buffer[_movementFilter._buffer.length - 2])
        : smoothed;

    if (smoothed != previousSmoothed || rawMovement == 1) {
      final deltaSteps = currentSteps - (previousSteps ?? 0);
      final deltaCal = currentCalories - (previousCalories ?? 0);
      final deltaUnk3 = currentUnknown3 - (previousUnknown3 ?? 0);

      debugPrint(
        '   📊 MOVEMENT: raw=$rawMovement → smoothed=$smoothed '
        '| window=${_movementFilter._buffer.length}/20 '
        '| Δsteps=$deltaSteps Δcal=$deltaCal Δunk3=$deltaUnk3',
      );
    }

    // Save current values for next comparison
    previousSteps = currentSteps;
    previousCalories = currentCalories;
    previousUnknown3 = currentUnknown3;

    return smoothed;
  }

  /// Calculate HRV from HR history (Heart Rate Variability)
  ///
  /// HRV = standard deviation of RR intervals (time between beats)
  /// Approximation from equally-sampled HR values
  /// Calibrated from real overnight data (6+ hours):
  /// - Low HRV (<10) = deep sleep, parasympathetic dominant (observed 8-13ms)
  /// - Medium HRV (10-20) = light sleep, stable (observed 13-20ms during real sleep)
  /// - Transition zone (20-30) = relaxation/awake calm, avoid false positives (observed 10-16ms when awake but still)
  /// - High HRV (>30) = REM/active dreaming, sympathetic active (observed 25-90ms during actual REM)
  ///
  /// NOTE: Sleep phase classification thresholds have been moved to
  /// dream_incubator's SleepStateClassifier for application-specific logic

  double calculateHRV(int currentHR) {
    // Add current HR to history
    _hrHistory.add(currentHR);

    // Keep only last 120 samples (~2 minutes)
    if (_hrHistory.length > _maxHrHistorySize) {
      _hrHistory.removeAt(0);
    }

    // Need at least 10 samples to calculate meaningful HRV
    if (_hrHistory.length < 10) {
      return 0.0;
    }

    // Calculate RR intervals (simplified: 60000 / HR in milliseconds)
    final rrIntervals = <double>[];
    for (final hr in _hrHistory) {
      if (hr > 0) {
        final rrInterval = 60000.0 / hr; // Convert BPM to RR interval (ms)
        rrIntervals.add(rrInterval);
      }
    }

    if (rrIntervals.length < 2) {
      return 0.0;
    }

    // Calculate mean RR interval
    final meanRR = rrIntervals.reduce((a, b) => a + b) / rrIntervals.length;

    // Calculate standard deviation (SDNN - HRV metric)
    final variance = rrIntervals
            .map((rr) => (rr - meanRR) * (rr - meanRR))
            .reduce((a, b) => a + b) /
        rrIntervals.length;

    final hrv = (variance >= 0) ? sqrt(variance) : 0.0;

    return hrv;
  }

  /// Get HR history for trend analysis
  List<int> getHRHistory() => List.unmodifiable(_hrHistory);

  /// Clear HRV history (e.g., when session ends)
  void clearHRHistory() => _hrHistory.clear();
}

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
      debugPrint(
        '   🔍 XiaomiSppRealtimeStatsParser: Attempting to parse ${bytes.length} bytes',
      );

      // 1. Parse protobuf Command
      // Some devices sometimes deliver the protobuf payload embedded inside
      // an activity/data packet with a small header. Try direct parse first,
      // then attempt to find an embedded protobuf by scanning small offsets.
      pb.Command command;
      try {
        command = pb.Command.fromBuffer(Uint8List.fromList(bytes));
      } catch (e) {
        // Attempt to locate embedded protobuf by scanning offsets up to 32 bytes
        bool parsed = false;
        command = pb.Command();
        final maxScan = bytes.length < 32 ? bytes.length : 32;
        for (int offset = 1; offset < maxScan; offset++) {
          try {
            final slice = Uint8List.fromList(bytes.sublist(offset));
            final candidate = pb.Command.fromBuffer(slice);
            // Validate it's a sensible command
            if (candidate.type >= 0 && candidate.type <= 15) {
              command = candidate;
              parsed = true;
              break;
            }
          } on Exception {
            // continue scanning
          }
        }

        if (!parsed) {
          // Rethrow original error to be handled by outer catch
          rethrow;
        }
      }

      // 2. Validate command type (Health service, realtime event)
      if (command.type != 8 || command.subtype != 47) {
        // Not a realtime stats event
        return null;
      }

      // 3. Extract RealTimeStats
      if (!command.hasHealth()) {
        return null;
      }

      if (!command.health.hasRealTimeStats()) {
        return null;
      }

      final stats = command.health.realTimeStats;

      // ✨ DEBUG: Print raw protobuf data (single line for easier grepping)
      if (stats.heartRate > 0 || stats.unknown3 > 0 || stats.steps > 0) {
        debugPrint(
          '   🔍 DEBUG: Raw RealTimeStats: HR=${stats.heartRate}(0x${stats.heartRate.toRadixString(16)}) unknown3=${stats.unknown3}(0x${stats.unknown3.toRadixString(16)}) steps=${stats.steps}(0x${stats.steps.toRadixString(16)}) calories=${stats.calories}(0x${stats.calories.toRadixString(16)}) unknown5=${stats.unknown5}(0x${stats.unknown5.toRadixString(16)}) standingHours=${stats.standingHours}(0x${stats.standingHours.toRadixString(16)})',
        );
      }

      final timestamp = DateTime.now();
      final samples = <BiometricSample>[];

      // ✨ NEW: Calculate HRV and detect movement (for all samples)
      final tracker = _RealtimeStatsTracker();
      double hrv = 0.0;
      int movementBinary = 0;

      // Only calculate HRV for physiologically valid HR values
      if (stats.hasHeartRate() &&
          isValidHeartRate(stats.heartRate.toDouble())) {
        hrv = tracker.calculateHRV(stats.heartRate);
      }

      if (stats.hasSteps() || stats.hasCalories() || stats.hasUnknown3()) {
        movementBinary = tracker.detectMovementChange(
          currentSteps: stats.steps,
          currentCalories: stats.calories,
          currentUnknown3: stats.unknown3,
        );
      }

      // 4. Parse Heart Rate (most critical for lucid dreaming)
      // Only include physiologically valid HR values (40-220 BPM)
      if (stats.hasHeartRate() &&
          isValidHeartRate(stats.heartRate.toDouble())) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.heartRate.toDouble(),
            sensorType: SensorType.heartRate,
            metadata: {
              'unit': 'bpm',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'valid': true, // Already validated above
            },
          ),
        );

        // ✨ NEW: Add HRV sample
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: hrv,
            sensorType: SensorType.heartRateVariability,
            metadata: {
              'unit': 'ms',
              'source': 'xiaomi_spp_hrv_calculation',
              'transport': 'bt_classic',
              'data_type_name': 'hrv_sdnn',
              'note':
                  'Standard deviation of RR intervals (calculated from HR history)',
              'raw_hrv_value': hrv,
            },
          ),
        );
      }

      // ✨ NEW: Add binary movement detection (only if there's actually movement data)
      if (stats.hasSteps() || stats.hasCalories() || stats.hasUnknown3()) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: movementBinary.toDouble(),
            sensorType: SensorType.movementDetected,
            metadata: {
              'unit': 'binary',
              'source': 'xiaomi_spp_movement_detector',
              'transport': 'bt_classic',
              'data_type_name': 'movement_detected',
              'note':
                  '1=movement detected (steps|calories|unknown3 changed), 0=no movement',
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
        debugPrint(
          '   ✅ Adding Standing Hours: ${stats.standingHours}',
        );
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

      // 9. Parse unknown5 (probably moving time or time counter)
      // Gadgetbridge: "0 probably moving time"
      // This field needs investigation - logging for data collection
      if (stats.hasUnknown5()) {
        samples.add(
          BiometricSample(
            timestamp: timestamp,
            value: stats.unknown5.toDouble(),
            sensorType: SensorType.unknown,
            metadata: {
              'unit': 'unknown',
              'source': 'xiaomi_spp_realtime',
              'transport': 'bt_classic',
              'data_type_name': 'unknown5_investigation',
              'note':
                  'Gadgetbridge says: "0 probably moving time" - needs investigation',
            },
          ),
        );
      }

      // 10. Return null if no valid samples
      if (samples.isEmpty) {
        return null;
      }

      debugPrint(
        '   ✅ Successfully parsed ${samples.length} samples',
      );
      return samples;
    } on Exception {
      // Invalid protobuf or parsing error
      // debugPrint(
      //   '   ❌ XiaomiSppRealtimeStatsParser caught exception: $e',
      // );
      // debugPrint(
      //   '   📋 Payload (hex): ${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      // );
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
