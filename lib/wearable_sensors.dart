/// Wearable Sensors - Unified API for Wearable Device Integration
///
/// This package provides a simple, vendor-agnostic API for discovering,
/// connecting to, and reading data from wearable devices.
///
/// **Supported Devices:**
/// - Xiaomi Mi Band (6, 7, 8, 9, 10) via BLE
/// - Fitbit devices (planned)
/// - Generic BLE wearables
///
/// **Basic Usage:**
/// ```dart
/// import 'package:wearable_sensors/wearable_sensors.dart';
///
/// // 1. Initialize
/// await WearableSensors.initialize();
///
/// // 2. Scan for devices
/// await for (final device in WearableSensors.scan()) {
///   print('Found: ${device.name}');
/// }
///
/// // 3. Connect
/// await WearableSensors.connect(deviceId);
///
/// // 4. Read sensor data
/// final hr = await WearableSensors.read(deviceId, SensorType.heartRate);
/// print('Heart Rate: ${hr.value} ${hr.unit}');
/// ```
///
/// **License:** Mozilla Public License 2.0
/// **Copyright:** (c) 2025 Alberto Oishi
library;

// ============================================================
// PUBLIC API FACADE
// ============================================================
export 'src/api/wearable_sensors.dart';

// ============================================================
// PUBLIC ENUMS
// ============================================================
export 'src/api/enums/connection_state.dart';
export 'src/api/enums/sensor_type.dart';

// ============================================================
// PUBLIC MODELS
// ============================================================
export 'src/api/models/auth_credentials.dart';
export 'src/api/models/gatt_service.dart'; // ✅ GATT Service model (agnóstico, descubierto en conexión)
export 'src/api/models/bluetooth_status.dart';
export 'src/api/models/device_capabilities.dart';
export 'src/api/models/device_types_loader.dart';
export 'src/api/models/sensor_reading.dart';
export 'src/api/models/wearable_device.dart';

// ============================================================
// PUBLIC SERVICES
// ============================================================
export 'src/api/gatt_services_catalog.dart'; // ✅ GATT Services Catalog

// ============================================================
// PUBLIC EXCEPTIONS
// ============================================================
export 'src/api/exceptions/wearable_exception.dart';
export 'src/api/exceptions/authentication_exception.dart';
export 'src/api/exceptions/connection_exception.dart';
