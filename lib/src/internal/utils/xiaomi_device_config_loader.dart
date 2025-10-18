import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wearable_sensors/src/internal/models/xiaomi_spp_config.dart';

/// Helper to load Xiaomi device implementation configurations
class XiaomiDeviceConfigLoader {
  // ✅ Ruta correcta para assets en paquetes: packages/nombre_paquete/ruta/al/asset
  static const String _basePath =
      'packages/wearable_sensors/assets/device_implementations';

  /// Load authentication config for a specific device type
  ///
  /// [deviceType] - e.g. "xiaomi_smart_band_10", "xiaomi_smart_band_9"
  static Future<XiaomiAuthConfig> loadAuthConfig(
    final String deviceType,
  ) async {
    final jsonPath = '$_basePath/$deviceType.json';

    try {
      final jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> deviceConfig = json.decode(jsonString);

      if (!deviceConfig.containsKey('authentication')) {
        throw Exception('No authentication section found in $deviceType.json');
      }

      return XiaomiAuthConfig.fromJson(
        deviceConfig['authentication'] as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to load auth config for $deviceType: $e');
    }
  }

  /// Load complete device configuration
  static Future<Map<String, dynamic>> loadDeviceConfig(
    final String deviceType,
  ) async {
    final jsonPath = '$_basePath/$deviceType.json';
    final jsonString = await rootBundle.loadString(jsonPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Get SPP protocol version for a device
  static Future<SppProtocolVersion> getDeviceSppVersion(
    final String deviceType,
  ) async {
    final authConfig = await loadAuthConfig(deviceType);
    return authConfig.sppProtocol.defaultVersion;
  }

  /// Check if device supports version detection
  static Future<bool> supportsVersionDetection(final String deviceType) async {
    final authConfig = await loadAuthConfig(deviceType);
    return authConfig.sppProtocol.versionDetection?.enabled ?? false;
  }
}
