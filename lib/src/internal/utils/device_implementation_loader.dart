// Copyright (c) 2025 Alberto Oishii
// SPDX-License-Identifier: MPL-2.0
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at http://mozilla.org/MPL/2.0/.

import 'dart:convert';
import 'package:flutter/services.dart';

/// Información de una característica para lookup por data type
class CharacteristicInfo {
  const CharacteristicInfo({
    required this.serviceUuid,
    required this.characteristicUuid,
    required this.characteristicName,
    this.parser,
    this.isPrimary = true,
  });

  final String serviceUuid;
  final String characteristicUuid;
  final String characteristicName;
  final String? parser;
  final bool isPrimary;

  @override
  String toString() {
    return 'CharacteristicInfo(service: $serviceUuid, char: $characteristicUuid, name: $characteristicName, primary: $isPrimary)';
  }
}

/// Definición de una característica BLE
class CharacteristicDefinition {
  const CharacteristicDefinition({
    required this.uuid,
    this.parser,
    required this.properties,
    this.dataType,
    this.primary,
    this.disabled = false,
  });

  factory CharacteristicDefinition.fromJson(final Map<String, dynamic> json) {
    return CharacteristicDefinition(
      uuid: json['uuid'] as String,
      parser: json['parser'] as String?,
      properties: (json['properties'] as List<dynamic>)
          .map((final e) => e as String)
          .toList(),
      dataType: json['data_type'] as String?,
      primary: json['primary'] as bool?,
      disabled: json['disabled'] as bool? ?? false,
    );
  }

  final String uuid;
  final String? parser;
  final List<String> properties;
  final String? dataType;
  final bool? primary;
  final bool disabled;

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'parser': parser,
      'properties': properties,
      if (dataType != null) 'data_type': dataType,
      if (primary != null) 'primary': primary,
      if (disabled) 'disabled': disabled,
    };
  }

  @override
  String toString() {
    return 'CharacteristicDefinition(uuid: $uuid, parser: $parser, dataType: $dataType, primary: $primary, properties: $properties)';
  }
}

/// Definición de un servicio BLE con sus características
class ServiceDefinition {
  const ServiceDefinition({
    required this.uuid,
    required this.name,
    required this.characteristics,
  });

