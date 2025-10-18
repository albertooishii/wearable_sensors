// 📦 Wearable Sensors Package v0.0.1
// BLE Service Model - Agnóstico (sin Material Design)
//
// Representa un servicio BLE estándar (Heart Rate, Device Info, etc.)
// con toda su metadata: nombre, descripción, categoría, iconos, colores
//
// Los nombres de iconos y colores son agnósticos (strings):
// - iconName: "favorite", "info", "watch", etc.
// - colorName: "red", "blue", "green", etc.
//
// Las aplicaciones (ej: dream_incubator con Material Design) mapean estos
// strings a sus propios sistemas de iconografía y temas.

/// Representa un servicio BLE (Bluetooth Low Energy)
///
/// Incluye toda la información descriptiva del servicio:
/// - Identificación (UUID)
/// - Nombre y descripción
/// - Clasificación (categoría, vendor)
/// - Representación visual (nombres agnósticos de icono y color)
/// - Flags (isGeneric, etc.)
///
/// **Agnóstico**: Este modelo NO depende de Flutter Material Design.
/// Es reutilizable en cualquier proyecto que necesite información de servicios BLE.
///
/// Ejemplo:
/// ```dart
/// final hrService = BleService(
///   uuid: '180D',
///   name: 'Heart Rate',
///   description: 'Heart rate measurement service',
///   category: 'health',
///   iconName: 'favorite',      // String, no IconData
///   colorName: 'red',          // String, no Color
///   isGeneric: false,
///   vendor: 'standard',
/// );
/// ```
class BleService {
  /// Crear una instancia desde JSON
  factory BleService.fromJson(
    final String uuid,
    final Map<String, dynamic> json,
  ) {
    return BleService(
      uuid: uuid,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'generic',
      iconName: json['icon'] as String? ?? 'help',
      colorName: json['color'] as String? ?? 'grey',
      isGeneric: json['isGeneric'] as bool? ?? false,
      vendor: json['vendor'] as String?,
    );
  }

  /// Constructor principal
  const BleService({
    required this.uuid,
    required this.name,
    required this.description,
    required this.category,
    required this.iconName,
    required this.colorName,
    this.isGeneric = false,
    this.vendor,
  });

  /// UUID corto (ej: "180D", "180A")
  /// O UUID largo completo (ej: "0000180d-0000-1000-8000-00805f9b34fb")
  final String uuid;

  /// Nombre legible del servicio (ej: "Heart Rate", "Device Information")
  final String name;

  /// Descripción detallada del servicio
  final String description;

  /// Categoría del servicio (ej: "health", "fitness", "vendor", "gaming")
  final String category;

  /// Nombre agnóstico del icono (ej: "favorite", "info", "watch")
  /// Las aplicaciones mapean esto a sus propios iconos
  /// (ej: Material Design IconData, emoji, SVG, etc.)
  final String iconName;

  /// Nombre agnóstico del color (ej: "red", "blue", "green")
  /// Las aplicaciones mapean esto a sus propios temas
  /// (ej: Material Design Color, hex, RGBA, etc.)
  final String colorName;

  /// True si es un servicio genérico que debe filtrarse en listados
  final bool isGeneric;

  /// Vendor específico si aplica (ej: "xiaomi", "fitbit", null para estándar)
  final String? vendor;

  /// Convertir a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'category': category,
      'iconName': iconName,
      'colorName': colorName,
      'isGeneric': isGeneric,
      'vendor': vendor,
    };
  }

  /// Igualdad comparando todos los campos
  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    if (other is! BleService) return false;

    return uuid == other.uuid &&
        name == other.name &&
        description == other.description &&
        category == other.category &&
        iconName == other.iconName &&
        colorName == other.colorName &&
        isGeneric == other.isGeneric &&
        vendor == other.vendor;
  }

  /// Hash code para uso en sets/maps
  @override
  int get hashCode => Object.hash(
    uuid,
    name,
    description,
    category,
    iconName,
    colorName,
    isGeneric,
    vendor,
  );

  @override
  String toString() => '$name ($uuid)';

  /// Copiar con cambios opcionales
  BleService copyWith({
    final String? uuid,
    final String? name,
    final String? description,
    final String? category,
    final String? iconName,
    final String? colorName,
    final bool? isGeneric,
    final String? vendor,
  }) {
    return BleService(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      colorName: colorName ?? this.colorName,
      isGeneric: isGeneric ?? this.isGeneric,
      vendor: vendor ?? this.vendor,
    );
  }
}
