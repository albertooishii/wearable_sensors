/// Example: Using WearableSensors.deviceStream()
///
/// This example demonstrates how to get devices that are bonded
/// (paired) at the system level through OS Bluetooth settings using
/// the unified streaming API with device filtering.
// ignore_for_file: avoid_print

library;

import 'package:wearable_sensors/wearable_sensors.dart';

Future<void> main() async {
  // Initialize the package
  await WearableSensors.initialize();

  print('=== Getting Bonded Devices ===\n');

  // Listen to bonded devices stream
  var count = 0;
  WearableSensors.deviceStream(filter: DeviceFilter.bonded).listen(
    (deviceMap) async {
      final bondedDevices = deviceMap.values.toList();

      if (bondedDevices.isEmpty) {
        print('No bonded devices found.');
        print('\nTip: Pair your wearable device through:');
        print('  - Android: Settings > Bluetooth');
        print('  - iOS: Settings > Bluetooth');
        return;
      }

      if (count++ == 0) {
        // Print header on first emission only
        print('Found ${bondedDevices.length} bonded device(s):\n');
      }

      for (final device in bondedDevices) {
        print('📱 ${device.name}');
        print('   ID: ${device.deviceId}');
        print('   MAC: ${device.macAddress}');
        print('   Status: ${device.statusText}');
        print('   Paired to System: ${device.isPairedToSystem}');

        // Check if device is also authenticated with this app
        final isAuthenticated =
            await WearableSensors.isDeviceAuthenticated(device.deviceId);
        print('   App Authenticated: $isAuthenticated');

        if (!isAuthenticated) {
          print('   ⚠️  Need to connect with auth credentials first');
        }
        print('');
      }

      // Example: Connect to first bonded device
      if (bondedDevices.isNotEmpty) {
        final device = bondedDevices.first;
        print('Attempting to connect to ${device.name}...');

        try {
          // Note: Some devices need authentication credentials on first connect
          // await WearableSensors.connect(
          //   device.deviceId,
          //   credentials: AuthCredentials(authKey: 'your_key_here'),
          // );

          WearableSensors.connect(device.deviceId)
              .then((_) => print('✅ Connected successfully!'))
              .catchError((e) => print('❌ Connection failed: $e'));
        } catch (e) {
          print('❌ Connection failed: $e');
        }
      }
    },
    onError: (e) {
      print('❌ Error listening to bonded devices: $e');
    },
  );

  // Keep the app running to listen to the stream
  await Future.delayed(const Duration(seconds: 30));
}
