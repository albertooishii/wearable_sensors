// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 🔌 Xiaomi Connection Orchestrator - Dream Incubator
//
// ========================================================
// CRITICAL ARCHITECTURE: BLE vs BT_CLASSIC Paths
// ========================================================
//
// **Xiaomi Protocol (Xiaomi Smart Band 10, etc.):**
//
// AUTHENTICATION PHASE (First time only):
//  1. BLE connect + 3-step handshake → Encryption keys obtained
//  2. Keys saved to persistent storage
//  3. Device paired at system level
//
// DATA STREAMING PHASE (All subsequent connections):
//  1. Skip BLE entirely
//  2. Connect directly via BT_CLASSIC (no BLE)
//  3. Use saved encryption keys for NONCE handshake
//  4. Stream biometric data
//
// KEY INSIGHT:
// - BLE auth generates encryption keys (happens ONCE)
// - Once keys exist: NEVER use BLE again
// - ALWAYS use BT_CLASSIC for reconnections (faster, simpler)
// - NO fallback BLE if BT_CLASSIC fails (circuit breaker pattern)
//
// Workflow:
// 1. Check if encryption keys exist + device bonded
//    → YES: Direct BT_CLASSIC (with retry logic, NO BLE)
//    → NO:  BLE authentication → save keys → transition BT_CLASSIC
// 2. Disconnect BLE (if used)
// 3. Start BT_CLASSIC streaming
// 4. Initialize XiaomiSppService with BtClassicSppTransport
// 5. Start biometric data streaming

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/internal/bluetooth/biometric_data_reader.dart';
import 'package:wearable_sensors/src/internal/services/battery_polling_service.dart';
import 'package:wearable_sensors/wearable_sensors.dart';

import 'package:wearable_sensors/src/internal/bluetooth/vendor_orchestrator.dart';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:wearable_sensors/src/internal/bluetooth/bluetooth_classic_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_auth_service.dart';
import 'xiaomi_spp_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/btclassic_spp_transport.dart';
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';

/// Xiaomi-specific connection orchestrator
///
/// **Implements:** VendorOrchestrator
///
/// **Workflow:**
/// 1. **BLE Authentication Phase:**
///    - Connect via BLE
///    - Authenticate using XiaomiAuthService (3-step handshake)
///    - Obtain encryption keys
///
/// 2. **Transition Phase:**
///    - Disconnect BLE cleanly
///    - Wait for device to be ready for BT_CLASSIC
///
/// 3. **BT_CLASSIC Streaming Phase:**
///    - Connect via Bluetooth Classic (SPP/RFCOMM)
///    - Initialize XiaomiSppService with BtClassicSppTransport
///    - Start biometric data streaming (HR, accelerometer, etc.)
///
/// **Based on:** Gadgetbridge XiaomiSupport.java architecture
class XiaomiConnectionOrchestrator extends VendorOrchestrator {
  XiaomiConnectionOrchestrator({
    required final BleService bleService,
    required final BluetoothClassicService btClassicService,
  })  : _bleService = bleService,
        _btClassicService = btClassicService;

  final BleService _bleService;
  final BluetoothClassicService _btClassicService;

  // State
  String? _deviceId;
  ConnectionState _currentState = ConnectionState.disconnected;
  DeviceImplementation? _deviceImplementation;

  // Services
  XiaomiAuthService? _authService;
  XiaomiSppService? _sppService;
  BtClassicSppTransport? _btClassicTransport;

  // Encryption keys from BLE authentication (needed for BT_CLASSIC)
  EncryptionKeys? _encryptionKeys;

  // Stream controllers
  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();
  final StreamController<BiometricData> _biometricDataController =
      StreamController<BiometricData>.broadcast();
  final StreamController<int?> _batteryController =
      StreamController<int?>.broadcast();
  final StreamController<ConnectionError> _errorController =
      StreamController<ConnectionError>.broadcast();

  // Subscriptions
  StreamSubscription<Uint8List>? _sppDataSubscription;

