import '../../api/models/wearable_device.dart';

/// Interface para persistencia de dispositivos BLE descubiertos
///
/// Define el contrato para guardar y recuperar información de dispositivos
/// que han sido enriquecidos con servicios BLE. La estrategia de caché es
/// PERMANENTE: una vez guardado, un MAC address nunca expira porque:
/// 1. MAC es único y permanente por dispositivo
/// 2. Servicios BLE no cambian para el mismo dispositivo
/// 3. Solo se elimina al desemparejar (unpair)
///
/// Implementaciones:
/// - [SharedPreferencesDiscoveredDeviceStorage] - Para desarrollo/production
/// - [MemoryDiscoveredDeviceStorage] - Para testing
abstract interface class DiscoveredDeviceStorage {
  /// Inicializar el storage (si es necesario)
  ///
  /// Para SharedPreferences, esto es un no-op (ya está inicializado).
  /// Para otras implementaciones, puede conectar a base de datos, etc.
  Future<void> initialize();

  /// Guardar o actualizar un dispositivo descubierto con sus servicios
  ///
  /// Usa el MAC address como clave única. Si el dispositivo ya existe,
  /// se actualiza la información (especialmente [discoveredServices]).
  ///
  /// [device] - Dispositivo con servicios ya descubiertos
  ///
  /// Throws: [DiscoveredDeviceStorageException] si falla el guardado
  Future<void> saveDevice(WearableDevice device);

  /// Obtener un dispositivo específico por MAC address
  ///
  /// [macAddress] - MAC address del dispositivo (formato: "AA:BB:CC:DD:EE:FF")
  ///
  /// Returns:
  /// - [WearableDevice] si existe en el storage
  /// - null si no existe
  ///
  /// Throws: [DiscoveredDeviceStorageException] si falla la lectura
  Future<WearableDevice?> getDevice(String macAddress);

  /// Obtener todos los dispositivos guardados
  ///
  /// Útil para:
  /// - Historial de dispositivos conectados
  /// - Migración de datos
  /// - Debug y diagnostics
  ///
  /// Returns: List de todos los dispositivos en el storage (puede estar vacío)
  ///
  /// Throws: [DiscoveredDeviceStorageException] si falla la lectura
  Future<List<WearableDevice>> getAllDevices();

  /// Eliminar un dispositivo específico del storage
  ///
  /// Se llama automáticamente desde [WearableSensors.unpair()].
  /// Es seguro llamar múltiples veces (idempotente).
  ///
  /// [macAddress] - MAC address del dispositivo a eliminar
  ///
  /// Returns: true si se eliminó algo, false si no existía
  ///
  /// Throws: [DiscoveredDeviceStorageException] si falla la eliminación
  Future<bool> deleteDevice(String macAddress);

  /// Limpiar todos los dispositivos del storage
  ///
  /// CUIDADO: Operación destructiva. Solo usar para:
  /// - Testing
  /// - Reset de la app
  /// - Migración de datos (backup first!)
  ///
  /// Throws: [DiscoveredDeviceStorageException] si falla la limpieza
  Future<void> cleanupAll();

  /// Obtener estadísticas del storage (debug/monitoring)
  ///
  /// Useful for:
  /// - Ver cuántos dispositivos se han guardado
  /// - Detectar crecimiento excesivo (indicador de bugs)
  /// - Dashboard de diagnostics
  ///
  /// Returns: Map con "device_count", "storage_size_bytes", etc.
  Future<Map<String, dynamic>> getStats();
}

/// Exception para errores de storage
class DiscoveredDeviceStorageException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  DiscoveredDeviceStorageException(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'DiscoveredDeviceStorageException: $message'
      '${originalError != null ? '\n  Causa: $originalError' : ''}'
      '${stackTrace != null ? '\n  Stack: $stackTrace' : ''}';
}
