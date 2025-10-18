// 📦 Wearable Sensors Package v0.0.1
// GATT Service Model - Agnóstico (sin Material Design)

/// Representa un servicio GATT (Generic Attribute Profile)
/// Descubierto cuando el dispositivo BLE está conectado
class GattService {
  /// Crear una instancia desde JSON
  factory GattService.fromJson(
    String uuid,
    Map<String, dynamic> json,
  ) {
    return GattService(
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
  const GattService({
    required this.uuid,
    required this.name,
    required this.description,
    required this.category,
    required this.iconName,
    required this.colorName,
    this.isGeneric = false,
    this.vendor,
  });

  /// UUID corto (ej: "180D") o completo
  final String uuid;

  /// Nombre legible (ej: "Heart Rate")
  final String name;

  /// Descripción detallada
  final String description;

  /// Categoría (ej: "health", "fitness", "vendor")
  final String category;

  /// Nombre agnóstico del icono (ej: "favorite")
  final String iconName;

  /// Nombre agnóstico del color (ej: "red")
  final String colorName;

  /// True si es servicio genérico a filtrar
  final bool isGeneric;

  /// Vendor si aplica (ej: "xiaomi", null para estándar)
  final String? vendor;

  /// Convertir a JSON
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

  /// Igualdad
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GattService) return false;

    return uuid == other.uuid &&
        name == other.name &&
        description == other.description &&
        category == other.category &&
        iconName == other.iconName &&
        colorName == other.colorName &&
        isGeneric == other.isGeneric &&
        vendor == other.vendor;
  }

  /// Hash code
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

  /// Copiar con cambios
  GattService copyWith({
    String? uuid,
    String? name,
    String? description,
    String? category,
    String? iconName,
    String? colorName,
    bool? isGeneric,
    String? vendor,
  }) {
    return GattService(
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
