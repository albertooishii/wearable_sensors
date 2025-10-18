/// Xiaomi Real-time Steps Parser
///
/// Parses real-time step counter from Xiaomi devices (characteristic 0x0007).
/// Single uint32 value representing total steps since last device reset.
///
/// Data format:
/// - Bytes 0-3: Total steps (little-endian uint32)
///
/// Update frequency: 1-5 seconds when device detects movement.
///
/// Reference: Gadgetbridge XiaomiRealtimeSteps
library;

import 'dart:typed_data';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';

class XiaomiRealtimeStepsParser {
  static int? _previousSteps;
  static DateTime? _previousTimestamp;

  /// Parse Xiaomi real-time step counter
  ///
  /// Returns BiometricSample with steps taken since last reading
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty || bytes.length < 4) {
      return null; // Invalid data
    }

    try {
      final buffer = ByteData.sublistView(Uint8List.fromList(bytes));
      final totalSteps = buffer.getUint32(0, Endian.little);
      final now = DateTime.now();

      // Calculate delta steps since last reading
      int deltaSteps;
      double? stepsPerMinute;

      if (_previousSteps != null && _previousTimestamp != null) {
        deltaSteps = totalSteps - _previousSteps!;

        // Calculate steps per minute (activity intensity metric)
        final elapsedSeconds = now.difference(_previousTimestamp!).inSeconds;
        if (elapsedSeconds > 0) {
          stepsPerMinute = (deltaSteps / elapsedSeconds) * 60.0;
        }
      } else {
        deltaSteps = totalSteps;
      }

      // Update previous values for next reading
      _previousSteps = totalSteps;
      _previousTimestamp = now;

      // Normalize to 0.0-1.0 range (assuming max ~200 steps/minute = vigorous activity)
      final normalizedIntensity =
          (stepsPerMinute ?? 0.0).clamp(0.0, 200.0) / 200.0;

      return BiometricSample(
        timestamp: now,
        value: normalizedIntensity,
        sensorType: SensorType.movement,
        metadata: {
          'total_steps': totalSteps,
          'delta_steps': deltaSteps,
          'steps_per_minute': stepsPerMinute,
          'source': 'xiaomi_realtime_steps',
        },
      );
    } on Exception {
      return null; // Parsing failed
    }
  }

  /// Reset the step counter baseline
  ///
  /// Call this when starting a new session or when device resets
  static void reset() {
    _previousSteps = null;
    _previousTimestamp = null;
  }

  /// Get total accumulated steps
  static int? get totalSteps => _previousSteps;
}
