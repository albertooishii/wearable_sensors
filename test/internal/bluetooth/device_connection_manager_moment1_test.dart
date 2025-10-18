import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/storage/shared_preferences_discovered_device_storage.dart';
import 'package:wearable_sensors/src/api/models/wearable_device.dart';
import 'package:wearable_sensors/src/api/enums/connection_state.dart';

void main() {
  group('DeviceConnectionManager - Moment 1 Save Integration', () {
    late MemoryDiscoveredDeviceStorage storage;

    setUp(() async {
      storage = MemoryDiscoveredDeviceStorage();
      await storage.initialize();
    });

    test('Storage injection via setter works correctly', () async {
      final device = const WearableDevice(
        deviceId: 'test-device',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Test Device',
        connectionState: ConnectionState.disconnected,
      );

      await storage.saveDevice(device);

      final retrieved = await storage.getDevice('AA:BB:CC:DD:EE:FF');
      expect(retrieved, isNotNull);
      expect(retrieved!.deviceId, 'test-device');
    });

    test('Moment 1 save pattern - device saved with timestamp', () async {
      final now = DateTime.now();

      final device = WearableDevice(
        deviceId: 'connected-device',
        macAddress: 'AA:BB:CC:DD:EE:01',
        name: 'Connected Device',
        connectionState: ConnectionState.connected,
        lastDiscoveredAt: now,
      );

      // Simulate Moment 1 save after connectAndAuthenticate
      await storage.saveDevice(device);

      final saved = await storage.getDevice('AA:BB:CC:DD:EE:01');
      expect(saved, isNotNull);
      expect(saved!.lastDiscoveredAt, isNotNull);
      expect(saved.connectionState, ConnectionState.connected);
    });

    test('Multiple Moment 1 saves update existing device', () async {
      final device1 = WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Device',
        connectionState: ConnectionState.disconnected,
        lastDiscoveredAt: DateTime(2025, 1, 1, 10, 0),
      );

      await storage.saveDevice(device1);

      // Later connection - Moment 1 save again
      final device2 = WearableDevice(
        deviceId: 'device-1',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        name: 'Device',
        connectionState: ConnectionState.connected,
        lastDiscoveredAt: DateTime(2025, 1, 2, 10, 0),
      );

      await storage.saveDevice(device2);

      final all = await storage.getAllDevices();
      expect(all.length, 1); // Still only 1 device
      expect(all.first.lastDiscoveredAt!.day, 2); // Updated timestamp
      expect(all.first.connectionState, ConnectionState.connected);
    });
  });
}