  // ✅ Battery polling service
  BatteryPollingService? _batteryPollingService;

  @override
  String get deviceId => _deviceId ?? '';

  @override
  Stream<ConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  @override
  Stream<BiometricData> get biometricDataStream =>
      _biometricDataController.stream;

  @override
  Stream<int?> get batteryStream => _batteryController.stream;

  @override
  Stream<ConnectionError> get errorStream => _errorController.stream;

  @override
  ConnectionState get currentState => _currentState;

  /// ✅ Public getter for SPP service (for BiometricDataReader)
  ///
  /// Returns `null` if not connected via BT_CLASSIC yet.
  XiaomiSppService? get sppService => _sppService;

  /// ✅ Getter for discovered device type ID
  ///
  /// Returns device type (e.g., 'xiaomi_smart_band_10') after loading implementation.
  /// Used by DeviceConnectionManager to populate WearableDevice.deviceTypeId
  @override
  String? get discoveredDeviceTypeId {
    final value = _deviceImplementation?.deviceType;
    debugPrint(
      '🔍 [XiaomiOrchestrator.discoveredDeviceTypeId getter] returning: $value',
    );
    return value;
  }

  @override
  Future<void> connectAndAuthenticate(final String deviceId) async {
    _deviceId = deviceId;
    _updateState(ConnectionState.connecting);

    try {
      debugPrint('🔌 Xiaomi Orchestrator: Starting connection for $deviceId');

      // 1. Load device implementation
      // TODO: Detect device type from deviceId or saved metadata
      // For now, hardcode to xiaomi_smart_band_10 (Band 10 with FE95 protocol V2)
      final deviceType = 'xiaomi_smart_band_10';
      _deviceImplementation = await DeviceImplementationLoader.load(deviceType);
      debugPrint(
        '   ✅ Loaded implementation: ${_deviceImplementation!.deviceType}',
      );
      debugPrint(
        '   ✅ _deviceImplementation now set, discoveredDeviceTypeId getter will return: $discoveredDeviceTypeId',
      );

      // ✅ Device type will be available via WearableDevice (set by DeviceConnectionManager)
      // When BiometricDataReader queries the device state, it will get the correct type
      // even in SPP mode (without BLE services)

      // 1.5. Create AuthService (needed for both bonded and non-bonded paths)
      _authService = XiaomiAuthService(
        deviceId: deviceId,
        bleService: _bleService,
        deviceImplementation: _deviceImplementation!,
        btClassicService: _btClassicService, // ← For BT_CLASSIC transition
      );
      debugPrint('   ✅ Auth service created');

      // 1.6. Check if device has saved encryption keys (authenticated before)
      // ✅ SIMPLE & RELIABLE: Check if keys exist, not external "known devices" list
      _encryptionKeys = await EncryptionKeys.load(deviceId);
      final isBonded = await _bleService.isDeviceBonded(deviceId);

      if (_encryptionKeys != null && isBonded) {
        // ✅ PATH 1: KNOWN DEVICE (Authenticated before)
        // - Encryption keys exist (from previous auth)
        // - Device bonded at system level
        // - Decision: Skip BLE ENTIRELY, connect directly via BT_CLASSIC
        // - Retry logic: Only BT_CLASSIC retries, NO fallback to BLE
        //
        // Why? BLE auth is expensive and unnecessary. Keys are already saved.
        // For every reconnection, use BT_CLASSIC directly.
        debugPrint(
          '✅ [PATH 1: KNOWN DEVICE] Encryption keys exist (authenticated previously)',
        );
        debugPrint('   ✅ Encryption keys loaded from storage');
        debugPrint('   🚫 SKIPPING BLE auth entirely');
        debugPrint(
          '   → Connecting directly via BT_CLASSIC (fast path, no BLE overhead)',
        );

        // ✅ CRITICAL: Load credentials IMMEDIATELY for NONCE handshake
        // Must happen BEFORE creating SPP service (which triggers SESSION_CONFIG)
        debugPrint('   🔑 Loading credentials into authService...');
        await _authService!.loadSavedCredentials();
        debugPrint('   ✅ Credentials loaded, authKey ready for handshake');

        // 3. Direct BT_CLASSIC connection (no BLE transition needed)
        //    → Never connected via BLE, so skip disconnect/wait
        //    → Connect directly with retry logic (only BT_CLASSIC, no BLE fallback)
        await _connectBtClassicDirect(deviceId);
      } else {
        // ✅ PATH 2: NEW DEVICE (First time authentication required)
        // - No encryption keys found
        // - Decision: Perform full BLE authentication to obtain keys
        // - Then: Transition to BT_CLASSIC for data streaming
        // - Future: All reconnections will use PATH 1 (BT_CLASSIC direct)
        if (isBonded) {
          debugPrint(
            '✅ [PATH 2: REAUTH] Device bonded at system level but no keys found',
          );
          debugPrint(
              '   → Situation: Keys were deleted, need to re-authenticate');
        } else {
          debugPrint(
              '✅ [PATH 2: FIRST_TIME] Device not bonded - first connection');
        }

        // 2. BLE Authentication Phase (required for first-time devices)
        // This establishes trust with the device and generates encryption keys
        debugPrint('🔐 Starting BLE authentication (one-time only)');
        await _authenticateViaBle(deviceId);

        // 3. Transition to BT_CLASSIC Phase (after successful BLE auth)
        // From now on, all reconnections will use PATH 1 (BT_CLASSIC direct)
        debugPrint('🔄 Transitioning from BLE to BT_CLASSIC for streaming');
        await _transitionToBtClassic(deviceId);
      }

      // 4. Start Biometric Streaming Phase (works for both paths)
      await _startBiometricStreaming(deviceId);

      // 5. ✅ Post-Auth Initialization (Gadgetbridge pattern)
      //    Configure device after successful BT_CLASSIC connection
      //    This runs ONCE after authentication, not on every START HR
      await _performPostAuthInitialization(deviceId);

      // 6. Start periodic battery polling (every 10 minutes)
      _startBatteryPolling(deviceId);

      _updateState(ConnectionState.streaming);
      debugPrint(
        '✅ Xiaomi Orchestrator: Connection complete, streaming active',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Xiaomi Orchestrator: Connection failed: $e');
      _updateState(ConnectionState.error);
      _errorController.add(
        ConnectionError(
          deviceId: deviceId,
          message: 'Connection failed: $e',
          stackTrace: stackTrace,
        ),
      );
      rethrow;
    }
  }

  /// Phase 1: BLE Authentication
  Future<void> _authenticateViaBle(final String deviceId) async {
    debugPrint('🔐 Phase 1: BLE Authentication');
    _updateState(ConnectionState.authenticating);

    try {
      // Auth service already created in connect() - just authenticate
      if (_authService == null) {
        throw Exception('Auth service not initialized');
      }

      debugPrint('🚀 Calling _authService.authenticate()...');

      // Authenticate (BLE connection + 3-step handshake)
      final authResult = await _authService!.authenticate();

      debugPrint(
        '📥 authenticate() returned: success=${authResult.success}, error=${authResult.errorMessage}',
      );

      if (!authResult.success) {
        debugPrint(
          '❌ Auth failed - throwing exception to stop connection flow',
        );
        throw Exception('Authentication failed: ${authResult.errorMessage}');
      }

      // ✅ CRITICAL: Save encryption keys for BT_CLASSIC phase
      _encryptionKeys = authResult.encryptionKeys;

      // ✅ CRITICAL: Reuse SPP service from auth to prevent nonce reuse
      if (authResult.sppService != null) {
        _sppService = authResult.sppService;
        debugPrint('   ✅ Reusing SPP service from auth (prevents nonce reuse)');
      }

      debugPrint('   ✅ BLE authentication successful');
      debugPrint('   🔑 Encryption keys obtained and saved');

      // ✅ CRITICAL FIX: Emit "connected" state IMMEDIATELY after auth success
      // This provides immediate UI feedback even if post-auth commands fail
      // Device transitions: authenticating → connected (for UI)
      _updateState(ConnectionState.connected);
      debugPrint(
        '   ✅ Emitted ConnectionState.connected (auth success confirmed)',
      );
    } catch (e) {
      debugPrint('   ❌ BLE authentication failed: $e');
      rethrow;
    }
  }

  /// Direct BT_CLASSIC connection (NO BLE transition, NO BLE fallback)
  ///
  /// Used when device is known and we skip BLE authentication.
  /// This path is taken when encryption keys already exist.
  ///
  /// **CRITICAL:** Only attempts BT_CLASSIC, NEVER falls back to BLE.
  /// Reason: BLE auth is expensive and already completed before (keys are saved).
  /// If BT_CLASSIC fails, it indicates a real connectivity issue that should
  /// be surfaced to user, not hidden by retrying with different protocols.
  ///
  /// Includes automatic retry logic for timing/transient issues (BT_CLASSIC only).
  Future<void> _connectBtClassicDirect(final String deviceId) async {
    debugPrint(
      '═══════════════════════════════════════════════════',
    );
    debugPrint(
      '🔄 Phase 2: Direct BT_CLASSIC Connection (Known Device Path)',
    );
    debugPrint(
      '   CRITICAL: BLE skipped (keys exist). BT_CLASSIC only, no fallback.',
    );
    debugPrint(
      '═══════════════════════════════════════════════════',
    );

    const maxRetries = 3;
    const retryDelayMs = 500; // 500ms between retries
    var attempt = 1;

    while (attempt <= maxRetries) {
      try {
        debugPrint(
          '   📡 Attempt $attempt/$maxRetries: Connecting via BT_CLASSIC...',
        );
        await _btClassicService.connect(deviceId);
        debugPrint('   ✅ SUCCESS: BT_CLASSIC connected on attempt $attempt');
        _updateState(ConnectionState.connected);
        debugPrint(
          '═══════════════════════════════════════════════════',
        );
        return;
      } on Exception catch (e) {
        debugPrint('   ⚠️ Attempt $attempt failed: $e');

        if (attempt < maxRetries) {
          debugPrint('   ⏳ Retrying BT_CLASSIC in ${retryDelayMs}ms...');
          debugPrint(
            '   (Skipping BLE fallback - keys exist, BLE not needed)',
          );
          await Future.delayed(const Duration(milliseconds: retryDelayMs));
          attempt++;
        } else {
          debugPrint(
            '═══════════════════════════════════════════════════',
          );
          debugPrint(
            '❌ FAILURE: BT_CLASSIC connection failed (no BLE fallback)',
          );
          debugPrint('   All $maxRetries attempts exhausted');
          debugPrint(
            '   Last error: $e',
          );
          debugPrint(
            '   NOTE: BLE fallback disabled for known devices.',
          );
          debugPrint(
            '   If this persists, consider: 1) Reboot device, 2) Re-pair (clear keys)',
          );
          debugPrint(
            '═══════════════════════════════════════════════════',
          );
          rethrow;
        }
      }
    }
  }

  /// Phase 2: Transition from BLE to BT_CLASSIC
  Future<void> _transitionToBtClassic(final String deviceId) async {
    debugPrint('🔄 Phase 2: BLE→BT_CLASSIC Transition');

    // Check if auth service already did the transition
    if (_sppService != null) {
      debugPrint('   ✅ BT_CLASSIC already connected by auth service');
      debugPrint('   ⏭️  Skipping redundant transition');
      _updateState(ConnectionState.connected);
      return;
    }

    try {
      // Only disconnect BLE if we came from BLE auth path
      // If using saved keys, we never connected BLE so nothing to disconnect
      try {
        debugPrint('   📴 Checking if BLE needs disconnection...');
        await _bleService.disconnectDevice(deviceId);
        debugPrint('   ✅ BLE disconnected');

        // Wait for device to be ready for BT_CLASSIC after BLE disconnect
        // Gadgetbridge experience: ~1-2 seconds needed
        debugPrint('   ⏳ Waiting for device to prepare BT_CLASSIC (2s)...');
        await Future.delayed(const Duration(seconds: 2));
      } on Exception catch (_) {
        // Device wasn't connected via BLE (using saved keys path)
        debugPrint('   ⏭️  No BLE connection to disconnect (using saved keys)');
        debugPrint('   → Connecting directly via BT_CLASSIC (no wait needed)');
      }

      // Connect via Bluetooth Classic (SPP/RFCOMM) with retry logic
      const maxRetries = 3;
      const retryDelayMs = 300;
      var attempt = 1;

      while (attempt <= maxRetries) {
        try {
          debugPrint('═══════════════════════════════════════════════════');
          debugPrint(
            '   📡 BT_CLASSIC connect attempt $attempt/$maxRetries...',
          );
          await _btClassicService.connect(deviceId);
          debugPrint('✅ SUCCESS: BT_CLASSIC connection established!');
          debugPrint('═══════════════════════════════════════════════════');
          _updateState(ConnectionState.connected);
          return;
        } on Exception catch (e) {
          debugPrint('   ⚠️ Attempt $attempt failed: $e');

          if (attempt < maxRetries) {
            debugPrint('   ⏳ Retrying in ${retryDelayMs}ms...');
            await Future.delayed(const Duration(milliseconds: retryDelayMs));
            attempt++;
          } else {
            debugPrint('═══════════════════════════════════════════════════');
            debugPrint('❌ FAILURE: BLE→BT_CLASSIC transition failed');
            debugPrint('   All $maxRetries attempts exhausted');
            debugPrint('   Error: $e');
            debugPrint('═══════════════════════════════════════════════════');
            rethrow;
          }
        }
      }
    } catch (e) {
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('❌ FAILURE: BLE→BT_CLASSIC transition failed');
      debugPrint('   Error: $e');
      debugPrint('═══════════════════════════════════════════════════');
      rethrow;
    }
  }

  /// Phase 3: Start Biometric Data Streaming
  Future<void> _startBiometricStreaming(final String deviceId) async {
    debugPrint('📊 Phase 3: Start Biometric Streaming');

    try {
      // Check if SPP service already exists (from auth transition)
      if (_sppService != null) {
        debugPrint('   ✅ SPP service already initialized by auth');
        debugPrint('   🔄 Auth service updated with SPP service reference');

        // Update auth service with the SPP service for bonded device path
        if (_authService != null) {
          _authService = XiaomiAuthService(
            deviceId: deviceId,
            bleService: _bleService,
            deviceImplementation: _deviceImplementation!,
            btClassicService: _btClassicService,
            sppService: _sppService,
          );
        }
        return; // Skip SPP service creation
      }

      // 1. Create BT_CLASSIC SPP transport
      _btClassicTransport = BtClassicSppTransport(
        deviceAddress: deviceId,
        btClassicService: _btClassicService,
      );

      debugPrint('   🔌 Initializing BT_CLASSIC transport...');
      await _btClassicTransport!.initialize();
      debugPrint('   ✅ BT_CLASSIC transport ready');

      // 2. Create XiaomiSppService with BT_CLASSIC transport
      // ✅ Pass encryption keys from BLE authentication phase
      _sppService = XiaomiSppService(
        transport: _btClassicTransport!,
        deviceType: _deviceImplementation!.deviceType,
        deviceId: deviceId,
        encryptionKeys: _encryptionKeys, // Keys from Phase 1 auth
        authService: _authService, // ← For calling startEncryptedHandshake()
      );

      debugPrint('   🔧 Initializing SPP service...');
      if (_encryptionKeys != null) {
        debugPrint('   🔑 Encryption keys passed to SPP service');
      } else {
        debugPrint('   ⚠️ No encryption keys available (bonded device path)');
      }
      await _sppService!.connect();
      debugPrint('   ✅ SPP service connected');

      // 🔧 Configure SESSION_CONFIG callback BEFORE updating authService
      // 🎯 CRITICAL FIX (Gadgetbridge Pattern): ALWAYS do NONCE handshake on new SPP V2 session
      // Even for known devices, session keys from previous connection are STALE
      // Every new SPP V2 session requires fresh NONCE exchange for security + protocol correctness
      _sppService!.onSessionConfigReceived = () async {
        debugPrint('');
        debugPrint('🔐 ════════════════════════════════════════════════');
        debugPrint('🔐 SESSION_CONFIG callback triggered');
        debugPrint('🔐 ════════════════════════════════════════════════');
        debugPrint('');

        if (_authService != null) {
          // ✅ GADGETBRIDGE PATTERN: ALWAYS handshake on new SPP V2 session
          debugPrint('🔐 SPP V2 session started - initiating NONCE handshake');
          debugPrint(
            '   (Fresh keys needed for this session, even if bonded device)',
          );
          try {
            await _authService!.startEncryptedHandshake();
          } on Exception catch (e) {
            debugPrint('❌ NONCE handshake failed: $e');
            debugPrint(
              '   → This will cause battery read timeout (device can\'t decrypt)',
            );
          }
        } else {
          debugPrint('⚠️ No authService available for NONCE handshake');
          debugPrint('   → Commands will fail (can\'t encrypt)');
        }
      };

      // 🔧 Update AuthService with SppService reference (for bonded device init)
      if (_authService != null && _encryptionKeys != null) {
        // Recreate authService with sppService reference for bonded path
        _authService = XiaomiAuthService(
          deviceId: deviceId,
          bleService: _bleService,
          deviceImplementation: _deviceImplementation!,
          btClassicService: _btClassicService, // ← For BT_CLASSIC transition
          sppService: _sppService, // ← NOW available
        );
        debugPrint('   🔄 Auth service updated with SPP service reference');

        // ✅ CRITICAL: Reload credentials after recreating authService
        // The new authService instance needs credentials for NONCE handshake
        debugPrint(
          '   🔑 Reloading credentials into new authService instance...',
        );
        await _authService!.loadSavedCredentials();
        debugPrint('   ✅ Credentials reloaded, ready for encrypted handshake');
      }

      // 🧪 DISABLED: Battery command now sent AFTER encrypted handshake
      // Gadgetbridge pattern: SESSION_CONFIG → NONCE handshake → Commands
      // The encrypted handshake is triggered automatically in xiaomi_spp_service.dart
      // when SESSION_CONFIG response is received.
      //
      // ✅ CRITICAL: Send post-auth initialization commands (System + Health services)
      // This initializes the device's health service so it can respond to realtime stats
      if (_encryptionKeys != null && _authService != null) {
        // ✅ NOTE: Post-auth initialization is now handled inside xiaomi_auth_service.dart
        // after NONCE handshake completes (see line 1068 in xiaomi_auth_service.dart)
        // This avoids duplicate command execution
        debugPrint(
          '✅ Post-auth initialization already triggered in auth service',
        );
      }

      debugPrint('✅ BT_CLASSIC connection ready');

      // 3. Subscribe to SPP data stream
      _sppDataSubscription = _btClassicTransport!.dataStream.listen(
        (final data) => _handleBiometricData(data),
        onError: (final error) {
          debugPrint('❌ SPP data stream error: $error');
          _errorController.add(
            ConnectionError(
              deviceId: deviceId,
              message: 'Biometric stream error: $error',
            ),
          );
        },
      );

      debugPrint('   ✅ Biometric data streaming started');
    } catch (e) {
      debugPrint('   ❌ Biometric streaming setup failed: $e');
      rethrow;
    }
  }

  /// Handle incoming biometric data from SPP transport
  void _handleBiometricData(final Uint8List data) {
    try {
      // TODO: Parse SPP packets and extract biometric data
      // For now, emit raw data
      final biometricData = BiometricData(
        deviceId: _deviceId!,
        timestamp: DateTime.now(),
        dataType: 'raw', // TODO: Parse packet type from SPP protocol
        rawData: data,
      );

      _biometricDataController.add(biometricData);
    } on Exception catch (e) {
      debugPrint('❌ Error parsing biometric data: $e');
    }
  }

  // ============================================================================
  // BIOMETRIC DATA (Battery, HR, Movement, etc) - VIA BiometricDataReader
  // ============================================================================
  ///
  /// ✅ **USES BiometricDataReader**: Universal data access layer
  /// 🚀 Post-Authentication Initialization (Simplified for Sleep Tracking)
  ///
  /// This method configures the device ONCE after successful BT_CLASSIC connection.
  /// We ONLY configure what's needed for SLEEP tracking, not fitness features.
  ///
  /// ℹ️  NOTE: User info (height, weight, age) is for FITNESS apps (calories, steps, etc.)
  /// For SLEEP tracking, we only need HR monitoring configuration.
  Future<void> _performPostAuthInitialization(final String deviceId) async {
    debugPrint('🚀 ═══════════════════════════════════════════════════');
    debugPrint('🚀 Post-Auth Initialization (Sleep Tracking Mode)');
    debugPrint('🚀 ═══════════════════════════════════════════════════');

    if (_sppService == null) {
      debugPrint('❌ Cannot initialize: SPP service not available');
      return;
    }

    try {
      // 1️⃣ Configure Heart Rate Monitoring
      debugPrint('1️⃣ Configuring HR monitoring...');
      await _configureHeartRateMonitoring();

      // 2️⃣ TODO: Sync Time (if needed for sleep session timestamps)
      // debugPrint('2️⃣ Syncing time...');
      // await _syncTime();

      debugPrint('✅ ═══════════════════════════════════════════════════');
      debugPrint('✅ Post-Auth Initialization Complete');
      debugPrint('✅ ═══════════════════════════════════════════════════');
    } on Exception catch (e) {
      debugPrint('❌ Post-auth initialization failed: $e');
      debugPrint('   ⚠️  Some features may not work correctly');
      // Don't rethrow - continue with connection even if init partially fails
    }
  }

  /// Configure HR monitoring (one-time setup)
  Future<void> _configureHeartRateMonitoring() async {
    debugPrint('   ⚙️  Setting HR monitoring parameters...');

    // ⏳ CRITICAL: Wait for SPP to be ready before sending config command
    // The SPP service needs to complete handshake (VERSION + SESSION_CONFIG)
    // before it can send encrypted protobuf commands
    if (!_sppService!.isReady) {
      debugPrint('   ⏳ Waiting for SPP to be ready (polling every 500ms)...');

      // Poll every 500ms for up to 10 seconds
      const maxAttempts = 20; // 20 * 500ms = 10 seconds
      var attempts = 0;

      while (!_sppService!.isReady && attempts < maxAttempts) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        attempts++;

        if (attempts % 4 == 0) {
          // Log every 2 seconds
          debugPrint('   ⏳ Still waiting... (${attempts * 500}ms elapsed)');
        }
      }

      if (!_sppService!.isReady) {
        debugPrint('   ❌ Timeout: SPP not ready after 10 seconds');
        debugPrint('   ⚠️  Skipping HR config - user will need to restart');
        return; // Don't throw, just skip configuration
      }

      debugPrint('   ✅ SPP is now ready after ${attempts * 500}ms');
    }

    final command = createEnableHeartRateMonitoringRequest();

    await _sppService!.sendProtobufCommand(
      command: command,
      expectsResponse: false,
    );

    debugPrint('   ✅ HR monitoring configured (continuous mode)');
  }

