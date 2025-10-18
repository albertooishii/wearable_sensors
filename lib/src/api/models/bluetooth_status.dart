// This file is part of the wearable_sensors package.
//
// Mozilla Public License Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.mozilla.org/en-US/MPL/2.0/
//
// Software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing rights and limitations
// under the License.
//
// SPDX-License-Identifier: MPL-2.0

/// Represents the current Bluetooth system state.
///
/// This class provides information about Bluetooth availability, permissions,
/// and any errors that may prevent device discovery or connection.
///
/// **Example:**
/// ```dart
/// final status = await WearableSensors.getBluetoothStatus();
///
/// if (!status.isEnabled) {
///   print('Please enable Bluetooth');
/// } else if (!status.hasPermissions) {
///   print('Please grant Bluetooth permissions');
/// } else if (status.isReady) {
///   print('Bluetooth is ready to use');
/// }
/// ```
class BluetoothStatus {
  /// Creates a new Bluetooth status.
  const BluetoothStatus({
    required this.isEnabled,
    required this.isAvailable,
    required this.hasPermissions,
    this.isScanning = false,
    this.errorMessage,
  });

  /// Creates an initial/default Bluetooth status.
  ///
  /// Returns a status indicating Bluetooth is disabled and permissions
  /// are not granted. Useful for initialization.
  factory BluetoothStatus.initial() {
    return const BluetoothStatus(
      isEnabled: false,
      isAvailable: false,
      hasPermissions: false,
      isScanning: false,
    );
  }

  /// Whether Bluetooth is currently enabled (turned on).
  ///
  /// If `false`, the user needs to enable Bluetooth in system settings.
  final bool isEnabled;

  /// Whether Bluetooth hardware is available on this device.
  ///
  /// If `false`, the device does not have Bluetooth capabilities.
  final bool isAvailable;

  /// Whether the app has been granted necessary Bluetooth permissions.
  ///
  /// Required permissions vary by platform:
  /// - Android 12+: BLUETOOTH_SCAN, BLUETOOTH_CONNECT
  /// - Android <12: BLUETOOTH, BLUETOOTH_ADMIN, ACCESS_FINE_LOCATION
  /// - iOS: Bluetooth permission (requested automatically)
  final bool hasPermissions;

  /// Whether a device scan is currently in progress.
  final bool isScanning;

  /// Error message if there's a problem with Bluetooth setup.
  ///
  /// Null if no errors. May contain details about permission issues,
  /// initialization failures, or other Bluetooth-related problems.
  final String? errorMessage;

  /// Whether Bluetooth is fully ready for device operations.
  ///
  /// Returns `true` only if Bluetooth is enabled, available, has permissions,
  /// and has no errors. This is the "green light" for scanning and connecting.
  bool get isReady =>
      isEnabled && isAvailable && hasPermissions && errorMessage == null;

  /// Whether there are any issues preventing Bluetooth usage.
  ///
  /// Opposite of [isReady]. Returns `true` if any problem exists.
  bool get hasIssues => !isReady;

  /// Human-readable description of the current Bluetooth state.
  ///
  /// Returns a user-friendly message explaining the current status,
  /// including any issues that need to be resolved.
  String get statusMessage {
    if (errorMessage != null) {
      return 'Error: $errorMessage';
    }
    if (!isAvailable) {
      return 'Bluetooth is not available on this device';
    }
    if (!isEnabled) {
      return 'Bluetooth is disabled - please enable it in settings';
    }
    if (!hasPermissions) {
      return 'Bluetooth permissions not granted';
    }
    if (isScanning) {
      return 'Scanning for devices...';
    }
    return 'Bluetooth is ready';
  }

  /// Creates a copy of this status with some fields replaced.
  BluetoothStatus copyWith({
    bool? isEnabled,
    bool? isAvailable,
    bool? hasPermissions,
    bool? isScanning,
    String? errorMessage,
  }) {
    return BluetoothStatus(
      isEnabled: isEnabled ?? this.isEnabled,
      isAvailable: isAvailable ?? this.isAvailable,
      hasPermissions: hasPermissions ?? this.hasPermissions,
      isScanning: isScanning ?? this.isScanning,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BluetoothStatus &&
        other.isEnabled == isEnabled &&
        other.isAvailable == isAvailable &&
        other.hasPermissions == hasPermissions &&
        other.isScanning == isScanning &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      isEnabled,
      isAvailable,
      hasPermissions,
      isScanning,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'BluetoothStatus('
        'enabled: $isEnabled, '
        'available: $isAvailable, '
        'permissions: $hasPermissions, '
        'scanning: $isScanning, '
        'ready: $isReady'
        ')';
  }
}
