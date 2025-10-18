// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 🔌 Vendor Orchestrator - Dream Incubator
// Abstract interface for device vendor-specific connection orchestration
//
// Implementaciones por vendor:
// - XiaomiConnectionOrchestrator (BLE→BT_CLASSIC→Streaming)
// - FitbitConnectionOrchestrator (BLE only)
// - AppleConnectionOrchestrator (CoreBluetooth)

import 'dart:async';
import 'package:flutter/foundation.dart';

// ✅ Import ConnectionState from shared/models (public API)
import 'package:wearable_sensors/wearable_sensors.dart';

/// Datos biométricos genéricos (vendor-agnostic)
///
/// **MODELO CANÓNICO UNIFICADO** - Este es el modelo oficial para todos los datos biométricos.
/// Reemplazó los siguientes modelos duplicados (ahora eliminados):
/// - ❌ BiometricData (shared/models/biometric_data.dart) - ELIMINADO
/// - ❌ BiometricData (sleep_insights/models/biometric_data.dart) - ELIMINADO
///
/// Coexiste con modelos especializados:
/// - ✅ BiometricReading (shared/models/) - Para lecturas específicas de sensores BLE
/// - ✅ BiometricSample (shared/models/) - Para samples raw de BLE characteristics
///
/// Todos los parsers, orchestrators y servicios de análisis usan ESTE modelo.
class BiometricData {
  /// Deserialize from JSON (for import/restore)
  factory BiometricData.fromJson(final Map<String, dynamic> json) {
    return BiometricData(
      deviceId: json['deviceId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      dataType: json['dataType'] as String,
      heartRate: json['heartRate'] as int?,
      heartRateVariability: (json['heartRateVariability'] as num?)?.toDouble(),
      bloodOxygenLevel: (json['bloodOxygenLevel'] as num?)?.toDouble(),
      respiratoryRate: json['respiratoryRate'] as int?,
      steps: json['steps'] as int?,
      calories: (json['calories'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      movement: (json['movement'] as num?)?.toDouble(),
      sleepStage: json['sleepStage'] as String?,
      stressLevel: json['stressLevel'] as int?,
      skinTemperature: (json['skinTemperature'] as num?)?.toDouble(),
      batteryLevel: json['batteryLevel'] as int?,
      accelerometer: json['accelerometer'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      // rawData: binary data not restored from JSON
    );
  }
  const BiometricData({
    required this.deviceId,
    required this.timestamp,
    required this.dataType,
    // Cardiovascular
    this.heartRate,
    this.heartRateVariability,
    this.bloodOxygenLevel,
    this.respiratoryRate,
    // Activity
    this.steps,
    this.calories,
    this.distance,
    this.movement,
    // Sleep
    this.sleepStage,
    this.stressLevel,
    // Environment
    this.skinTemperature,
    // System
    this.batteryLevel,
    // Raw data
    this.accelerometer,
    this.rawData,
    this.metadata,
  });

  final String deviceId;
  final DateTime timestamp;
  final String dataType; // From BleDataTypes constants

  // Cardiovascular metrics
  final int? heartRate; // BPM (60-220)
  final double? heartRateVariability; // RMSSD in ms
  final double? bloodOxygenLevel; // SpO2 percentage (0-100)
  final int? respiratoryRate; // breaths per minute

  // Activity metrics
  final int? steps;
  final double? calories; // kcal burned
  final double? distance; // km
  final double? movement; // Normalized intensity (0.0-1.0)

  // Sleep metrics
  final String? sleepStage; // awake, light, deep, rem
  final int? stressLevel; // 0-100

  // Environmental
  final double? skinTemperature; // Celsius

  // System
  final int? batteryLevel; // 0-100%

  // Raw data
  final Map<String, dynamic>? accelerometer; // {x, y, z}
  final Uint8List? rawData; // Raw packet for debugging
  final Map<String, dynamic>? metadata; // Additional vendor-specific data

  /// Create copy with updated fields
  BiometricData copyWith({
    final String? deviceId,
    final DateTime? timestamp,
    final String? dataType,
    final int? heartRate,
    final double? heartRateVariability,
    final double? bloodOxygenLevel,
    final int? respiratoryRate,
    final int? steps,
    final double? calories,
    final double? distance,
    final double? movement,
    final String? sleepStage,
    final int? stressLevel,
    final double? skinTemperature,
    final int? batteryLevel,
    final Map<String, dynamic>? accelerometer,
    final Uint8List? rawData,
    final Map<String, dynamic>? metadata,
  }) {
    return BiometricData(
      deviceId: deviceId ?? this.deviceId,
      timestamp: timestamp ?? this.timestamp,
      dataType: dataType ?? this.dataType,
      heartRate: heartRate ?? this.heartRate,
      heartRateVariability: heartRateVariability ?? this.heartRateVariability,
      bloodOxygenLevel: bloodOxygenLevel ?? this.bloodOxygenLevel,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      movement: movement ?? this.movement,
      sleepStage: sleepStage ?? this.sleepStage,
      stressLevel: stressLevel ?? this.stressLevel,
      skinTemperature: skinTemperature ?? this.skinTemperature,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      accelerometer: accelerometer ?? this.accelerometer,
      rawData: rawData ?? this.rawData,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Serialize to JSON (for export/storage)
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'timestamp': timestamp.toIso8601String(),
      'dataType': dataType,
      if (heartRate != null) 'heartRate': heartRate,
      if (heartRateVariability != null)
        'heartRateVariability': heartRateVariability,
      if (bloodOxygenLevel != null) 'bloodOxygenLevel': bloodOxygenLevel,
      if (respiratoryRate != null) 'respiratoryRate': respiratoryRate,
      if (steps != null) 'steps': steps,
      if (calories != null) 'calories': calories,
      if (distance != null) 'distance': distance,
      if (movement != null) 'movement': movement,
      if (sleepStage != null) 'sleepStage': sleepStage,
      if (stressLevel != null) 'stressLevel': stressLevel,
      if (skinTemperature != null) 'skinTemperature': skinTemperature,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (accelerometer != null) 'accelerometer': accelerometer,
      if (metadata != null) 'metadata': metadata,
      // rawData omitted (binary data not suitable for JSON)
    };
  }

  @override
  String toString() {
    return 'BiometricData($dataType: device=$deviceId, HR=$heartRate, battery=$batteryLevel%, steps=$steps, time=$timestamp)';
  }
}

/// Errores de conexión
class ConnectionError {
  const ConnectionError({
    required this.deviceId,
    required this.message,
    this.errorCode,
    this.stackTrace,
  });

  final String deviceId;
  final String message;
  final String? errorCode;
  final StackTrace? stackTrace;

  @override
  String toString() => 'ConnectionError($deviceId): $message';
}

/// Abstract interface para orchestrators vendor-specific
///
/// **Responsabilidad:**
/// - Gestionar conexión completa de UN dispositivo
/// - Autenticación (si aplica)
/// - Transiciones de transporte (BLE→BT_CLASSIC si aplica)
/// - Streaming de datos biométricos
/// - Manejo de errores y reconexión
///
/// **Implementación por vendor:**
/// ```dart
/// class XiaomiConnectionOrchestrator extends VendorOrchestrator {
///   @override
///   Future<void> connectAndAuthenticate(String deviceId) async {
///     // 1. BLE authentication
///     // 2. Transition to BT_CLASSIC
///     // 3. Start biometric streaming
///   }
/// }
/// ```
abstract class VendorOrchestrator {
  /// Device ID being managed
  String get deviceId;

  /// ✅ Device type ID discovered during orchestration
  ///
  /// E.g., 'xiaomi_smart_band_10', null if not yet determined
  /// Used by DeviceConnectionManager to populate DeviceState.deviceTypeId
  String? get discoveredDeviceTypeId;

  /// Current connection state stream
  Stream<ConnectionState> get connectionStateStream;

  /// Biometric data stream (emits when device sends data)
  Stream<BiometricData> get biometricDataStream;

  /// Battery level stream (emits when battery level changes)
  /// Value range: 0-100 (percentage), null if unavailable
  Stream<int?> get batteryStream;

  /// Error stream (emits when connection errors occur)
  Stream<ConnectionError> get errorStream;

  /// Current connection state (synchronous getter)
  ConnectionState get currentState;

  /// Connect to device and authenticate (if required)
  ///
  /// **Workflow:**
  /// 1. Connect via BLE/BT_CLASSIC
  /// 2. Authenticate (if vendor requires it)
  /// 3. Start biometric data streaming
  ///
  /// **Throws:** Exception if connection fails
  Future<void> connectAndAuthenticate(final String deviceId);

  /// Disconnect from device and cleanup resources
  Future<void> disconnect();

  /// Send command to device (vendor-specific)
  ///
  /// Used for post-connection commands like:
  /// - Start/stop heart rate monitoring
  /// - Configure sleep tracking
  /// - Sync time
  Future<void> sendCommand(
    final String command, {
    final Map<String, dynamic>? params,
  });

  /// Dispose resources (called when orchestrator is no longer needed)
  Future<void> dispose();
}
