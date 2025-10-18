import 'wearable_exception.dart';

/// Exception thrown when device authentication fails.
///
/// This can occur during initial pairing, key exchange, or when
/// attempting to connect to a device that requires authentication
/// but valid credentials are not available.
///
/// Example:
/// ```dart
/// try {
///   await WearableSensors.connect(xiaomiDeviceId);
/// } on AuthenticationException catch (e) {
///   if (e.code == 'INVALID_KEY') {
///     print('Please re-pair the device');
///   }
/// }
/// ```
class AuthenticationException extends WearableException {
  /// The device ID that failed authentication, if available.
  final String? deviceId;

  /// The authentication method that was attempted.
  ///
  /// Examples: 'XIAOMI_HMAC', 'PIN_CODE', 'PASSKEY', 'BOND'
  final String? authMethod;

  /// Creates a new [AuthenticationException].
  ///
  /// [message] should describe the authentication failure clearly.
  /// [deviceId] identifies which device failed authentication.
  /// [authMethod] specifies what authentication approach was attempted.
  ///
  /// Common error codes:
  /// - `INVALID_KEY`: Authentication key is incorrect or corrupted
  /// - `KEY_NOT_FOUND`: No authentication key stored for this device
  /// - `AUTH_TIMEOUT`: Authentication handshake exceeded time limit
  /// - `AUTH_REJECTED`: Device rejected authentication attempt
  /// - `UNSUPPORTED_METHOD`: Device requires unsupported auth method
  const AuthenticationException(
    super.message, {
    super.code,
    super.cause,
    super.stackTrace,
    this.deviceId,
    this.authMethod,
  });

  /// Returns true if a specific device was involved in the failure.
  bool get hasDeviceId => deviceId != null;

  /// Returns true if the authentication method is known.
  bool get hasAuthMethod => authMethod != null;

  @override
  String toString() {
    final buffer = StringBuffer('AuthenticationException: $message');
    if (code != null) {
      buffer.write(' (code: $code)');
    }
    if (deviceId != null) {
      buffer.write('\nDevice: $deviceId');
    }
    if (authMethod != null) {
      buffer.write('\nMethod: $authMethod');
    }
    if (cause != null) {
      buffer.write('\nCaused by: $cause');
    }
    return buffer.toString();
  }
}
