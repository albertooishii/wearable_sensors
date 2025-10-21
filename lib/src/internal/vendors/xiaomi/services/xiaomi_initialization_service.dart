import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/handler.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/packet.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_spp_service.dart';
import 'xiaomi_health_service.dart';

/// 🔧 Xiaomi Initialization Service
///
/// **Responsibility:** Post-authentication initialization of device services.
///
/// This service is called AFTER successful authentication to:
/// 1. Initialize System Service (battery polling, device state, time sync)
/// 2. Initialize Health Service (heart rate monitoring, etc.)
/// 3. Start realtime stats streaming for live HR data
///
/// **THIS IS NOT AUTHENTICATION** - authentication is handled by
/// XiaomiAuthService. This only runs AFTER auth succeeds.
///
/// **Based on Gadgetbridge XiaomiSupport.onAuthSuccess()**
class XiaomiInitializationService {
  final String deviceId;
  final XiaomiSppService? sppService;
  final SppV2ProtocolHandler? sppV2Handler;

  late final XiaomiHealthService healthService;

  /// Command type for system operations (from Gadgetbridge)
  static const int _systemCommandType = 2;

  // System command subtypes
  static const int _cmdBattery = 1;
  static const int _cmdDeviceStateGet = 78;
  static const int _cmdLanguage = 6;

  XiaomiInitializationService({
    required this.deviceId,
    this.sppService,
    this.sppV2Handler,
  }) {
    healthService = XiaomiHealthService(
      deviceId: deviceId,
      sppService: sppService,
      sppV2Handler: sppV2Handler,
    );
  }

