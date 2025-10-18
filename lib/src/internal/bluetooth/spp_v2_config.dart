// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP V2 Protocol Configuration
///
/// SPP V2 protocol uses UNIVERSAL constants that are identical across all Xiaomi devices.
/// All values are hardcoded from SppV2Constants (based on Gadgetbridge's implementation).
///
/// JSON is NO LONGER READ for protocol values. Only device-specific data (UUIDs,
/// auth keys, supported commands) should be in JSON files.
///
/// IMPORTANT: All SPP V2 values (opcodes, channels, preamble, etc.) are IDENTICAL
/// across Mi Band 8, 9, 10, Redmi Watch series, and all other Xiaomi devices.
/// Source: Gadgetbridge XiaomiSppPacketV2.java (analyzed 20+ device implementations)
library;

import 'dart:convert';

import '../vendors/xiaomi/protocol/v2/constants.dart';

/// Configuration for SPP V2 Protocol
///
/// This class holds all universal constants for SPP V2 protocol.
/// Values are hardcoded from SppV2Constants - JSON is ignored for protocol values.
class SppV2Config {
  // --- Factory Constructors ---

  /// Load configuration from JSON map
  ///
  /// ALWAYS uses universal constants from SppV2Constants.
  /// JSON is ignored for protocol values (they're universal across all Xiaomi devices).
  factory SppV2Config.fromJson(final Map<String, dynamic> deviceJson) {
    // Ignore JSON, use universal constants
    return SppV2Config(
      packetPreamble: SppV2Constants.packetPreamble,
      packetTypes: SppV2Constants.defaultPacketTypes,
      sessionConfigOpcodes: SppV2Constants.defaultSessionConfigOpcodes,
      sessionConfigKeys: SppV2Constants.defaultSessionConfigKeys,
      dataOpcodes: SppV2Constants.defaultDataOpcodes,
      channels: SppV2Constants.defaultChannels,
    );
  }

  /// Load configuration from JSON string
  factory SppV2Config.fromJsonString(final String jsonString) {
    final deviceJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return SppV2Config.fromJson(deviceJson);
  }
  SppV2Config({
    required this.packetPreamble,
    required this.packetTypes,
    required this.sessionConfigOpcodes,
    required this.sessionConfigKeys,
    required this.dataOpcodes,
    required this.channels,
  });

  // --- Properties ---

  /// Packet preamble bytes (e.g., [0xa5, 0xa5] for Band 10)
  final List<int> packetPreamble;

  /// Packet type mappings: "ack" → 1, "session_config" → 2, "data" → 3
  final Map<String, int> packetTypes;

  /// Session config opcode mappings
  final Map<String, int> sessionConfigOpcodes;

  /// Session config key mappings
  final Map<String, int> sessionConfigKeys;

  /// Data opcode mappings
  final Map<String, int> dataOpcodes;

  /// Channel mappings: "version" → 0, "authentication" → 2, etc.
  final Map<String, int> channels;

  // --- Singleton Pattern ---

  static SppV2Config? _instance;

