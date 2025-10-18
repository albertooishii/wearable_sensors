import '../../api/enums/connection_state.dart';
import '../../api/enums/sensor_type.dart' as api;
import '../../api/models/device_capabilities.dart';
import '../../api/models/device_types_loader.dart';
import '../../api/models/wearable_device.dart';
import '../models/bluetooth_device.dart';

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
  /// **Note:** Since [BluetoothDevice] is a minimal scan result model,
  /// many fields are set to defaults. Full device state should be queried
  /// after connection.
  static Future<WearableDevice> fromInternal(
    BluetoothDevice internal, {
    bool? isSavedDevice,
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

    return WearableDevice(
      deviceId: internal.deviceId,
      connectionState: internal.paired
          ? ConnectionState.disconnected
          : ConnectionState.disconnected,
      name: internal.name.isNotEmpty ? internal.name : null,
      deviceTypeId: detectedDeviceTypeId,
      macAddress: internal.deviceId,
      batteryLevel: null, // Not available from scan
      lastDataTimestamp: null,
      lastSeen: DateTime.now(),
      connectedAt: null,
      discoveredServices: internal.services,
      isSavedDevice: isSavedDevice ?? false,
      isPairedToSystem: internal.paired,
      rssi: internal.rssi,
    );
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
}
