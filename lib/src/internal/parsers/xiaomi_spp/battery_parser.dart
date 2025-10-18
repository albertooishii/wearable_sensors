/// Xiaomi SPP Protobuf Battery Parser
///
/// Parses battery data from SPP V2 encrypted Command responses (Mi Band 9/10).
/// Uses protobuf Command structure (type=2, subtype=1) via BT_CLASSIC.
///
/// Data format (protobuf):
/// ```
/// Command {
///   type: 2 (SYSTEM)
///   subtype: 1 (BATTERY)
///   system {
///     power {
///       battery {
///         level: 0-100  // ✅ Battery percentage
///         status: 1=charging, 2=not_charging
///       }
///     }
///   }
/// }
/// ```
///
/// Transport: BT_CLASSIC SPP (Serial Port Profile)
/// Encryption: AES-CTR (V2 protocol)
/// Polling interval: Every 5 minutes during monitoring
///
/// Reference: Gadgetbridge XiaomiBatteryInfo, xiaomi.proto
library;

import 'dart:typed_data';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';

/// Xiaomi SPP Protobuf Battery Parser
///
/// Parses battery data from encrypted SPP Command responses.
/// Integrates with ParserRegistry architecture.
class XiaomiSppBatteryParser {
  /// Parse SPP protobuf battery data
  ///
  /// Input: Protobuf-encoded Command bytes (decrypted)
  /// Output: BiometricSample with battery percentage (0-100)
  ///
  /// Returns null if:
  /// - Data is invalid/malformed
  /// - Command doesn't contain battery info
  /// - Protobuf parsing fails
  static BiometricSample? parse(final List<int> bytes) {
    if (bytes.isEmpty) return null;

    try {
      // 1. Parse protobuf Command from bytes
      final command = pb.Command.fromBuffer(Uint8List.fromList(bytes));

      // 2. Extract battery level using existing protobuf parser
      final batteryLevel = parseBatteryFromCommand(command);

      if (batteryLevel == null) {
        return null; // Battery data not available in Command
      }

      // 3. Extract charging status (if available)
      String? chargingStatus;
      if (command.hasSystem() &&
          command.system.hasPower() &&
          command.system.power.hasBattery()) {
        final battery = command.system.power.battery;
        if (battery.hasState()) {
          // state: 1=charging, 2=not_charging, 3=full
          chargingStatus = battery.state == 1
              ? 'charging'
              : battery.state == 3
                  ? 'full'
                  : 'not_charging';
        }
      }

      // 4. Convert to BiometricSample (ParserRegistry format)
      return BiometricSample(
        timestamp: DateTime.now(),
        value: batteryLevel.toDouble(), // 0-100
        sensorType: SensorType.battery,
        metadata: {
          'unit': 'percentage',
          'source': 'xiaomi_spp_protobuf',
          'transport': 'bt_classic',
          if (chargingStatus != null) 'charging_status': chargingStatus,
        },
      );
    } on Exception {
      return null; // Protobuf parsing failed
    }
  }

  /// Classify battery health based on level
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
