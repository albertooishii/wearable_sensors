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

// 📡 Bluetooth Connection State - Dream Incubator
// Estado global de conexión Bluetooth del sistema

/// Estado global de la conexión Bluetooth del sistema
class BluetoothConnectionState {
  const BluetoothConnectionState({
    required this.isBluetoothEnabled,
    required this.isBluetoothAvailable,
    required this.isScanning,
    required this.hasPermissions,
    this.requiredPermissions = const [],
    this.errorMessage,
  });

  /// Crear estado inicial
  factory BluetoothConnectionState.initial() {
    return const BluetoothConnectionState(
      isBluetoothEnabled: false,
      isBluetoothAvailable: false,
      isScanning: false,
      hasPermissions: false,
      requiredPermissions: [
        'android.permission.BLUETOOTH',
        'android.permission.BLUETOOTH_ADMIN',
        'android.permission.ACCESS_FINE_LOCATION',
      ],
    );
  }

  final bool isBluetoothEnabled;
  final bool isBluetoothAvailable;
  final bool isScanning;
  final bool hasPermissions;
  final List<String> requiredPermissions;
  final String? errorMessage;

  /// Estado completamente funcional
  bool get isReady =>
      isBluetoothEnabled &&
      isBluetoothAvailable &&
      hasPermissions &&
      errorMessage == null;

  /// Estado con problemas que necesitan resolución
  bool get hasIssues => !isReady;

  BluetoothConnectionState copyWith({
    final bool? isBluetoothEnabled,
    final bool? isBluetoothAvailable,
    final bool? isScanning,
    final bool? hasPermissions,
    final List<String>? requiredPermissions,
    final String? errorMessage,
  }) {
    return BluetoothConnectionState(
      isBluetoothEnabled: isBluetoothEnabled ?? this.isBluetoothEnabled,
      isBluetoothAvailable: isBluetoothAvailable ?? this.isBluetoothAvailable,
      isScanning: isScanning ?? this.isScanning,
      hasPermissions: hasPermissions ?? this.hasPermissions,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() => 'BluetoothConnectionState('
      'enabled: $isBluetoothEnabled, '
      'available: $isBluetoothAvailable, '
      'scanning: $isScanning, '
      'permissions: $hasPermissions'
      ')';
}