  factory ServiceDefinition.fromJson(final Map<String, dynamic> json) {
    final characteristicsMap = json['characteristics'] as Map<String, dynamic>;
    final characteristics = <String, CharacteristicDefinition>{};

    for (final entry in characteristicsMap.entries) {
      characteristics[entry.key] = CharacteristicDefinition.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return ServiceDefinition(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      characteristics: characteristics,
    );
  }

  final String uuid;
  final String name;
  final Map<String, CharacteristicDefinition> characteristics;

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'characteristics': characteristics.map(
        (final key, final value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  @override
  String toString() {
    return 'ServiceDefinition(uuid: $uuid, name: $name, characteristics: ${characteristics.length})';
  }
}

/// Configuración de parser de datos
class DataParser {
  const DataParser({required this.type, this.config});

  factory DataParser.fromJson(final Map<String, dynamic> json) {
    return DataParser(
      type: json['type'] as String,
      config: json['config'] as Map<String, dynamic>?,
    );
  }

  final String type;
  final Map<String, dynamic>? config;

  Map<String, dynamic> toJson() {
    return {'type': type, if (config != null) 'config': config};
  }

  @override
  String toString() {
    return 'DataParser(type: $type)';
  }
}

/// Configuración de autenticación
class AuthenticationConfig {
  const AuthenticationConfig({
    required this.protocol,
    this.serviceUuid,
    this.commandReadUuid,
    this.commandWriteUuid,
    this.config,
  });

  factory AuthenticationConfig.fromJson(final Map<String, dynamic> json) {
    return AuthenticationConfig(
      protocol: json['protocol'] as String,
      serviceUuid: json['service_uuid'] as String?,
      commandReadUuid: json['command_read_uuid'] as String?,
      commandWriteUuid: json['command_write_uuid'] as String?,
      // Preserve all other fields in config for future extensibility
      config: Map<String, dynamic>.from(json)
        ..remove('protocol')
        ..remove('service_uuid')
        ..remove('command_read_uuid')
        ..remove('command_write_uuid'),
    );
  }

  final String protocol;
  final String? serviceUuid;
  final String? commandReadUuid;
  final String? commandWriteUuid;
  final Map<String, dynamic>? config;

  Map<String, dynamic> toJson() {
    return {
      'protocol': protocol,
      if (serviceUuid != null) 'service_uuid': serviceUuid,
      if (commandReadUuid != null) 'command_read_uuid': commandReadUuid,
      if (commandWriteUuid != null) 'command_write_uuid': commandWriteUuid,
      if (config != null) ...config!,
    };
  }

  @override
  String toString() {
    return 'AuthenticationConfig(protocol: $protocol, service: $serviceUuid, read: $commandReadUuid, write: $commandWriteUuid)';
  }
}

/// Implementación completa de un dispositivo BLE
class DeviceImplementation {
  DeviceImplementation({
    required this.version,
    required this.deviceType,
    required this.displayName,
    required this.serviceFilter,
    required this.services,
    required this.dataParsers,
    required this.authentication,
  }) {
    // Construir index de data types automáticamente al crear la instancia
    _dataTypeIndex = _buildDataTypeIndex();
  }

  factory DeviceImplementation.fromJson(final Map<String, dynamic> json) {
    final servicesMap = json['services'] as Map<String, dynamic>;
    final services = <String, ServiceDefinition>{};

    for (final entry in servicesMap.entries) {
      services[entry.key] = ServiceDefinition.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    final parsersMap = json['data_parsers'] as Map<String, dynamic>;
    final dataParsers = <String, DataParser>{};

    for (final entry in parsersMap.entries) {
      dataParsers[entry.key] = DataParser.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return DeviceImplementation(
      version: json['version'] as String,
      deviceType: json['device_type'] as String,
      displayName: json['display_name'] as String,
      serviceFilter: (json['service_filter'] as List<dynamic>)
          .map((final e) => e as String)
          .toList(),
      services: services,
      dataParsers: dataParsers,
      authentication: AuthenticationConfig.fromJson(
        json['authentication'] as Map<String, dynamic>,
      ),
    );
  }

  final String version;
  final String deviceType;
  final String displayName;
  final List<String> serviceFilter;
  final Map<String, ServiceDefinition> services;
  final Map<String, DataParser> dataParsers;
  final AuthenticationConfig authentication;

  // 🆕 Index automático para lookup O(1) de data types
  late final Map<String, CharacteristicInfo> _dataTypeIndex;

  /// Construye el index de data types para lookup rápido
  Map<String, CharacteristicInfo> _buildDataTypeIndex() {
    final index = <String, CharacteristicInfo>{};

    for (final serviceEntry in services.entries) {
      final service = serviceEntry.value;

      for (final charEntry in service.characteristics.entries) {
        final char = charEntry.value;

        // ✅ SKIP disabled characteristics
        if (char.disabled) {
          continue;
        }

        if (char.dataType != null) {
          final dataType = char.dataType!;

          // Si ya existe, solo reemplazar si esta es primary
          if (index.containsKey(dataType)) {
            if (char.primary == true) {
              index[dataType] = CharacteristicInfo(
                serviceUuid: service.uuid,
                characteristicUuid: char.uuid,
                characteristicName: charEntry.key,
                parser: char.parser,
              );
            }
          } else {
            index[dataType] = CharacteristicInfo(
              serviceUuid: service.uuid,
              characteristicUuid: char.uuid,
              characteristicName: charEntry.key,
              parser: char.parser,
              isPrimary: char.primary ?? true,
            );
          }
        }
      }
    }

    return index;
  }

  /// 🎯 Obtiene la característica para un data type específico (O(1) lookup)
  ///
  /// Ejemplo: getCharacteristicForDataType('heart_rate') →
  /// CharacteristicInfo con serviceUuid, characteristicUuid, parser, etc.
  CharacteristicInfo? getCharacteristicForDataType(final String dataType) {
    return _dataTypeIndex[dataType];
  }

  /// Obtiene todos los data types soportados
  List<String> getSupportedDataTypes() {
    return _dataTypeIndex.keys.toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'device_type': deviceType,
      'display_name': displayName,
      'service_filter': serviceFilter,
      'services': services.map(
        (final key, final value) => MapEntry(key, value.toJson()),
      ),
      'data_parsers': dataParsers.map(
        (final key, final value) => MapEntry(key, value.toJson()),
      ),
      'authentication': authentication.toJson(),
    };
  }

  /// Obtiene el parser para una característica específica
  DataParser? getParserForCharacteristic(
    final String serviceUuid,
    final String characteristicKey,
  ) {
    final service = services[serviceUuid];
    if (service == null) return null;

    final characteristic = service.characteristics[characteristicKey];
    if (characteristic == null) return null;

    return dataParsers[characteristic.parser];
  }

  /// Lista todos los UUIDs de servicios
  List<String> getAllServiceUuids() {
    return services.values.map((final s) => s.uuid).toList();
  }

  /// Lista todos los UUIDs de características
  List<String> getAllCharacteristicUuids() {
    final List<String> uuids = [];
    for (final service in services.values) {
      for (final char in service.characteristics.values) {
        uuids.add(char.uuid);
      }
    }
    return uuids;
  }

  @override
  String toString() {
    return 'DeviceImplementation(deviceType: $deviceType, displayName: $displayName, services: ${services.length})';
  }
}

/// Loader para cargar implementaciones de dispositivos desde JSON
class DeviceImplementationLoader {
  DeviceImplementationLoader._();

  static DeviceImplementation? _cachedGeneric;
  static final Map<String, DeviceImplementation> _cache = {};

  /// Carga la implementación de un dispositivo específico
  ///
  /// [deviceType] debe coincidir con el nombre del archivo JSON
  /// Ejemplo: 'xiaomi_smart_band_10' carga 'assets/device_implementations/xiaomi_smart_band_10.json'
  static Future<DeviceImplementation> load(final String deviceType) async {
    // Verificar cache
    if (_cache.containsKey(deviceType)) {
      return _cache[deviceType]!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'packages/wearable_sensors/assets/device_implementations/$deviceType.json',
      );
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final implementation = DeviceImplementation.fromJson(json);

      // Guardar en cache
      _cache[deviceType] = implementation;

      return implementation;
    } on Exception catch (e) {
      throw Exception(
        'Failed to load device implementation for $deviceType: $e',
      );
    }
  }

  /// Carga la implementación genérica (fallback)
  ///
  /// La implementación genérica soporta servicios estándar Bluetooth SIG
  static Future<DeviceImplementation> loadGeneric() async {
    if (_cachedGeneric != null) {
      return _cachedGeneric!;
    }

    _cachedGeneric = await load('generic');
    return _cachedGeneric!;
  }

  /// Intenta cargar la implementación del dispositivo, fallback a generic
  ///
  /// Útil cuando no estás seguro si existe una implementación específica
  static Future<DeviceImplementation> loadOrGeneric(
    final String deviceType,
  ) async {
    try {
      return await load(deviceType);
    } on Object {
      // Si falla por cualquier razón (Exception, Error, FlutterError), usar genérico
      return await loadGeneric();
    }
  }

  /// Limpia el cache de implementaciones
  ///
  /// Útil para testing o para forzar recarga de JSONs
  static void clearCache() {
    _cache.clear();
    _cachedGeneric = null;
  }

  /// Verifica si una implementación está en cache
  static bool isCached(final String deviceType) {
    return _cache.containsKey(deviceType);
  }

  /// Lista todos los device types en cache
  static List<String> getCachedDeviceTypes() {
    return _cache.keys.toList();
  }
}
