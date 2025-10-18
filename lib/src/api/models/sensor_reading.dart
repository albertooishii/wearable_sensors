// 📦 Wearable Sensors Package - Sensor Reading Model
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

import '../enums/sensor_type.dart';

/// A single sensor reading from a wearable device
class SensorReading {
  const SensorReading({
    required this.deviceId,
    required this.sensorType,
    required this.value,
    required this.timestamp,
    this.unit,
    this.quality,
    this.metadata,
  });

  final String deviceId;
  final SensorType sensorType;
  final double value;
  final DateTime timestamp;
  final String? unit;
  final double? quality;
  final Map<String, dynamic>? metadata;

  String get displayUnit => unit ?? sensorType.unit;
  bool get hasGoodQuality => quality != null && quality! >= 0.8;
  bool get hasPoorQuality => quality != null && quality! < 0.5;

  SensorReading copyWith({
    String? deviceId,
    SensorType? sensorType,
    double? value,
    DateTime? timestamp,
    String? unit,
    double? quality,
    Map<String, dynamic>? metadata,
  }) {
    return SensorReading(
      deviceId: deviceId ?? this.deviceId,
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      unit: unit ?? this.unit,
      quality: quality ?? this.quality,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'sensorType': sensorType.name,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      if (unit != null) 'unit': unit,
      if (quality != null) 'quality': quality,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      deviceId: json['deviceId'] as String,
      sensorType: SensorType.values.firstWhere(
        (t) => t.name == json['sensorType'],
        orElse: () => SensorType.unknown,
      ),
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      unit: json['unit'] as String?,
      quality: json['quality'] as double?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    final qualityStr =
        quality != null ? ' (${(quality! * 100).toStringAsFixed(0)}%)' : '';
    return 'SensorReading(${sensorType.displayName}: $value $displayUnit$qualityStr)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorReading &&
          other.deviceId == deviceId &&
          other.sensorType == sensorType &&
          other.value == value &&
          other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(deviceId, sensorType, value, timestamp);
}
