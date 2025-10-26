import '../../api/enums/connection_state.dart';
import '../../api/enums/authentication_type.dart';
import '../../api/enums/sensor_type.dart' as api;
import '../../api/models/device_capabilities.dart';
import '../../api/models/device_types_loader.dart';
import '../../api/models/wearable_device.dart';
import '../models/bluetooth_device.dart';
import '../utils/xiaomi_device_detection.dart';
import '../storage/discovered_device_storage.dart';
import '../vendors/xiaomi/xiaomi_device_credentials.dart';

/// Adapter that converts between internal BluetoothDevice and public WearableDevice.
///
/// This provides a clean separation between vendor-specific internal models
/// and the unified public API models that consumers interact with.
class DeviceAdapter {
  DeviceAdapter._(); // Prevent instantiation

  /// Converts an internal [BluetoothDevice] to a public [WearableDevice].
  ///
  /// Maps internal bluetooth-specific fields to the public API model,
  /// providing a vendor-agnostic representation.
  ///
  /// **Incluye enriquecimiento de servicios GATT:**
  /// - Si [BluetoothDevice.services] contiene UUIDs, se convierten a [GattService] objects
  /// - Cada UUID se busca en el catálogo GATT para obtener metadatos completos
  /// - El dispositivo retornado incluye `discoveredServices` enriquecidos
  ///
  /// **Saved Device Enrichment (bonded devices only):**
  /// - If [storage] is provided (non-null), this is a bonded device:
  ///   - Try to load saved copy from storage (has discovered services from previous connection)
  ///   - Return saved copy with full services if found
  ///   - If no saved copy exists, return with empty services (normal - first time bonded)
  /// - If [storage] is null, this is a discovered device (no storage lookup)
  ///
  /// **Note:** This is async because it needs to load GATT service metadata.
  static Future<WearableDevice> fromInternal(
    BluetoothDevice internal, {
    DiscoveredDeviceStorage? storage,
  }) async {
    // Detect device type from advertised services using DeviceTypesLoader
    String detectedDeviceTypeId = 'unknown';
    if (internal.services.isNotEmpty) {
      try {
        final loader = DeviceTypesLoader();
        final detectedType = await loader.detectDeviceType(internal.services);
        detectedDeviceTypeId = detectedType.id;
      } catch (e) {
        // Fallback to 'unknown' if detection fails
        detectedDeviceTypeId = 'unknown';
      }
    }

    // ✅ Detect authentication method based on device type
    // For new/unpaired devices, set requiresAuthentication=true if they need auth
    AuthenticationType authMethod = AuthenticationType.none;
    bool requiresAuth = false;

    // Xiaomi devices require AuthKey extraction
    // Use REGEX patterns from Gadgetbridge for reliable detection
    if (_isXiaomiDevice(detectedDeviceTypeId, internal.name)) {
      authMethod = AuthenticationType.xiaomiSpp;

      // Check if device has saved credentials
      // ✅ NEW: Check for saved credentials via public API (requires async)
      // If no credentials saved, mark as requiresAuth=true
      // This will be checked later in _loadBondedDevices via enrichCheckCredentials()
      requiresAuth = !internal.paired;
    }

    // Crear device base
    // ✅ isNearby: true if discovered (storage==null), false if bonded (storage!=null)
    // ✅ CRITICAL: For bonded devices (storage != null), FORCE isPairedToSystem=true
    // because some Android/FlutterBluePlus implementations report paired=false for bonded devices
    final isDiscovered = (storage == null);
    final isBonded = (storage != null);
    final isPaired = isBonded ? true : internal.paired; // Force true for bonded

    final baseDevice = WearableDevice(
      deviceId: internal.deviceId,
      connectionState: isPaired
          ? ConnectionState.disconnected
          : ConnectionState.disconnected,
      name: internal.name.isNotEmpty ? internal.name : null,
      deviceTypeId: detectedDeviceTypeId,
      macAddress: internal.deviceId,
      batteryLevel: null, // Not available from scan
      lastDataTimestamp: null,
      lastSeen: DateTime.now(),
      connectedAt: null,
      lastDiscoveredAt: DateTime.now(), // ✅ Mark when discovered
      discoveredServices: [], // Será enriquecido abajo
      isPairedToSystem: isPaired,
      isNearby: isDiscovered, // ✅ true for discovered, false for bonded
      rssi: internal.rssi,
      requiresAuthentication: requiresAuth,
      authenticationMethod: authMethod,
    );

    // ✅ CRITICAL: Always enrich services before returning if they exist
    // This ensures UI only receives fully-enriched devices
    if (internal.services.isNotEmpty) {
      return await WearableDevice.enrichServicesFromUuids(
        baseDevice,
        internal.services,
      );
    }

    // ✅ For bonded devices, try loading saved copy with services from storage
    if (storage != null) {
      try {
        final savedCopy = await storage.getDevice(internal.deviceId);
        if (savedCopy != null && savedCopy.discoveredServices.isNotEmpty) {
          // ✅ Found saved copy with services - use it!
          // 🔥 CRITICAL: Respect current system bond status (internal.paired)
          // Don't force isPairedToSystem=true - it should reflect actual system status
          return savedCopy.copyWith(
            // Update fresh info from current system device
            lastSeen: DateTime.now(),
            lastDiscoveredAt: DateTime.now(),
            name: internal.name.isNotEmpty ? internal.name : savedCopy.name,
            rssi: internal.rssi,
            isPairedToSystem:
                internal.paired, // ✅ Respect current system status
            isNearby: !internal.paired, // ✅ nearby if NOT bonded to system
          );
        }
      } catch (e) {
        // Silently ignore storage errors - not critical
        // Device will be returned without services (normal for unpaired)
      }
    }

    return baseDevice;
  }