  /// Get the global SPP V2 configuration instance
  ///
  /// Throws StateError if not initialized. Call [initialize] first.
  static SppV2Config get instance {
    if (_instance == null) {
      throw StateError(
        'SppV2Config not initialized. Call SppV2Config.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if config has been initialized
  static bool get isInitialized => _instance != null;

  /// Initialize the global SPP V2 configuration from device JSON
  ///
  /// Example:
  /// ```dart
  /// final deviceJson = jsonDecode(await rootBundle.loadString('assets/device_implementations/xiaomi_smart_band_10.json'));
  /// SppV2Config.initialize(deviceJson);
  /// ```
  static void initialize(final Map<String, dynamic> deviceJson) {
    _instance = SppV2Config.fromJson(deviceJson);
    _instance!.validate();
  }

  /// Clear the global configuration (useful for testing)
  static void reset() {
    _instance = null;
  }

  // --- Packet Type Helpers ---

  /// Get packet type value by name (e.g., "ack" → 1)
  int getPacketType(final String name) {
    final value = packetTypes[name];
    if (value == null) {
      throw ArgumentError('Unknown packet type: $name');
    }
    return value;
  }

  /// Get packet type name by value (e.g., 1 → "ack")
  String getPacketTypeName(final int value) {
    final entry = packetTypes.entries.firstWhere(
      (final e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown packet type value: $value'),
    );
    return entry.key;
  }

  // --- Session Config Opcode Helpers ---

  /// Get session config opcode by name (e.g., "start_session_request" → 1)
  int getSessionConfigOpcode(final String name) {
    final value = sessionConfigOpcodes[name];
    if (value == null) {
      throw ArgumentError('Unknown session config opcode: $name');
    }
    return value;
  }

  /// Get session config opcode name by value (e.g., 1 → "start_session_request")
  String getSessionConfigOpcodeName(final int value) {
    final entry = sessionConfigOpcodes.entries.firstWhere(
      (final e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Unknown session config opcode value: $value'),
    );
    return entry.key;
  }

  // --- Session Config Key Helpers ---

  /// Get session config key by name (e.g., "version" → 1)
  int getSessionConfigKey(final String name) {
    final value = sessionConfigKeys[name];
    if (value == null) {
      throw ArgumentError('Unknown session config key: $name');
    }
    return value;
  }

  /// Get session config key name by value (e.g., 1 → "version")
  String getSessionConfigKeyName(final int value) {
    final entry = sessionConfigKeys.entries.firstWhere(
      (final e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Unknown session config key value: $value'),
    );
    return entry.key;
  }

  // --- Data Opcode Helpers ---

  /// Get data opcode by name (e.g., "send_auth" → 2)
  int getDataOpcode(final String name) {
    final value = dataOpcodes[name];
    if (value == null) {
      throw ArgumentError('Unknown data opcode: $name');
    }
    return value;
  }

  /// Get data opcode name by value (e.g., 2 → "send_auth")
  String? getDataOpcodeName(final int value) {
    final entry = dataOpcodes.entries.firstWhere(
      (final e) => e.value == value,
      orElse: () => const MapEntry('', -1),
    );
    return entry.key.isNotEmpty ? entry.key : null;
  }

  // --- Channel Helpers ---

  /// Get channel by name (e.g., "authentication" → 2)
  int getChannel(final String name) {
    final value = channels[name];
    if (value == null) {
      throw ArgumentError('Unknown channel: $name');
    }
    return value;
  }

  /// Get channel name by value (e.g., 2 → "authentication")
  String? getChannelName(final int value) {
    final entry = channels.entries.firstWhere(
      (final e) => e.value == value,
      orElse: () => const MapEntry('', -1),
    );
    return entry.key.isNotEmpty ? entry.key : null;
  }

  // --- Validation ---

  /// Validate configuration completeness
  void validate() {
    if (packetPreamble.isEmpty) {
      throw StateError('Packet preamble cannot be empty');
    }

    final requiredPacketTypes = ['ack', 'session_config', 'data'];
    for (final type in requiredPacketTypes) {
      if (!packetTypes.containsKey(type)) {
        throw StateError('Missing required packet type: $type');
      }
    }

    final requiredSessionConfigOpcodes = [
      'start_session_request',
      'start_session_response',
      'stop_session_request',
      'stop_session_response',
    ];
    for (final opcode in requiredSessionConfigOpcodes) {
      if (!sessionConfigOpcodes.containsKey(opcode)) {
        throw StateError('Missing required session config opcode: $opcode');
      }
    }

    final requiredSessionConfigKeys = [
      'version',
      'max_packet_size',
      'tx_win',
      'send_timeout',
    ];
    for (final key in requiredSessionConfigKeys) {
      if (!sessionConfigKeys.containsKey(key)) {
        throw StateError('Missing required session config key: $key');
      }
    }

    final requiredChannels = ['version', 'authentication'];
    for (final channel in requiredChannels) {
      if (!channels.containsKey(channel)) {
        throw StateError('Missing required channel: $channel');
      }
    }
  }

  @override
  String toString() {
    return 'SppV2Config('
        'preamble: ${packetPreamble.map((final b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(', ')}, '
        'packetTypes: $packetTypes, '
        'sessionConfigOpcodes: $sessionConfigOpcodes, '
        'sessionConfigKeys: $sessionConfigKeys, '
        'dataOpcodes: $dataOpcodes, '
        'channels: $channels'
        ')';
  }
}
