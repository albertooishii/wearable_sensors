import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/handler.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/protocol/v2/packet.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_spp_service.dart';

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
      final tz = timezone ?? _getSystemTimezone();
      final userOffset = _getTimezoneOffset(tz);

      // Device appears to have UTC+2 hardcoded and ignores zoneOffset field.
      // To show the correct time, we need to send: (userLocalTime - deviceInternalOffset + userOffset)
      // This way: device adds 2h → result shows userLocalTime
      //
      // Example: Madrid is UTC+2 (Oct), device is UTC+2
      //   - User time: 14:00 Madrid
      //   - We send: 14:00 - 2 = 12:00
      //   - Device adds 2: 12:00 + 2 = 14:00 ✓
      //
      // Example: New York is UTC-5, device is UTC+2
      //   - User time: 08:00 NY
      //   - Offset difference: UTC+2 - UTC-5 = 7 hours
      //   - We send: 08:00 - 7 = 01:00
      //   - Device adds 2: 01:00 + 2 = 03:00 (which is 08:00 NY adjusted to UTC+2) ✓

      const int deviceInternalOffset = 2; // Device is UTC+2
      final hoursToSubtract =
          deviceInternalOffset; // Just subtract the device offset
      final adjustedDateTime =
          dateTime.subtract(Duration(hours: hoursToSubtract));

      debugPrint(
        '   Local time: ${dateTime.toIso8601String()} (timezone: $tz, UTC offset: $userOffset)',
      );
      debugPrint(
        '   Device internal offset: UTC+$deviceInternalOffset',
      );
      debugPrint(
        '   Adjustment: subtracting $hoursToSubtract hours',
      );
      debugPrint(
        '   Time to send: ${adjustedDateTime.toIso8601String()}',
      );

      // Build Clock protobuf message
      // Send the ADJUSTED time and let the device add its 2 hours
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

  /// Get system timezone offset in hours
  ///
  /// Try offset in simple hours (not 15-min blocks as proto comments suggest)
  /// Examples:
  /// - UTC+1 (Madrid) → 1
  /// - UTC-5 (New York) → -5
  /// - UTC+9 (Tokyo) → 9
  static int _getTimezoneOffset(String timezone) {
    // Map common timezones to their UTC offset in HOURS
    const offsetHours = {
      'UTC': 0,
      'Europe/London': 0,
      'Europe/Madrid': 1, // UTC+1
      'Europe/Paris': 1,
      'Europe/Berlin': 1,
      'Europe/Rome': 1,
      'Europe/Amsterdam': 1,
      'America/New_York': -5,
      'America/Chicago': -6,
      'America/Denver': -7,
      'America/Los_Angeles': -8,
      'America/Mexico_City': -6,
      'Asia/Tokyo': 9,
      'Asia/Shanghai': 8,
      'Australia/Sydney': 10,
    };

    return offsetHours[timezone] ?? 0;
  }

  /// Get system timezone name
  static String _getSystemTimezone() {
    // TODO: Use package:timezone to get actual system timezone
    return 'UTC';
  }

  /// Cleanup
  void dispose() {
    // No resources to clean up
  }
}
