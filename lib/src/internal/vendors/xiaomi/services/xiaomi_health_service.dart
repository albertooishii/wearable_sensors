import 'package:flutter/foundation.dart';

import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/handler.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/packet.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_spp_service.dart';

/// 🏥 Xiaomi Health Service
///
/// Handles all health-related monitoring commands:
/// - Heart rate realtime streaming (START/STOP)
/// - SPO2 monitoring
/// - Stress monitoring
/// - Sleep monitoring
///
/// **Architecture:**
/// This service is responsible for health-specific command logic AFTER
/// authentication is complete. It does NOT handle authentication itself,
/// only post-auth health operations.
///
/// **Based on Gadgetbridge XiaomiHealthService.java**
class XiaomiHealthService {
  // Command type for health operations
  static const int _healthCommandType = 8;

  // Health command subtypes (from Gadgetbridge XiaomiHealthService)
  static const int _cmdRealtimeStatsStart = 45;
  static const int _cmdRealtimeStatsStop = 46;

  final String deviceId;
  final XiaomiSppService? sppService;
  final SppV2ProtocolHandler? sppV2Handler;

  /// Flags for realtime stats management (from Gadgetbridge)
  bool _realtimeStarted = false;

  XiaomiHealthService({
    required this.deviceId,
    this.sppService,
    this.sppV2Handler,
  });

  /// 🎯 START REALTIME STATS - Critical for heart rate data!
  ///
  /// **THIS IS THE KEY COMMAND:** Tells device to BEGIN streaming sensor data
  /// at ~1Hz (subtype=47 events).
  ///
  /// **Without this command:**
  /// ❌ Device is configured but NEVER sends realtime events
  /// ❌ "Waiting for data..." timeout forever
  ///
  /// **With this command:**
  /// ✅ Device begins sending subtype=47 events
  /// ✅ Heart rate data flows to UI
  ///
  /// **Based on Gadgetbridge's XiaomiHealthService.enableRealtimeStats(true)**
  Future<void> startRealtimeStats() async {
    debugPrint('   🎯 STARTING REALTIME STATS (type=8, subtype=45)...');
    debugPrint('   📝 This tells device to BEGIN streaming sensor data!');

    _realtimeStarted = true;

    try {
      final command = pb.Command()
        ..type = _healthCommandType // 8 = Health command type
        ..subtype = _cmdRealtimeStatsStart; // 45 = START (NOT 11!)

      // Send via appropriate transport (BLE handler or BT_CLASSIC service)
      if (sppV2Handler != null) {
        // Path 1: BLE auth flow - use SPP V2 handler (encrypted)
        debugPrint('   📤 Sending START_REALTIME_STATS (BLE, encrypted)');
        final payload = command.writeToBuffer();
        await sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.protobufCommand,
          payload: payload,
          encrypted: true,
        );
        debugPrint(
          '   ✅ REALTIME STATS STARTED - Device should now stream data!',
        );
      } else if (sppService != null) {
        // Path 2: Bonded device flow (BT_CLASSIC) - use SppService
        debugPrint('   📤 Sending START_REALTIME_STATS (BT_CLASSIC)');
        await sppService!.sendProtobufCommand(command: command);
        debugPrint(
          '   ✅ REALTIME STATS STARTED - Device should now stream data!',
        );
      } else {
        debugPrint('   ⚠️ No transport available, cannot start realtime stats');
      }
    } catch (e) {
      debugPrint('   ⚠️ Failed to start realtime stats: $e');
      _realtimeStarted = false;
      rethrow;
    }
  }

  /// Stop realtime stats streaming
  ///
  /// Tells device to STOP sending subtype=47 events (saves battery).
  ///
  /// **Based on Gadgetbridge's XiaomiHealthService.enableRealtimeStats(false)**
  Future<void> stopRealtimeStats() async {
    debugPrint('   🛑 STOPPING REALTIME STATS (type=8, subtype=46)...');

    _realtimeStarted = false;

    try {
      final command = pb.Command()
        ..type = _healthCommandType
        ..subtype = _cmdRealtimeStatsStop; // 46 = STOP

      if (sppV2Handler != null) {
        debugPrint('   📤 Sending STOP_REALTIME_STATS (BLE)');
        final payload = command.writeToBuffer();
        await sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.protobufCommand,
          payload: payload,
          encrypted: true,
        );
        debugPrint('   ✅ REALTIME STATS STOPPED');
      } else if (sppService != null) {
        debugPrint('   📤 Sending STOP_REALTIME_STATS (BT_CLASSIC)');
        await sppService!.sendProtobufCommand(command: command);
        debugPrint('   ✅ REALTIME STATS STOPPED');
      } else {
        debugPrint('   ⚠️ No transport available, cannot stop realtime stats');
      }
    } catch (e) {
      debugPrint('   ⚠️ Failed to stop realtime stats: $e');
      rethrow;
    }
  }

  /// Get realtime stats streaming status
  bool isRealtimeStatsActive() => _realtimeStarted;

  /// Dispose resources
  void dispose() {
    _realtimeStarted = false;
  }
}
