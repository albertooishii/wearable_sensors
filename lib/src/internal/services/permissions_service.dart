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

// Phase 6: Wearable Integration - Permission Service
import 'package:permission_handler/permission_handler.dart';
import 'package:wearable_sensors/src/internal/utils/logger.dart';

/// Service for managing app permissions with comprehensive Bluetooth and location support
class PermissionsService {
  static const String _logPrefix = '[DREAM INCUBATOR][PermissionsService]';

  /// List of all permissions required for full app functionality
  /// NOTE: Permission.bluetooth is deprecated in Android 12+
  /// We only use the new granular permissions (bluetoothScan, bluetoothConnect, bluetoothAdvertise)
  ///
  /// IMPORTANT: On Android 12+ (API 31+) with BLUETOOTH_SCAN using "neverForLocation" flag,
  /// location permissions are NOT required for BLE scanning. However, we keep them for
  /// potential future features that may need location.
  static const List<Permission> _requiredPermissions = [
    // Permission.bluetooth, // ❌ REMOVED - deprecated in Android 12+
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.nearbyWifiDevices,
    // Location permissions removed - not needed for BLE on Android 12+ with neverForLocation
  ];

  /// List of critical permissions needed for wearable functionality
  /// NOTE: Location is NOT included because BLUETOOTH_SCAN has neverForLocation flag
  static const List<Permission> _criticalPermissions = [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ];

  /// Check if all required permissions are granted
  static Future<bool> areAllPermissionsGranted() async {
    try {
      for (final permission in _criticalPermissions) {
        final status = await permission.status;
        if (!status.isGranted) {
          WearableLogger.d(
            '🔍 $_logPrefix ❌ Permission not granted: $permission',
          );
          return false;
        }
      }

      WearableLogger.d('ℹ️ $_logPrefix ✅ All critical permissions are granted');
      return true;
    } on Exception catch (e) {
      WearableLogger.d('❌ $_logPrefix Error checking permissions: $e');
      return false;
    }
  }

  /// Request all required permissions with user-friendly explanations
  static Future<bool> requestAllPermissions() async {
    try {
      WearableLogger.d('ℹ️ $_logPrefix 🔐 Requesting app permissions...');

      // Check current status
      final Map<Permission, PermissionStatus> statuses =
          await _requiredPermissions.request();

      bool allGranted = true;
      for (final entry in statuses.entries) {
        final permission = entry.key;
        final status = entry.value;

        if (status.isGranted) {
          WearableLogger.d('ℹ️ $_logPrefix ✅ $permission: Granted');
        } else if (status.isDenied) {
          WearableLogger.d('ℹ️ $_logPrefix ⚠️ $permission: Denied');
          if (_criticalPermissions.contains(permission)) {
            allGranted = false;
          }
        } else if (status.isPermanentlyDenied) {
          WearableLogger.d('ℹ️ $_logPrefix 🚫 $permission: Permanently denied');
          if (_criticalPermissions.contains(permission)) {
            allGranted = false;
          }
        }
      }

      if (!allGranted) {
        WearableLogger.d(
          '⚠️ $_logPrefix Some critical permissions were denied',
        );
        return false;
      }

      WearableLogger.d('ℹ️ $_logPrefix ✅ All permissions granted successfully');
      return true;
    } on Exception catch (e) {
      WearableLogger.d('❌ $_logPrefix Error requesting permissions: $e');
      return false;
    }
  }

  /// Request specific Bluetooth permissions for wearable connectivity
  /// NOTE: Android 12+ uses granular permissions (scan/connect/advertise)
  /// Android 11 and below used Permission.bluetooth (deprecated)
  static Future<bool> requestBluetoothPermissions() async {
    try {
      WearableLogger.d('ℹ️ $_logPrefix 📱 Requesting Bluetooth permissions...');

      // Only use new granular permissions (Android 12+)
      final bluetoothPermissions = [
        // Permission.bluetooth, // ❌ REMOVED - deprecated in Android 12+
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ];

      final Map<Permission, PermissionStatus> statuses =
          await bluetoothPermissions.request();

      bool allGranted = true;
      for (final entry in statuses.entries) {
        if (!entry.value.isGranted) {
          WearableLogger.d('ℹ️ $_logPrefix ❌ ${entry.key}: ${entry.value}');
          allGranted = false;
        } else {
          WearableLogger.d('ℹ️ $_logPrefix ✅ ${entry.key}: Granted');
        }
      }

      return allGranted;
    } on Exception catch (e) {
      WearableLogger.d(
        '❌ $_logPrefix Error requesting Bluetooth permissions: $e',
      );
      return false;
    }
  }

  /// Open app settings if permissions are permanently denied
  static Future<void> openSettings() async {
    try {
      WearableLogger.d(
        'ℹ️ $_logPrefix 🔧 Opening app settings for manual permission grant...',
      );
      await openAppSettings();
    } on Exception catch (e) {
      WearableLogger.d('❌ $_logPrefix Error opening app settings: $e');
    }
  }

  /// Get detailed permission status for debugging
  static Future<Map<String, String>> getPermissionStatusDetails() async {
    final Map<String, String> details = {};

    try {
      for (final permission in _requiredPermissions) {
        final status = await permission.status;
        details[permission.toString()] = status.toString();
      }
    } on Exception catch (e) {
      WearableLogger.d('❌ $_logPrefix Error getting permission details: $e');
    }

    return details;
  }

  /// Initialize permissions when app starts
  static Future<bool> initializePermissions() async {
    try {
      WearableLogger.d('ℹ️ $_logPrefix 🚀 Initializing app permissions...');

      // First check if we already have permissions
      if (await areAllPermissionsGranted()) {
        WearableLogger.d('ℹ️ $_logPrefix ✅ All permissions already granted');
        return true;
      }

      // Request permissions
      final granted = await requestAllPermissions();

      if (!granted) {
        WearableLogger.d(
          '⚠️ $_logPrefix Some permissions were denied. Wearable features may be limited.',
        );
        // Print detailed status for debugging
        final details = await getPermissionStatusDetails();
        for (final entry in details.entries) {
          WearableLogger.d('🔍 $_logPrefix ${entry.key}: ${entry.value}');
        }
      }

      return granted;
    } on Exception catch (e) {
      WearableLogger.d('❌ $_logPrefix Error initializing permissions: $e');
      return false;
    }
  }
}
