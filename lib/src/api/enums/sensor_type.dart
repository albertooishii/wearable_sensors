// 📦 Wearable Sensors Package - Sensor Type Enum

// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

/// Types of sensors available in wearable devices
///
/// This enum represents all possible sensor types that can be read
/// from wearable devices like Mi Band, Fitbit, Apple Watch, etc.
enum SensorType {
  /// Battery level (0-100%)
  battery,

  /// Heart rate in BPM (beats per minute)
  heartRate,

  /// Heart rate variability in milliseconds
  heartRateVariability,

  /// Step counter
  steps,

  /// Distance traveled in kilometers
  distance,

  /// Calories burned
  calories,

  /// Sleep stage (awake, light, deep, rem)
  sleep,

  /// Blood oxygen saturation (SpO2) in percentage
  bloodOxygen,

  /// Skin temperature in Celsius
  skinTemperature,

  /// Stress level (0-100)
  stressLevel,

  /// Respiratory rate (breaths per minute)
  respiratoryRate,

  /// Movement intensity (0.0-1.0 or accelerometer data)
  movement,

  /// Binary movement detection (0 = no movement, 1 = movement detected)
  movementDetected,

  /// Raw accelerometer X-axis data
  accelerometerX,

  /// Raw accelerometer Y-axis data
  accelerometerY,

  /// Raw accelerometer Z-axis data
  accelerometerZ,

  /// Generic sensor type for unknown/custom sensors
  unknown,
}

/// Extension methods for [SensorType]
extension SensorTypeExtension on SensorType {
  /// Human-readable name in English
  String get displayName {
    switch (this) {
      case SensorType.battery:
        return 'Battery Level';
      case SensorType.heartRate:
        return 'Heart Rate';
      case SensorType.heartRateVariability:
        return 'Heart Rate Variability';
      case SensorType.steps:
        return 'Steps';
      case SensorType.distance:
        return 'Distance';
      case SensorType.calories:
        return 'Calories';
      case SensorType.sleep:
        return 'Sleep Stage';
      case SensorType.bloodOxygen:
        return 'Blood Oxygen';
      case SensorType.skinTemperature:
        return 'Skin Temperature';
      case SensorType.stressLevel:
        return 'Stress Level';
      case SensorType.respiratoryRate:
        return 'Respiratory Rate';
      case SensorType.movement:
        return 'Movement';
      case SensorType.movementDetected:
        return 'Movement Detected';
      case SensorType.accelerometerX:
        return 'Accelerometer X';
      case SensorType.accelerometerY:
        return 'Accelerometer Y';
      case SensorType.accelerometerZ:
        return 'Accelerometer Z';
      case SensorType.unknown:
        return 'Unknown Sensor';
    }
  }

  /// Human-readable name in Spanish
  String get displayNameEs {
    switch (this) {
      case SensorType.battery:
        return 'Nivel de Batería';
      case SensorType.heartRate:
        return 'Frecuencia Cardíaca';
      case SensorType.heartRateVariability:
        return 'Variabilidad Cardíaca';
      case SensorType.steps:
        return 'Pasos';
      case SensorType.distance:
        return 'Distancia';
      case SensorType.calories:
        return 'Calorías';
      case SensorType.sleep:
        return 'Fase de Sueño';
      case SensorType.bloodOxygen:
        return 'Oxígeno en Sangre';
      case SensorType.skinTemperature:
        return 'Temperatura de Piel';
      case SensorType.stressLevel:
        return 'Nivel de Estrés';
      case SensorType.respiratoryRate:
        return 'Frecuencia Respiratoria';
      case SensorType.movement:
        return 'Movimiento';
      case SensorType.movementDetected:
        return 'Movimiento Detectado';
      case SensorType.accelerometerX:
        return 'Acelerómetro X';
      case SensorType.accelerometerY:
        return 'Acelerómetro Y';
      case SensorType.accelerometerZ:
        return 'Acelerómetro Z';
      case SensorType.unknown:
        return 'Sensor Desconocido';
    }
  }

