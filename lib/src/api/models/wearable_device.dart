// 📦 Wearable Sensors Package v0.0.1
// Wearable device state model
//
// Combines:
// - Device info (name, type, MAC, services)
// - Connection state (connecting, connected, streaming, error)
// - Battery level (0-100%, null if unavailable)
// - Last biometric data timestamp
// - Pairing info
// - Error information (if any)
//

import '../enums/connection_state.dart';
import '../exceptions/connection_exception.dart';
import '../gatt_services_catalog.dart';
import 'gatt_service.dart';
import 'device_types_loader.dart' as loader;

/// Unified device state for UI
///
/// This model combines all relevant real-time information about a device
/// that the UI needs to display (cards, dialogs, etc.)
class WearableDevice {
  /// Create from JSON
  factory WearableDevice.fromJson(final Map<String, dynamic> json) {
    return WearableDevice(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String?,
      deviceTypeId: json['deviceTypeId'] as String? ?? 'unknown',
      macAddress: json['macAddress'] as String?,
      connectionState: ConnectionState.values.firstWhere(
        (final s) => s.name == json['connectionState'],
        orElse: () => ConnectionState.disconnected,
      ),
      batteryLevel: json['batteryLevel'] as int?,
      lastDataTimestamp: json['lastDataTimestamp'] != null
          ? DateTime.parse(json['lastDataTimestamp'] as String)
          : null,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      connectedAt: json['connectedAt'] != null
          ? DateTime.parse(json['connectedAt'] as String)
          : null,
      discoveredServices: (json['discoveredServices'] as List<dynamic>?)
              ?.map((final s) {
                if (s is Map<String, dynamic>) {
                  return GattService.fromJson(
                    s['uuid'] as String,
                    s,
                  );
                }
                return null;
              })
              .whereType<GattService>()
              .toList() ??
          const [],
      isSavedDevice: json['isSavedDevice'] as bool? ?? false,
      isPairedToSystem: json['isPairedToSystem'] as bool? ?? false,
      rssi: json['rssi'] as int?,
    );
  }
  const WearableDevice({
    required this.deviceId,
    required this.connectionState,
    this.name,
    this.deviceTypeId = 'unknown',
    this.macAddress,
    this.batteryLevel,
    this.lastDataTimestamp,
    this.lastSeen,
    this.connectedAt,
    this.discoveredServices = const [],
    this.isSavedDevice = false,
    this.isPairedToSystem = false,
    this.rssi,
    this.error,
  });

  final String deviceId;
  final ConnectionState connectionState;
  final String? name;
  final String
      deviceTypeId; // ID from device_types.json (e.g., 'vr_headset', 'mi_band_8_plus')
  final String? macAddress;
  final int? batteryLevel; // 0-100%, null if unavailable
  final DateTime? lastDataTimestamp; // Last time biometric data received
  final DateTime? lastSeen;
  final DateTime? connectedAt;
  final List<GattService>
      discoveredServices; // ✅ GATT Service objects descubiertos en conexión
  final bool isSavedDevice;
  final bool isPairedToSystem;
  final int? rssi; // Signal strength
  final ConnectionException? error;

  // Backwards compatibility aliases
  String get id => deviceId; // Alias for WearableDevice.id
  int get servicesCount => discoveredServices.length;
  ConnectionState get status =>
      connectionState; // Alias for DeviceConnectionStatus

  /// Check if device is actively connected
  bool get isConnected =>
      connectionState == ConnectionState.connected ||
      connectionState == ConnectionState.streaming;

  /// Check if device is streaming biometric data
  bool get isStreaming => connectionState == ConnectionState.streaming;

  /// Get battery status text
  String get batteryText {
    if (batteryLevel == null) return 'N/A';
    return '$batteryLevel%';
  }

  /// Get connection status text for UI
  String get statusText {
    switch (connectionState) {
      case ConnectionState.disconnected:
        return 'Disconnected';
      case ConnectionState.connecting:
        return 'Connecting...';
      case ConnectionState.authenticating:
        return 'Authenticating...';
      case ConnectionState.connected:
        return 'Connected';
      case ConnectionState.streaming:
        return 'Streaming';
      case ConnectionState.error:
        return 'Error';
    }
  }