  /// ✅ **USES BatteryPollingService**: Gadgetbridge-style periodic polling
  /// ✅ **AUTO-DISCOVERY**: Evita circular dependencies
  ///
  /// Battery read ONLY via BT_CLASSIC (no BLE interference)
  void _startBatteryPolling(final String deviceId) {
    debugPrint('🔋 Starting battery polling via BatteryPollingService...');

    try {
      // ✅ Get BatteryPollingService singleton from BiometricDataReader
      final reader = BiometricDataReader();
      _batteryPollingService = reader.batteryPollingService;

      debugPrint(
        '   📡 Battery will be polled via BT_CLASSIC SPP every 5 minutes',
      );

      // ✅ Start periodic polling
      // ⏰ IMPORTANT: initialDelay MUST be long enough for post-auth initialization to complete
      // Post-auth sends 5+ encrypted commands (battery, device state, time, language, configs)
      // Typical post-auth takes ~3-5s, so we use 8s to be safe
      _batteryPollingService!.startPeriodicPolling(
        initialDelay: const Duration(seconds: 8),
      );

      debugPrint('   ✅ Battery polling started (first poll in 8s)');

      // ✅ Subscribe to battery updates and emit to stream
      _batteryPollingService!.addListener(() {
        // ⚠️ DEFENSIVE: Check if service still exists
        final service = _batteryPollingService;
        if (service == null) return;

        final batteryLevel = service.lastBatteryLevel;
        if (batteryLevel != null) {
          debugPrint('   🔋 Battery update: $batteryLevel%');
          _batteryController.add(batteryLevel);
        }
      });
    } on Exception catch (e) {
      debugPrint('   ⚠️  Failed to initialize battery polling: $e');
      // Don't fail connection if polling setup fails
    }
  }

