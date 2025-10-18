/// Xiaomi SPP Battery Parser Tests
///
/// Validates parsing of SPP protobuf battery data from Mi Band 9/10.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/parsers/xiaomi_spp/battery_parser.dart';
import 'package:wearable_sensors/src/internal/parsers/parser_registry.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';

void main() {
  group('XiaomiSppBatteryParser', () {
    test('parse valid battery response (63%)', () {
      // Real response from Mi Band 10:
      // Command { type: 2, subtype: 1, system.power.battery.level: 63 }
      final command = Command(
        type: XiaomiCommandType.system,
        subtype: XiaomiSystemCommand.battery,
        system: System(
          power: Power(
            battery: Battery(
              level: 63,
              state: 2, // not_charging
            ),
          ),
        ),
      );

      final bytes = command.writeToBuffer();
      final sample = XiaomiSppBatteryParser.parse(bytes);

      expect(sample, isNotNull);
      expect(sample!.value, equals(63.0));
      expect(sample.sensorType, equals(SensorType.battery));
      expect(sample.metadata?['source'], equals('xiaomi_spp_protobuf'));
      expect(sample.metadata?['unit'], equals('percentage'));
      expect(sample.metadata?['charging_status'], equals('not_charging'));
      expect(sample.metadata?['transport'], equals('bt_classic'));
    });

    test('parse battery response with charging status', () {
      final command = Command(
        type: XiaomiCommandType.system,
        subtype: XiaomiSystemCommand.battery,
        system: System(
          power: Power(
            battery: Battery(
              level: 85,
              state: 1, // charging
            ),
          ),
        ),
      );

      final bytes = command.writeToBuffer();
      final sample = XiaomiSppBatteryParser.parse(bytes);

      expect(sample, isNotNull);
      expect(sample!.value, equals(85.0));
      expect(sample.metadata?['charging_status'], equals('charging'));
    });

    test('parse battery response without status (minimal)', () {
      final command = Command(
        type: XiaomiCommandType.system,
        subtype: XiaomiSystemCommand.battery,
        system: System(
          power: Power(
            battery: Battery(
              level: 42,
              // No state field
            ),
          ),
        ),
      );

      final bytes = command.writeToBuffer();
      final sample = XiaomiSppBatteryParser.parse(bytes);

      expect(sample, isNotNull);
      expect(sample!.value, equals(42.0));
      expect(sample.metadata?['charging_status'], isNull);
    });

    test('parse returns null for empty bytes', () {
      final sample = XiaomiSppBatteryParser.parse([]);
      expect(sample, isNull);
    });

    test('parse returns null for invalid protobuf', () {
      final invalidBytes = [0xFF, 0xFF, 0xFF, 0xFF];
      final sample = XiaomiSppBatteryParser.parse(invalidBytes);
      expect(sample, isNull);
    });

    test('parse returns null for non-battery Command', () {
      final command = Command(
        type: 10, // Wrong type (health instead of system)
        subtype: 99,
      );

      final bytes = command.writeToBuffer();
      final sample = XiaomiSppBatteryParser.parse(bytes);

      expect(sample, isNull);
    });

    test('classifyBatteryLevel', () {
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(100), equals('full'));
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(80), equals('high'));
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(50), equals('medium'));
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(30), equals('medium'));
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(20), equals('low'));
      expect(XiaomiSppBatteryParser.classifyBatteryLevel(10), equals('low'));
      expect(
        XiaomiSppBatteryParser.classifyBatteryLevel(5),
        equals('critical'),
      );
      expect(
        XiaomiSppBatteryParser.classifyBatteryLevel(2),
        equals('critical'),
      );
    });

    test('isLowBattery', () {
      expect(XiaomiSppBatteryParser.isLowBattery(25), isFalse);
      expect(XiaomiSppBatteryParser.isLowBattery(20), isTrue);
      expect(XiaomiSppBatteryParser.isLowBattery(10), isTrue);
    });

    test('isCriticalBattery', () {
      expect(XiaomiSppBatteryParser.isCriticalBattery(10), isFalse);
      expect(XiaomiSppBatteryParser.isCriticalBattery(5), isTrue);
      expect(XiaomiSppBatteryParser.isCriticalBattery(2), isTrue);
    });
  });

  group('ParserRegistry Integration', () {
    test('xiaomi_spp_battery parser is registered', () {
      expect(ParserRegistry.hasParser('xiaomi_spp_battery'), isTrue);
    });

    test('get xiaomi_spp_battery parser from registry', () {
      final parser = ParserRegistry.getParser('xiaomi_spp_battery');
      expect(parser, isNotNull);

      // Test with real battery data
      final command = Command(
        type: XiaomiCommandType.system,
        subtype: XiaomiSystemCommand.battery,
        system: System(power: Power(battery: Battery(level: 63))),
      );

      final sample = parser!(command.writeToBuffer());
      expect(sample, isNotNull);
      expect(sample!.value, equals(63.0));
    });

    test('getParsersByDevice includes SPP parsers', () {
      final xiaomiParsers = ParserRegistry.getParsersByDevice('xiaomi');

      expect(xiaomiParsers, contains('xiaomi_spp_battery'));
      expect(xiaomiParsers, contains('xiaomi_battery_level')); // BLE
      expect(xiaomiParsers, contains('xiaomi_activity_data'));
    });
  });
}
