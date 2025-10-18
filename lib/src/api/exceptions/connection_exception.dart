import 'wearable_exception.dart';

/// Exception thrown when device connection operations fail.
///
/// This includes failures during device discovery, connection establishment,
/// disconnection, or when the connection is unexpectedly lost.
///
/// Example:
/// ```dart
/// try {
///   await WearableSensors.connect(deviceId);
/// } on ConnectionException catch (e) {
///   if (e.code == 'DEVICE_NOT_FOUND') {
///     print('Device is out of range or powered off');
///   } else if (e.code == 'CONNECTION_LOST') {
///     print('Connection interrupted, attempting reconnect...');
///   }
/// }
/// ```
class ConnectionException extends WearableException {
  /// The device ID involved in the connection failure, if available.
  final String? deviceId;

  /// The device name, if available (helpful for user messages).
  final String? deviceName;

  /// Whether this was a connection attempt (true) or disconnection (false).
  final bool isConnectionAttempt;

  /// Creates a new [ConnectionException].
  ///
  /// [message] should describe the connection failure clearly.
  /// [deviceId] identifies which device had connection issues.
  /// [deviceName] provides a user-friendly device identifier.
  /// [isConnectionAttempt] indicates if this was during connect (true) or disconnect (false).
  ///
  /// Common error codes:
  /// - `DEVICE_NOT_FOUND`: Device ID not in registry or out of range
  /// - `BLUETOOTH_DISABLED`: Bluetooth adapter is turned off
  /// - `CONNECTION_TIMEOUT`: Failed to establish connection in time
  /// - `CONNECTION_LOST`: Existing connection unexpectedly dropped
  /// - `ALREADY_CONNECTED`: Device is already connected
  /// - `NOT_CONNECTED`: Attempted operation requires active connection
  /// - `PAIRING_FAILED`: System-level Bluetooth pairing failed
  /// - `PERMISSION_DENIED`: Missing Bluetooth or location permissions
  /// - `UNSUPPORTED_DEVICE`: Device type not supported by package
  const ConnectionException(
    super.message, {
    super.code,
    super.cause,
    super.stackTrace,
    this.deviceId,
    this.deviceName,
    this.isConnectionAttempt = true,
  });

  /// Returns true if a specific device was involved in the failure.
  bool get hasDeviceId => deviceId != null;

  /// Returns true if a device name is available.
  bool get hasDeviceName => deviceName != null;

  /// Returns true if this was a disconnection failure.
  bool get isDisconnectionAttempt => !isConnectionAttempt;

  @override
  String toString() {
    final buffer = StringBuffer('ConnectionException: $message');
    if (code != null) {
      buffer.write(' (code: $code)');
    }
    if (deviceId != null) {
      buffer.write('\nDevice ID: $deviceId');
    }
    if (deviceName != null) {
      buffer.write('\nDevice Name: $deviceName');
    }
    buffer.write(
      '\nOperation: ${isConnectionAttempt ? 'Connection' : 'Disconnection'}',
    );
    if (cause != null) {
      buffer.write('\nCaused by: $cause');
    }
    return buffer.toString();
  }
}
