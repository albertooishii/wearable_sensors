import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceImplementationLoader', () {
    tearDown(() {
      DeviceImplementationLoader.clearCache();
    });

    test(
      'load() should return valid DeviceImplementation for generic',
      () async {
        final impl = await DeviceImplementationLoader.load('generic');

        expect(impl, isNotNull);
        expect(impl.services, isNotEmpty);
      },
    );

    test(
      'load() should return valid DeviceImplementation for xiaomi_smart_band_10',
      () async {
        final impl = await DeviceImplementationLoader.load(
          'xiaomi_smart_band_10',
        );

        expect(impl, isNotNull);
        expect(impl.services, isNotEmpty);
        expect(impl.authentication, isNotNull);
      },
    );

    test('loadGeneric() should return generic implementation', () async {
      final impl = await DeviceImplementationLoader.loadGeneric();

      expect(impl, isNotNull);
      expect(impl.services, isNotEmpty);
      // Generic should have common services like Heart Rate, Battery
      final serviceUuids =
          impl.services.values.map((final s) => s.uuid.toUpperCase()).toSet();
      expect(
        serviceUuids,
        contains('0000180D-0000-1000-8000-00805F9B34FB'),
      ); // Heart Rate
      expect(
        serviceUuids,
        contains('0000180F-0000-1000-8000-00805F9B34FB'),
      ); // Battery
    });

    test(
      'loadOrGeneric() should return specific implementation when available',
      () async {
        final impl = await DeviceImplementationLoader.loadOrGeneric(
          'xiaomi_smart_band_10',
        );

        expect(impl, isNotNull);
        expect(impl.services, isNotEmpty);
        // Should have xiaomi-specific services
        final serviceUuids =
            impl.services.values.map((final s) => s.uuid.toUpperCase()).toSet();
        expect(
          serviceUuids,
          contains('0000FE95-0000-1000-8000-00805F9B34FB'),
        ); // Xiaomi service
      },
    );

    test('loadOrGeneric() should fallback to generic on error', () async {
      final impl = await DeviceImplementationLoader.loadOrGeneric(
        'non_existent_device',
      );

      expect(impl, isNotNull);
      expect(impl.services, isNotEmpty);
      // Should return generic implementation
      expect(impl.deviceType, equals('generic'));
      final serviceUuids =
          impl.services.values.map((final s) => s.uuid.toUpperCase()).toSet();
      expect(
        serviceUuids,
        contains('0000180D-0000-1000-8000-00805F9B34FB'),
      ); // Heart Rate (generic)
    });

    test('getAllServiceUuids() should return all service UUIDs', () async {
      final impl = await DeviceImplementationLoader.loadGeneric();
      final uuids = impl.getAllServiceUuids();

      expect(uuids, isNotEmpty);
      expect(
        uuids.map((final u) => u.toUpperCase()),
        contains('0000180D-0000-1000-8000-00805F9B34FB'),
      ); // Heart Rate
      expect(
        uuids.map((final u) => u.toUpperCase()),
        contains('0000180F-0000-1000-8000-00805F9B34FB'),
      ); // Battery
    });

    test(
      'getAllCharacteristicUuids() should return all characteristic UUIDs',
      () async {
        final impl = await DeviceImplementationLoader.loadGeneric();
        final uuids = impl.getAllCharacteristicUuids();

        expect(uuids, isNotEmpty);
        // Should include characteristics from all services
        expect(uuids.length, greaterThan(0));
      },
    );

    test('xiaomi_smart_band_10 should have authentication config', () async {
      final impl = await DeviceImplementationLoader.load(
        'xiaomi_smart_band_10',
      );

      expect(impl.authentication, isNotNull);
      expect(impl.authentication.protocol, isNotEmpty);
    });

    test(
      'generic implementation should have parsers for common characteristics',
      () async {
        final impl = await DeviceImplementationLoader.loadGeneric();

        // Find heart rate service
        final hrService = impl.services.values.firstWhere(
          (final s) =>
              s.uuid.toUpperCase() == '0000180D-0000-1000-8000-00805F9B34FB',
          orElse: () => throw Exception('Heart Rate service not found'),
        );

        // Should have heart rate measurement characteristic (2A37)
        expect(hrService.characteristics, isNotEmpty);

        // Check if HR measurement characteristic exists
        final hrChar = hrService.characteristics.values.firstWhere(
          (final c) =>
              c.uuid.toUpperCase() == '00002A37-0000-1000-8000-00805F9B34FB',
          orElse: () => throw Exception(
            'Heart Rate Measurement characteristic not found',
          ),
        );

        // Should have a parser defined
        expect(hrChar.parser, isNotEmpty);
      },
    );

    test('ServiceDefinition toJson/fromJson should be reversible', () async {
      final impl = await DeviceImplementationLoader.loadGeneric();
      final service = impl.services.values.first;

      final json = service.toJson();
      final restored = ServiceDefinition.fromJson(json);

      expect(restored.uuid, equals(service.uuid));
      expect(restored.name, equals(service.name));
      expect(
        restored.characteristics.length,
        equals(service.characteristics.length),
      );
    });

    test(
      'CharacteristicDefinition toJson/fromJson should be reversible',
      () async {
        final impl = await DeviceImplementationLoader.loadGeneric();
        final characteristic =
            impl.services.values.first.characteristics.values.first;

        final json = characteristic.toJson();
        final restored = CharacteristicDefinition.fromJson(json);

        expect(restored.uuid, equals(characteristic.uuid));
        expect(restored.parser, equals(characteristic.parser));
        expect(restored.properties, equals(characteristic.properties));
      },
    );

    test('DataParser toJson/fromJson should be reversible', () async {
      final impl = await DeviceImplementationLoader.loadGeneric();

      // Get first data parser
      if (impl.dataParsers.isNotEmpty) {
        final parser = impl.dataParsers.values.first;
        final json = parser.toJson();
        final restored = DataParser.fromJson(json);

        expect(restored.type, equals(parser.type));
        expect(restored.config, equals(parser.config));
      }
    });

    test('AuthenticationConfig toJson/fromJson should be reversible', () async {
      final impl = await DeviceImplementationLoader.load(
        'xiaomi_smart_band_10',
      );

      final json = impl.authentication.toJson();
      final restored = AuthenticationConfig.fromJson(json);

      expect(restored.protocol, equals(impl.authentication.protocol));
      expect(restored.config, equals(impl.authentication.config));
    });

    test('cache should return same instance on multiple calls', () async {
      final first = await DeviceImplementationLoader.load('generic');
      final second = await DeviceImplementationLoader.load('generic');

      expect(identical(first, second), isTrue);
    });

    test('clearCache() should force reload with different instance', () async {
      final first = await DeviceImplementationLoader.load('generic');
      DeviceImplementationLoader.clearCache();
      final second = await DeviceImplementationLoader.load('generic');

      expect(identical(first, second), isFalse);
      expect(
        first.services.length,
        equals(second.services.length),
      ); // Same data
    });

    test('xiaomi_smart_band_10 should have FE95 service defined', () async {
      final impl = await DeviceImplementationLoader.load(
        'xiaomi_smart_band_10',
      );
      final serviceUuids =
          impl.services.values.map((final s) => s.uuid.toUpperCase()).toSet();

      expect(serviceUuids, contains('0000FE95-0000-1000-8000-00805F9B34FB'));
    });

    test('generic should have multiple standard services', () async {
      final impl = await DeviceImplementationLoader.loadGeneric();
      final serviceUuids =
          impl.services.values.map((final s) => s.uuid.toUpperCase()).toSet();

      // Should have at least these standard services
      expect(
        serviceUuids,
        contains('0000180F-0000-1000-8000-00805F9B34FB'),
      ); // Battery
      expect(
        serviceUuids,
        contains('0000180D-0000-1000-8000-00805F9B34FB'),
      ); // Heart Rate

      // Should have at least 2 services (removed 180A as not verified in generic.json)
      expect(impl.services.length, greaterThanOrEqualTo(2));
    });
  });
}
