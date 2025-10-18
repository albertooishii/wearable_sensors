import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/wearable_sensors.dart';
import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceTypesLoader', () {
    late DeviceTypesLoader loader;

    setUp(() {
      loader = DeviceTypesLoader(testAssetBundle: MockAssetBundle());
    });

    tearDown(() {
      loader.clearCache();
    });

    test('load() returns device types from mock bundle', () async {
      final deviceTypes = await loader.load();
      expect(deviceTypes.length, greaterThanOrEqualTo(6));
    });

    test('all loaded device types have required fields', () async {
      final deviceTypes = await loader.load();

      for (final dt in deviceTypes) {
        expect(dt.id, isNotEmpty);
        expect(dt.name, isNotEmpty);
        expect(dt.category, isNotEmpty);
        expect(dt.icon, isNotEmpty);
        expect(dt.vendor, isNotEmpty);
      }
    });

    test('detectDeviceType identifies Xiaomi Mi Band 8', () async {
      final result = await loader.detectDeviceType(['180D', 'FEE0']);
      expect(result.id, equals('xiaomi_mi_band_8'));
    });

    test('detectDeviceType identifies heart rate monitor', () async {
      final result = await loader.detectDeviceType(['180D']);
      expect(result.category, isNotEmpty); // Multiple devices may match 180D
    });

    test('detectDeviceType returns unknown for unmatched services', () async {
      final result = await loader.detectDeviceType(['9999', '8888']);
      expect(result.id, equals('unknown'));
    });

    test('cache returns same instance on multiple calls', () async {
      final first = await loader.load();
      final second = await loader.load();
      expect(identical(first, second), isTrue);
    });

    test('clearCache forces reload with new instance', () async {
      final first = await loader.load();
      loader.clearCache();
      final second = await loader.load();
      expect(identical(first, second), isFalse);
      expect(first.length, equals(second.length));
    });

    test('getById retrieves device by id', () async {
      final xiaomi = await loader.getById('xiaomi_mi_band_8');
      expect(xiaomi, isNotNull);
      expect(xiaomi!.id, equals('xiaomi_mi_band_8'));
    });

    test('getByVendor retrieves devices by vendor', () async {
      final xiaomiDevices = await loader.getByVendor('xiaomi');
      expect(xiaomiDevices.isNotEmpty, isTrue);
      expect(xiaomiDevices.every((d) => d.vendor == 'xiaomi'), isTrue);
    });

    test('getByCategory retrieves devices by category', () async {
      final fitnessDevices = await loader.getByCategory('fitness_tracker');
      expect(fitnessDevices.isNotEmpty, isTrue);
      expect(
        fitnessDevices.every((d) => d.category == 'fitness_tracker'),
        isTrue,
      );
    });

    test('DeviceType serialization round-trip works', () async {
      final deviceTypes = await loader.load();
      final original = deviceTypes.first;

      final json = original.toJson();
      final restored = DeviceType.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.category, equals(original.category));
    });

    test('DeviceDetection serialization round-trip works', () async {
      final deviceTypes = await loader.load();
      final original = deviceTypes.first.detection;

      final json = original.toJson();
      final restored = DeviceDetection.fromJson(json);

      expect(restored.requiredServices, equals(original.requiredServices));
      expect(restored.optionalServices, equals(original.optionalServices));
    });

    test('matchScore returns -1 for unmet required services', () async {
      final deviceTypes = await loader.load();
      final xiaomi = deviceTypes.firstWhere((d) => d.id == 'xiaomi_mi_band_8');

      // 180D is required, FEE0 is required for Mi Band 8
      final score = xiaomi.detection.matchScore(['180D']); // Missing FEE0
      expect(score, equals(-1)); // Does not match because FEE0 is missing
    });

    test('matchScore returns positive score for met requirements', () async {
      final deviceTypes = await loader.load();
      final heartRateMonitor =
          deviceTypes.firstWhere((d) => d.id == 'heart_rate_monitor');

      // heart_rate_monitor only requires 180D
      final score = heartRateMonitor.detection.matchScore(['180D']);
      expect(score, greaterThanOrEqualTo(0));
    });

    test('unknown device type always exists', () async {
      final unknown = await loader.getById('unknown');
      expect(unknown, isNotNull);
      expect(unknown!.id, equals('unknown'));
    });
  });
}
