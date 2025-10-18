// 📦 Wearable Sensors Package - Internal Logger
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

import 'package:flutter/foundation.dart';

/// Internal logger for wearable_sensors package
///
/// Simple logging utility for debugging and development.
/// Production apps should configure [debugEnabled] = false.
class WearableLogger {
  /// Enable/disable debug logging
  static bool debugEnabled = kDebugMode;

  /// Log prefix for all messages
  static const String _prefix = '[WEARABLE_SENSORS]';

  /// Debug log (verbose)
  static void d(String message, [String? tag]) {
    if (debugEnabled) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 🔍 $message');
    }
  }

  /// Info log
  static void i(String message, [String? tag]) {
    if (debugEnabled) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr ℹ️ $message');
    }
  }

  /// Warning log
  static void w(String message, [String? tag]) {
    if (debugEnabled) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr ⚠️ $message');
    }
  }

  /// Error log
  static void e(
    String message, [
    Object? error,
    StackTrace? stack,
    String? tag,
  ]) {
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$_prefix$tagStr ❌ $message');
    if (error != null) debugPrint('Error: $error');
    if (stack != null && debugEnabled) debugPrint('Stack trace:\n$stack');
  }

  /// Success log
  static void s(String message, [String? tag]) {
    if (debugEnabled) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr ✅ $message');
    }
  }
}
