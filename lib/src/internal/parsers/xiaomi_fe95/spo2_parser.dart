/// Xiaomi Activity File SpO2 Parser
///
/// Parses SpO2 samples from Xiaomi activity files (characteristic 0x0005).
/// Binary format containing timestamp, SpO2 percentage, and pulse rate.
///
/// Data format (based on Gadgetbridge reverse engineering):
/// - Bytes 0-3: Timestamp (Unix epoch, little-endian uint32)
/// - Byte 4: SpO2 percentage (0-100, 255=invalid)
/// - Byte 5: Pulse rate (BPM)
///
/// Polling interval: 60-300 seconds if all-day monitoring enabled.
/// Requires authentication via FE95 encrypted service.
///
/// ⚠️ NOT IMPLEMENTED YET - Future use only
///
/// Reference: Gadgetbridge XiaomiSpo2SampleProvider
library;

import 'dart:typed_data';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';

class XiaomiSpo2Parser {
  /// Parse Xiaomi SpO2 sample from activity file
  ///
  /// Returns BiometricSample with SpO2 percentage (0-100)
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty || bytes.length < 6) {
      return null; // Invalid data
    }

    try {
      final buffer = ByteData.sublistView(Uint8List.fromList(bytes));

      // Parse timestamp (bytes 0-3, little-endian)
      final timestamp = buffer.getUint32(0, Endian.little);

      // Parse SpO2 (byte 4, 0-100 or 255=invalid)
      final spo2 = bytes[4];
      if (spo2 == 255) {
        return null; // Invalid measurement
      }

      // Parse pulse rate (byte 5)
      final pulseRate = bytes[5];

      return BiometricSample(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
        value: spo2.toDouble(),
        sensorType: SensorType.bloodOxygen,
        metadata: {
          'pulse_rate': pulseRate,
          'source': 'xiaomi_spo2',
          'all_day_monitoring': true,
        },
      );
    } on Exception {
      return null; // Parsing failed
    }
  }

  /// Classify SpO2 level
  ///
  /// Returns: 'normal', 'low', 'critical'
  ///
  /// Clinical guidelines:
  /// - Normal: 95-100%
  /// - Low: 90-94% (mild hypoxemia)
  /// - Critical: <90% (severe hypoxemia, requires medical attention)
  static String classifySpo2Level(final double spo2) {
    if (spo2 >= 95.0) return 'normal';
    if (spo2 >= 90.0) return 'low';
    return 'critical';
  }

  /// Check if SpO2 value is clinically valid
  ///
  /// Valid range: 70-100% (values <70% are physiologically unlikely)
  static bool isValidSpo2(final double spo2) {
    return spo2 >= 70.0 && spo2 <= 100.0;
  }
}
