// This file is part of the wearable_sensors package.
//
// Mozilla Public License Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.mozilla.org/en-US/MPL/2.0/
//
// Software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing rights and limitations
// under the License.
//
// SPDX-License-Identifier: MPL-2.0

// This file is part of the wearable_sensors package.
//
// Mozilla Public License Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.mozilla.org/en-US/MPL/2.0/
//
// Software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing rights and limitations
// under the License.
//
// SPDX-License-Identifier: MPL-2.0

/// 🔧 Configuración de dispositivos soportados
///
/// Este archivo define todos los dispositivos wearables soportados por Dream Incubator
/// de forma modular y extensible.
///
/// **Arquitectura:**
/// - ✅ Patterns en Dart para detección rápida (sync, no I/O)
/// - ✅ Metadata (displayName, authProtocol) cargada desde JSONs (única fuente de verdad)
/// - ✅ Zero duplicación: solo el JSON tiene información completa
/// - ✅ Fácil agregar dispositivos: pattern aquí + JSON en assets/
library;

import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';

/// Configuración de un dispositivo soportado
///
/// **IMPORTANTE**: Esta clase ahora carga metadata dinámicamente desde JSONs.
/// Solo el `namePattern` y `deviceType` se definen aquí.
/// El resto (displayName, authProtocol, etc.) se obtiene del JSON.
class SupportedDeviceConfig {
  const SupportedDeviceConfig._({
    required this.namePattern,
    required this.deviceType,
    required this.displayName,
    required this.requiresAuth,
    this.authProtocol,
    this.notes,
  });

  /// Factory que carga metadata desde JSON
  static Future<SupportedDeviceConfig> fromJson({
    required final RegExp namePattern,
    required final String deviceType,
  }) async {
    try {
      final impl = await DeviceImplementationLoader.load(deviceType);

      return SupportedDeviceConfig._(
        namePattern: namePattern,
        deviceType: deviceType,
        displayName: impl.displayName,
        requiresAuth: impl.authentication.protocol.isNotEmpty,
        authProtocol: impl.authentication.protocol.isEmpty
            ? null
            : impl.authentication.protocol,
        notes: impl.version, // Use version as notes
      );
    } catch (e) {
      throw Exception('Failed to load device config for $deviceType: $e');
    }
  }

  /// Pattern regex para detectar el dispositivo por nombre
  /// Ejemplo: r'^Xiaomi Smart Band 10 [0-9A-F]{4}$'
  final RegExp namePattern;

  /// Tipo de dispositivo para cargar JSON implementation
  /// Ejemplo: 'xiaomi_smart_band_10'
  final String deviceType;

  /// Nombre para mostrar al usuario (cargado desde JSON)
  /// Ejemplo: 'Xiaomi Smart Band 10 (FE95 Protocol V2)'
  final String displayName;

  /// Si requiere autenticación especial (derivado de JSON)
  final bool requiresAuth;

  /// Protocolo de autenticación (cargado desde JSON)
  /// Ejemplo: 'xiaomi_spp_v2'
  final String? authProtocol;

  /// Notas adicionales (version del JSON)
  final String? notes;

  /// Verifica si un nombre de dispositivo coincide con este patrón
  bool matches(final String deviceName) => namePattern.hasMatch(deviceName);

  @override
  String toString() => 'SupportedDevice($displayName, type: $deviceType)';
}

/// ⚡ Configuración centralizada de todos los dispositivos soportados
class SupportedDevicesConfig {
  SupportedDevicesConfig._();

  /// 📱 Patterns de dispositivos Xiaomi (solo detección - metadata en JSONs)
  static final _xiaomiPatterns = {
    'xiaomi_smart_band_9': RegExp(r'^Xiaomi Smart Band 9 [0-9A-F]{4}$'),
    'xiaomi_smart_band_10': RegExp(r'^Xiaomi Smart Band 10 [0-9A-F]{4}$'),
    // 🔮 Futuros modelos (fácil de agregar)
    // 'xiaomi_smart_band_11': RegExp(r'^Xiaomi Smart Band 11 [0-9A-F]{4}$'),
  };

  /// 🌐 Todos los patterns de dispositivos soportados
  static final _allPatterns = {
    ..._xiaomiPatterns,
    // Futuro: Fitbit, Garmin, Samsung, etc.
  };

  /// Cache de configuraciones ya cargadas (evita recargar JSONs)
  static final Map<String, SupportedDeviceConfig> _configCache = {};

