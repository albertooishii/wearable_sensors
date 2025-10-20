/// Enumeration of all supported device commands.
///
/// Each command represents a specific operation that can be sent to a wearable device,
/// such as configuration changes (clock sync, language), device actions (vibration),
/// or future capabilities (firmware updates, notification sending, etc.).
///
/// **Extend this enum as new commands are implemented:**
/// - Add the new command value to the enum
/// - Implement handling in [XiaomiCommandService] (or vendor-specific service)
/// - Add support in [WearableSensors.write()] if needed
///
/// **Example:**
/// ```dart
/// // Use with WearableSensors.write()
/// await WearableSensors.write(
///   deviceId,
///   DeviceCommandType.clock,
///   DateTime.now(),
///   metadata: {'timezone': 'Europe/Madrid'},
/// );
/// ```
enum DeviceCommandType {
  /// **Clock Synchronization**
  ///
  /// Syncs the device's time with the phone's current time.
  ///
  /// **Parameters:**
  /// - `value`: DateTime (current time)
  /// - `metadata['timezone']`: String (e.g., 'Europe/Madrid', 'America/New_York')
  /// - `metadata['is24Hour']`: bool (optional, true for 24-hour format)
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.write(
  ///   deviceId,
  ///   DeviceCommandType.clock,
  ///   DateTime.now(),
  ///   metadata: {'timezone': 'Europe/Madrid', 'is24Hour': true},
  /// );
  /// ```
  clock('clock'),

  /// **Device Language Configuration**
  ///
  /// Sets the device's language/locale for UI display.
  ///
  /// **Parameters:**
  /// - `value`: String (language code, e.g., 'en', 'es', 'fr')
  /// - `metadata['locale']`: String (optional, full locale e.g., 'en_US')
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.write(
  ///   deviceId,
  ///   DeviceCommandType.language,
  ///   'es',
  ///   metadata: {'locale': 'es_ES'},
  /// );
  /// ```
  language('language'),

  /// **Vibration Pattern Test**
  ///
  /// Sends a vibration pattern to the device for testing.
  ///
  /// **Parameters:**
  /// - `value`: `List<Map<String, int>>` (vibration pattern)
  ///   - Each map contains: `{'vibrate': 0|1, 'ms': duration}`
  ///   - `vibrate`: 0 = pause, 1 = vibrate
  ///   - `ms`: duration in milliseconds
  /// - `metadata['repeat']`: int (optional, number of repeats, default 1)
  ///
  /// **Example:**
  /// ```dart
  /// await WearableSensors.write(
  ///   deviceId,
  ///   DeviceCommandType.vibration,
  ///   [
  ///     {'vibrate': 0, 'ms': 100},
  ///     {'vibrate': 1, 'ms': 200},
  ///     {'vibrate': 0, 'ms': 100},
  ///     {'vibrate': 1, 'ms': 200},
  ///   ],
  /// );
  /// ```
  vibration('vibration'),

  // Future commands (placeholder for extensibility)
  // firmware_update('firmware_update'),
  // notification_send('notification_send'),
  // find_device('find_device'),
  // screenshot('screenshot'),
  // battery_status('battery_status'),
  ;

  /// The string representation of this command type.
  ///
  /// Used internally for serialization and routing to vendor-specific handlers.
  /// This value is passed to [XiaomiCommandService] and similar.
  final String value;

  const DeviceCommandType(this.value);

  /// Converts a string to the corresponding [DeviceCommandType].
  ///
  /// **Parameters:**
  /// - [value]: The string value to convert
  ///
  /// **Returns:** The matching [DeviceCommandType], or `null` if no match found.
  ///
  /// **Example:**
  /// ```dart
  /// final cmd = DeviceCommandType.fromString('clock');
  /// if (cmd != null) {
  ///   print('${cmd.value}');  // Prints: clock
  /// }
  /// ```
  static DeviceCommandType? fromString(String value) {
    try {
      return DeviceCommandType.values.firstWhere(
        (cmd) => cmd.value == value,
      );
    } catch (e) {
      return null;
    }
  }

  /// Checks if this command is supported by a device.
  ///
  /// Currently all devices support all commands, but this can be extended
  /// to check device capabilities if needed.
  ///
  /// **Parameters:**
  /// - [deviceTypeId]: Optional device type filter
  ///
  /// **Returns:** `true` if the device supports this command.
  bool isSupported({String? deviceTypeId}) {
    // All commands are currently supported universally
    // This can be extended to check specific device types
    return true;
  }

  /// Human-readable display name for this command.
  ///
  /// **Example:**
  /// ```dart
  /// print(DeviceCommandType.clock.displayName);  // Prints: "Clock Sync"
  /// ```
  String get displayName {
    return switch (this) {
      DeviceCommandType.clock => 'Clock Sync',
      DeviceCommandType.language => 'Language',
      DeviceCommandType.vibration => 'Vibration Test',
    };
  }

  /// Description of what this command does.
  String get description {
    return switch (this) {
      DeviceCommandType.clock => 'Synchronize device time with phone',
      DeviceCommandType.language => 'Configure device language/locale',
      DeviceCommandType.vibration => 'Send vibration pattern for testing',
    };
  }
}
