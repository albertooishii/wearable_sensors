// 🔐 Authentication Type Enum
// Define los tipos de autenticación soportados por diferentes vendors

/// Tipos de autenticación que pueden requerir los wearables
enum AuthenticationType {
  /// Sin autenticación requerida (BLE abierto)
  none('none', 'No Authentication'),

  /// Xiaomi SPP Protocol V2 (MI Band, Mi Watch)
  /// Requiere: AuthKey (hex string) extraído de Mi Fitness app
  xiaomiSpp('xiaomi_spp', 'Xiaomi SPP Protocol'),

  /// Fitbit OAuth (futura)
  fitbitOAuth('fitbit_oauth', 'Fitbit OAuth'),

  /// Apple HealthKit (futura)
  appleHealthKit('apple_healthkit', 'Apple HealthKit'),

  /// Genérico/desconocido
  unknown('unknown', 'Unknown');

  const AuthenticationType(this.id, this.displayName);

  /// ID único del tipo de autenticación
  final String id;

  /// Nombre amigable para mostrar al usuario
  final String displayName;

  /// Parsear desde string ID
  static AuthenticationType fromString(final String? value) {
    if (value == null) return AuthenticationType.none;
    try {
      return AuthenticationType.values.firstWhere(
        (final e) => e.id == value,
        orElse: () => AuthenticationType.unknown,
      );
    } catch (_) {
      return AuthenticationType.unknown;
    }
  }

  /// Verificar si requiere extracción manual de credenciales
  bool get requiresManualCredentialExtraction {
    return this == AuthenticationType.xiaomiSpp ||
        this == AuthenticationType.fitbitOAuth;
  }

  /// Obtener instrucciones para el usuario
  String get userInstructions {
    switch (this) {
      case AuthenticationType.xiaomiSpp:
        return 'Extract authentication key from Mi Fitness app';
      case AuthenticationType.fitbitOAuth:
        return 'Login with your Fitbit account';
      case AuthenticationType.appleHealthKit:
        return 'Authorize access to Apple Health';
      case AuthenticationType.none:
        return 'No authentication required';
      case AuthenticationType.unknown:
        return 'Unknown authentication method';
    }
  }
}
