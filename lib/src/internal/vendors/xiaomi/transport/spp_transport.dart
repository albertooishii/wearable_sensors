// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 SPP Transport Layer - Dream Incubator
// Abstract transport interface for SPP communication
// Allows SPP protocol to work over both BLE and Bluetooth Classic

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Abstract transport layer for SPP communication
///
/// This allows the SPP protocol to work over different transport mechanisms:
/// - BLE (during authentication)
/// - Bluetooth Classic (for biometric data streaming)
abstract class SppTransport {
  /// Send raw data through the transport
  Future<bool> sendData(final Uint8List data);

  /// Stream of incoming raw data
  Stream<Uint8List> get dataStream;

  /// Check if transport is connected and ready
  bool get isConnected;

  /// Initialize the transport (connect, discover services, etc.)
  Future<void> initialize();

  /// Dispose resources
  Future<void> dispose();
}

/// Transport connection state
enum TransportState { disconnected, connecting, connected, error }
