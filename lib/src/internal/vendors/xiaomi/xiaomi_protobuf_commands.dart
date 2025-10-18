// Copyright (c) 2025 Alberto Oishii
// SPDX-License-Identifier: MPL-2.0
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at http://mozilla.org/MPL/2.0/.

// 📦 Xiaomi Protobuf Commands - Dream Incubator
// Helper functions to create Xiaomi protobuf commands

import 'dart:typed_data';
import '../../models/generated/xiaomi.pb.dart';

/// Xiaomi Command Types (from Gadgetbridge)
class XiaomiCommandType {
  /// System commands (battery, device info, clock, etc.)
  static const int system = 2;

  /// Health commands (heart rate, steps, sleep, etc.)
  static const int health = 8; // ✅ FIXED: Was 10, should be 8
}

/// Xiaomi System Command Subtypes
class XiaomiSystemCommand {
  /// Request battery level
  static const int battery = 1;

  /// Request device info
  static const int deviceInfo = 2;

  /// Request device state
  static const int deviceState = 3;
}

/// Xiaomi Health Command Subtypes (from Gadgetbridge)
class XiaomiHealthCommand {
  /// Request battery info (Health service also has battery)
  static const int batteryInfo = 1;

  /// Get heart rate monitoring config
  static const int heartRateConfigGet = 10;

  /// Set heart rate monitoring config
  static const int heartRateConfigSet = 11;

  /// Start realtime stats streaming (HR, steps, movement, calories)
  static const int realtimeStatsStart = 45;

  /// Stop realtime stats streaming
  static const int realtimeStatsStop = 46;

  /// Realtime stats event (periodic updates from device)
  static const int realtimeStatsEvent = 47;
}

/// Create a battery request command
///
/// Sends a request to the device to get current battery level.
/// Device will respond with a Command message containing Battery data.
///
/// **Protocol (based on Gadgetbridge reverse engineering):**
/// ```
/// Request:  Command { type: 2, subtype: 1 }  // 4 bytes: 08021001
/// Response: Command { type: 2, subtype: 1, system: { power: { battery: { level: 85 } } } }
/// ```
///
/// **CRITICAL:** Device ONLY accepts minimal request (no system field).
/// Sending extra fields causes device to ACK but NOT respond with data.
Command createBatteryRequest() {
  return Command(
    type: XiaomiCommandType.system,
    subtype: XiaomiSystemCommand.battery,
    // ❌ DO NOT add system.power field - device rejects it!
  );
}

/// Parse battery level from Command response
///
/// **Returns:** Battery level (0-100) or null if not available
int? parseBatteryFromCommand(final Command command) {
  if (!command.hasSystem()) {
    return null;
  }

  final system = command.system;
  if (!system.hasPower()) {
    return null;
  }

  final power = system.power;
  if (!power.hasBattery()) {
    return null;
  }

  final battery = power.battery;
  if (!battery.hasLevel()) {
    return null;
  }

  return battery.level;
}

/// Encode a Command to bytes for transmission
Uint8List encodeCommand(final Command command) {
  return Uint8List.fromList(command.writeToBuffer());
}

/// Decode bytes to Command
Command decodeCommand(final Uint8List bytes) {
  return Command.fromBuffer(bytes);
}

// ============================================================================
// 🫀 HEALTH SERVICE COMMANDS (Realtime Stats)
// ============================================================================

/// Enable realtime stats streaming
///
/// Starts periodic transmission of realtime statistics from the device:
/// - Heart rate (BPM)
/// - Steps (cumulative)
/// - Movement intensity (activity proxy)
/// - Calories burned
/// - Standing hours
///
/// **Protocol (from Gadgetbridge):**
/// ```
/// Request:  Command { type: 8, subtype: 45 }  // Start streaming
/// Response: Periodic Command { type: 8, subtype: 47, health: { realTimeStats: {...} } }
/// ```
///
/// **Frequency:** ~1 event/second when active
///
/// **Battery Impact:** Moderate - only enable during active sleep sessions
///
/// **Usage:**
/// ```dart
/// final cmd = createRealtimeStatsStartRequest();
/// await sppService.sendCommand(deviceId, encodeCommand(cmd));
///
/// // Listen for events (subtype 47)
/// sppService.dataStream.listen((bytes) {
///   final samples = XiaomiSppRealtimeStatsParser.parse(bytes);
///   // Process HR, movement, steps, etc.
/// });
/// ```
Command createRealtimeStatsStartRequest() {
  return Command(
    type: XiaomiCommandType.health,
    subtype: XiaomiHealthCommand.realtimeStatsStart,
    // No additional fields needed
  );
}

