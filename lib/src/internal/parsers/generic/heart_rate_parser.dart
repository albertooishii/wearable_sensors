import 'dart:typed_data';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';

/// Generic BLE Heart Rate Measurement Parser (0x2A37)
///
/// Implements standard Bluetooth SIG Heart Rate Service specification.
/// Compatible with ALL BLE devices (Polar, Fitbit, Garmin, Xiaomi, etc).
///
/// Specification:
/// - Flags byte (uint8) - format and sensor contact info
/// - Heart Rate Value (uint8 or uint16) - beats per minute
/// - Optional: RR Intervals (uint16 array) - milliseconds between beats
///
/// References:
/// - BLE GATT: Heart Rate Service (0x180D)
/// - Characteristic: Heart Rate Measurement (0x2A37)
/// - Bluetooth SIG specification
class GenericHeartRateParser {
  /// Parse standard BLE Heart Rate Measurement data
  ///
  /// Returns [BiometricSample] with:
  /// - value: Heart rate in BPM
  /// - metadata.sensor_contact: true if skin contact detected
  /// - metadata.rr_intervals: List of RR intervals if available
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty) return null;

    try {
      final buffer = ByteData.sublistView(Uint8List.fromList(bytes));

      // Byte 0: Flags
      final flags = bytes[0];

      // Bit 0: Heart Rate Value Format (0 = uint8, 1 = uint16)
      final hrFormat = (flags & 0x01) == 0 ? 'uint8' : 'uint16';

      // Bits 1-2: Sensor Contact Status
      // 00/01 = Not supported/detected, 10/11 = Supported, not detected/detected
      final sensorContact = (flags & 0x06) >> 1;
      final hasSensorContact = sensorContact == 3;

      // Bit 3: Energy Expended Status (not used in this parser)
      // Bit 4: RR-Interval bit
      final hasRRIntervals = (flags & 0x10) != 0;

      // Parse Heart Rate Value
      int heartRate;
      int offset;

      if (hrFormat == 'uint8') {
        heartRate = bytes[1];
        offset = 2;
      } else {
        heartRate = buffer.getUint16(1, Endian.little);
        offset = 3;
      }

      // Validate heart rate range (clinical: 30-220 BPM)
      if (heartRate < 30 || heartRate > 250) {
        return null; // Invalid reading
      }

      // Parse optional RR-Intervals
      final rrIntervals = <int>[];
      if (hasRRIntervals && offset < bytes.length) {
        while (offset + 1 < bytes.length) {
          final rrInterval = buffer.getUint16(offset, Endian.little);
          rrIntervals.add(rrInterval);
          offset += 2;
        }
      }

      return BiometricSample(
        timestamp: DateTime.now(),
        value: heartRate.toDouble(),
        sensorType: SensorType.heartRate,
        metadata: {
          'sensor_contact': hasSensorContact,
          'rr_intervals': rrIntervals.isNotEmpty ? rrIntervals : null,
          'format': hrFormat,
          'source': 'generic_ble',
        },
      );
    } on Exception {
      return null;
    }
  }

  /// Validate heart rate value is within physiological range
  static bool isValidHeartRate(final double hr) {
    return hr >= 30.0 && hr <= 250.0;
  }

  /// Calculate average RR interval from list (milliseconds)
  static double? averageRRInterval(final List<int>? rrIntervals) {
    if (rrIntervals == null || rrIntervals.isEmpty) return null;
    return rrIntervals.reduce((final a, final b) => a + b) / rrIntervals.length;
  }

  /// Convert RR intervals to heart rate (BPM)
  static double? rrIntervalToHeartRate(final double rrMs) {
    if (rrMs <= 0) return null;
    return 60000.0 / rrMs; // 60000 ms per minute
  }
}
