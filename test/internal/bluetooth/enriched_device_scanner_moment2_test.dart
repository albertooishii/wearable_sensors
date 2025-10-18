import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/api/models/wearable_device.dart';
import 'package:wearable_sensors/src/api/enums/connection_state.dart';
import 'package:wearable_sensors/src/api/models/gatt_service.dart';
import 'package:wearable_sensors/src/internal/storage/shared_preferences_discovered_device_storage.dart';

// Helper to create GattService with minimal required params
GattService _createService(String uuid, String name) {
  return GattService(
    uuid: uuid,
    name: name,
    description: 'Service $name',
    category: 'standard',
    iconName: 'bluetooth',
    colorName: 'blue',
  );
}

void main() {
  group('EnrichedDeviceScanner - Moment 2 Save Integration', () {
    late MemoryDiscoveredDeviceStorage storage;

    setUp(() async {
      storage = MemoryDiscoveredDeviceStorage();
      await storage.initialize();
    });

    test('Moment 2 save pattern - device enriched with services', () async {
      // Basic device (from Moment 1)
      final device1 = WearableDevice(
        deviceId: 'scanner-device',
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Scanner Device',
        connectionState: ConnectionState.connected,
        lastDiscoveredAt: DateTime(2025, 1, 1, 10, 0),
      );

      await storage.saveDevice(device1);

      // After enrichment with services (Moment 2)
      final service = _createService('180A', 'Device Information');

      final device2 = WearableDevice(
        deviceId: 'scanner-device',
        macAddress: 'AA:BB:CC:DD:EE:02',
        name: 'Scanner Device',
        connectionState: ConnectionState.connected,
        discoveredServices: [service],
        lastDiscoveredAt: DateTime(2025, 1, 1, 11, 0), // Updated timestamp
      );

      await storage.saveDevice(device2); // Moment 2 save

      final enriched = await storage.getDevice('AA:BB:CC:DD:EE:02');
      expect(enriched, isNotNull);
      expect(enriched!.discoveredServices.length, 1);
      expect(enriched.discoveredServices.first.uuid, '180A');
      expect(enriched.isEnriched, true);
    });

    test('Moment 2 updates device with multiple services', () async {
      // Device after Moment 1
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'multi-service-device',
          macAddress: 'AA:BB:CC:DD:EE:03',
          name: 'Multi Service Device',
          connectionState: ConnectionState.connected,
          lastDiscoveredAt: DateTime(2025, 1, 1, 10, 0),
        ),
      );

      // After Moment 2 enrichment with multiple services
      final services = [
        _createService('180A', 'Device Information'),
        _createService('180F', 'Battery Service'),
        _createService('180D', 'Heart Rate'),
      ];

      await storage.saveDevice(
        WearableDevice(
          deviceId: 'multi-service-device',
          macAddress: 'AA:BB:CC:DD:EE:03',
          name: 'Multi Service Device',
          connectionState: ConnectionState.connected,
          discoveredServices: services,
          lastDiscoveredAt: DateTime(2025, 1, 1, 11, 0),
        ),
      );

      final retrieved = await storage.getDevice('AA:BB:CC:DD:EE:03');
      expect(retrieved!.discoveredServices.length, 3);
      expect(retrieved.isEnriched, true);
    });

    test('Multiple Moment 1 and Moment 2 cycles', () async {
      const macAddress = 'AA:BB:CC:DD:EE:04';

      // Cycle 1 - Moment 1
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'cycle-device',
          macAddress: macAddress,
          name: 'Cycle Device',
          connectionState: ConnectionState.connected,
          lastDiscoveredAt: DateTime(2025, 1, 1, 10, 0),
        ),
      );

      // Cycle 1 - Moment 2
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'cycle-device',
          macAddress: macAddress,
          name: 'Cycle Device',
          connectionState: ConnectionState.connected,
          discoveredServices: [
            _createService('180A', 'Device Information'),
          ],
          lastDiscoveredAt: DateTime(2025, 1, 1, 11, 0),
        ),
      );

      var device = await storage.getDevice(macAddress);
      expect(device!.discoveredServices.length, 1);

      // Cycle 2 - Moment 1 (reconnect)
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'cycle-device',
          macAddress: macAddress,
          name: 'Cycle Device',
          connectionState: ConnectionState.connected,
          lastDiscoveredAt: DateTime(2025, 1, 2, 10, 0),
        ),
      );

      device = await storage.getDevice(macAddress);
      expect(device!.lastDiscoveredAt!.day, 2);
      // Services from Moment 2 of cycle 1 are preserved until Moment 2 of cycle 2

      // Cycle 2 - Moment 2 (refresh services)
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'cycle-device',
          macAddress: macAddress,
          name: 'Cycle Device',
          connectionState: ConnectionState.connected,
          discoveredServices: [
            _createService('180A', 'Device Information'),
            _createService('180F', 'Battery Service'),
          ],
          lastDiscoveredAt: DateTime(2025, 1, 2, 11, 0),
        ),
      );

      device = await storage.getDevice(macAddress);
      expect(device!.discoveredServices.length, 2);
      expect(device.lastDiscoveredAt!.day, 2);
    });

    test('Storage cleanup removes all devices including enriched', () async {
      // Add basic device (Moment 1)
      await storage.saveDevice(
        const WearableDevice(
          deviceId: 'device-1',
          macAddress: 'AA:BB:CC:DD:EE:05',
          name: 'Device 1',
          connectionState: ConnectionState.connected,
        ),
      );

      // Enrich with services (Moment 2)
      await storage.saveDevice(
        WearableDevice(
          deviceId: 'device-1',
          macAddress: 'AA:BB:CC:DD:EE:05',
          name: 'Device 1',
          connectionState: ConnectionState.connected,
          discoveredServices: [
            _createService('180A', 'Device Information'),
          ],
        ),
      );

      expect((await storage.getAllDevices()).length, 1);
      expect((await storage.getDevice('AA:BB:CC:DD:EE:05'))!.isEnriched, true);

      // Cleanup
      await storage.cleanupAll();

      expect((await storage.getAllDevices()).length, 0);
      expect(await storage.getDevice('AA:BB:CC:DD:EE:05'), isNull);
    });
  });
}
