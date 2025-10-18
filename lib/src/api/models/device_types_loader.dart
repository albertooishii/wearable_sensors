import 'dart:convert';
import 'package:flutter/services.dart';

/// Reglas de detección de un tipo de dispositivo
class DeviceDetection {
  const DeviceDetection({
    required this.requiredServices,
    required this.optionalServices,
  });

  factory DeviceDetection.fromJson(final Map<String, dynamic> json) {
    return DeviceDetection(
      requiredServices: (json['required_services'] as List<dynamic>)
          .map((final e) => e as String)
          .toList(),
      optionalServices: (json['optional_services'] as List<dynamic>)
          .map((final e) => e as String)
          .toList(),
    );
  }
  final List<String> requiredServices;
  final List<String> optionalServices;

  Map<String, dynamic> toJson() {
    return {
      'required_services': requiredServices,
      'optional_services': optionalServices,
    };
  }

  /// Calcula score de coincidencia con lista de servicios
  /// Retorna -1 si no cumple requisitos, o número de matches si cumple
  int matchScore(final List<String> deviceServices) {
    // Normalizar servicios del dispositivo (mayúsculas, sin guiones)
    final normalizedDeviceServices = deviceServices
        .map((final s) => s.replaceAll('-', '').toUpperCase())
        .toList();

    // Verificar servicios requeridos
    for (final required in requiredServices) {
      final normalizedRequired = required.replaceAll('-', '').toUpperCase();
      final hasService = normalizedDeviceServices.any(
        (final s) =>
            s == normalizedRequired || s.startsWith(normalizedRequired),
      );

      if (!hasService) {
        return -1; // No cumple requisitos
      }
    }

    // Contar servicios opcionales que coinciden
    int optionalMatches = 0;
    for (final optional in optionalServices) {
      final normalizedOptional = optional.replaceAll('-', '').toUpperCase();
      final hasService = normalizedDeviceServices.any(
        (final s) =>
            s == normalizedOptional || s.startsWith(normalizedOptional),
      );

      if (hasService) {
        optionalMatches++;
      }
    }

    // Score = servicios requeridos (peso 100) + opcionales
    return (requiredServices.length * 100) + optionalMatches;
  }
}

/// Información de un tipo de dispositivo
class DeviceType {
  const DeviceType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.category,
    required this.vendor,
    required this.description,
    required this.detection,
  });

  factory DeviceType.fromJson(final Map<String, dynamic> json) {
    return DeviceType(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      category: json['category'] as String,
      vendor: json['vendor'] as String,
      description: json['description'] as String,
      detection: DeviceDetection.fromJson(
        json['detection'] as Map<String, dynamic>,
      ),
    );
  }
  final String id;
  final String name;
  final String icon;
  final String color;
  final String category;
  final String vendor;
  final String description;
  final DeviceDetection detection;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'category': category,
      'vendor': vendor,
      'description': description,
      'detection': detection.toJson(),
    };
  }

  @override
  String toString() {
    return 'DeviceType(id: $id, name: $name, vendor: $vendor, category: $category)';
  }
}

/// Loader para cargar y detectar tipos de dispositivos desde JSON
class DeviceTypesLoader {
  // ✅ Ruta correcta para assets en paquetes: packages/nombre_paquete/assets/...
  // Flutter maneja automáticamente los assets declarados en flutter.assets del pubspec.yaml
  // Cuando se importa como paquete externo, rootBundle necesita este prefijo
  static const String _assetPath =
      'packages/wearable_sensors/assets/data/device_types.json';

  List<DeviceType>? _deviceTypes;
  final AssetBundle? _testAssetBundle;

  /// Constructor that accepts optional asset bundle for testing
  DeviceTypesLoader({AssetBundle? testAssetBundle})
      : _testAssetBundle = testAssetBundle;

  /// Carga los tipos de dispositivos desde el JSON
  Future<List<DeviceType>> load() async {
    if (_deviceTypes != null) {
      return _deviceTypes!;
    }

    // Use test bundle if provided, otherwise use rootBundle
    final bundle = _testAssetBundle ?? rootBundle;
    final jsonString = await bundle.loadString(_assetPath);
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    _deviceTypes = jsonList
        .map((final json) => DeviceType.fromJson(json as Map<String, dynamic>))
        .toList();

    return _deviceTypes!;
  }

  /// Detecta el tipo de dispositivo basado en sus servicios BLE
  /// Usa scoring para encontrar el mejor match
  Future<DeviceType> detectDeviceType(final List<String> deviceServices) async {
    final types = await load();

    // Calcular scores para cada tipo
    final scores = <DeviceType, int>{};
    for (final type in types) {
      final score = type.detection.matchScore(deviceServices);
      if (score >= 0) {
        scores[type] = score;
      }
    }

    // Si no hay matches, retornar 'unknown'
    if (scores.isEmpty) {
      return types.firstWhere(
        (final t) => t.id == 'unknown',
        orElse: () => types.last, // Último como fallback
      );
    }

    // Retornar el tipo con mayor score
    final sortedEntries = scores.entries.toList()
      ..sort((final a, final b) => b.value.compareTo(a.value));

    final winner = sortedEntries.first.key;

    return winner;
  }

  /// Obtiene un tipo de dispositivo por ID
  Future<DeviceType?> getById(final String id) async {
    final types = await load();
    return types.firstWhere(
      (final t) => t.id == id,
      orElse: () => types.firstWhere((final t) => t.id == 'unknown'),
    );
  }

  /// Obtiene todos los tipos de un vendor
  Future<List<DeviceType>> getByVendor(final String vendor) async {
    final types = await load();
    return types.where((final t) => t.vendor == vendor).toList();
  }

  /// Obtiene todos los tipos de una categoría
  Future<List<DeviceType>> getByCategory(final String category) async {
    final types = await load();
    return types.where((final t) => t.category == category).toList();
  }

  /// Limpia el cache (útil para testing)
  void clearCache() {
    _deviceTypes = null;
  }
}
