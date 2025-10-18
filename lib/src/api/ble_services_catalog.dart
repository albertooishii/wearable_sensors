// 📦 Wearable Sensors Package v0.0.1
// BLE Services Catalog - Agnóstico (sin Material Design)
//
// Carga y gestiona el catálogo de servicios BLE desde JSON.
// Retorna BleService objects con toda la información descriptiva.
//
// **Agnóstico**: No depende de Flutter Material Design.
// Otros proyectos mapean los nombres de iconos/colores a sus propios temas.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'models/ble_service_info.dart';

/// Catálogo completo de servicios BLE cargado desde JSON
///
/// Responsable de:
/// 1. Cargar ble_services_registry.json desde assets
/// 2. Cachear los servicios en memoria
/// 3. Proporcionar métodos de consulta
///
/// **Agnóstico**: Retorna BleServiceInfo (sin Material Design).
/// dream_incubator (u otros proyectos) convierten a BleServiceUI/etc. según necesiten.
class BleServicesCatalog {
  /// Caché de servicios cargados
  static Map<String, BleServiceInfo>? _services;

  /// Caché de categorías
  static Map<String, dynamic>? _categories;

  /// Cargar el catálogo desde el archivo JSON (una sola vez)
  static Future<void> _loadCatalog() async {
    if (_services != null) return; // Ya cargado

    try {
      final String jsonString = await rootBundle.loadString(
        'packages/wearable_sensors/assets/data/ble_services_registry.json',
      );
      final Map<String, dynamic> data = json.decode(jsonString);

      _services = {};
      final Map<String, dynamic> servicesData =
          data['services'] as Map<String, dynamic>;

      for (final entry in servicesData.entries) {
        _services![entry.key] = BleServiceInfo.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        );
      }

      _categories = (data['categories'] as Map<String, dynamic>?) ?? {};

      debugPrint(
        '✅ BLE Services Catalog loaded: ${_services!.length} services, ${_categories!.length} categories',
      );
    } on Exception catch (e) {
      debugPrint('❌ Error loading BLE Services Catalog: $e');
      _services = {};
      _categories = {};
    }
  }

  /// Obtener un servicio específico por UUID corto
  ///
  /// Ejemplo: getService('180D') → BleServiceInfo(Heart Rate)
  static Future<BleServiceInfo?> getService(final String shortUuid) async {
    await _loadCatalog();
    return _services![shortUuid.toUpperCase()];
  }

  /// Obtener todos los servicios
  static Future<Map<String, BleServiceInfo>> getAllServices() async {
    await _loadCatalog();
    return Map.from(_services!);
  }

  /// Obtener servicios por categoría
  static Future<List<BleServiceInfo>> getServicesByCategory(
    final String category,
  ) async {
    await _loadCatalog();
    return _services!.values
        .where((final service) => service.category == category)
        .toList();
  }

  /// Obtener servicios de salud
  static Future<List<BleServiceInfo>> getHealthServices() async {
    return await getServicesByCategory('health');
  }

  /// Obtener servicios de fitness
  static Future<List<BleServiceInfo>> getFitnessServices() async {
    return await getServicesByCategory('fitness');
  }

  /// Obtener servicios de vendor (Xiaomi, Fitbit, etc.)
  static Future<List<BleServiceInfo>> getVendorServices() async {
    return await getServicesByCategory('vendor');
  }

  /// Obtener servicios de gaming/VR
  static Future<List<BleServiceInfo>> getGamingServices() async {
    return await getServicesByCategory('gaming');
  }

  /// Detectar tipo de dispositivo basado en servicios descubiertos
  ///
  /// Retorna el nombre del primer servicio no-genérico relevante
  static Future<String> detectDeviceType(
    final List<String> serviceUuids,
  ) async {
    if (serviceUuids.isEmpty) return 'Unknown Device';

    await _loadCatalog();

    // Detectar dinámica: usar el primer servicio no-genérico más relevante
    for (final uuid in serviceUuids) {
      final service = await getService(uuid);
      if (service != null && !service.isGeneric) {
        return service.name;
      }
    }

    return 'Unknown Device';
  }

  /// Verificar si un dispositivo cumple los criterios para Dream Incubator
  ///
  /// **IMPORTANTE**: Esta lógica es específica de Dream Incubator.
  /// Otros proyectos deben implementar su propia lógica.
  ///
  /// Requisitos científicos (Dream Incubator):
  /// 1. OBLIGATORIO: Heart Rate (180D) - categoría "health"
  /// 2. AL MENOS UNO:
  ///    - Otro servicio de salud (health)
  ///    - Servicio de fitness (fitness)
  ///    - Servicio vendor específico (vendor con "FE" prefix = Xiaomi/vendor health)
  static Future<bool> isDreamIncubatorCompatible(
    final List<String> serviceUuids,
  ) async {
    await _loadCatalog();

    final normalizedUuids =
        serviceUuids.map((final uuid) => uuid.toUpperCase()).toSet();

    // Requisito obligatorio: Heart Rate (180D)
    if (!normalizedUuids.contains('180D')) {
      return false;
    }

    // Contar servicios por categoría
    int healthCount = 0;
    int fitnessCount = 0;
    int vendorHealthCount = 0;

    for (final uuid in normalizedUuids) {
      final service = _services![uuid];
      if (service == null) continue;

      if (service.category == 'health') {
        healthCount++;
      } else if (service.category == 'fitness') {
        fitnessCount++;
      } else if (service.category == 'vendor' && uuid.startsWith('FE')) {
        vendorHealthCount++;
      }
    }

    // Compatible si tiene HR + al menos uno más
    return healthCount >= 2 || fitnessCount >= 1 || vendorHealthCount >= 1;
  }

  /// Verificar si un servicio debe filtrarse (es genérico)
  static Future<bool> shouldFilterService(final String shortUuid) async {
    final service = await getService(shortUuid);
    return service?.isGeneric ?? false;
  }

  /// Extraer UUID corto de UUID completo
  static String extractShortUuid(final String uuid) {
    if (uuid.length == 4) return uuid.toUpperCase();
    if (uuid.length >= 8) return uuid.substring(4, 8).toUpperCase();
    return uuid.toUpperCase();
  }

  /// Obtener estadísticas de servicios por categoría
  static Future<Map<String, int>> getServiceStatsByCategory(
    final List<String> serviceUuids,
  ) async {
    await _loadCatalog();

    final stats = <String, int>{};

    // Inicializar contadores para todas las categorías
    for (final category in _categories!.keys) {
      stats[category] = 0;
    }

    // Contar servicios por categoría
    for (final uuid in serviceUuids) {
      final service = await getService(uuid);
      if (service != null) {
        stats[service.category] = (stats[service.category] ?? 0) + 1;
      }
    }

    return stats;
  }

  /// Obtener información de todas las categorías
  static Future<Map<String, dynamic>> getCategories() async {
    await _loadCatalog();
    return Map.from(_categories!);
  }
}