/// Disable realtime stats streaming
///
/// Stops periodic transmission of realtime statistics.
/// Always call this when stopping a sleep session to save battery.
///
/// **Protocol:**
/// ```
/// Request:  Command { type: 8, subtype: 46 }  // Stop streaming
/// Response: Device stops sending subtype 47 events
/// ```
///
/// **Usage:**
/// ```dart
/// final cmd = createRealtimeStatsStopRequest();
/// await sppService.sendCommand(deviceId, encodeCommand(cmd));
/// ```
Command createRealtimeStatsStopRequest() {
  return Command(
    type: XiaomiCommandType.health,
    subtype: XiaomiHealthCommand.realtimeStatsStop,
    // No additional fields needed
  );
}

/// One-shot heart rate measurement
///
/// Triggers a single heart rate measurement. This is the same as starting
/// realtime stats, but the caller should auto-stop after receiving the first
/// valid HR reading (>10 BPM).
///
/// **Pattern (from Gadgetbridge):**
/// 1. Send start command
/// 2. Wait for first HR event with heartRate > 10
/// 3. Send stop command
/// 4. Timeout after 30 seconds if no valid HR
///
/// **Usage:**
/// ```dart
/// final cmd = createHeartRateTestRequest();
/// await sppService.sendCommand(deviceId, encodeCommand(cmd));
///
/// // Wait for first valid HR
/// final sample = await dataStream
///     .where((s) => s.dataType == 'heart_rate' && s.value > 10)
///     .first
///     .timeout(Duration(seconds: 30));
///
/// // Auto-stop
/// await sppService.sendCommand(deviceId, encodeCommand(createRealtimeStatsStopRequest()));
/// ```
Command createHeartRateTestRequest() {
  // Same as realtime start, but caller logic handles one-shot behavior
  return createRealtimeStatsStartRequest();
}

/// Enable heart rate monitoring configuration
///
/// **CRITICAL:** Must be called BEFORE using realtime stats.
/// Xiaomi devices require heart rate monitoring to be enabled before
/// they will respond to realtime stats requests.
///
/// **Protocol (from Gadgetbridge reverse engineering):**
/// ```
/// Request:  Command {
///   type: 8,
///   subtype: 11,
///   health: {
///     heartRate: {
///       disabled: false,
///       interval: 1,  // 1 minute intervals (minimum)
///       advancedMonitoring: { enabled: false },
///       breathingScore: 2,
///       alarmHighEnabled: false,
///       alarmHighThreshold: 0,
///       heartRateAlarmLow: {
///         alarmLowEnabled: false,
///         alarmLowThreshold: 0
///       },
///       unknown7: 1
///     }
///   }
/// }
/// ```
///
/// **Usage:**
/// ```dart
/// // 1. Enable heart rate monitoring (REQUIRED FIRST)
/// await sppService.sendCommand(deviceId, createEnableHeartRateMonitoringRequest());
///
/// // 2. Wait 1-2 seconds for device to process
/// await Future.delayed(Duration(seconds: 2));
///
/// // 3. Now realtime stats will work
/// await sppService.sendCommand(deviceId, createRealtimeStatsStartRequest());
/// ```
Command createEnableHeartRateMonitoringRequest() {
  return Command(
    type: XiaomiCommandType.health,
    subtype: XiaomiHealthCommand.heartRateConfigSet,
    health: Health(
      heartRate: HeartRate(
        disabled: false,
        interval: 0, // 0 = Smart/continuous mode (required for realtime stats)
        advancedMonitoring: AdvancedMonitoring(enabled: false),
        breathingScore: 2, // Disabled (1 = enabled, 2 = disabled)
        alarmHighEnabled: false,
        alarmHighThreshold: 0,
        heartRateAlarmLow: HeartRateAlarmLow(
          alarmLowEnabled: false,
          alarmLowThreshold: 0,
        ),
        unknown7: 1, // Always 1 (from Gadgetbridge)
      ),
    ),
  );
}

/// Get current heart rate monitoring configuration
///
/// Query the device for current HR monitoring settings.
///
/// **Protocol:**
/// ```
/// Request:  Command { type: 8, subtype: 10 }
/// Response: Command { type: 8, subtype: 10, health: { heartRate: {...} } }
/// ```
Command createGetHeartRateConfigRequest() {
  return Command(
    type: XiaomiCommandType.health,
    subtype: XiaomiHealthCommand.heartRateConfigGet,
  );
}

/// Check if a Command is a realtime stats event
///
/// Returns true if this is a periodic update from the device.
///
/// **Usage:**
/// ```dart
/// final command = decodeCommand(bytes);
/// if (isRealtimeStatsEvent(command)) {
///   final samples = XiaomiSppRealtimeStatsParser.parse(bytes);
/// }
/// ```
bool isRealtimeStatsEvent(final Command command) {
  return command.type == XiaomiCommandType.health &&
      command.subtype == XiaomiHealthCommand.realtimeStatsEvent;
}