  /// Copy with updated fields
  WearableDevice copyWith({
    final String? name,
    final String? deviceTypeId,
    final String? macAddress,
    final ConnectionState? connectionState,
    final int? batteryLevel,
    final DateTime? lastDataTimestamp,
    final DateTime? lastSeen,
    final DateTime? connectedAt,
    final List<GattService>? discoveredServices, // ✅ GATT Services actualizados
    final bool? isSavedDevice,
    final bool? isPairedToSystem,
    final int? rssi,
    final ConnectionException? error,
  }) {
    return WearableDevice(
      deviceId: deviceId,
      name: name ?? this.name,
      deviceTypeId: deviceTypeId ?? this.deviceTypeId,
      macAddress: macAddress ?? this.macAddress,
      connectionState: connectionState ?? this.connectionState,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastDataTimestamp: lastDataTimestamp ?? this.lastDataTimestamp,
      lastSeen: lastSeen ?? this.lastSeen,
      connectedAt: connectedAt ?? this.connectedAt,
      discoveredServices: discoveredServices ?? this.discoveredServices,
      isSavedDevice: isSavedDevice ?? this.isSavedDevice,
      isPairedToSystem: isPairedToSystem ?? this.isPairedToSystem,
      rssi: rssi ?? this.rssi,
      error: error ?? this.error,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'deviceTypeId': deviceTypeId,
      'macAddress': macAddress,
      'connectionState': connectionState.name,
      'batteryLevel': batteryLevel,
      'lastDataTimestamp': lastDataTimestamp?.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'connectedAt': connectedAt?.toIso8601String(),
      'discoveredServices': discoveredServices.map((s) => s.toJson()).toList(),
      'isSavedDevice': isSavedDevice,
      'isPairedToSystem': isPairedToSystem,
      'rssi': rssi,
    };
  }

  /// Create from BluetoothDevice (scanned device)
  ///
  /// Note: En el escaneo inicial, los servicios vienen como UUIDs (strings).
  /// Para convertirlos a BleService objects, use `enrichServicesFromUuids()`.
  ///
  /// Este constructor crea un device con servicios vacíos, que se rellenan
  /// después mediante el método estático `enrichServicesFromUuids()`.
  static WearableDevice fromBluetoothDevice(
    final String deviceId,
    final String name, {
    final String? deviceTypeId,
    final int? rssi,
    final bool isPaired = false,
  }) {
    return WearableDevice(
      deviceId: deviceId,
      name: name,
      deviceTypeId: deviceTypeId ?? 'unknown',
      macAddress: deviceId,
      connectionState: ConnectionState.disconnected,
      discoveredServices: const [], // ✅ Vacío inicialmente
      rssi: rssi,
      isPairedToSystem: isPaired,
    );
  }

  /// Enriquecer servicios desde lista de UUID strings
  ///
  /// Este método carga los GattService objects desde UUIDs.
  /// Se llama después de `fromBluetoothDevice()` para llenar los servicios.
  static Future<WearableDevice> enrichServicesFromUuids(
    final WearableDevice device,
    final List<String> serviceUuids,
  ) async {
    final enrichedServices = <GattService>[];

    for (final uuid in serviceUuids) {
      final service = await GattServicesCatalog.getService(uuid);
      if (service != null) {
        enrichedServices.add(service);
      } else {
        // Crear un GattService "unknown" para UUIDs no reconocidos
        enrichedServices.add(
          GattService(
            uuid: uuid,
            name: 'Unknown Service',
            description: 'Unknown service UUID',
            category: 'generic',
            iconName: 'help',
            colorName: 'grey',
            isGeneric: true,
          ),
        );
      }
    }

    return device.copyWith(discoveredServices: enrichedServices);
  }

  /// Load device type metadata from DeviceTypesLoader
  ///
  /// Returns the full DeviceType object with icon, color, category, etc.
  Future<loader.DeviceType> loadDeviceType() async {
    final loaderInstance = loader.DeviceTypesLoader();
    final deviceType = await loaderInstance.getById(deviceTypeId);
    return deviceType ??
        await loaderInstance.getById('unknown') ??
        const loader.DeviceType(
          id: 'unknown',
          name: 'Unknown Device',
          icon: 'device_unknown',
          color: 'grey',
          category: 'generic',
          vendor: 'generic',
          description: 'Unidentified device',
          detection: loader.DeviceDetection(
            requiredServices: [],
            optionalServices: [],
          ),
        );
  }

  @override
  String toString() {
    return 'WearableDevice($deviceId: $statusText, battery: $batteryText, streaming: $isStreaming)';
  }

  /// Equality comparison excluding time-based fields (lastSeen, lastDataTimestamp)
  /// to prevent unnecessary rebuilds in StreamBuilder
  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    if (other is! WearableDevice) return false;

