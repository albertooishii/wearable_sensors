// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// SPP Protocol Version Detection Service
///
/// Detects which SPP protocol version (V1 or V2) the Xiaomi device uses.
///
/// Based on Gadgetbridge XiaomiSppSupport.java lines 272-294:
/// ```java
/// private void handleVersionPacket(final byte[] payloadBytes) {
///     if (payloadBytes != null && payloadBytes.length > 0) {
///         if (payloadBytes[0] >= 2) {
///             LOG.info("detected protocol version higher than 2, switching protocol");
///             mProtocol = new XiaomiSppProtocolV2(this);
///         }
///     }
/// }
/// ```
///
/// Usage:
/// ```dart
/// final detector = SppVersionDetector();
/// final version = await detector.detectVersion(
///   deviceId: 'XX:XX:XX:XX:XX:XX',
///   deviceConfig: config,
/// );
/// // version = 1 for Band 9, version = 2 for Band 10
/// ```
library;

import 'dart:async';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:flutter/foundation.dart';
import 'v1/packet.dart';

/// Result of version detection
class SppVersionDetectionResult {
  const SppVersionDetectionResult({
    required this.version,
    required this.detectedFromResponse,
    required this.reason,
  });
  final int version;
  final bool detectedFromResponse;
  final String reason;

  @override
  String toString() =>
      'SppVersionDetectionResult(version=$version, detected=$detectedFromResponse, reason=$reason)';
}

/// SPP Protocol Version Detector
///
/// Sends VERSION request in V1 format and parses the response to determine
/// which protocol version the device supports.
class SppVersionDetector {
  SppVersionDetector(this._bleService);
  final BleService _bleService;

