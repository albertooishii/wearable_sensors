import '../../api/enums/connection_state.dart';

/// Adapter that converts between internal connection states and public ConnectionState.
///
/// Handles mapping of vendor-specific connection status to the unified
/// [ConnectionState] enum exposed by the public API.
class ConnectionAdapter {
  ConnectionAdapter._(); // Prevent instantiation

  /// Converts internal connection state to public [ConnectionState].
  ///
  /// Handles various internal state representations:
  /// - Enum values (BluetoothConnectionState)
  /// - String values ('connected', 'disconnected', etc.)
  /// - Integer codes (0=disconnected, 1=connecting, etc.)
  ///
  /// Parameters:
  /// - [internalState]: Internal state representation (dynamic type)
  ///
  /// Returns: Public API [ConnectionState] enum
  static ConnectionState toPublicState(dynamic internalState) {
    // Handle null or invalid states
    if (internalState == null) {
      return ConnectionState.disconnected;
    }

    // Convert to lowercase string for comparison
    final stateString = internalState.toString().split('.').last.toLowerCase();

    switch (stateString) {
      case 'disconnected':
      case '0':
        return ConnectionState.disconnected;

      case 'connecting':
      case '1':
        return ConnectionState.connecting;

      case 'authenticating':
      case '2':
        return ConnectionState.authenticating;

      case 'connected':
      case '3':
        return ConnectionState.connected;

      case 'streaming':
      case '4':
        return ConnectionState.streaming;

      case 'error':
      case 'failed':
      case '-1':
        return ConnectionState.error;

      default:
        // Unknown states default to disconnected
        return ConnectionState.disconnected;
    }
  }

  /// Converts public [ConnectionState] to internal state identifier.
  ///
  /// Used when setting connection state in internal services.
  ///
  /// Parameters:
  /// - [publicState]: Public API connection state
  ///
  /// Returns: Internal state string
  static String toInternalState(ConnectionState publicState) {
    switch (publicState) {
      case ConnectionState.disconnected:
        return 'disconnected';
      case ConnectionState.connecting:
        return 'connecting';
      case ConnectionState.authenticating:
        return 'authenticating';
      case ConnectionState.connected:
        return 'connected';
      case ConnectionState.streaming:
        return 'streaming';
      case ConnectionState.error:
        return 'error';
    }
  }

  /// Checks if a state indicates the device is actively connected.
  ///
  /// Connected, authenticating, and streaming all count as "connected"
  /// for practical purposes (device is reachable and usable).
  ///
  /// Parameters:
  /// - [state]: Connection state to check
  ///
  /// Returns: True if device is in a connected state
  static bool isConnectedState(ConnectionState state) {
    return state == ConnectionState.connected ||
        state == ConnectionState.streaming ||
        state == ConnectionState.authenticating;
  }

  /// Checks if a state indicates an error or failure.
  ///
  /// Parameters:
  /// - [state]: Connection state to check
  ///
  /// Returns: True if state represents an error
  static bool isErrorState(ConnectionState state) {
    return state == ConnectionState.error;
  }

  /// Checks if a state indicates a transition is in progress.
  ///
  /// Connecting and authenticating are both transitional states
  /// where the connection is being established.
  ///
  /// Parameters:
  /// - [state]: Connection state to check
  ///
  /// Returns: True if state is transitional
  static bool isTransitionalState(ConnectionState state) {
    return state == ConnectionState.connecting ||
        state == ConnectionState.authenticating;
  }
}
