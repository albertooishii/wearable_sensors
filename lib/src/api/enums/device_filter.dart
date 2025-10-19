// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Device filtering criteria for [WearableSensors.deviceStream]
///
/// Determines which devices are included in the stream:
/// - [bonded]: Only system-bonded devices (paired through OS settings)
/// - [nearby]: Only devices discovered during active BLE scan
/// - [saved]: Only devices saved in app storage (custom saved devices)
/// - [all]: All devices (bonded + nearby + saved)
enum DeviceFilter {
  /// System-bonded devices (iOS/Android Bluetooth settings)
  /// Usually paired before, will be auto-enriched on init
  bonded,

  /// Devices discovered during active BLE scan
  /// Populated while scan is running, cleared when scan stops
  nearby,

  /// Devices saved in app storage (custom selections)
  /// Persist across app restarts
  saved,

  /// All devices (bonded + nearby + saved combined)
  all,
}

extension DeviceFilterX on DeviceFilter {
  String get displayName {
    switch (this) {
      case DeviceFilter.bonded:
        return 'My Devices';
      case DeviceFilter.nearby:
        return 'Scanned Devices';
      case DeviceFilter.saved:
        return 'Saved Devices';
      case DeviceFilter.all:
        return 'All Devices';
    }
  }

  /// Check if a device should be included in this filter
  bool matches({
    required bool isPairedToSystem,
    required bool isSavedDevice,
    required bool isNearby,
  }) {
    switch (this) {
      case DeviceFilter.bonded:
        return isPairedToSystem;
      case DeviceFilter.nearby:
        return isNearby;
      case DeviceFilter.saved:
        return isSavedDevice;
      case DeviceFilter.all:
        return isPairedToSystem || isSavedDevice || isNearby;
    }
  }
}
