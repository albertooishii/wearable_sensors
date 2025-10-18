// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP V1 Protocol Universal Constants
///
/// These values are UNIVERSAL across ALL Xiaomi devices using SPP Protocol V1.
/// They are hardcoded based on Gadgetbridge's implementation.
///
/// Source: Gadgetbridge XiaomiSppPacketV1.java
/// Devices analyzed: Mi Band 9, Mi Band 8, Mi Watch Lite, etc. (10+ devices)
/// Conclusion: ALL use identical V1 protocol constants (no device-specific overrides).
///
/// Evidence:
/// - XiaomiSppPacketV1.java contains `static final` constants
/// - No device coordinator overrides these values
/// - Proven across 10+ Xiaomi devices in Gadgetbridge codebase
library;

/// SPP V1 Protocol Universal Constants
class SppV1Constants {
  /// Packet preamble - universal [0xba, 0xdc, 0xfe]
  /// Source: XiaomiSppPacketV1.java line 28
  static const packetPreamble = [0xba, 0xdc, 0xfe];

  /// Packet epilogue - universal [0xef]
  /// Source: XiaomiSppPacketV1.java line 29
  static const packetEpilogue = [0xef];

  // ========== Channels - UNIVERSAL ==========

  /// Channel for VERSION handshake (used to detect V1 vs V2)
  static const channelVersion = 0;

  /// Channel for PROTO messages received FROM device
  static const channelProtoRx = 1;

  /// Channel for PROTO messages sent TO device (authentication, commands)
  static const channelProtoTx = 2;

  /// Channel for fitness/activity data
  static const channelFitness = 3;

  /// Channel for voice data
  static const channelVoice = 4;

  /// Channel for mass data transfer
  static const channelMass = 5;

  /// Channel for OTA firmware updates
  static const channelOta = 7;

  // ========== Opcodes - UNIVERSAL ==========

  /// Opcode for READ operations
  static const opcodeRead = 0;

  /// Opcode for SEND operations (write data)
  static const opcodeSend = 2;

  // ========== Data Types - UNIVERSAL ==========

  /// Data type: Plain text (no encryption)
  static const dataTypePlain = 0;

  /// Data type: Encrypted data
  static const dataTypeEncrypted = 1;

  /// Data type: Authentication data
  static const dataTypeAuth = 2;

  // ========== Default Mappings for Backward Compatibility ==========

  /// Default channel mappings (for config.dart)
  static const Map<String, int> defaultChannels = {
    'version': channelVersion, // 0
    'proto_rx': channelProtoRx, // 1
    'proto_tx': channelProtoTx, // 2
    'authentication': channelProtoTx, // 2 (alias for proto_tx)
    'fitness': channelFitness, // 3
    'voice': channelVoice, // 4
    'mass': channelMass, // 5
    'ota': channelOta, // 7
  };

  /// Default opcode mappings (for config.dart)
  static const Map<String, int> defaultOpcodes = {
    'read': opcodeRead, // 0
    'send': opcodeSend, // 2
  };

  /// Default data type mappings (for config.dart)
  static const Map<String, int> defaultDataTypes = {
    'plain': dataTypePlain, // 0
    'encrypted': dataTypeEncrypted, // 1
    'auth': dataTypeAuth, // 2
  };
}
