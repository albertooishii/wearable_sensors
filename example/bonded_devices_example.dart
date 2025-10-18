/// Example: Using WearableSensors.getBondedDevices()
///
/// This example demonstrates how to get devices that are bonded
/// (paired) at the system level through OS Bluetooth settings.
// ignore_for_file: avoid_print

library;

import 'package:wearable_sensors/wearable_sensors.dart';

Future<void> main() async {
  // Initialize the package
  await WearableSensors.initialize();

  print('=== Getting Bonded Devices ===\n');

  // Get list of devices bonded at system level
  final bondedDevices = await WearableSensors.getBondedDevices();

  if (bondedDevices.isEmpty) {
    print('No bonded devices found.');
    print('\nTip: Pair your wearable device through:');
    print('  - Android: Settings > Bluetooth');
    print('  - iOS: Settings > Bluetooth');
    return;
  }

  print('Found ${bondedDevices.length} bonded device(s):\n');

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

      await WearableSensors.connect(device.deviceId);
      print('✅ Connected successfully!');
    } catch (e) {
      print('❌ Connection failed: $e');
    }
  }
}
