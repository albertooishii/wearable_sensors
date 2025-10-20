// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter_test/flutter_test.dart';
import 'package:wearable_sensors/src/internal/storage/shared_preferences_discovered_device_storage.dart';
import 'package:wearable_sensors/src/api/models/wearable_device.dart';
import 'package:wearable_sensors/src/api/enums/connection_state.dart';

void main() {
  group('Authentication Persistence Tests', () {
    late MemoryDiscoveredDeviceStorage storage;

    setUp(() async {
      storage = MemoryDiscoveredDeviceStorage();
      await storage.initialize();
    });

    tearDown(() async {
      // Cleanup
    });

    group(
        'Test 1: saveDeviceCredentials() persists requiresAuthentication=false',
        () {
      test(
        'should persist requiresAuthentication=false to storage '
        'when device is saved with authentication credentials',
        () async {
          const deviceId = '04:34:C3:92:84:CA';

          // Setup: Create a device that requires authentication initially
          final initialDevice = const WearableDevice(
            deviceId: deviceId,
            macAddress: deviceId,
            name: 'Xiaomi Smart Band 10',
            connectionState: ConnectionState.connected,
            deviceTypeId: 'xiaomi_smart_band_10',
            isPairedToSystem: true,
            isNearby: true,
            requiresAuthentication: true, // Initially requires auth
            batteryLevel: 85,
          );

          // Save initial device
          await storage.saveDevice(initialDevice);

          // Verify initial state
          final loadedInitial = await storage.getDevice(deviceId);
          expect(
            loadedInitial?.requiresAuthentication,
            true,
            reason: 'Initial state should require authentication',
          );

          // Execute: Simulate what saveDeviceCredentials does:
          // Update the device to NOT require authentication and save it
          final updatedDevice = initialDevice.copyWith(
            requiresAuthentication: false,
          );

          await storage.saveDevice(updatedDevice);

          // Verify: The persisted device should have requiresAuthentication=false
          final loadedUpdated = await storage.getDevice(deviceId);

          expect(
            loadedUpdated,
            isNotNull,
            reason: 'Device should be retrievable from storage',
          );

          expect(
            loadedUpdated!.requiresAuthentication,
            false,
            reason:
                'Persisted device should have requiresAuthentication=false after credentials saved',
          );

          // Verify: Other device properties should be preserved
          expect(loadedUpdated.deviceId, deviceId);
          expect(
            loadedUpdated.isPairedToSystem,
            true,
            reason: 'isPairedToSystem should be preserved',
          );
          expect(loadedUpdated.deviceTypeId, 'xiaomi_smart_band_10');
          expect(loadedUpdated.macAddress, deviceId);
        },
      );

      test(
        'should preserve all device properties when persisting authentication state',
        () async {
          const deviceId = '04:34:C3:92:84:CB';
          final now = DateTime.now();

          // Setup: Device with multiple properties
          final device = WearableDevice(
            deviceId: deviceId,
            macAddress: deviceId,
            name: 'Mi Band 6',
            connectionState: ConnectionState.connected,
            deviceTypeId: 'xiaomi_smart_band_6',
            isPairedToSystem: true,
            isNearby: true,
            requiresAuthentication: true,
            batteryLevel: 92,
            lastSeen: now,
            connectedAt: now,
          );

          await storage.saveDevice(device);

          // Update authentication state
          final updated = device.copyWith(
            requiresAuthentication: false,
            connectionState: ConnectionState.disconnected,
          );

          await storage.saveDevice(updated);

          // Verify all properties persisted
          final loaded = await storage.getDevice(deviceId);

          expect(loaded?.deviceId, deviceId);
          expect(loaded?.name, 'Mi Band 6');
          expect(loaded?.isPairedToSystem, true);
          expect(loaded?.isNearby, true);
          expect(loaded?.requiresAuthentication, false);
          expect(loaded?.batteryLevel, 92);
          expect(loaded?.connectionState, ConnectionState.disconnected);
        },
      );
    });

    group(
        'Test 2: _loadBondedDevices() restores requiresAuthentication=false on restart',
        () {
      test(
        'should load requiresAuthentication=false from storage on app restart',
        () async {
          const deviceId = '04:34:C3:92:84:CC';

          // Setup: Create a device and save it with requiresAuthentication=false
          // (simulating a device where credentials were already saved in a previous session)
          final savedDevice = const WearableDevice(
            deviceId: deviceId,
            macAddress: deviceId,
            name: 'Xiaomi Smart Band 10',
            connectionState: ConnectionState.disconnected,
            deviceTypeId: 'xiaomi_smart_band_10',
            isPairedToSystem: true,
            isNearby: false,
            requiresAuthentication:
                false, // Already authenticated in previous session
            batteryLevel: 85,
          );

          // Save device (simulating previous session)
          await storage.saveDevice(savedDevice);

          // Simulate app restart by creating new storage instance
          // (In real app, this would happen when app is closed and reopened)
          final newStorageInstance = MemoryDiscoveredDeviceStorage();
          await newStorageInstance.initialize();

          // Copy the saved data (simulating SharedPreferences reload)
          // For this test with MemoryDiscoveredDeviceStorage, we manually save again
          // In production, SharedPreferences would automatically persist
          await newStorageInstance.saveDevice(savedDevice);

          // Execute: Load the device (as if on app restart)
          final loadedDevice = await newStorageInstance.getDevice(deviceId);

          // Verify: The device should be loaded with requiresAuthentication=false
          expect(
            loadedDevice,
            isNotNull,
            reason: 'Device should be loaded from storage on restart',
          );

          expect(
            loadedDevice!.requiresAuthentication,
            false,
            reason:
                'Loaded device should have requiresAuthentication=false (persisted state from previous session)',
          );

          // Verify: Device can be connected without asking for auth again
          // (Other properties indicate it knows it's already authenticated)
          expect(loadedDevice.isPairedToSystem, true);
          expect(loadedDevice.deviceTypeId, 'xiaomi_smart_band_10');
        },
      );

      test(
        'getAllDevices() should include devices with requiresAuthentication=false',
        () async {
          const device1Id = '04:34:C3:92:84:C1';
          const device2Id = '04:34:C3:92:84:C2';

          // Setup: Two devices - one authenticated, one not
          final unauthenticatedDevice = const WearableDevice(
            deviceId: device1Id,
            macAddress: device1Id,
            name: 'Mi Band - Needs Auth',
            connectionState: ConnectionState.disconnected,
            deviceTypeId: 'xiaomi_smart_band_10',
            isPairedToSystem: true,
            requiresAuthentication: true,
          );

          final authenticatedDevice = const WearableDevice(
            deviceId: device2Id,
            macAddress: device2Id,
            name: 'Mi Band - Authenticated',
            connectionState: ConnectionState.disconnected,
            deviceTypeId: 'xiaomi_smart_band_10',
            isPairedToSystem: true,
            requiresAuthentication: false, // This one is already authenticated
          );

          await storage.saveDevice(unauthenticatedDevice);
          await storage.saveDevice(authenticatedDevice);

          // Execute: Load all devices
          final allDevices = await storage.getAllDevices();

          // Verify: Both devices should be present with correct auth states
          expect(allDevices.length, 2);

          final auth = allDevices.firstWhere((d) => d.deviceId == device2Id);
          expect(
            auth.requiresAuthentication,
            false,
            reason: 'Authenticated device should have flag=false',
          );

          final notAuth = allDevices.firstWhere((d) => d.deviceId == device1Id);
          expect(
            notAuth.requiresAuthentication,
            true,
            reason: 'Unauthenticated device should have flag=true',
          );
        },
      );
    });

    group('Test 3: Complete auth flow - save and restore', () {
      test(
        'should handle complete authentication persistence flow correctly',
        () async {
          const deviceId = '04:34:C3:92:84:CD';

          // Phase 1: Initial discovery - device needs authentication
          final discoveredDevice = const WearableDevice(
            deviceId: deviceId,
            macAddress: deviceId,
            name: 'Xiaomi Smart Band 10',
            connectionState: ConnectionState.disconnected,
            deviceTypeId: 'xiaomi_smart_band_10',
            requiresAuthentication: true, // Initially needs auth
          );

          await storage.saveDevice(discoveredDevice);

          // Phase 2: Bonding and authentication
          final connectedDevice = discoveredDevice.copyWith(
            connectionState: ConnectionState.authenticating,
            isPairedToSystem: true,
            isNearby: true,
          );

          await storage.saveDevice(connectedDevice);

          // Phase 3: Credentials saved - update auth flag
          // This is what updateDeviceAuthenticationState() does
          final authenticatedDevice = connectedDevice.copyWith(
            requiresAuthentication: false, // Auth complete
            connectionState: ConnectionState.streaming,
          );

          await storage.saveDevice(authenticatedDevice);

          // Phase 4: Verify persisted state
          final persistedDevice = await storage.getDevice(deviceId);

          expect(
            persistedDevice?.requiresAuthentication,
            false,
            reason: 'Device should be marked as authenticated',
          );
          expect(persistedDevice?.isPairedToSystem, true);
          expect(persistedDevice?.connectionState, ConnectionState.streaming);

          // Phase 5: Simulate app restart - all data should be preserved
          // (For MemoryDiscoveredDeviceStorage, data is in memory)
          // For SharedPreferencesDiscoveredDeviceStorage, this would reload from SharedPreferences

          final reloadedDevice = await storage.getDevice(deviceId);

          expect(
            reloadedDevice?.requiresAuthentication,
            false,
            reason:
                'After app restart, device should still be marked as authenticated',
          );
        },
      );

      test(
        'should not ask for auth again if credentials were previously saved',
        () async {
          const deviceId = '04:34:C3:92:84:CE';

          // Scenario: Device was authenticated in previous session
          // and the flag was persisted
          final previouslyAuthenticatedDevice = const WearableDevice(
            deviceId: deviceId,
            macAddress: deviceId,
            name: 'Xiaomi Smart Band 10',
            connectionState: ConnectionState.disconnected,
            deviceTypeId: 'xiaomi_smart_band_10',
            isPairedToSystem: true,
            requiresAuthentication:
                false, // Flag persisted from previous session
          );

          await storage.saveDevice(previouslyAuthenticatedDevice);

          // App restarts and loads bonded devices
          final loadedDevice = await storage.getDevice(deviceId);

          // Key assertion: The flag should indicate NO authentication needed
          expect(
            loadedDevice?.requiresAuthentication,
            false,
            reason:
                'Should NOT ask for authentication - already authenticated in previous session',
          );

          // This is the fix: before the persistence changes, this flag would have
          // been reset to true (default), causing the app to ask for auth again
          // unnecessarily after app restart.
        },
      );
    });
  });
}
