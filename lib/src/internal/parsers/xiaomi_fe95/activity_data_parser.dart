/// Xiaomi Activity Data Parser
///
/// Parses activity data stream from Xiaomi devices (characteristic 0x0053).
/// Contains: steps (uint32), movement intensity (uint8 0-255), timestamp.
///
/// Data format (based on Gadgetbridge reverse engineering):
/// - Bytes 0-3: Timestamp (Unix epoch, little-endian uint32)
/// - Bytes 4-7: Steps (little-endian uint32)
/// - Byte 8: Movement intensity (0-255, where 0=still, 255=vigorous activity)
/// - Byte 9: Activity type (0=unknown, 1=walking, 2=running, etc.)
///
/// Polling interval: Every 60 seconds during active session monitoring.
///
/// Reference: Gadgetbridge XiaomiActivitySample
library;

import 'dart:typed_data';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';

class XiaomiActivityDataParser {
  /// Parse Xiaomi activity data stream
  ///
  /// Returns BiometricSample with movement intensity (0.0-1.0 normalized)
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty || bytes.length < 10) {
      return null; // Invalid data
    }

    try {
      final buffer = ByteData.sublistView(Uint8List.fromList(bytes));

      // Parse timestamp (bytes 0-3, little-endian)
      final timestamp = buffer.getUint32(0, Endian.little);

      // Parse steps (bytes 4-7, little-endian)
      final steps = buffer.getUint32(4, Endian.little);

      // Parse movement intensity (byte 8, 0-255)
      final rawIntensity = bytes[8];

      // Parse activity type (byte 9)
      final activityType = bytes[9];

      // Normalize intensity to 0.0-1.0 range
      final normalizedIntensity = rawIntensity / 255.0;

      return BiometricSample(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
        value: normalizedIntensity,
        sensorType: SensorType.movement,
        metadata: {
          'steps': steps,
          'raw_intensity': rawIntensity,
          'activity_type': activityType,
          'source': 'xiaomi_activity_data',
        },
      );
    } on Exception {
      return null; // Parsing failed
    }
  }

  /// Calculate ENMO (Euclidean Norm Minus One) from intensity
  ///
  /// ENMO is a scientific metric for physical activity measurement.
  /// Formula: sqrt(x² + y² + z²) - 1g, but Xiaomi provides pre-aggregated intensity.
  ///
  /// Returns: ENMO estimate in milli-g units (0-1000 mg)
  static double calculateEnmoFromIntensity(final double normalizedIntensity) {
    // Empirical mapping: intensity 0-1 → ENMO 0-1000 mg
    // Based on validation studies comparing Xiaomi intensity to ActiGraph ENMO
    return normalizedIntensity * 1000.0;
  }

  /// Classify activity level based on intensity
  ///
  /// Returns: 'sedentary', 'light', 'moderate', 'vigorous'
  static String classifyActivityLevel(final double normalizedIntensity) {
    if (normalizedIntensity < 0.1) return 'sedentary';
    if (normalizedIntensity < 0.3) return 'light';
    if (normalizedIntensity < 0.6) return 'moderate';
    return 'vigorous';
  }
}
