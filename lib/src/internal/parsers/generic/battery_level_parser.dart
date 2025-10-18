import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';

/// Generic BLE Battery Level Parser (0x2A19)
///
/// Implements standard Bluetooth SIG Battery Service specification.
/// Compatible with ALL BLE devices (Polar, Fitbit, Garmin, Xiaomi, etc).
///
/// Specification:
/// - Single uint8 value (0-100) representing battery percentage
///
/// References:
/// - BLE GATT: Battery Service (0x180F)
/// - Characteristic: Battery Level (0x2A19)
/// - Bluetooth SIG specification
class GenericBatteryLevelParser {
  /// Parse standard BLE Battery Level data
  ///
  /// Returns [BiometricSample] with:
  /// - value: Battery percentage (0-100)
  /// - metadata.unit: 'percentage'
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty) return null;

    try {
      // Byte 0: Battery percentage (0-100)
      final batteryPercentage = bytes[0];

      // Validate range
      if (batteryPercentage > 100) {
        return null; // Invalid value
      }

      return BiometricSample(
        timestamp: DateTime.now(),
        value: batteryPercentage.toDouble(),
        sensorType: SensorType.battery,
        metadata: {'unit': 'percentage', 'source': 'generic_ble'},
      );
    } on Exception {
      return null;
    }
  }

  /// Classify battery level
  ///
  /// Returns: 'critical', 'low', 'medium', 'high', 'full'
  static String classifyBatteryLevel(final double percentage) {
    if (percentage <= 5) return 'critical';
    if (percentage <= 20) return 'low';
    if (percentage <= 50) return 'medium';
    if (percentage < 100) return 'high';
    return 'full';
  }

  /// Check if battery is low (≤20%)
  static bool isLowBattery(final double percentage) => percentage <= 20.0;

  /// Check if battery is critical (≤5%)
  static bool isCriticalBattery(final double percentage) => percentage <= 5.0;
}
