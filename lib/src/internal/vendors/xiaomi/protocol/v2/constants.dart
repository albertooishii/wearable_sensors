// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP V2 Protocol Universal Constants
///
/// These values are IDENTICAL for ALL Xiaomi devices that use SPP V2 protocol.
/// They are defined as constants in Gadgetbridge's XiaomiSppPacketV2.java
/// and should NOT be configured per-device.
///
/// Source: Gadgetbridge XiaomiSppPacketV2.java (lines 40-270)
library;

/// Packet Preamble - Always [0xA5, 0xA5]
class SppV2Constants {
  SppV2Constants._(); // Private constructor to prevent instantiation

  /// Packet preamble bytes (universal for all Xiaomi SPP V2 devices)
  static const packetPreamble = [0xa5, 0xa5];

  /// Packet Types (universal)
  static const packetTypeAck = 1;
  static const packetTypeSessionConfig = 2;
  static const packetTypeData = 3;

  /// Data Opcodes (universal)
  /// Gadgetbridge: OPCODE_SEND_PLAINTEXT = 1, OPCODE_SEND_ENCRYPTED = 2
  static const opcodeDataSendPlaintext = 1;
  static const opcodeDataSendEncrypted = 2;
  static const opcodeDataSendActivity = 3;
  static const opcodeDataSendMassData = 5;

  /// Channels (universal)
  /// Gadgetbridge: CHANNEL_PROTOBUF=1, CHANNEL_DATA=2, CHANNEL_ACTIVITY=5
  static const channelVersion = 0; // V1 version handshake
  static const channelProtobuf = 1; // encrypted after authentication
  static const channelData = 2; // not encrypted
  static const channelActivity = 5; // encrypted

  /// Session Config Opcodes (universal)
  static const opcodeStartSessionRequest = 1;
  static const opcodeStartSessionResponse = 2;
  static const opcodeStopSessionRequest = 3;
  static const opcodeStopSessionResponse = 4;

  /// Session Config Keys (universal)
  static const keyVersion = 1;
  static const keyMaxPacketSize = 2;
  static const keyTxWin = 3;
  static const keySendTimeout = 4;

  /// Default mapping: opcode name → value
  /// This maintains compatibility with existing dynamic config code
  static const Map<String, int> defaultDataOpcodes = {
    'send_plaintext': opcodeDataSendPlaintext,
    'send_encrypted': opcodeDataSendEncrypted,
    'send_protobuf': opcodeDataSendEncrypted, // Alias for encrypted
    'send_auth':
        opcodeDataSendPlaintext, // ✅ FIXED: Auth uses PLAINTEXT opcode=1 (Gadgetbridge XiaomiSppPacketV2.java:348)
    'send_activity': opcodeDataSendActivity,
    'send_mass_data': opcodeDataSendMassData,
  };

  /// Default mapping: channel name → value
  static const Map<String, int> defaultChannels = {
    'version': channelVersion,
    'authentication': channelProtobuf,
    'protobuf_command': channelProtobuf,
    'activity': channelActivity,
    'data': channelData,
  };

  /// Default mapping: packet type name → value
  static const Map<String, int> defaultPacketTypes = {
    'ack': packetTypeAck,
    'session_config': packetTypeSessionConfig,
    'data': packetTypeData,
  };

  /// Default mapping: session config opcode name → value
  static const Map<String, int> defaultSessionConfigOpcodes = {
    'start_session_request': opcodeStartSessionRequest,
    'start_session_response': opcodeStartSessionResponse,
    'stop_session_request': opcodeStopSessionRequest,
    'stop_session_response': opcodeStopSessionResponse,
  };

  /// Default mapping: session config key name → value
  static const Map<String, int> defaultSessionConfigKeys = {
    'version': keyVersion,
    'max_packet_size': keyMaxPacketSize,
    'tx_win': keyTxWin,
    'send_timeout': keySendTimeout,
  };
}
