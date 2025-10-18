// Copyright (c) 2025 Alberto Oishii
// SPDX-License-Identifier: MPL-2.0
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at http://mozilla.org/MPL/2.0/.

/// Biometric Sample Model
///
/// Represents a single biometric measurement from any transport layer:
/// - BLE GATT characteristics (e.g., Heart Rate 0x2A19)
/// - Bluetooth Classic SPP (e.g., Xiaomi protobuf protocol)
/// - BLE Advertisements (e.g., Xiaomi FE95 service)
/// - Future: HealthKit API, REST APIs, etc.
///
/// Used by all parsers to return standardized, transport-agnostic data samples.
library;

import '../../api/enums/sensor_type.dart';

/// A single biometric data sample from any wearable device
///
/// Transport-agnostic: Works with BLE, Bluetooth Classic, APIs, etc.
class BiometricSample {
  const BiometricSample({
    required this.timestamp,
    required this.value,
    required this.sensorType,
    this.metadata,
  });

  /// Create from JSON
  factory BiometricSample.fromJson(final Map<String, dynamic> json) {
    return BiometricSample(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
      sensorType: SensorType.values.firstWhere(
        (type) => type.name == json['sensor_type'] as String,
        orElse: () => SensorType.unknown,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Timestamp when the sample was recorded
  final DateTime timestamp;

  /// Primary measured value (interpretation depends on sensorType)
  ///
  /// Examples:
  /// - heartRate: BPM (60-220)
  /// - bloodOxygen: % oxygen saturation (0-100)
  /// - skinTemperature: °C (20-45)
  /// - movement: normalized intensity (0.0-1.0)
  /// - battery: % charge (0-100)
  final double value;

  /// Type of biometric data
  final SensorType sensorType;

  /// Optional additional data specific to the measurement
  ///
  /// Examples:
  /// - heart_rate: {'rr_intervals': [800, 820, 790], 'contact': true}
  /// - spo2: {'pulse_rate': 78, 'confidence': 0.95}
  /// - movement: {'steps': 42, 'activity_type': 1}
  /// - temperature: {'sensor_location': 'wrist', 'unit': 'celsius'}
  final Map<String, dynamic>? metadata;

  /// Create a copy with updated fields
  BiometricSample copyWith({
    final DateTime? timestamp,
    final double? value,
    final SensorType? sensorType,
    final Map<String, dynamic>? metadata,
  }) {
    return BiometricSample(
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      sensorType: sensorType ?? this.sensorType,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'sensor_type': sensorType.name,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    final metaStr = metadata != null ? ' (${metadata!.keys.join(', ')})' : '';
    return 'BiometricSample(${sensorType.displayName}: $value${sensorType.unit} at ${timestamp.toIso8601String()}$metaStr)';
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is BiometricSample &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          value == other.value &&
          sensorType == other.sensorType;

  @override
  int get hashCode => timestamp.hashCode ^ value.hashCode ^ sensorType.hashCode;
}
