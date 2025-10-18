// 📡 Wearable Sensors Package - Internal Bluetooth Device Model
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

/// Basic information about a scanned Bluetooth device
///
/// Internal model independent of specific Bluetooth libraries.
/// Used for scan results before converting to WearableDevice.
class BluetoothDevice {
  const BluetoothDevice({
    required this.deviceId,
    required this.name,
    required this.services,
    required this.rssi,
    required this.paired,
    required this.isSystemDevice,
  });

  /// Crear desde datos básicos Bluetooth
  factory BluetoothDevice.fromBasicInfo({
    required final String deviceId,
    required final String? name,
    required final List<String> services,
    required final int? rssi,
    required final bool paired,
    required final bool isSystemDevice,
  }) {
    return BluetoothDevice(
      deviceId: deviceId,
      name: name ?? 'Unknown Device',
      services: services,
      rssi: rssi ?? -100,
      paired: paired,
      isSystemDevice: isSystemDevice,
    );
  }

  final String deviceId;
  final String name;
  final List<String> services;
  final int rssi;
  final bool paired;
  final bool isSystemDevice;

  /// Indica si el dispositivo tiene un nombre válido
  bool get hasValidName => name.isNotEmpty && name != 'Unknown Device';

  /// Indica si el dispositivo tiene servicios útiles
  bool get hasServices => services.isNotEmpty;

  /// Obtener servicios formateados para logging
  String get servicesInfo => services.join(', ');

  @override
  String toString() =>
      'BluetoothDevice(deviceId: $deviceId, name: $name, services: $services, rssi: $rssi, paired: $paired, isSystemDevice: $isSystemDevice)';

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is BluetoothDevice &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId;

  @override
  int get hashCode => deviceId.hashCode;
}
