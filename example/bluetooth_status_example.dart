/// Example: Using WearableSensors.getBluetoothStatus()
///
/// This example demonstrates how to check Bluetooth status before
/// attempting to scan or connect to devices.
// ignore_for_file: avoid_print

library;

import 'package:wearable_sensors/wearable_sensors.dart';

Future<void> main() async {
  // Initialize the package
  await WearableSensors.initialize();

  // Get current Bluetooth status
  final status = await WearableSensors.getBluetoothStatus();

  print('=== Bluetooth Status ===');
  print('Enabled: ${status.isEnabled}');
  print('Available: ${status.isAvailable}');
  print('Has Permissions: ${status.hasPermissions}');
  print('Scanning: ${status.isScanning}');
  print('Ready: ${status.isReady}');
  print('Status Message: ${status.statusMessage}');

  // Check if ready to use
  if (!status.isReady) {
    if (!status.isAvailable) {
      print('\n❌ Bluetooth not available on this device');
    } else if (!status.isEnabled) {
      print('\n⚠️ Please enable Bluetooth in system settings');
    } else if (!status.hasPermissions) {
      print('\n⚠️ Please grant Bluetooth permissions');
    }
    return;
  }

  print('\n✅ Bluetooth is ready! You can now scan and connect.');

  // Listen to Bluetooth status changes
  WearableSensors.bluetoothStatusStream.listen((newStatus) {
    print('\n📡 Bluetooth status changed: ${newStatus.statusMessage}');
  });
}
