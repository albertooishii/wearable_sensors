import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/handler.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/packet.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_spp_service.dart';
import 'xiaomi_timezone_helper.dart';

/// 🎮 Xiaomi Command Service
///
/// **Responsibility:** Send commands to device for configuration/control.
///
/// Handles writing device settings like:
/// - Clock synchronization (time + timezone)
/// - Language/locale configuration
/// - Vibration patterns (test or custom)
/// - Other device control commands
///
/// **Based on Gadgetbridge XiaomiSystemService**
class XiaomiCommandService {
  final String deviceId;
  final XiaomiSppService? sppService;
  final SppV2ProtocolHandler? sppV2Handler;

  /// Command type for system operations (from Gadgetbridge)
  static const int _systemCommandType = 2;

  // System command subtypes
  static const int _cmdClock = 3;
  static const int _cmdLanguage = 6;
  static const int _cmdVibrationTest = 59;

  XiaomiCommandService({
    required this.deviceId,
    this.sppService,
    this.sppV2Handler,
  });

  /// 🕐 Sync device clock with phone time
  ///
  /// **Parameters:**
  /// - [dateTime]: DateTime to sync (default: now, in LOCAL timezone)
  /// - [timezone]: Timezone string (e.g., 'Europe/Madrid', default: system TZ)
  /// - [is24Hour]: Use 24-hour format (default: true)
  ///
  /// **Important:** The dateTime parameter is expected to be in the LOCAL timezone.
  /// This method will convert it to UTC before sending to the device, which will
  /// then apply the timezone offset to display the correct local time.
  Future<void> syncClock({
    DateTime? dateTime,
    String? timezone,
    bool is24Hour = true,
  }) async {
    debugPrint('🕐 Syncing clock for $deviceId...');

    try {
      dateTime ??= DateTime.now();
      final tz = timezone ?? XiaomiTimezoneHelper.getSystemTimezoneName();

      // ⚠️ WORKAROUND: Device appears to calculate its own offset incorrectly
      // and ignores the zoneOffset field we send in the protobuf message.
      //
      // SOLUTION: Send UTC time directly and let the device apply timezone by name.
      // The timezone name (e.g., 'Europe/Madrid') should handle DST automatically.
      //
      // Example: Madrid at 14:00 local time
      //   - Local time: 14:00 (UTC+1 in winter, UTC+2 in summer)
      //   - We send: 13:00 UTC (14:00 - 1h offset)
      //   - Device applies 'Europe/Madrid' TZ → displays 14:00 ✓
      final adjustedDateTime = dateTime.toUtc();

      debugPrint(
        '   Local time: ${dateTime.toIso8601String()} (timezone: $tz)',
      );
      debugPrint(
        '   UTC time to send: ${adjustedDateTime.toIso8601String()}',
      );
      debugPrint(
        '   Device will apply timezone: $tz',
      );

      // Build Clock protobuf message
      // Send UTC time and let device apply timezone by name (handles DST automatically)
      final clock = pb.Clock()
        ..date = (pb.Date()
          ..year = adjustedDateTime.year
          ..month = adjustedDateTime.month
          ..day = adjustedDateTime.day)
        ..time = (pb.Time()
          ..hour = adjustedDateTime.hour
          ..minute = adjustedDateTime.minute
          ..second = adjustedDateTime.second
          ..millisecond = adjustedDateTime.millisecond)
        ..timezone = (pb.TimeZone()
          ..name = tz
          ..zoneOffset = 0 // Always send 0 - timezone name should be enough
          ..dstOffset = 0)
        ..isNot24hour = !is24Hour;

      // Build command
      final command = pb.Command()
        ..type = _systemCommandType
        ..subtype = _cmdClock
        ..system = (pb.System()..clock = clock);

      await _sendCommand(command, 'sync clock');
      debugPrint(
        '✅ Clock synced: Device will show ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} in $tz',
      );
    } catch (e) {
      debugPrint('❌ Clock sync failed: $e');
      rethrow;
    }
  }

  /// 🌐 Set device language
  ///
  /// **Parameters:**
  /// - [languageCode]: ISO 639-1 code ('en', 'es', 'fr', etc.)
  /// - [locale]: Full locale code (e.g., 'en_US', optional)
  Future<void> setLanguage({
    required String languageCode,
    String? locale,
  }) async {
    debugPrint('🌐 Setting language to $languageCode for $deviceId...');

    try {
      // Build Language protobuf message
      final language = pb.Language()
        ..code = locale ?? '${languageCode}_${languageCode.toUpperCase()}';

      // Build command
      final command = pb.Command()
        ..type = _systemCommandType
        ..subtype = _cmdLanguage
        ..system = (pb.System()..language = language);

      await _sendCommand(command, 'set language to $languageCode');
      debugPrint('✅ Language set to $languageCode');
    } catch (e) {
      debugPrint('❌ Language setting failed: $e');
      rethrow;
    }
  }

  /// 📳 Send vibration test pattern
  ///
  /// **Parameters:**
  /// - [vibrationPattern]: List of {vibrate: 0/1, ms: duration}
  ///   Example: [{'vibrate': 0, 'ms': 100}, {'vibrate': 1, 'ms': 100}]
  /// - [repeat]: Number of times to repeat pattern (default: 1)
  Future<void> sendVibrationTest({
    required List<Map<String, int>> vibrationPattern,
    int repeat = 1,
  }) async {
    debugPrint('📳 Sending vibration test for $deviceId...');

    try {
      // Build Vibration messages
      final vibrations = <pb.Vibration>[];
      for (final pattern in vibrationPattern) {
        final vibrate = pattern['vibrate'] ?? 0;
        final ms = pattern['ms'] ?? 100;
        vibrations.add(
          pb.Vibration()
            ..vibrate = vibrate
            ..ms = ms,
        );
      }

      // Repeat pattern if requested
      if (repeat > 1) {
        final basePattern = List<pb.Vibration>.from(vibrations);
        for (int i = 1; i < repeat; i++) {
          vibrations.addAll(basePattern);
        }
      }

      // Build VibrationTest message
      final vibrationTest = pb.VibrationTest()..vibration.addAll(vibrations);

      // Build command
      final command = pb.Command()
        ..type = _systemCommandType
        ..subtype = _cmdVibrationTest
        ..system = (pb.System()..vibrationTestCustom = vibrationTest);

      await _sendCommand(command, 'vibration test');
      debugPrint('✅ Vibration test sent (${vibrations.length} pulses)');
    } catch (e) {
      debugPrint('❌ Vibration test failed: $e');
      rethrow;
    }
  }

  /// Generic command sender for protobuf commands
  Future<void> _sendCommand(
    pb.Command command,
    String description,
  ) async {
    debugPrint(
      '📤 Sending: $description (type: ${command.type}, subtype: ${command.subtype})',
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
    } else if (sppService != null) {
      // Bonded device flow (BT_CLASSIC) - use SppService
      await sppService!.sendProtobufCommand(command: command);
    } else {
      throw Exception('No transport available for commands');
    }
  }

  /// Cleanup
  void dispose() {
    // No resources to clean up
  }
}
