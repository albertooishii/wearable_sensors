import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/storage/discovered_device_storage.dart';
import 'package:wearable_sensors/src/internal/storage/shared_preferences_discovered_device_storage.dart';
import 'package:wearable_sensors/src/api/models/wearable_device.dart';
import 'package:wearable_sensors/src/api/enums/connection_state.dart';

void main() {
  group('DiscoveredDeviceStorage Tests', () {
    late DiscoveredDeviceStorage storage;

    setUp(() {
      // Use MemoryDiscoveredDeviceStorage for testing (doesn't require SharedPreferences)
      storage = MemoryDiscoveredDeviceStorage();
    });

    test('initialize() should complete without error', () async {
      expect(() => storage.initialize(), returnsNormally);
    });

    test('saveDevice() should save a device', () async {
      await storage.initialize();

      final device = const WearableDevice(
        deviceId: 'test-device-1',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Test Device',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device);

      final retrieved = await storage.getDevice('AA:BB:CC:DD:EE:FF');
      expect(retrieved, isNotNull);
      expect(retrieved!.deviceId, 'test-device-1');
    });

    test('getDevice() should return null for non-existent device', () async {
      await storage.initialize();

      final device = await storage.getDevice('FF:FF:FF:FF:FF:FF');
      expect(device, isNull);
    });

    test('getAllDevices() should return all saved devices', () async {
      await storage.initialize();

      final device1 = const WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:01',
        name: 'Device 1',
        connectionState: ConnectionState.disconnected,
      );

      final device2 = const WearableDevice(
        deviceId: 'device-2',
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Device 2',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device1);
      await storage.saveDevice(device2);

      final allDevices = await storage.getAllDevices();
      expect(allDevices.length, 2);
      expect(allDevices.any((d) => d.deviceId == 'device-1'), true);
      expect(allDevices.any((d) => d.deviceId == 'device-2'), true);
    });

    test('deleteDevice() should remove a device', () async {
      await storage.initialize();

      final device = const WearableDevice(
        deviceId: 'test-device',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Test Device',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device);
      expect(await storage.getDevice('AA:BB:CC:DD:EE:FF'), isNotNull);

      await storage.deleteDevice('AA:BB:CC:DD:EE:FF');
      expect(await storage.getDevice('AA:BB:CC:DD:EE:FF'), isNull);
    });

    test('saveDevice() should update existing device by MAC', () async {
      await storage.initialize();

      final device1 = const WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Device 1 Name',
        connectionState: ConnectionState.disconnected,
      );

      final device2 = const WearableDevice(
        deviceId: 'device-1-updated',
        macAddress: 'AA:BB:CC:DD:EE:FF', // Same MAC
        name: 'Device 1 Updated',
        connectionState: ConnectionState.connected,
      );

      await storage.saveDevice(device1);
      await storage.saveDevice(device2);

      final all = await storage.getAllDevices();
      expect(all.length, 1); // Should still have only 1 device
      expect(all.first.name, 'Device 1 Updated');
    });

    test('cleanupAll() should remove all devices', () async {
      await storage.initialize();

      final device1 = const WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:01',
        name: 'Device 1',
        connectionState: ConnectionState.disconnected,
      );

      final device2 = const WearableDevice(
        deviceId: 'device-2',
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Device 2',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device1);
      await storage.saveDevice(device2);

      expect((await storage.getAllDevices()).length, 2);

      await storage.cleanupAll();

      expect((await storage.getAllDevices()).length, 0);
    });

    test('getStats() should return correct statistics', () async {
      await storage.initialize();

      final device1 = const WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:01',
        name: 'Device 1',
        connectionState: ConnectionState.disconnected,
      );

      final device2 = const WearableDevice(
        deviceId: 'device-2',
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Device 2',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device1);
      await storage.saveDevice(device2);

      final stats = await storage.getStats();
      expect(stats['device_count'], 2);
      expect(stats.containsKey('storage_type'), true);
    });
    test('Multiple devices with lastDiscoveredAt', () async {
      await storage.initialize();

      final now = DateTime.now();

      final device = WearableDevice(
        deviceId: 'test-device',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Test Device',
        connectionState: ConnectionState.disconnected,
        lastDiscoveredAt: now,
      );

      await storage.saveDevice(device);

      final retrieved = await storage.getDevice('AA:BB:CC:DD:EE:FF');
      expect(retrieved!.lastDiscoveredAt, isNotNull);
    });
  });
}
