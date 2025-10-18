/// Configuration for Xiaomi SPP (Serial Port Profile) protocol
/// Loaded dynamically from device implementation JSON files
library;

import 'package:flutter/foundation.dart';

/// SPP Protocol version
enum SppProtocolVersion {
  v1,
  v2,
  unknown;

  static SppProtocolVersion fromString(final String version) {
    switch (version.toLowerCase()) {
      case 'v1':
        return SppProtocolVersion.v1;
      case 'v2':
        return SppProtocolVersion.v2;
      default:
        return SppProtocolVersion.unknown;
    }
  }
}

/// Version detection configuration
@immutable
class SppVersionDetectionConfig {
  const SppVersionDetectionConfig({
    required this.enabled,
    required this.channel,
    required this.opcode,
    required this.timeoutMs,
    required this.fallbackToV1,
  });

  factory SppVersionDetectionConfig.fromJson(final Map<String, dynamic> json) {
    return SppVersionDetectionConfig(
      enabled: json['enabled'] as bool? ?? false,
      channel: json['channel'] as int? ?? 0,
      opcode: json['opcode'] as int? ?? 0,
      timeoutMs: json['timeout_ms'] as int? ?? 5000,
      fallbackToV1: json['fallback_to_v1'] as bool? ?? true,
    );
  }
  final bool enabled;
  final int channel;
  final int opcode;
  final int timeoutMs;
  final bool fallbackToV1;

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'channel': channel,
        'opcode': opcode,
        'timeout_ms': timeoutMs,
        'fallback_to_v1': fallbackToV1,
      };
}

/// SPP V1 Protocol configuration
@immutable
class SppV1Config {
  const SppV1Config({
    required this.packetPreamble,
    required this.packetEpilogue,
    required this.channels,
    required this.opcodes,
    required this.dataTypes,
  });

  factory SppV1Config.fromJson(final Map<String, dynamic> json) {
    return SppV1Config(
      packetPreamble: List<int>.from(json['packet_preamble'] as List),
      packetEpilogue: List<int>.from(json['packet_epilogue'] as List),
      channels: Map<String, int>.from(json['channels'] as Map),
      opcodes: Map<String, int>.from(json['opcodes'] as Map),
      dataTypes: Map<String, int>.from(json['data_types'] as Map),
    );
  }
  final List<int> packetPreamble;
  final List<int> packetEpilogue;
  final Map<String, int> channels;
  final Map<String, int> opcodes;
  final Map<String, int> dataTypes;

  Map<String, dynamic> toJson() => {
        'packet_preamble': packetPreamble,
        'packet_epilogue': packetEpilogue,
        'channels': channels,
        'opcodes': opcodes,
        'data_types': dataTypes,
      };
}

/// SPP V2 Protocol configuration
@immutable
class SppV2Config {
  const SppV2Config({
    required this.packetPreamble,
    required this.packetTypes,
    required this.sessionSetupRequired,
  });

  factory SppV2Config.fromJson(final Map<String, dynamic> json) {
    return SppV2Config(
      packetPreamble: List<int>.from(json['packet_preamble'] as List),
      packetTypes: Map<String, int>.from(json['packet_types'] as Map),
      sessionSetupRequired: json['session_setup_required'] as bool? ?? false,
    );
  }
  final List<int> packetPreamble;
  final Map<String, int> packetTypes;
  final bool sessionSetupRequired;

  Map<String, dynamic> toJson() => {
        'packet_preamble': packetPreamble,
        'packet_types': packetTypes,
        'session_setup_required': sessionSetupRequired,
      };
}

/// Complete SPP Protocol configuration
@immutable
class XiaomiSppConfig {
  const XiaomiSppConfig({
    required this.defaultVersion,
    this.versionDetection,
    this.v1Config,
    this.v2Config,
  });

  factory XiaomiSppConfig.fromJson(final Map<String, dynamic> json) {
    final versionString = json['version'] as String? ?? 'v1';
    final defaultVersion = SppProtocolVersion.fromString(versionString);

    return XiaomiSppConfig(
      defaultVersion: defaultVersion,
      versionDetection: json['version_detection'] != null
          ? SppVersionDetectionConfig.fromJson(
              json['version_detection'] as Map<String, dynamic>,
            )
          : null,
      v1Config: json['v1'] != null
          ? SppV1Config.fromJson(json['v1'] as Map<String, dynamic>)
          : null,
      v2Config: json['v2'] != null
          ? SppV2Config.fromJson(json['v2'] as Map<String, dynamic>)
          : null,
    );
  }
  final SppProtocolVersion defaultVersion;
  final SppVersionDetectionConfig? versionDetection;
  final SppV1Config? v1Config;
  final SppV2Config? v2Config;

  Map<String, dynamic> toJson() => {
        'version': defaultVersion.name,
        if (versionDetection != null)
          'version_detection': versionDetection!.toJson(),
        if (v1Config != null) 'v1': v1Config!.toJson(),
        if (v2Config != null) 'v2': v2Config!.toJson(),
      };

  @override
  String toString() {
    return 'XiaomiSppConfig('
        'defaultVersion=$defaultVersion, '
        'versionDetection=${versionDetection != null}, '
        'v1Config=${v1Config != null}, '
        'v2Config=${v2Config != null})';
  }
}

/// Authentication configuration with SPP protocol info
@immutable
class XiaomiAuthConfig {
  const XiaomiAuthConfig({
    required this.protocol,
    required this.connectionType,
    required this.serviceUuid,
    required this.commandReadUuid,
    required this.commandWriteUuid,
    required this.encryptionRequired,
    required this.sppProtocol,
  });

  factory XiaomiAuthConfig.fromJson(final Map<String, dynamic> json) {
    return XiaomiAuthConfig(
      protocol: json['protocol'] as String? ?? 'xiaomi_spp',
      connectionType: json['connection_type'] as String? ?? 'spp_over_ble',
      serviceUuid: json['service_uuid'] as String,
      commandReadUuid: json['command_read_uuid'] as String,
      commandWriteUuid: json['command_write_uuid'] as String,
      encryptionRequired: json['encryption_required'] as bool? ?? true,
      sppProtocol: XiaomiSppConfig.fromJson(
        json['spp_protocol'] as Map<String, dynamic>,
      ),
    );
  }
  final String protocol;
  final String connectionType;
  final String serviceUuid;
  final String commandReadUuid;
  final String commandWriteUuid;
  final bool encryptionRequired;
  final XiaomiSppConfig sppProtocol;

  Map<String, dynamic> toJson() => {
        'protocol': protocol,
        'connection_type': connectionType,
        'service_uuid': serviceUuid,
        'command_read_uuid': commandReadUuid,
        'command_write_uuid': commandWriteUuid,
        'encryption_required': encryptionRequired,
        'spp_protocol': sppProtocol.toJson(),
      };

  @override
  String toString() {
    return 'XiaomiAuthConfig('
        'protocol=$protocol, '
        'connectionType=$connectionType, '
        'sppVersion=${sppProtocol.defaultVersion})';
  }
}
