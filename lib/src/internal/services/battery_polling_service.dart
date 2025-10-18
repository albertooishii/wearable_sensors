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

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/utils/logger.dart';

/// Battery polling service inspired by Gadgetbridge's periodic polling pattern.
///
/// Instead of waiting for a single battery request with a fixed timeout,
/// this service periodically polls the device battery in the background.
/// This is more reliable and matches Gadgetbridge's proven approach.
///
/// Key differences from naive timeout approach:
/// - Periodic polling every N minutes (default 5 min)
/// - Initial delay before first poll to allow device initialization
/// - Graceful handling of poll failures (just wait for next poll)
/// - UI shows "last known" battery instead of "Unknown" on timeout
/// - Continues polling even if one poll fails
class BatteryPollingService extends ChangeNotifier {
  factory BatteryPollingService({
    required final Future<int?> Function() pollFunction,
  }) {
    _instance ??= BatteryPollingService._internal(pollFunction);
    return _instance!;
  }

  /// Constructor
  /// [pollFunction] - async function that returns battery level 0-100 or throws on error
  BatteryPollingService._internal(this.pollFunction);
  // ✅ SINGLETON PATTERN
  static BatteryPollingService? _instance;

  /// Default polling interval (matches Gadgetbridge range)
  static const Duration defaultPollingInterval = Duration(minutes: 5);

  /// Initial delay after authentication to allow device to settle
  /// before first battery poll (device busy with initialization)
  static const Duration initialDelayAfterInit = Duration(seconds: 2);

  /// Function to call for actual battery data retrieval
  /// Returns battery level (0-100) or throws on error
  final Future<int?> Function() pollFunction;

  /// Periodic timer for polling
  Timer? _pollingTimer;

  /// Timestamp of last successful poll
  DateTime? _lastPollTime;

  /// Last successfully retrieved battery level (0-100)
  int? _lastBatteryLevel;

  /// Count of successful polls
  int _successCount = 0;

  /// Count of failed polls
  int _failureCount = 0;

  /// Whether polling is currently active
  bool get isPollingActive => _pollingTimer != null;

  /// Number of successful polls
  int get successCount => _successCount;

  /// Number of failed polls
  int get failureCount => _failureCount;

  /// Timestamp of last poll attempt
  DateTime? get lastPollTime => _lastPollTime;

  /// Last battery level retrieved (may be stale), 0-100
  int? get lastBatteryLevel => _lastBatteryLevel;

  /// Start periodic battery polling with optional initial delay.
  ///
  /// This mimics Gadgetbridge's pattern:
  /// 1. Wait for [initialDelay] to let device settle after init
  /// 2. Execute first poll
  /// 3. Schedule subsequent polls every [interval]
  /// 4. On each poll success, reschedule the next poll
  /// 5. On poll failure, still reschedule (graceful degradation)
  ///
  /// Usage:
  /// ```dart
  /// batteryPolling.startPeriodicPolling(
  ///   interval: Duration(minutes: 5),
  ///   initialDelay: Duration(seconds: 2),
  /// );
  /// ```
  void startPeriodicPolling({
    final Duration interval = defaultPollingInterval,
    final Duration? initialDelay,
  }) {
    // Cancel any existing timer
    _stopPolling();

    final delay = initialDelay ?? initialDelayAfterInit;

    WearableLogger.d(
      'Starting periodic battery polling '
      'interval=${interval.inSeconds}s, '
      'initialDelay=${delay.inSeconds}s',
    );

    // Schedule first poll with initial delay
    Future.delayed(delay, () {
      // Only proceed if polling wasn't stopped in the meantime
      if (_pollingTimer == null && !_disposed) {
        _executePoll();
        _scheduleNextPoll(interval);
      }
    });
  }

  /// Schedule the next poll after [interval]
  void _scheduleNextPoll(final Duration interval) {
    _pollingTimer = Timer.periodic(interval, (_) {
      _executePoll();
    });
  }

  /// Execute a single battery poll
  ///
  /// This method:
  /// 1. Calls the poll function
  /// 2. Updates _lastBatteryLevel on success
  /// 3. Tracks success/failure counts
  /// 4. Notifies listeners on completion
  /// 5. Does NOT throw exceptions (graceful degradation)
  Future<void> _executePoll() async {
    if (_disposed) return;

    try {
      _lastPollTime = DateTime.now();

      final batteryLevel = await pollFunction();

      if (batteryLevel != null) {
        _lastBatteryLevel = batteryLevel;
        _successCount++;

        WearableLogger.d(
          'Battery poll #$_successCount success: $batteryLevel%',
        );
      } else {
        _failureCount++;
        WearableLogger.w(
          'Battery poll returned null (attempt #$_failureCount)',
        );
      }

      notifyListeners();
    } on Exception catch (e) {
      _failureCount++;

      WearableLogger.w(
        'Battery poll failed (attempt #$_failureCount): $e',
      );

      notifyListeners();
      // Note: We do NOT rethrow. Graceful degradation means
      // we just wait for the next scheduled poll.
    }
  }

  /// Stop periodic polling
  ///
  /// Cancels the timer and does NOT reset statistics or last data.
  /// Call [reset()] if you want to clear state.
  void stopPolling() {
    _stopPolling();

    WearableLogger.d(
      'Battery polling stopped. '
      'Stats: success=$_successCount, failed=$_failureCount',
    );

    notifyListeners();
  }

  /// Stop polling and reset all state
  void reset() {
    _stopPolling();
    _successCount = 0;
    _failureCount = 0;
    _lastPollTime = null;
    _lastBatteryLevel = null;

    WearableLogger.d('Battery polling service reset');

    notifyListeners();
  }

  /// Internal helper to stop the timer
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Get poll statistics as a string (for debugging/logging)
  String getStatistics() {
    final totalPolls = _successCount + _failureCount;
    final successRate =
        totalPolls > 0 ? (_successCount * 100) ~/ totalPolls : 0;
    return 'Polls: total=$totalPolls, success=$_successCount, '
        'failed=$_failureCount, successRate=$successRate%, '
        'lastPoll=$_lastPollTime';
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _stopPolling();
    super.dispose();
  }
}
