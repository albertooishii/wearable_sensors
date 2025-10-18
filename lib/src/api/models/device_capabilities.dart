// 📦 Wearable Sensors Package - Device Capabilities Model
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

import '../enums/sensor_type.dart';

/// Device capabilities and specifications
///
/// Describes what a wearable device can do: supported sensors,
/// connectivity types, authentication requirements, etc.
class DeviceCapabilities {
  const DeviceCapabilities({
    required this.supportedSensors,
    this.supportsBLE = true,
    this.supportsClassic = false,
    this.requiresAuthentication = false,
    this.supportsFirmwareUpdate = false,
    this.batteryCapacity,
    this.maxSamplingRate,
    this.modelName,
    this.hardwareVersion,
    this.firmwareVersion,
    this.vendorName,
  });

  /// Set of sensors supported by this device
  final Set<SensorType> supportedSensors;

  /// Whether device supports Bluetooth Low Energy
  final bool supportsBLE;

  /// Whether device supports Bluetooth Classic
  final bool supportsClassic;

  /// Whether device requires authentication before use
  final bool requiresAuthentication;

  /// Whether device supports firmware updates
  final bool supportsFirmwareUpdate;

  /// Battery capacity in mAh (if known)
  final int? batteryCapacity;

  /// Maximum sampling rate in Hz (if known)
  final double? maxSamplingRate;

  /// Device model name (e.g., "Mi Smart Band 10")
  final String? modelName;

  /// Hardware version (e.g., "V2.1")
  final String? hardwareVersion;

  /// Firmware version (e.g., "1.0.2.43")
  final String? firmwareVersion;

  /// Vendor/manufacturer name (e.g., "Xiaomi")
  final String? vendorName;

  /// Whether device supports a specific sensor type
  bool supportsSensor(SensorType type) => supportedSensors.contains(type);

  /// Whether device supports health metrics (HR, HRV, SpO2, etc.)
  bool get supportsHealthMetrics =>
      supportedSensors.any((s) => s.isHealthMetric);

  /// Whether device supports activity tracking (steps, distance, calories)
  bool get supportsActivityTracking =>
      supportedSensors.any((s) => s.isActivityMetric);

  DeviceCapabilities copyWith({
    Set<SensorType>? supportedSensors,
    bool? supportsBLE,
    bool? supportsClassic,
    bool? requiresAuthentication,
    bool? supportsFirmwareUpdate,
    int? batteryCapacity,
    double? maxSamplingRate,
    String? modelName,
    String? hardwareVersion,
    String? firmwareVersion,
    String? vendorName,
  }) {
    return DeviceCapabilities(
      supportedSensors: supportedSensors ?? this.supportedSensors,
      supportsBLE: supportsBLE ?? this.supportsBLE,
      supportsClassic: supportsClassic ?? this.supportsClassic,
      requiresAuthentication:
          requiresAuthentication ?? this.requiresAuthentication,
      supportsFirmwareUpdate:
          supportsFirmwareUpdate ?? this.supportsFirmwareUpdate,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      maxSamplingRate: maxSamplingRate ?? this.maxSamplingRate,
      modelName: modelName ?? this.modelName,
      hardwareVersion: hardwareVersion ?? this.hardwareVersion,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      vendorName: vendorName ?? this.vendorName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supportedSensors': supportedSensors.map((s) => s.name).toList(),
      'supportsBLE': supportsBLE,
      'supportsClassic': supportsClassic,
      'requiresAuthentication': requiresAuthentication,
      'supportsFirmwareUpdate': supportsFirmwareUpdate,
      if (batteryCapacity != null) 'batteryCapacity': batteryCapacity,
      if (maxSamplingRate != null) 'maxSamplingRate': maxSamplingRate,
      if (modelName != null) 'modelName': modelName,
      if (hardwareVersion != null) 'hardwareVersion': hardwareVersion,
      if (firmwareVersion != null) 'firmwareVersion': firmwareVersion,
      if (vendorName != null) 'vendorName': vendorName,
    };
  }

  factory DeviceCapabilities.fromJson(Map<String, dynamic> json) {
    return DeviceCapabilities(
      supportedSensors: (json['supportedSensors'] as List)
          .map(
            (name) => SensorType.values.firstWhere(
              (t) => t.name == name,
              orElse: () => SensorType.unknown,
            ),
          )
          .toSet(),
      supportsBLE: json['supportsBLE'] as bool? ?? true,
      supportsClassic: json['supportsClassic'] as bool? ?? false,
      requiresAuthentication: json['requiresAuthentication'] as bool? ?? false,
      supportsFirmwareUpdate: json['supportsFirmwareUpdate'] as bool? ?? false,
      batteryCapacity: json['batteryCapacity'] as int?,
      maxSamplingRate: json['maxSamplingRate'] as double?,
      modelName: json['modelName'] as String?,
      hardwareVersion: json['hardwareVersion'] as String?,
      firmwareVersion: json['firmwareVersion'] as String?,
      vendorName: json['vendorName'] as String?,
    );
  }

  @override
  String toString() {
    return 'DeviceCapabilities(sensors: ${supportedSensors.length}, '
        'BLE: $supportsBLE, auth: $requiresAuthentication)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceCapabilities &&
          other.supportedSensors == supportedSensors &&
          other.supportsBLE == supportsBLE &&
          other.supportsClassic == supportsClassic &&
          other.requiresAuthentication == requiresAuthentication;

  @override
  int get hashCode => Object.hash(
        supportedSensors,
        supportsBLE,
        supportsClassic,
        requiresAuthentication,
      );
}