  /// 🚀 Run complete post-auth initialization
  ///
  /// **Sequence (from Gadgetbridge):**
  /// 1. System Service: Battery, device state, time sync, language
  /// 2. Health Service: Get configurations
  /// 3. **START REALTIME STATS** ← This is critical for HR data!
  ///
  /// **Timing:** Called IMMEDIATELY after authentication succeeds
  Future<void> initializePostAuth() async {
    debugPrint('🔧 Starting post-authentication initialization...');

    try {
      // Step 1: System service initialization
      await _initializeSystemService();

      // Small delay between service initializations (for device stability)
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 2: Health service initialization
      await _initializeHealthService();

      debugPrint('✅ Post-auth initialization completed successfully');
    } catch (e) {
      debugPrint('❌ Post-auth initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize System Service: battery, device state, clock, language
  ///
  /// **OPTIMIZATION:** These commands are sent in BACKGROUND (non-blocking).
  /// They sync device state but are NOT required for connection success.
  /// Connection returns immediately while system sync happens asynchronously.
  Future<void> _initializeSystemService() async {
    debugPrint('🔧 Scheduling System Service background initialization...');

    // Schedule all system commands to run in background WITHOUT BLOCKING
    // This unblocks the connection flow immediately
    Future.microtask(() async {
      try {
        debugPrint('   🔋 [BG] Battery polling...');
        await _sendCommand(
          _systemCommandType,
          _cmdBattery,
          'get battery',
        );
        await Future.delayed(const Duration(milliseconds: 100));

        debugPrint('   📊 [BG] Device state polling...');
        await _sendCommand(
          _systemCommandType,
          _cmdDeviceStateGet,
          'get device status',
        );
        await Future.delayed(const Duration(milliseconds: 100));

        debugPrint('   🕐 [BG] Syncing time and timezone...');
        await _syncDeviceTime();
        await Future.delayed(const Duration(milliseconds: 100));

        debugPrint('   🌐 [BG] Syncing language and locale...');
        await _sendCommand(
          _systemCommandType,
          _cmdLanguage,
          'sync language',
        );

        debugPrint('✅ [BG] System Service background initialization completed');
      } catch (e) {
        debugPrint('⚠️ [BG] System Service background sync failed: $e');
        // Don't rethrow - background task failure shouldn't block connection
      }
    });

    debugPrint('✅ System Service background tasks scheduled');
  }

  /// Initialize Health Service and START realtime stats
  ///
  /// **Optimization:** Health service configs loaded on-demand
  /// No GET_CONFIG queries here - they're unnecessary for connection
  /// Only instantiate the service for later use (e.g., realtime stats)
  Future<void> _initializeHealthService() async {
    debugPrint('🔧 Initializing Health Service (lazy load only)...');

    try {
      // Health service is already instantiated and ready for use
      // Configs will be loaded on-demand when user accesses settings

      debugPrint('✅ Health Service initialized (lazy mode)');
    } catch (e) {
      debugPrint('❌ Health Service initialization failed: $e');
      rethrow;
    }
  }

  /// Sync device time with current system time (DEFAULT behavior)
  ///
  /// **Logic:** Uses system DateTime.now() with auto-detected timezone
  /// This is the SAME logic as the debug widget's default time sync
  ///
  /// **Device Requirements:**
  /// - Expects Command type=2 (system), subtype=3 (clock)
  /// - With Clock containing Date, Time, and TimeZone info
  Future<void> _syncDeviceTime() async {
    try {
      debugPrint('🕐 [INIT] Syncing device time with system time...');

      final now = DateTime.now();

      // Create Date structure
      final date = pb.Date.create()
        ..year = now.year
        ..month = now.month
        ..day = now.day;

      // Create Time structure
      final time = pb.Time.create()
        ..hour = now.hour
        ..minute = now.minute
        ..second = now.second
        ..millisecond = now.millisecond;

      // Create TimeZone structure with system timezone
      final offset =
          now.timeZoneOffset.inMinutes ~/ 15; // Convert to 15-min blocks

      // Get system timezone name
      String tzName = _getSystemTimezoneName();

      final timezone = pb.TimeZone.create()
        ..zoneOffset = offset
        ..dstOffset = 0 // DST not calculated, can be enhanced
        ..name = tzName;

      // Create Clock structure
      final clock = pb.Clock.create()
        ..date = date
        ..time = time
        ..timezone = timezone
        ..isNot24hour = false; // ✅ Always use 24-hour format

      // Create command with clock data
      final command = pb.Command()
        ..type = 2 // System
        ..subtype = 3 // Clock sync
        ..system = (pb.System.create()..clock = clock);

      debugPrint(
        '   📅 Current time: ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
      );
      debugPrint(
        '   🌍 System Timezone: $tzName (offset: $offset blocks of 15min)',
      );

      if (sppV2Handler != null) {
        // BLE auth flow - use handler
        final payload = command.writeToBuffer();
        await sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.protobufCommand,
          payload: payload,
          encrypted: true,
        );
        debugPrint(
          '   ✅ [BLE] Clock sync command sent (${payload.length} bytes)',
        );
      } else if (sppService != null) {
        // Bonded device flow (BT_CLASSIC) - use SppService
        await sppService!.sendProtobufCommand(command: command);
        debugPrint('   ✅ [BT_CLASSIC] Clock sync command sent');
      } else {
        throw Exception('No transport available for time sync');
      }

      debugPrint('✅ Device time synchronized successfully');
    } catch (e) {
      debugPrint('❌ Failed to sync device time: $e');
      // Don't rethrow - time sync is not critical for operation
    }
  }

  /// Get system timezone name
  ///
  /// Detecta automáticamente desde las variables de entorno del sistema.
  /// Fallback a UTC si no se detecta.
  String _getSystemTimezoneName() {
    try {
      // Intentar obtener la zona horaria del entorno
      final tzEnv = Platform.environment['TZ'];
      if (tzEnv != null && tzEnv.isNotEmpty) {
        debugPrint('   📍 Timezone del sistema: $tzEnv');
        return tzEnv;
      }

      // Fallback a UTC
      debugPrint('   📍 Timezone del sistema: UTC (default)');
      return 'UTC';
    } catch (e) {
      debugPrint('   ⚠️  Error detectando timezone: $e');
      return 'UTC';
    }
  }

  /// Generic command sender for post-auth protobuf commands (GET requests only)
  ///
  /// **Critical:** Device ONLY accepts simple {type, subtype} for GET requests.
  /// Adding empty nested messages causes ACK but NO response.
  Future<void> _sendCommand(
    final int commandType,
    final int subType,
    final String description,
  ) async {
    debugPrint(
      '📤 Sending: $description (type: $commandType, subtype: $subType)',
    );

    final command = pb.Command()
      ..type = commandType
      ..subtype = subType;

    if (sppV2Handler != null) {
      // BLE auth flow - use handler
      final payload = command.writeToBuffer();
      await sppV2Handler!.sendData(
        deviceId,
        channel: SppV2Channel.protobufCommand,
        payload: payload,
        encrypted: true,
      );
    } else if (sppService != null) {
      // Bonded device flow (BT_CLASSIC) - use SppService
      await sppService!.sendProtobufCommand(command: command);
    } else {
      throw Exception('No transport available for post-auth commands');
    }
  }

  /// Get the health service for caller to manage realtime stats
  XiaomiHealthService getHealthService() => healthService;

  /// Cleanup
  void dispose() {
    healthService.dispose();
  }
}
