import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 🌍 Centralized timezone detection for Xiaomi commands
///
/// Uses system offset detection with timezone database fallback.
class XiaomiTimezoneHelper {
  /// Get the system timezone name by matching offset against database
  ///
  /// Simply iterates through all timezones and finds one matching the
  /// current system offset (which automatically includes DST).
  static String getSystemTimezoneName() {
    try {
      // Initialize timezone database
      if (!_isInitialized) {
        tz_data.initializeTimeZones();
        _isInitialized = true;
      }

      final now = DateTime.now();
      final systemOffset = now.timeZoneOffset;
      final systemOffsetHours = systemOffset.inHours;

      debugPrint(
        '🌍 System offset: UTC${systemOffsetHours >= 0 ? '+' : ''}${systemOffsetHours}h',
      );

      // Search for matching timezone
      debugPrint('🌍 Searching through timezone database...');
      final locations = tz.timeZoneDatabase.locations;
      debugPrint('   Database has ${locations.length} locations');

      for (final location in locations.values) {
        final tzObj = location.timeZone(now.millisecondsSinceEpoch);
        // Convert tzObj offset (in milliseconds) to hours: 7200000ms → 2 hours
        final tzOffsetHours = tzObj.offset ~/ 3600000;

        if (tzOffsetHours == systemOffsetHours) {
          debugPrint(
            '✅ Found: ${location.name} (UTC${tzOffsetHours >= 0 ? '+' : ''}${tzOffsetHours}h)',
          );
          return location.name;
        }
      }

      // No exact match found
      debugPrint('❌ No exact match. All offsets in database:');
      final allOffsets = <int, List<String>>{};
      for (final location in locations.values) {
        final tzObj = location.timeZone(now.millisecondsSinceEpoch);
        allOffsets.putIfAbsent(tzObj.offset, () => []).add(location.name);
      }
      for (final entry in allOffsets.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key))) {
        // entry.key is offset in milliseconds (e.g., 7200000 = UTC+2)
        final offsetInHours = entry.key ~/ 3600000;
        debugPrint(
          '   UTC${offsetInHours >= 0 ? '+' : ''}${offsetInHours}h: ${entry.value.take(3).join(", ")}${entry.value.length > 3 ? " (+${entry.value.length - 3} more)" : ""}',
        );
      }

      debugPrint('⚠️ No matching timezone found, using UTC');
      return 'UTC';
    } catch (e) {
      debugPrint('❌ Error: $e');
      return 'UTC';
    }
  }

  static bool _isInitialized = false;
}
