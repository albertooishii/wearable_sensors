import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../api/models/wearable_device.dart';
import 'discovered_device_storage.dart';

/// Implementación de [DiscoveredDeviceStorage] usando SharedPreferences
///
/// **Storage Strategy: PERMANENT CACHE**
///
/// Almacena dispositivos descubiertos con sus servicios BLE en SharedPreferences.
/// La caché NUNCA expira porque:
/// - MAC address es único y permanente por dispositivo
/// - Servicios BLE no cambian para el mismo MAC
/// - La única razón para eliminar es unpair() (manual)
///
/// **Storage Format:**
/// ```
/// Key: "wearable_sensors_discovered_devices"
/// Value: JSON Map {
///   "AA:BB:CC:DD:EE:FF": { WearableDevice.toJson() },
///   "11:22:33:44:55:66": { WearableDevice.toJson() },
///   ...
/// }
/// ```
///
/// **Performance:**
/// - Lectura de getBondedDevices() + auto-enrich: O(n) donde n = bonded devices
/// - Lookups individuales: O(1) - lectura JSON local
/// - Escrituras: O(n) - reescribir todo el mapa (OK para <1000 devices)
///
/// **Concurrencia:**
/// SharedPreferences no es thread-safe. Las llamadas se cuelan internamente,
/// pero es seguro llamar desde múltiples contextos async.
class SharedPreferencesDiscoveredDeviceStorage
    implements DiscoveredDeviceStorage {
  static const String _storageKey = 'wearable_sensors_discovered_devices';

  late SharedPreferences _prefs;

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveDevice(WearableDevice device) async {
    try {
      final macAddress = device.macAddress;
      if (macAddress == null) {
        throw DiscoveredDeviceStorageException(
          'Cannot save device without MAC address',
        );
      }

      // Leer mapa actual
      final devicesJson = _prefs.getString(_storageKey) ?? '{}';
      final Map<String, dynamic> devicesMap =
          jsonDecode(devicesJson) as Map<String, dynamic>;

      // Guardar/actualizar dispositivo
      devicesMap[macAddress] = device.toJson();

      // Persistir
      await _prefs.setString(_storageKey, jsonEncode(devicesMap));
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error saving device ${device.macAddress}',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<WearableDevice?> getDevice(String macAddress) async {
    try {
      final devicesJson = _prefs.getString(_storageKey) ?? '{}';
      final Map<String, dynamic> devicesMap =
          jsonDecode(devicesJson) as Map<String, dynamic>;

      final deviceJson = devicesMap[macAddress];
      if (deviceJson == null) return null;

      return WearableDevice.fromJson(deviceJson as Map<String, dynamic>);
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error reading device $macAddress',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<WearableDevice>> getAllDevices() async {
    try {
      final devicesJson = _prefs.getString(_storageKey) ?? '{}';
      final Map<String, dynamic> devicesMap =
          jsonDecode(devicesJson) as Map<String, dynamic>;

      return devicesMap.values
          .map((json) => WearableDevice.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error reading all devices',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> deleteDevice(String macAddress) async {
    try {
      final devicesJson = _prefs.getString(_storageKey) ?? '{}';
      final Map<String, dynamic> devicesMap =
          jsonDecode(devicesJson) as Map<String, dynamic>;

      final wasPresent = devicesMap.containsKey(macAddress);
      if (wasPresent) {
        devicesMap.remove(macAddress);
        await _prefs.setString(_storageKey, jsonEncode(devicesMap));
      }

      return wasPresent;
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error deleting device $macAddress',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> cleanupAll() async {
    try {
      await _prefs.remove(_storageKey);
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error cleaning up all devices',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    try {
      final devicesJson = _prefs.getString(_storageKey) ?? '{}';
      final Map<String, dynamic> devicesMap =
          jsonDecode(devicesJson) as Map<String, dynamic>;

      // Contar servicios totales
      int totalServices = 0;
      int devicesWithServices = 0;

      for (final json in devicesMap.values) {
        final device = WearableDevice.fromJson(json as Map<String, dynamic>);
        if (device.discoveredServices.isNotEmpty) {
          devicesWithServices++;
          totalServices += device.discoveredServices.length;
        }
      }

      return {
        'device_count': devicesMap.length,
        'devices_with_services': devicesWithServices,
        'total_services': totalServices,
        'storage_key': _storageKey,
        'estimated_size_bytes': devicesJson.length,
      };
    } catch (e, st) {
      throw DiscoveredDeviceStorageException(
        'Error getting stats',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

/// Implementación en-memory para testing (no persiste)
///
/// Useful para:
/// - Unit tests (sin dependencias externas)
/// - Testing de lógica sin I/O
/// - Aislar storage behavior
class MemoryDiscoveredDeviceStorage implements DiscoveredDeviceStorage {
  final Map<String, WearableDevice> _devices = {};

  @override
  Future<void> initialize() async {
    _devices.clear();
  }

  @override
  Future<void> saveDevice(WearableDevice device) async {
    final macAddress = device.macAddress;
    if (macAddress == null) {
      throw DiscoveredDeviceStorageException(
        'Cannot save device without MAC address',
      );
    }
    _devices[macAddress] = device;
  }

  @override
  Future<WearableDevice?> getDevice(String macAddress) async {
    return _devices[macAddress];
  }

  @override
  Future<List<WearableDevice>> getAllDevices() async {
    return _devices.values.toList();
  }

  @override
  Future<bool> deleteDevice(String macAddress) async {
    return _devices.remove(macAddress) != null;
  }

  @override
  Future<void> cleanupAll() async {
    _devices.clear();
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    int totalServices = 0;
    int devicesWithServices = 0;

    for (final device in _devices.values) {
      if (device.discoveredServices.isNotEmpty) {
        devicesWithServices++;
        totalServices += device.discoveredServices.length;
      }
    }

    return {
      'device_count': _devices.length,
      'devices_with_services': devicesWithServices,
      'total_services': totalServices,
      'storage_type': 'memory',
    };
  }
}
