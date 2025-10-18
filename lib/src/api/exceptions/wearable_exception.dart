/// Base exception class for all wearable_sensors package errors.
///
/// All exceptions thrown by the public API inherit from this class,
/// allowing consumers to catch all package-specific errors with a single catch block.
///
/// Example:
/// ```dart
/// try {
///   await WearableSensors.connect(deviceId);
/// } on WearableException catch (e) {
///   print('Wearable error: ${e.message}');
/// }
/// ```
class WearableException implements Exception {
  /// Human-readable error message describing what went wrong.
  final String message;

  /// Optional error code for programmatic error handling.
  ///
  /// Common codes:
  /// - `BLUETOOTH_DISABLED`: Bluetooth is turned off
  /// - `PERMISSION_DENIED`: Required permissions not granted
  /// - `DEVICE_NOT_FOUND`: Device ID not found in registry
  /// - `TIMEOUT`: Operation exceeded time limit
  /// - `INVALID_STATE`: Operation not allowed in current state
  final String? code;

  /// Optional underlying error that caused this exception.
  final Object? cause;

  /// Optional stack trace from the underlying error.
  final StackTrace? stackTrace;

  /// Creates a new [WearableException].
  ///
  /// [message] is required and should describe the error clearly.
  /// [code] is optional and useful for programmatic error handling.
  /// [cause] and [stackTrace] preserve the original error context.
  const WearableException(
    this.message, {
    this.code,
    this.cause,
    this.stackTrace,
  });

  /// Returns true if this exception has an error code.
  bool get hasCode => code != null;

  /// Returns true if this exception has an underlying cause.
  bool get hasCause => cause != null;

  @override
  String toString() {
    final buffer = StringBuffer('WearableException: $message');
    if (code != null) {
      buffer.write(' (code: $code)');
    }
    if (cause != null) {
      buffer.write('\nCaused by: $cause');
    }
    return buffer.toString();
  }
}
