// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 BLE SPP Transport - Dream Incubator
// SPP transport implementation over BLE (used during authentication)

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/spp_transport.dart';

/// BLE transport for SPP communication (used during authentication)
class BleSppTransport implements SppTransport {
  BleSppTransport({
    required this.deviceId,
    required this.bleService,
    required this.serviceUuid,
    required this.writeCharacteristicUuid,
    required this.readCharacteristicUuid,
  });

  final String deviceId;
  final BleService bleService;
  final String serviceUuid;
  final String writeCharacteristicUuid;
  final String readCharacteristicUuid;

  StreamController<Uint8List>? _dataController;
  StreamSubscription<BleDataPacket>? _bleSubscription;
  bool _isInitialized = false;

  @override
  bool get isConnected => _isInitialized;

  @override
  Stream<Uint8List> get dataStream {
    _dataController ??= StreamController<Uint8List>.broadcast();
    return _dataController!.stream;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ BleSppTransport already initialized');
      return;
    }

    try {
      debugPrint('🔧 Initializing BLE SPP transport...');
      debugPrint('   Device: $deviceId');
      debugPrint('   Service: $serviceUuid');
      debugPrint('   Write: $writeCharacteristicUuid');
      debugPrint('   Read: $readCharacteristicUuid');

      // ✅ CRÍTICO: Enable notifications on read characteristic FIRST
      debugPrint('🔔 Enabling notifications on $readCharacteristicUuid...');
      await bleService.setNotifiable(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: readCharacteristicUuid,
        enable: true,
      );
      debugPrint('✅ Notifications enabled on read characteristic');

      // Subscribe to notifications from read characteristic
      _dataController = StreamController<Uint8List>.broadcast();

      _bleSubscription = bleService.rawBleDataStream.listen(
        (final packet) {
          if (packet.deviceId == deviceId &&
              packet.serviceUuid.toLowerCase() == serviceUuid.toLowerCase() &&
              packet.characteristicUuid.toLowerCase() ==
                  readCharacteristicUuid.toLowerCase()) {
            debugPrint(
              '📥 BLE transport received ${packet.rawData.length} bytes',
            );
            _dataController?.add(Uint8List.fromList(packet.rawData));
          }
        },
        onError: (final error) {
          debugPrint('❌ BLE transport error: $error');
        },
      );

      _isInitialized = true;
      debugPrint('✅ BLE SPP transport initialized');
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize BLE transport: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<bool> sendData(final Uint8List data) async {
    if (!_isInitialized) {
      debugPrint('⚠️ BLE transport not initialized');
      return false;
    }

    try {
      final success = await bleService.writeCharacteristic(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: writeCharacteristicUuid,
        data: data.toList(),
      );
      if (success) {
        debugPrint('📤 BLE: Sent ${data.length} bytes');
      }
      return success;
    } on Exception catch (e) {
      debugPrint('❌ BLE: Failed to send data: $e');
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    debugPrint('🗑️ Disposing BLE SPP transport...');
    await _bleSubscription?.cancel();
    _bleSubscription = null;
    await _dataController?.close();
    _dataController = null;
    _isInitialized = false;
    debugPrint('✅ BLE SPP transport disposed');
  }
}
