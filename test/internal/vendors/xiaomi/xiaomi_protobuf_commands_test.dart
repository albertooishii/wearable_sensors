import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('XiaomiProtobufCommands - Realtime Stats', () {
    group('createRealtimeStatsStartRequest', () {
      test('creates minimal start command', () {
        final command = createRealtimeStatsStartRequest();

        expect(command.type, equals(XiaomiCommandType.health));
        expect(command.subtype, equals(XiaomiHealthCommand.realtimeStatsStart));
        expect(command.subtype, equals(45)); // Verify exact value

        // No additional fields (minimal command)
        expect(command.hasHealth(), isFalse);
        expect(command.hasSystem(), isFalse);
      });

      test('encodes to valid protobuf bytes', () {
        final command = createRealtimeStatsStartRequest();
        final bytes = encodeCommand(command);

        expect(bytes, isNotEmpty);
        expect(bytes.length, greaterThan(0));

        // Verify can be decoded back
        final decoded = decodeCommand(bytes);
        expect(decoded.type, equals(XiaomiCommandType.health));
        expect(decoded.subtype, equals(45));
      });

      test('is idempotent (multiple calls produce same result)', () {
        final cmd1 = createRealtimeStatsStartRequest();
        final cmd2 = createRealtimeStatsStartRequest();

        final bytes1 = encodeCommand(cmd1);
        final bytes2 = encodeCommand(cmd2);

        expect(bytes1, equals(bytes2));
      });
    });

    group('createRealtimeStatsStopRequest', () {
      test('creates minimal stop command', () {
        final command = createRealtimeStatsStopRequest();

        expect(command.type, equals(XiaomiCommandType.health));
        expect(command.subtype, equals(XiaomiHealthCommand.realtimeStatsStop));
        expect(command.subtype, equals(46)); // Verify exact value

        // No additional fields
        expect(command.hasHealth(), isFalse);
        expect(command.hasSystem(), isFalse);
      });

      test('encodes to valid protobuf bytes', () {
        final command = createRealtimeStatsStopRequest();
        final bytes = encodeCommand(command);

        expect(bytes, isNotEmpty);

        // Verify can be decoded back
        final decoded = decodeCommand(bytes);
        expect(decoded.type, equals(XiaomiCommandType.health));
        expect(decoded.subtype, equals(46));
      });
    });

    group('createHeartRateTestRequest', () {
      test('creates same command as realtime start', () {
        final hrTest = createHeartRateTestRequest();
        final realtimeStart = createRealtimeStatsStartRequest();

        final hrBytes = encodeCommand(hrTest);
        final startBytes = encodeCommand(realtimeStart);

        // Should be identical (difference is caller logic, not command)
        expect(hrBytes, equals(startBytes));
      });

      test('has health command type', () {
        final command = createHeartRateTestRequest();

        expect(command.type, equals(XiaomiCommandType.health));
        expect(command.subtype, equals(45));
      });
    });

    group('isRealtimeStatsEvent', () {
      test('returns true for valid realtime event', () {
        final stats = RealTimeStats.create()
          ..heartRate = 78
          ..steps = 1234;

        final health = Health.create()..realTimeStats = stats;

        final command = Command.create()
          ..type = XiaomiCommandType.health
          ..subtype = XiaomiHealthCommand.realtimeStatsEvent
          ..health = health;

        expect(isRealtimeStatsEvent(command), isTrue);
      });

      test('returns false for non-event health commands', () {
        final command = Command.create()
          ..type = XiaomiCommandType.health
          ..subtype =
              XiaomiHealthCommand.realtimeStatsStart; // Start, not event

        expect(isRealtimeStatsEvent(command), isFalse);
      });

      test('returns false for system commands', () {
        final command = Command.create()
          ..type = XiaomiCommandType.system
          ..subtype = XiaomiSystemCommand.battery;

        expect(isRealtimeStatsEvent(command), isFalse);
      });

      test('returns false for wrong subtype', () {
        final command = Command.create()
          ..type = XiaomiCommandType.health
          ..subtype = 99; // Invalid subtype

        expect(isRealtimeStatsEvent(command), isFalse);
      });
    });

    group('Command encoding/decoding roundtrip', () {
      test('start command survives encode/decode', () {
        final original = createRealtimeStatsStartRequest();
        final bytes = encodeCommand(original);
        final decoded = decodeCommand(bytes);

        expect(decoded.type, equals(original.type));
        expect(decoded.subtype, equals(original.subtype));
      });

      test('stop command survives encode/decode', () {
        final original = createRealtimeStatsStopRequest();
        final bytes = encodeCommand(original);
        final decoded = decodeCommand(bytes);

        expect(decoded.type, equals(original.type));
        expect(decoded.subtype, equals(original.subtype));
      });

      test('event command with data survives encode/decode', () {
        final stats = RealTimeStats.create()
          ..heartRate = 82
          ..steps = 5678
          ..calories = 123
          ..unknown3 = 15
          ..standingHours = 2;

        final health = Health.create()..realTimeStats = stats;

        final original = Command.create()
          ..type = XiaomiCommandType.health
          ..subtype = XiaomiHealthCommand.realtimeStatsEvent
          ..health = health;

        final bytes = encodeCommand(original);
        final decoded = decodeCommand(bytes);

        expect(decoded.type, equals(original.type));
        expect(decoded.subtype, equals(original.subtype));
        expect(decoded.hasHealth(), isTrue);
        expect(decoded.health.hasRealTimeStats(), isTrue);
        expect(decoded.health.realTimeStats.heartRate, equals(82));
        expect(decoded.health.realTimeStats.steps, equals(5678));
        expect(decoded.health.realTimeStats.calories, equals(123));
      });
    });

    group('XiaomiHealthCommand constants', () {
      test('command subtypes have correct values', () {
        // Verify against Gadgetbridge values
        expect(XiaomiHealthCommand.batteryInfo, equals(1));
        expect(XiaomiHealthCommand.realtimeStatsStart, equals(45));
        expect(XiaomiHealthCommand.realtimeStatsStop, equals(46));
        expect(XiaomiHealthCommand.realtimeStatsEvent, equals(47));
      });
    });

    group('XiaomiCommandType constants', () {
      test('command types have correct values', () {
        // Verify against Gadgetbridge values
        expect(XiaomiCommandType.system, equals(2));
        expect(
          XiaomiCommandType.health,
          equals(8),
        ); // ✅ FIXED: Was 10, corrected to 8
      });
    });

    group('Integration: Start → Event → Stop flow', () {
      test('simulates complete realtime stats session', () {
        // 1. Start streaming
        final startCmd = createRealtimeStatsStartRequest();
        final startBytes = encodeCommand(startCmd);
        expect(startBytes, isNotEmpty);

        // 2. Receive event (simulated)
        final stats = RealTimeStats.create()
          ..heartRate = 75
          ..steps = 100;
        final health = Health.create()..realTimeStats = stats;
        final eventCmd = Command.create()
          ..type = XiaomiCommandType.health
          ..subtype = XiaomiHealthCommand.realtimeStatsEvent
          ..health = health;

        expect(isRealtimeStatsEvent(eventCmd), isTrue);

        final eventBytes = encodeCommand(eventCmd);
        final decodedEvent = decodeCommand(eventBytes);
        expect(decodedEvent.health.realTimeStats.heartRate, equals(75));

        // 3. Stop streaming
        final stopCmd = createRealtimeStatsStopRequest();
        final stopBytes = encodeCommand(stopCmd);
        expect(stopBytes, isNotEmpty);
        expect(stopBytes, isNot(equals(startBytes))); // Different commands
      });
    });
  });
}
