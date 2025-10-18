// Copyright (c) 2025 Alberto Oishii
// SPDX-License-Identifier: MPL-2.0
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at http://mozilla.org/MPL/2.0/.

// 🎯 BLE Data Types - Dream Incubator
// Constantes tipadas para data types biométricos soportados

import 'package:flutter/material.dart';

/// Tipos de datos biométricos BLE estandarizados
///
/// ⚠️ IMPORTANTE: Esta clase define ÚNICAMENTE los tipos de datos biométricos
/// que los dispositivos pueden producir. Los mecanismos de protocolo
/// (autenticación, cifrado, comandos) NO son tipos de datos y pertenecen
/// a las definiciones de servicios/características de cada dispositivo.
///
/// Arquitectura (basada en Gadgetbridge):
/// - **Data Types** (esta clase): ¿Qué mide el dispositivo? (HR, SpO2, etc.)
/// - **Device Protocols**: ¿Cómo se autentica/comunica? (Xiaomi FE95, etc.)
/// - **BLE Transport**: ¿Qué UUIDs usa? (Services, Characteristics)
///
/// Estos valores corresponden al campo `data_type` en los JSONs de
/// device implementations (generic.json, xiaomi_smart_band_10.json, etc.)
///
/// Uso:
/// ```dart
/// await bluetoothService.subscribeToDataType(
///   deviceId: deviceId,
///   dataType: BleDataTypes.heartRate, // ✅ Tipado seguro
///   onData: (data) => print('HR: $data'),
/// );
/// ```
class BleDataTypes {
  const BleDataTypes._(); // Private constructor - solo constantes estáticas

  // ============================================================================
  // 🫀 BIOMETRIC DATA TYPES - Los 5 tipos fundamentales
  // ============================================================================

  /// Heart rate measurement (BPM)
  ///
  /// Fuentes:
  /// - Bluetooth SIG: Heart Rate Service (0x180D)
  /// - Xiaomi: Obtenido vía comandos después de autenticación FE95
  static const String heartRate = 'heart_rate';

  /// Blood oxygen saturation (SpO2 %)
  ///
  /// Fuentes:
  /// - Bluetooth SIG: Pulse Oximeter Service (0x1822)
  static const String spo2 = 'spo2';

  /// Skin/body temperature (°C)
  ///
  /// Fuentes:
  /// - Bluetooth SIG: Environmental Sensing (0x181A)
  /// - Bluetooth SIG: Health Thermometer (0x1809)
  static const String temperature = 'temperature';

  /// Movement/activity intensity (0.0-1.0)
  ///
  /// Fuentes:
  /// - Bluetooth SIG: Running Speed and Cadence (0x1814)
  /// - Bluetooth SIG: Cycling Speed and Cadence (0x1816)
  static const String movement = 'movement';

  /// Battery level (0-100%)
  ///
  /// Fuentes:
  /// - Bluetooth SIG: Battery Service (0x180F)
  static const String battery = 'battery';

  /// Step count (cumulative or delta depending on context)
  ///
  /// Fuentes:
  /// - Xiaomi: Realtime stats protobuf
  /// - Bluetooth SIG: Running Speed and Cadence (0x1814)
  static const String steps = 'steps';

  /// Calories burned (kcal, cumulative or delta)
  ///
  /// Fuentes:
  /// - Xiaomi: Realtime stats protobuf
  static const String calories = 'calories';

  /// Stress level (0-100 or device-specific scale)
  ///
  /// Fuentes:
  /// - Xiaomi: Stress monitoring feature
  static const String stress = 'stress';

  /// Sleep stage (encoded as integer or string in metadata)
  ///
  /// Fuentes:
  /// - Device-specific sleep algorithms
  static const String sleepStage = 'sleep_stage';

  // ============================================================================
  // 🔧 UTILITIES
  // ============================================================================

  /// All supported biometric data types (for validation)
  static const List<String> all = [
    heartRate,
    spo2,
    temperature,
    movement,
    battery,
    steps,
    calories,
    stress,
    sleepStage,
  ];

  /// Check if a data type is valid
  static bool isValid(final String dataType) => all.contains(dataType);

  /// Get human-readable name for a data type
  static String getName(final String dataType) {
    switch (dataType) {
      case heartRate:
        return 'Heart Rate';
      case spo2:
        return 'SpO2';
      case temperature:
        return 'Temperature';
      case movement:
        return 'Movement';
      case battery:
        return 'Battery';
      case steps:
        return 'Steps';
      case calories:
        return 'Calories';
      case stress:
        return 'Stress';
      case sleepStage:
        return 'Sleep Stage';
      default:
        return 'Unknown';
    }
  }

  /// Get Material Icon for a data type
  static IconData getIconData(final String dataType) {
    switch (dataType) {
      case heartRate:
        return Icons.favorite; // Heart icon
      case spo2:
        return Icons.bloodtype; // Blood/oxygen icon
      case temperature:
        return Icons.thermostat; // Temperature icon
      case movement:
        return Icons.directions_run; // Movement/activity icon
      case battery:
        return Icons.battery_std; // Battery icon
      case steps:
        return Icons.directions_walk; // Steps icon
      case calories:
        return Icons.local_fire_department; // Calories/fire icon
      case stress:
        return Icons.psychology; // Stress/brain icon
      case sleepStage:
        return Icons.bedtime; // Sleep icon
      default:
        return Icons.help_outline; // Unknown icon
    }
  }
}