  /// 🔍 Detecta el dispositivo por nombre y carga su configuración completa
  ///
  /// Returns: SupportedDeviceConfig con metadata desde JSON, o null si no soportado
  ///
  /// **Ejemplo:**
  /// ```dart
  /// final config = await SupportedDevicesConfig.detectDevice('Xiaomi Smart Band 10 A1B2');
  /// if (config != null) {
  ///   print('Display: ${config.displayName}'); // "Xiaomi Smart Band 10 (FE95 Protocol V2)"
  ///   print('Auth: ${config.authProtocol}');   // "xiaomi_spp_v2"
  /// }
  /// ```
  static Future<SupportedDeviceConfig?> detectDevice(
    final String deviceName,
  ) async {
    // 1️⃣ Buscar deviceType por pattern matching (rápido, sin I/O)
    String? deviceType;
    RegExp? matchedPattern;

    for (final entry in _allPatterns.entries) {
      if (entry.value.hasMatch(deviceName)) {
        deviceType = entry.key;
        matchedPattern = entry.value;
        break;
      }
    }

    if (deviceType == null || matchedPattern == null) {
      return null; // Dispositivo no soportado
    }

    // 2️⃣ Verificar cache antes de cargar JSON
    if (_configCache.containsKey(deviceType)) {
      return _configCache[deviceType];
    }

    // 3️⃣ Cargar metadata desde JSON (primera vez)
    try {
      final config = await SupportedDeviceConfig.fromJson(
        namePattern: matchedPattern,
        deviceType: deviceType,
      );

      // Guardar en cache
      _configCache[deviceType] = config;

      return config;
    } on Exception {
      // Si falla cargar JSON, retornar null (dispositivo no configurado correctamente)
      return null;
    }
  }

  /// ✅ Verifica si un dispositivo es soportado (solo pattern check - rápido)
  ///
  /// **Uso cuando NO necesitas metadata completa**, solo saber si es reconocido.
  static bool isSupported(final String deviceName) {
    return _allPatterns.values.any(
      (final pattern) => pattern.hasMatch(deviceName),
    );
  }

  /// 🔐 Verifica si un dispositivo requiere autenticación
  ///
  /// **Nota**: Carga el JSON completo para obtener esta info.
  static Future<bool> requiresAuth(final String deviceName) async {
    final device = await detectDevice(deviceName);
    return device?.requiresAuth ?? false;
  }

  /// 📦 Obtiene el device type sin cargar JSON (solo pattern matching)
  ///
  /// **Uso**: Cuando necesitas el deviceType pero NO la metadata completa.
  static String? getDeviceType(final String deviceName) {
    for (final entry in _allPatterns.entries) {
      if (entry.value.hasMatch(deviceName)) {
        return entry.key;
      }
    }
    return null;
  }

  /// 📋 Lista todos los dispositivos Xiaomi soportados (carga todos los JSONs)
  ///
  /// **Nota**: Este método carga todos los JSONs de Xiaomi.
  /// Usar con precaución en hot paths.
  static Future<List<String>> getSupportedXiaomiModels() async {
    final models = <String>[];

    for (final deviceType in _xiaomiPatterns.keys) {
      try {
        final impl = await DeviceImplementationLoader.load(deviceType);
        models.add(impl.displayName);
      } on Exception {
        // Skip dispositivos con JSON inválido
        continue;
      }
    }

    return models;
  }

  /// 📋 Lista todos los dispositivos soportados (carga TODOS los JSONs)
  ///
  /// **Advertencia**: Puede ser lento si hay muchos dispositivos.
  static Future<List<String>> getAllSupportedModels() async {
    final models = <String>[];

    for (final deviceType in _allPatterns.keys) {
      try {
        final impl = await DeviceImplementationLoader.load(deviceType);
        models.add(impl.displayName);
      } on Exception {
        // Skip dispositivos con JSON inválido
        continue;
      }
    }

    return models;
  }

  /// 🗑️ Limpia el cache de configuraciones
  ///
  /// Útil para testing o para forzar recarga de JSONs.
  static void clearCache() {
    _configCache.clear();
  }

  /// 📊 Estadísticas del cache
  static Map<String, dynamic> getCacheStats() {
    return {
      'cached_configs': _configCache.length,
      'total_patterns': _allPatterns.length,
      'cache_hit_rate': _configCache.isEmpty
          ? 0.0
          : _configCache.length / _allPatterns.length,
    };
  }
}