  /// Standard unit for this sensor type
  String get unit {
    switch (this) {
      case SensorType.battery:
        return '%';
      case SensorType.heartRate:
        return 'bpm';
      case SensorType.heartRateVariability:
        return 'ms';
      case SensorType.steps:
        return 'steps';
      case SensorType.distance:
        return 'km';
      case SensorType.calories:
        return 'kcal';
      case SensorType.sleep:
        return '';
      case SensorType.bloodOxygen:
        return '%';
      case SensorType.skinTemperature:
        return '°C';
      case SensorType.stressLevel:
        return '';
      case SensorType.respiratoryRate:
        return 'bpm';
      case SensorType.movement:
        return '';
      case SensorType.movementDetected:
        return '';
      case SensorType.accelerometerX:
      case SensorType.accelerometerY:
      case SensorType.accelerometerZ:
        return 'g';
      case SensorType.unknown:
        return '';
    }
  }

  /// Emoji icon for this sensor type
  String get emoji {
    switch (this) {
      case SensorType.battery:
        return '🔋';
      case SensorType.heartRate:
        return '❤️';
      case SensorType.heartRateVariability:
        return '💓';
      case SensorType.steps:
        return '👣';
      case SensorType.distance:
        return '🏃';
      case SensorType.calories:
        return '🔥';
      case SensorType.sleep:
        return '😴';
      case SensorType.bloodOxygen:
        return '🫁';
      case SensorType.skinTemperature:
        return '🌡️';
      case SensorType.stressLevel:
        return '😰';
      case SensorType.respiratoryRate:
        return '🌬️';
      case SensorType.movement:
        return '🏃‍♂️';
      case SensorType.movementDetected:
        return '🚨';
      case SensorType.accelerometerX:
      case SensorType.accelerometerY:
      case SensorType.accelerometerZ:
        return '📊';
      case SensorType.unknown:
        return '❓';
    }
  }

  /// Whether this sensor type is health-related
  bool get isHealthMetric {
    return this == SensorType.heartRate ||
        this == SensorType.heartRateVariability ||
        this == SensorType.bloodOxygen ||
        this == SensorType.skinTemperature ||
        this == SensorType.stressLevel ||
        this == SensorType.respiratoryRate;
  }

  /// Whether this sensor type is activity-related
  bool get isActivityMetric {
    return this == SensorType.steps ||
        this == SensorType.distance ||
        this == SensorType.calories ||
        this == SensorType.movement;
  }

  /// Internal data type string for BiometricDataReader
  ///
  /// Used when communicating with internal bluetooth layer.
  /// Maps SensorType enum to string identifiers used by device implementations.
  String get internalDataType {
    switch (this) {
      case SensorType.battery:
        return 'battery';
      case SensorType.heartRate:
        return 'heart_rate';
      case SensorType.heartRateVariability:
        return 'heart_rate_variability';
      case SensorType.steps:
        return 'steps';
      case SensorType.distance:
        return 'distance';
      case SensorType.calories:
        return 'calories';
      case SensorType.sleep:
        return 'sleep';
      case SensorType.bloodOxygen:
        return 'blood_oxygen';
      case SensorType.skinTemperature:
        return 'skin_temperature';
      case SensorType.stressLevel:
        return 'stress_level';
      case SensorType.respiratoryRate:
        return 'respiratory_rate';
      case SensorType.movement:
        return 'movement';
      case SensorType.movementDetected:
        return 'movement_detected';
      case SensorType.accelerometerX:
        return 'accelerometer_x';
      case SensorType.accelerometerY:
        return 'accelerometer_y';
      case SensorType.accelerometerZ:
        return 'accelerometer_z';
      case SensorType.unknown:
        return 'unknown';
    }
  }
}