    return deviceId == other.deviceId &&
        name == other.name &&
        deviceTypeId == other.deviceTypeId &&
        macAddress == other.macAddress &&
        connectionState == other.connectionState &&
        batteryLevel == other.batteryLevel &&
        // ❌ NOT comparing: lastSeen, lastDataTimestamp (time fields)
        connectedAt == other.connectedAt &&
        discoveredServices.length == other.discoveredServices.length &&
        isSavedDevice == other.isSavedDevice &&
        isPairedToSystem == other.isPairedToSystem &&
        rssi == other.rssi &&
        error == other.error;
  }

  /// HashCode excluding time-based fields
  @override
  int get hashCode {
    return Object.hash(
      deviceId,
      name,
      deviceTypeId,
      macAddress,
      connectionState,
      batteryLevel,
      // ❌ NOT hashing: lastSeen, lastDataTimestamp
      connectedAt,
      discoveredServices.length,
      isSavedDevice,
      isPairedToSystem,
      rssi,
      error,
    );
  }
}

// ========================================
// PAIRING STATE MODELS
// ========================================

/// Estado del proceso de pairing
class PairingState {
  const PairingState({
    required this.deviceId,
    required this.status,
    this.message,
    required this.progress,
    this.estimatedTimeRemaining,
  });

  factory PairingState.initial(final String deviceId) {
    return PairingState(
      deviceId: deviceId,
      status: PairingStatus.none,
      progress: 0.0,
    );
  }

  factory PairingState.started(final String deviceId) {
    return PairingState(
      deviceId: deviceId,
      status: PairingStatus.discovering,
      message: 'Discovering device...',
      progress: 0.1,
      estimatedTimeRemaining: const Duration(seconds: 30),
    );
  }

  factory PairingState.connecting(final String deviceId) {
    return PairingState(
      deviceId: deviceId,
      status: PairingStatus.connecting,
      message: 'Connecting to device...',
      progress: 0.5,
      estimatedTimeRemaining: const Duration(seconds: 15),
    );
  }

  factory PairingState.success(final String deviceId) {
    return PairingState(
      deviceId: deviceId,
      status: PairingStatus.completed,
      message: 'Device paired successfully!',
      progress: 1.0,
    );
  }

  factory PairingState.failed(final String deviceId, final String error) {
    return PairingState(
      deviceId: deviceId,
      status: PairingStatus.failed,
      message: 'Pairing failed: $error',
      progress: 0.0,
    );
  }

  final String deviceId;
  final PairingStatus status;
  final String? message;
  final double progress; // 0.0 to 1.0
  final Duration? estimatedTimeRemaining;

  PairingState copyWith({
    final String? deviceId,
    final PairingStatus? status,
    final String? message,
    final double? progress,
    final Duration? estimatedTimeRemaining,
  }) {
    return PairingState(
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      estimatedTimeRemaining:
          estimatedTimeRemaining ?? this.estimatedTimeRemaining,
    );
  }
}

/// Estados del proceso de pairing
enum PairingStatus {
  none('Not Started'),
  discovering('Discovering'),
  connecting('Connecting'),
  authenticating('Authenticating'),
  completed('Completed'),
  failed('Failed'),
  cancelled('Cancelled');

  const PairingStatus(this.label);

  final String label;

  bool get isActive =>
      this == PairingStatus.discovering ||
      this == PairingStatus.connecting ||
      this == PairingStatus.authenticating;

  bool get isComplete =>
      this == PairingStatus.completed ||
      this == PairingStatus.failed ||
      this == PairingStatus.cancelled;
}

/// Connection result with success/failure metadata
class ConnectionResult {
  const ConnectionResult({
    required this.success,
    required this.deviceId,
    this.errorMessage,
    this.errorCode,
    this.connectionTime,
    this.metadata,
  });

  factory ConnectionResult.success(
    final String deviceId, {
    final Duration? connectionTime,
  }) {
    return ConnectionResult(
      success: true,
      deviceId: deviceId,
      connectionTime: connectionTime,
    );
  }

  factory ConnectionResult.failure(
    final String deviceId,
    final String error, {
    final String? errorCode,
  }) {
    return ConnectionResult(
      success: false,
      deviceId: deviceId,
      errorMessage: error,
      errorCode: errorCode,
    );
  }

  final bool success;
  final String deviceId;
  final String? errorMessage;
  final String? errorCode; // GATT error code (147, 133, etc.)
  final Duration? connectionTime;
  final Map<String, dynamic>? metadata;

  @override
  String toString() =>
      'ConnectionResult(success: $success, deviceId: $deviceId${errorMessage != null ? ', error: $errorMessage' : ''})';
}
