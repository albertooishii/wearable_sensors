// � Wearable Sensors Package v0.0.1
// Connection state enum for wearable devices
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// Connection state for wearable devices
///
/// Vendor-agnostic state machine for device connections.
/// Used by all layers of the app without importing bluetooth internals.
enum ConnectionState {
  /// Device is not connected
  disconnected,

  /// Device is in the process of connecting (may include authentication)
  connecting,

  /// Device is authenticating (BLE pairing, key exchange, etc.)
  authenticating,

  /// Device is connected and ready to receive commands
  connected,

  /// Device is connected and actively streaming biometric data
  streaming,

  /// Connection error occurred
  error,
}

/// Extension methods for ConnectionState
extension ConnectionStateExtension on ConnectionState {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case ConnectionState.disconnected:
        return 'Disconnected';
      case ConnectionState.connecting:
        return 'Connecting...';
      case ConnectionState.authenticating:
        return 'Authenticating...';
      case ConnectionState.connected:
        return 'Connected';
      case ConnectionState.streaming:
        return 'Streaming';
      case ConnectionState.error:
        return 'Error';
    }
  }

  /// Check if device is in a connected state (connected or streaming)
  bool get isConnected =>
      this == ConnectionState.connected || this == ConnectionState.streaming;

  /// Check if device is actively streaming biometric data
  bool get isStreaming => this == ConnectionState.streaming;

  /// Check if device is in a transitional state (connecting or authenticating)
  bool get isTransitioning =>
      this == ConnectionState.connecting ||
      this == ConnectionState.authenticating;

  /// Check if device is in an error state
  bool get hasError => this == ConnectionState.error;

  /// Check if device can be connected (disconnected or error)
  bool get canConnect =>
      this == ConnectionState.disconnected || this == ConnectionState.error;

  /// Check if device can be disconnected (any state except disconnected)
  bool get canDisconnect => this != ConnectionState.disconnected;

  /// Icon name for UI representation
  String get iconName {
    switch (this) {
      case ConnectionState.disconnected:
        return 'bluetooth_disabled';
      case ConnectionState.connecting:
        return 'bluetooth_searching';
      case ConnectionState.authenticating:
        return 'lock_open';
      case ConnectionState.connected:
        return 'bluetooth_connected';
      case ConnectionState.streaming:
        return 'bluetooth_audio';
      case ConnectionState.error:
        return 'error';
    }
  }

  /// Color for UI representation (as hex string)
  String get colorHex {
    switch (this) {
      case ConnectionState.disconnected:
        return '#9E9E9E'; // Gray
      case ConnectionState.connecting:
        return '#2196F3'; // Blue
      case ConnectionState.authenticating:
        return '#FF9800'; // Orange
      case ConnectionState.connected:
        return '#4CAF50'; // Green
      case ConnectionState.streaming:
        return '#00BCD4'; // Cyan
      case ConnectionState.error:
        return '#F44336'; // Red
    }
  }
}
