import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/parsers/xiaomi_spp/realtime_stats_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XiaomiSppRealtimeStatsParser', () {
    group('parse', () {
      test('returns null for invalid protobuf', () {
        final invalidBytes = [0xFF, 0xFF, 0xFF, 0xFF];
        final result = XiaomiSppRealtimeStatsParser.parse(invalidBytes);

        expect(result, isNull);
      });

      test('returns null for wrong command type', () {
        final command = pb.Command.create()
          ..type = 2 // Not Health (should be 8)
          ..subtype = 47;

        final bytes = command.writeToBuffer();
        final result = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(result, isNull);
      });

      test('returns null for wrong command subtype', () {
        final command = pb.Command.create()
          ..type = 8 // Health
          ..subtype = 1; // Not realtime event (should be 47)

        final bytes = command.writeToBuffer();
        final result = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(result, isNull);
      });

      test('returns null when no realTimeStats field', () {
        final health = pb.Health.create(); // No realTimeStats
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final result = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(result, isNull);
      });

      test('parses valid realtime stats with all sensors', () {
        final stats = pb.RealTimeStats.create()
          ..heartRate = 78
          ..steps = 1234
          ..calories = 56
          ..unknown3 = 12 // Movement intensity
          ..standingHours = 3;

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(samples, isNotNull);
        expect(
          samples!.length,
          equals(5),
        ); // HR, movement, steps, calories, standing

        // Heart Rate sample
        final hrSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.heartRate,
        );
        expect(hrSample.value, equals(78.0));
        expect(hrSample.metadata?['unit'], equals('bpm'));
        expect(hrSample.metadata?['source'], equals('xiaomi_spp_realtime'));
        expect(hrSample.metadata?['valid'], isTrue); // 78 is valid HR

        // Movement sample
        final movementSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.movement,
        );
        expect(movementSample.value, equals(12.0));
        expect(
          movementSample.metadata?['note'],
          equals('activity_intensity_proxy'),
        );

        // Steps sample
        final stepsSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.steps,
        );
        expect(stepsSample.value, equals(1234.0));
        expect(stepsSample.metadata?['cumulative'], isTrue);

        // Calories sample
        final caloriesSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.calories,
        );
        expect(caloriesSample.value, equals(56.0));

        // Standing hours sample
        final standingSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.unknown,
        );
        expect(standingSample.value, equals(3.0));
      });

      test('ignores HR <= 10 (invalid)', () {
        final stats = pb.RealTimeStats.create()
          ..heartRate = 5 // Invalid (too low)
          ..steps = 100;

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(samples, isNotNull);
        // Should only have steps, no HR
        expect(
          samples!.any((final s) => s.sensorType == SensorType.heartRate),
          isFalse,
        );
        expect(
          samples.any((final s) => s.sensorType == SensorType.steps),
          isTrue,
        );
      });

      test('ignores movement intensity = 0', () {
        final stats = pb.RealTimeStats.create()
          ..heartRate = 70
          ..unknown3 = 0; // No movement

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(samples, isNotNull);
        // Should have HR but no movement
        expect(
          samples!.any((final s) => s.sensorType == SensorType.heartRate),
          isTrue,
        );
        expect(
          samples.any((final s) => s.sensorType == SensorType.movement),
          isFalse,
        );
      });

      test('returns null when all values are zero/invalid', () {
        final stats = pb.RealTimeStats.create()
          ..heartRate = 0 // Invalid (<=10 filtered)
          ..steps = 0
          ..calories = 0
          ..unknown3 = 0
          ..standingHours = 0;

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        // ✅ FIXED: Steps and calories are ALWAYS emitted (even if 0)
        // Rationale: Reset at midnight means 0 is a valid value
        // App layer needs these for change detection
        expect(samples, isNotNull);
        expect(samples!.length, equals(2)); // Steps + Calories
        expect(
          samples.any((final s) => s.sensorType == SensorType.steps),
          isTrue,
        );
        expect(
          samples.any((final s) => s.sensorType == SensorType.calories),
          isTrue,
        );
      });

      test('handles partial data (only HR)', () {
        final stats = pb.RealTimeStats.create()..heartRate = 82;

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(samples, isNotNull);
        // ✅ FIXED: Should have HR + Steps (0) + Calories (0)
        // Steps and calories always emitted for change detection
        expect(samples!.length, equals(3)); // HR + Steps + Calories

        final hrSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.heartRate,
        );
        expect(hrSample.value, equals(82.0));

        // Verify steps and calories are present with 0 values
        final stepsSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.steps,
        );
        expect(stepsSample.value, equals(0.0));

        final caloriesSample = samples.firstWhere(
          (final s) => s.sensorType == SensorType.calories,
        );
        expect(caloriesSample.value, equals(0.0));
      });

      test('marks HR as invalid when out of physiological range', () {
        final stats = pb.RealTimeStats.create()..heartRate = 250; // Too high

        final health = pb.Health.create()..realTimeStats = stats;
        final command = pb.Command.create()
          ..type = 8
          ..subtype = 47
          ..health = health;

        final bytes = command.writeToBuffer();
        final samples = XiaomiSppRealtimeStatsParser.parse(bytes);

        expect(samples, isNotNull);
        final hrSample = samples!.firstWhere(
          (final s) => s.sensorType == SensorType.heartRate,
        );
        expect(hrSample.value, equals(250.0));
        expect(hrSample.metadata?['valid'], isFalse); // Marked as invalid
      });
    });

    group('isValidHeartRate', () {
      test('returns true for valid HR range', () {
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(40), isTrue);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(60), isTrue);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(100), isTrue);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(180), isTrue);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(220), isTrue);
      });

      test('returns false for invalid HR', () {
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(0), isFalse);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(10), isFalse);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(39), isFalse);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(221), isFalse);
        expect(XiaomiSppRealtimeStatsParser.isValidHeartRate(300), isFalse);
      });
    });

    group('classifyHeartRateZone', () {
      test('classifies HR zones correctly', () {
        expect(
          XiaomiSppRealtimeStatsParser.classifyHeartRateZone(45),
          equals('very_low'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyHeartRateZone(55),
          equals('low'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyHeartRateZone(70),
          equals('normal'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyHeartRateZone(85),
          equals('elevated'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyHeartRateZone(120),
          equals('high'),
        );
      });
    });

    group('classifyMovementLevel', () {
      test('classifies movement levels correctly', () {
        expect(
          XiaomiSppRealtimeStatsParser.classifyMovementLevel(0),
          equals('none'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyMovementLevel(3),
          equals('minimal'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyMovementLevel(10),
          equals('moderate'),
        );
        expect(
          XiaomiSppRealtimeStatsParser.classifyMovementLevel(20),
          equals('high'),
        );
      });
    });

    group('isLikelyAwake', () {
      test('returns false when no previous steps', () {
        expect(
          XiaomiSppRealtimeStatsParser.isLikelyAwake(
            currentSteps: 100,
            previousSteps: null,
          ),
          isFalse,
        );
      });

      test('returns true when steps increased', () {
        expect(
          XiaomiSppRealtimeStatsParser.isLikelyAwake(
            currentSteps: 150,
            previousSteps: 100,
          ),
          isTrue,
        );
      });

      test('returns false when steps unchanged', () {
        expect(
          XiaomiSppRealtimeStatsParser.isLikelyAwake(
            currentSteps: 100,
            previousSteps: 100,
          ),
          isFalse,
        );
      });

      test('returns false when steps decreased (edge case)', () {
        // Shouldn't happen in normal operation, but test anyway
        expect(
          XiaomiSppRealtimeStatsParser.isLikelyAwake(
            currentSteps: 100,
            previousSteps: 150,
          ),
          isFalse,
        );
      });
    });
  });
}