  /// Converts internal device capabilities to public [DeviceCapabilities].
  ///
  /// Maps vendor-specific capability info to the public API format.
  ///
  /// **Note:** This is a placeholder implementation. Full capabilities
  /// detection will be implemented in FASE 5 when device implementations
  /// include full capability metadata.
  static DeviceCapabilities capabilitiesFromInternal(dynamic internalCaps) {
    return const DeviceCapabilities(
      supportedSensors: {
        api.SensorType.battery,
        api.SensorType.heartRate,
        api.SensorType.steps,
      },
      supportsBLE: true,
      supportsClassic: false,
      requiresAuthentication: false,
    );
  }

  /// Maps internal sensor names to public [SensorType] enum.
  ///
  /// Used for converting device capability info and sensor reading types.
  static api.SensorType? mapSensorName(String sensorName) {
    switch (sensorName.toLowerCase()) {
      case 'battery':
        return api.SensorType.battery;
      case 'heart_rate':
      case 'heartrate':
        return api.SensorType.heartRate;
      case 'hrv':
      case 'heart_rate_variability':
        return api.SensorType.heartRateVariability;
      case 'steps':
        return api.SensorType.steps;
      case 'distance':
        return api.SensorType.distance;
      case 'calories':
        return api.SensorType.calories;
      case 'sleep':
        return api.SensorType.sleep;
      case 'spo2':
      case 'blood_oxygen':
        return api.SensorType.bloodOxygen;
      case 'temperature':
      case 'skin_temperature':
        return api.SensorType.skinTemperature;
      case 'stress':
      case 'stress_level':
        return api.SensorType.stressLevel;
      case 'respiratory_rate':
        return api.SensorType.respiratoryRate;
      case 'movement':
        return api.SensorType.movement;
      case 'accelerometer_x':
        return api.SensorType.accelerometerX;
      case 'accelerometer_y':
        return api.SensorType.accelerometerY;
      case 'accelerometer_z':
        return api.SensorType.accelerometerZ;
      default:
        return null; // Unknown sensor type
    }
  }

  /// ✅ Helper: Detect if device is Xiaomi using centralized patterns
  ///
  /// Uses XiaomiDeviceDetection which has all patterns from Gadgetbridge.
  static bool _isXiaomiDevice(String deviceTypeId, String deviceName) {
    // First try: deviceTypeId check
    if (deviceTypeId.toLowerCase().contains('xiaomi')) {
      return true;
    }

    // Second: Use centralized Xiaomi detection patterns
    return XiaomiDeviceDetection.isXiaomiDevice(deviceName);
  }

  /// ✅ NEW: Check if bonded Xiaomi device has saved credentials
  ///
  /// For bonded Xiaomi devices, checks if they have authentication keys saved.
  /// If a device is bonded BUT has no keys, it needs re-authentication.
  ///
  /// **Returns:** true if device has saved credentials, false if needs auth
  static Future<bool> hasXiaomiCredentials(String deviceId) async {
    try {
      // Try to load credentials - if null, device has no auth key
      final credentials = await XiaomiDeviceCredentials.load(deviceId);
      return credentials != null;
    } catch (e) {
      // If check fails, assume no credentials (safer default)
      // Device will be marked as requiresAuthentication=true
      return false;
    }
  }
}