  /// Detect SPP protocol version
  ///
  /// Process:
  /// 1. Build VERSION request using V1 packet format
  /// 2. Write to device's command_write characteristic
  /// 3. Wait for response on rawBleDataStream (timeout 5s)
  /// 4. Parse response byte[0]:
  ///    - If >= 2: Device uses SPP V2
  ///    - If 1: Device uses SPP V1
  ///    - If timeout/empty: Fallback to V1
  ///
  /// Parameters:
  /// - [deviceId]: Device Bluetooth ID
  /// - [commandWriteUuid]: UUID for writing commands (e.g., '005F' for Band 10)
  /// - [enableAutoDetection]: If false, skip detection and use [fallbackVersion]
  /// - [fallbackVersion]: Version to use if detection fails (default: 1)
  /// - [timeoutSeconds]: Timeout for waiting response (default: 5)
  ///
  /// Returns: [SppVersionDetectionResult] with detected version
  Future<SppVersionDetectionResult> detectVersion({
    required final String deviceId,
    required final String commandWriteUuid,
    final bool enableAutoDetection = true,
    final int fallbackVersion = 1,
    final int timeoutSeconds = 5,
  }) async {
    // Check if auto-detection is disabled
    if (!enableAutoDetection) {
      debugPrint(
        '⚙️  SPP Version: Auto-detection disabled, using fallback V$fallbackVersion',
      );
      return SppVersionDetectionResult(
        version: fallbackVersion,
        detectedFromResponse: false,
        reason: 'Auto-detection disabled',
      );
    }

    debugPrint('🔍 SPP Version: Detecting protocol version...');
    debugPrint('   Device: $deviceId');
    debugPrint('   Write UUID: $commandWriteUuid');

    try {
      // Step 1: Build VERSION request (V1 format)
      final versionRequest = _buildVersionRequest();
      debugPrint('📤 SPP Version: Sending VERSION request (V1 format)');
      debugPrint(
        '   Packet: ${versionRequest.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Step 2: Set up response listener BEFORE sending request
      final responseCompleter = Completer<Uint8List>();
      StreamSubscription<BleDataPacket>? subscription;

      subscription = _bleService.rawBleDataStream.listen(
        (final packet) {
          final data = Uint8List.fromList(packet.rawData);
          debugPrint(
            '🔔 SPP Version: Received BLE data (${data.length} bytes)',
          );
          debugPrint(
            '   Data: ${data.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
          );

          // Check if this is a VERSION response
          if (_isVersionResponse(data)) {
            debugPrint('✅ SPP Version: Valid VERSION response detected');
            if (!responseCompleter.isCompleted) {
              responseCompleter.complete(data);
              subscription?.cancel();
            }
          }
        },
        onError: (final error) {
          debugPrint('❌ SPP Version: Error in data stream: $error');
          if (!responseCompleter.isCompleted) {
            responseCompleter.completeError(error);
          }
        },
      );

      // Step 3: Write VERSION request to device
      await _bleService.writeCharacteristic(
        deviceId: deviceId,
        serviceUuid: '0000FE95-0000-1000-8000-00805F9B34FB',
        characteristicUuid: commandWriteUuid,
        data: versionRequest,
        withoutResponse: true,
      );

      debugPrint(
        '⏳ SPP Version: Waiting for response (timeout: ${timeoutSeconds}s)...',
      );

      // Step 4: Wait for response with timeout
      final response = await responseCompleter.future.timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          debugPrint(
            '⚠️  SPP Version: Response timeout after ${timeoutSeconds}s',
          );
          subscription?.cancel();
          return Uint8List(0); // Empty response on timeout
        },
      );

      // Step 5: Parse version from response
      final result = _parseVersionResponse(response, fallbackVersion);
      debugPrint('🎯 SPP Version: Detection complete - $result');

      return result;
    } on Exception catch (e) {
      debugPrint('❌ SPP Version: Detection failed: $e');
      debugPrint('   Falling back to V$fallbackVersion');
      return SppVersionDetectionResult(
        version: fallbackVersion,
        detectedFromResponse: false,
        reason: 'Detection failed: $e',
      );
    }
  }

  /// Build VERSION request packet (V1 format)
  ///
  /// Packet structure (Gadgetbridge XiaomiSppSupport.java:75):
  /// ```java
  /// builder.write(XiaomiSppPacketV1.newBuilder()
  ///     .channel(Channel.Version)
  ///     .needsResponse(true)
  ///     .opCode(OPCODE_READ)
  ///     .dataType(DATA_TYPE_PLAIN)
  ///     .frameSerial(0)
  ///     .build()
  ///     .encode(null, null));
  /// ```
  Uint8List _buildVersionRequest() {
    final packet = XiaomiSppPacketV1Builder()
        .setChannel(XiaomiSppChannel.version) // Channel 0
        .setOpCode(XiaomiSppV1Constants.opcodeRead) // READ opcode (0)
        .setDataType(XiaomiSppV1Constants.dataTypePlain) // PLAIN data (0)
        .setFrameSerial(0) // Serial 0
        .setNeedsResponse(true) // Expect response
        .setPayload(Uint8List(0)) // Empty payload
        .build();

    return packet.encode();
  }

  /// Check if received data is a VERSION response
  ///
  /// VERSION responses should:
  /// - Start with V1 preamble [0xba, 0xdc, 0xfe] OR V2 preamble [0xa5, 0xa5]
  /// - Have channel 0 (VERSION channel)
  /// - Contain version byte in payload
  bool _isVersionResponse(final Uint8List data) {
    if (data.isEmpty) return false;

    // Check for V1 preamble
    if (data.length >= 3 &&
        data[0] == 0xba &&
        data[1] == 0xdc &&
        data[2] == 0xfe) {
      // V1 packet: check channel byte
      if (data.length >= 4 && data[3] == 0x00) {
        // Channel 0 = VERSION
        return true;
      }
    }

    // Check for V2 preamble
    if (data.length >= 2 && data[0] == 0xa5 && data[1] == 0xa5) {
      // V2 packet: likely a VERSION response if device supports V2
      return true;
    }

    return false;
  }

  /// Parse VERSION response and determine protocol version
  ///
  /// Gadgetbridge logic (XiaomiSppSupport.java:284):
  /// ```java
  /// if (payloadBytes[0] >= 2) {
  ///     LOG.info("detected protocol version higher than 2, switching protocol");
  ///     mProtocol = new XiaomiSppProtocolV2(this);
  /// }
  /// ```
  SppVersionDetectionResult _parseVersionResponse(
    final Uint8List response,
    final int fallbackVersion,
  ) {
    if (response.isEmpty) {
      return SppVersionDetectionResult(
        version: fallbackVersion,
        detectedFromResponse: false,
        reason: 'Empty response, using fallback V$fallbackVersion',
      );
    }

    try {
      // Decode V1 packet to get payload
      final packet = XiaomiSppPacketV1.decode(response);

      if (packet?.payload.isEmpty ?? true) {
        debugPrint('⚠️  SPP Version: Empty payload in response');
        return SppVersionDetectionResult(
          version: fallbackVersion,
          detectedFromResponse: false,
          reason: 'Empty payload, using fallback V$fallbackVersion',
        );
      }

      // Parse version byte (first byte of payload)
      final versionByte = packet!.payload[0];
      debugPrint('📡 SPP Version: Response payload[0] = $versionByte');

      // Gadgetbridge auto-switch logic
      if (versionByte >= 2) {
        debugPrint('🔄 SPP Version: Device supports V2 (response byte >= 2)');
        return SppVersionDetectionResult(
          version: 2,
          detectedFromResponse: true,
          reason: 'Device reported version $versionByte (>= 2)',
        );
      } else {
        debugPrint('📌 SPP Version: Device supports V1 (response byte < 2)');
        return SppVersionDetectionResult(
          version: 1,
          detectedFromResponse: true,
          reason: 'Device reported version $versionByte (< 2)',
        );
      }
    } on Exception catch (e) {
      debugPrint('⚠️  SPP Version: Failed to parse response: $e');
      return SppVersionDetectionResult(
        version: fallbackVersion,
        detectedFromResponse: false,
        reason: 'Parse error: $e, using fallback V$fallbackVersion',
      );
    }
  }
}
