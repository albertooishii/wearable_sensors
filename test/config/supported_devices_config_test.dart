// 🧪 Tests de validación de arquitectura - SupportedDevicesConfig
// Verifica que la configuración modular es consistente y completa

import 'package:wearable_sensors/src/internal/config/supported_devices_config.dart';
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ✅ Inicializar binding de Flutter para cargar assets
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SupportedDevicesConfig Architecture Validation', () {
    setUp(() {
      // Limpiar cache antes de cada test
      SupportedDevicesConfig.clearCache();
      DeviceImplementationLoader.clearCache();
    });

    test('All patterns have corresponding JSON implementations', () async {
      // Obtener todos los device types de los patterns
      final deviceTypes = [
        'xiaomi_smart_band_9',
        'xiaomi_smart_band_10',
        // Agregar aquí nuevos device types cuando se agreguen
      ];

      // Verificar que cada device type tiene su JSON
      for (final deviceType in deviceTypes) {
        expect(
          () async => await DeviceImplementationLoader.load(deviceType),
          returnsNormally,
          reason:
              '$deviceType.json should exist in assets/device_implementations/',
        );

        // Verificar que el JSON es válido
        final impl = await DeviceImplementationLoader.load(deviceType);
        expect(impl.deviceType, deviceType);
        expect(impl.displayName, isNotEmpty);
        expect(impl.authentication.protocol, isNotEmpty);
      }
    });

    test('detectDevice returns null for unsupported devices', () async {
      final unsupportedNames = [
        'Mi Band 6 ABC123',
        'Mi Band 7 DEF456',
        'Some Random Device',
        'Unknown Wearable XYZ789',
      ];

      for (final name in unsupportedNames) {
        final config = await SupportedDevicesConfig.detectDevice(name);
        expect(
          config,
          isNull,
          reason: '$name should not be detected as supported',
        );
      }
    });

    test('detectDevice recognizes Xiaomi Smart Band 9', () async {
      final testNames = [
        'Xiaomi Smart Band 9 A1B2',
        'Xiaomi Smart Band 9 1234',
        'Xiaomi Smart Band 9 FFFF',
      ];

      for (final name in testNames) {
        final config = await SupportedDevicesConfig.detectDevice(name);
        expect(config, isNotNull, reason: '$name should be recognized');
        expect(config!.deviceType, 'xiaomi_smart_band_9');
        expect(config.displayName, contains('Smart Band 9'));
        expect(config.requiresAuth, isTrue);
        expect(
          config.authProtocol,
          'xiaomi_spp',
        ); // Both use xiaomi_spp protocol
      }
    });

    test('detectDevice recognizes Xiaomi Smart Band 10', () async {
      final testNames = [
        'Xiaomi Smart Band 10 A1B2',
        'Xiaomi Smart Band 10 1234',
        'Xiaomi Smart Band 10 FFFF',
      ];

      for (final name in testNames) {
        final config = await SupportedDevicesConfig.detectDevice(name);
        expect(config, isNotNull, reason: '$name should be recognized');
        expect(config!.deviceType, 'xiaomi_smart_band_10');
        expect(config.displayName, contains('Smart Band 10'));
        expect(config.requiresAuth, isTrue);
        expect(
          config.authProtocol,
          'xiaomi_spp',
        ); // Both use xiaomi_spp protocol
      }
    });

    test('isSupported works with pattern matching only (fast)', () {
      // Sync check - no I/O
      expect(
        SupportedDevicesConfig.isSupported('Xiaomi Smart Band 9 A1B2'),
        isTrue,
      );
      expect(
        SupportedDevicesConfig.isSupported('Xiaomi Smart Band 10 1234'),
        isTrue,
      );
      expect(SupportedDevicesConfig.isSupported('Mi Band 6 ABC123'), isFalse);
      expect(SupportedDevicesConfig.isSupported('Random Device'), isFalse);
    });

    test('getDeviceType returns correct type without loading JSON', () {
      // Sync check - no I/O
      expect(
        SupportedDevicesConfig.getDeviceType('Xiaomi Smart Band 9 A1B2'),
        'xiaomi_smart_band_9',
      );
      expect(
        SupportedDevicesConfig.getDeviceType('Xiaomi Smart Band 10 1234'),
        'xiaomi_smart_band_10',
      );
      expect(SupportedDevicesConfig.getDeviceType('Mi Band 6 ABC123'), isNull);
    });

    test('requiresAuth loads JSON and checks authentication', () async {
      // Async check - loads JSON
      expect(
        await SupportedDevicesConfig.requiresAuth('Xiaomi Smart Band 9 A1B2'),
        isTrue,
      );
      expect(
        await SupportedDevicesConfig.requiresAuth('Xiaomi Smart Band 10 1234'),
        isTrue,
      );
      expect(
        await SupportedDevicesConfig.requiresAuth('Mi Band 6 ABC123'),
        isFalse, // Not supported, returns false
      );
    });

    test('getSupportedXiaomiModels returns non-empty list', () async {
      final models = await SupportedDevicesConfig.getSupportedXiaomiModels();

      expect(models, isNotEmpty);
      expect(models.length, greaterThanOrEqualTo(2)); // At least Band 9 and 10

      // Verify models contain expected names
      expect(models.any((final m) => m.contains('Smart Band 9')), isTrue);
      expect(models.any((final m) => m.contains('Smart Band 10')), isTrue);
    });

    test('cache works correctly', () async {
      // First call should load JSON
      final config1 = await SupportedDevicesConfig.detectDevice(
        'Xiaomi Smart Band 10 A1B2',
      );

      // Second call should use cache
      final config2 = await SupportedDevicesConfig.detectDevice(
        'Xiaomi Smart Band 10 A1B2',
      );

      expect(config1, isNotNull);
      expect(config2, isNotNull);
      expect(config1!.deviceType, config2!.deviceType);
      expect(config1.displayName, config2.displayName);

      // Cache stats should show 1 cached config
      final stats = SupportedDevicesConfig.getCacheStats();
      expect(stats['cached_configs'], 1);
    });

    test('clearCache resets cached configurations', () async {
      // Load config
      await SupportedDevicesConfig.detectDevice('Xiaomi Smart Band 10 A1B2');

      var stats = SupportedDevicesConfig.getCacheStats();
      expect(stats['cached_configs'], 1);

      // Clear cache
      SupportedDevicesConfig.clearCache();

      stats = SupportedDevicesConfig.getCacheStats();
      expect(stats['cached_configs'], 0);
    });

    test('JSON metadata matches config expectations', () async {
      // Verify Band 9 JSON
      final band9 = await DeviceImplementationLoader.load(
        'xiaomi_smart_band_9',
      );
      expect(band9.deviceType, 'xiaomi_smart_band_9');
      expect(band9.displayName, isNotEmpty);
      expect(
        band9.authentication.protocol,
        'xiaomi_spp',
      ); // Both use xiaomi_spp

      // Verify Band 10 JSON
      final band10 = await DeviceImplementationLoader.load(
        'xiaomi_smart_band_10',
      );
      expect(band10.deviceType, 'xiaomi_smart_band_10');
      expect(band10.displayName, isNotEmpty);
      expect(
        band10.authentication.protocol,
        'xiaomi_spp',
      ); // Both use xiaomi_spp
    });

    test('No hardcoded metadata in patterns (only in JSONs)', () async {
      // This test verifies that patterns don't have displayName/authProtocol
      // They should only have namePattern and deviceType

      // Load a config to verify it pulls from JSON
      final config = await SupportedDevicesConfig.detectDevice(
        'Xiaomi Smart Band 10 A1B2',
      );

      expect(config, isNotNull);

      // Verify displayName comes from JSON (not hardcoded)
      final impl = await DeviceImplementationLoader.load(config!.deviceType);
      expect(config.displayName, impl.displayName);
      expect(config.authProtocol, impl.authentication.protocol);
    });
  });
}
