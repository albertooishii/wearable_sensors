// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 Bluetooth Classic SPP Transport - Dream Incubator
// SPP transport implementation over Bluetooth Classic (used for biometric data)

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/bluetooth/bluetooth_classic_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/spp_transport.dart';

/// Bluetooth Classic transport for SPP communication (post-authentication data streaming)
class BtClassicSppTransport implements SppTransport {
  BtClassicSppTransport({
    required this.deviceAddress,
    required this.btClassicService,
  });

  final String deviceAddress;
  final BluetoothClassicService btClassicService;

  StreamController<Uint8List>? _dataController;
  StreamSubscription<BluetoothClassicDataPacket>? _btClassicSubscription;
  bool _isInitialized = false;

  @override
  bool get isConnected =>
      _isInitialized && btClassicService.isConnected(deviceAddress);

  @override
  Stream<Uint8List> get dataStream {
    _dataController ??= StreamController<Uint8List>.broadcast();
    return _dataController!.stream;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ BtClassicSppTransport already initialized');
      return;
    }

    try {
      debugPrint('🔧 Initializing BT_CLASSIC SPP transport...');
      debugPrint('   Device: $deviceAddress');

      // Initialize Bluetooth Classic service
      await btClassicService.initialize();

      // Connect to device via BT_CLASSIC
      // ✅ .connect() now throws on failure instead of returning false
      await btClassicService.connect(deviceAddress);

      // Start listening to incoming data
      _dataController = StreamController<Uint8List>.broadcast();

      _btClassicSubscription = btClassicService.dataStream.listen(
        (final packet) {
          // debugPrint('📥 BT_CLASSIC transport received data:');
          // debugPrint('   Device: ${packet.deviceAddress}');
          // debugPrint('   Data length: ${packet.rawData.length} bytes');
          // debugPrint(
          //   '   HEX: ${packet.rawData.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
          // );

          if (packet.deviceAddress == deviceAddress) {
            // debugPrint('   ✅ Forwarding to SPP service');
            _dataController?.add(packet.rawData);
          } else {
            // debugPrint('   ⚠️ Ignoring (wrong device)');
          }
        },
        onError: (final error) {
          // debugPrint('❌ BT_CLASSIC transport error: $error');
        },
      );

      _isInitialized = true;
      // debugPrint('✅ BT_CLASSIC SPP transport initialized');
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize BT_CLASSIC transport: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<bool> sendData(final Uint8List data) async {
    if (!_isInitialized) {
      debugPrint('⚠️ BT_CLASSIC transport not initialized');
      return false;
    }

    try {
      final success = await btClassicService.sendData(deviceAddress, data);
      if (success) {
        // debugPrint('📤 BT_CLASSIC: Sent ${data.length} bytes');
      }
      return success;
    } on Exception catch (e) {
      debugPrint('❌ BT_CLASSIC: Failed to send data: $e');
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    debugPrint('🗑️ Disposing BT_CLASSIC SPP transport...');
    await _btClassicSubscription?.cancel();
    _btClassicSubscription = null;
    await _dataController?.close();
    _dataController = null;
    await btClassicService.disconnect(deviceAddress);
    _isInitialized = false;
    debugPrint('✅ BT_CLASSIC SPP transport disposed');
  }
}