  /// Stop battery polling
  void _stopBatteryPolling() {
    _batteryPollingService?.stopPolling();
    _batteryPollingService = null;
    debugPrint('🔋 Stopped battery polling');
  }

  /// ❌ REMOVED: requestBatteryLevel()
  ///
  /// **REASON**: Battery reads now go ONLY through BiometricDataReader.
  /// See: DeviceConnectionManager.requestBatteryUpdate() which uses BiometricDataReader.read('battery')
  /// This maintains clean architecture with BiometricDataReader as universal data access layer.

  @override
  Future<void> disconnect() async {
    debugPrint('📴 Xiaomi Orchestrator: Disconnecting $deviceId');

    try {
      // 1. Stop battery polling
      _stopBatteryPolling();

      // 2. Stop biometric streaming
      await _sppDataSubscription?.cancel();
      _sppDataSubscription = null;

      // 3. Disconnect SPP service
      await _sppService?.disconnect();
      _sppService = null;

      // 4. Dispose transport
      await _btClassicTransport?.dispose();
      _btClassicTransport = null;

      // 5. Disconnect BT_CLASSIC
      await _btClassicService.disconnect(_deviceId!);

      // 5. Disconnect BLE (if still connected)
      try {
        await _bleService.disconnectDevice(_deviceId!);
      } on Exception catch (e) {
        // Ignore if already disconnected
        debugPrint('   ℹ️  BLE already disconnected: $e');
      }

      _updateState(ConnectionState.disconnected);
      debugPrint('✅ Xiaomi Orchestrator: Disconnected successfully');
    } catch (e) {
      debugPrint('❌ Xiaomi Orchestrator: Disconnect error: $e');
      _updateState(ConnectionState.error);
      rethrow;
    }
  }

  @override
  Future<void> sendCommand(
    final String command, {
    final Map<String, dynamic>? params,
  }) async {
    if (_sppService == null) {
      throw Exception('SPP service not initialized');
    }

    // TODO: Implement command sending via XiaomiSppService
    debugPrint('📤 Sending command: $command with params: $params');
    // await _sppService!.sendCommand(...);
  }

  @override
  Future<void> dispose() async {
    debugPrint('🧹 Xiaomi Orchestrator: Disposing resources');

    await disconnect();

    // Ensure battery polling is stopped
    _stopBatteryPolling();

    await _connectionStateController.close();
    await _biometricDataController.close();
    await _batteryController.close();
    await _errorController.close();

    _authService?.dispose();
    _authService = null;

    debugPrint('✅ Xiaomi Orchestrator: Disposed');
  }

  /// Update connection state and emit to stream
  void _updateState(final ConnectionState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _connectionStateController.add(newState);
      debugPrint('   📊 State: $newState');
    }
  }
}
