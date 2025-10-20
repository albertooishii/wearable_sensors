// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 🔑 Xiaomi Auth Service - Dream Incubator
// Servicio de autenticación para dispositivos Xiaomi Smart Band 9/10
//
// Basado en: Gadgetbridge XiaomiAuthService.java
// Protocolo: 3-step handshake con AES-CCM encryption

import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Platform;
import 'dart:math' show Random;
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:wearable_sensors/src/internal/bluetooth/bluetooth_classic_service.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';
import 'xiaomi_crypto.dart';
import 'xiaomi_device_credentials.dart';
import 'protocol/v1/packet.dart';
import 'package:wearable_sensors/src/internal/models/xiaomi_spp_config.dart';
import 'package:wearable_sensors/src/internal/utils/xiaomi_device_config_loader.dart';

// 🔄 SPP V2 Support
import 'protocol/version_detector.dart';
import 'protocol/v2/handler.dart';
import 'protocol/v2/packet.dart';
import 'package:wearable_sensors/src/internal/bluetooth/spp_v2_config.dart'
    as v2_config;
import 'package:flutter/services.dart' show rootBundle;

// Protobuf command helpers
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';

// 🔌 Transport Abstraction
import 'package:wearable_sensors/src/internal/vendors/xiaomi/transport/spp_transport.dart';
import 'transport/ble_spp_transport.dart';
import 'xiaomi_spp_service.dart'; // For bonded device init commands
import 'services/xiaomi_initialization_service.dart';

/// Estados del proceso de autenticación
enum AuthState {
  idle, // No iniciado
  sendingPhoneNonce, // Step 1: Enviando phone nonce
  waitingWatchNonce, // Step 2: Esperando watch nonce
  sendingAuthStep3, // Step 3: Enviando encrypted device info
  authenticated, // ✅ Autenticación exitosa
  failed, // ❌ Autenticación fallida
}

/// Resultado de autenticación
class AuthResult {
  const AuthResult({
    required this.success,
    this.errorMessage,
    this.encryptionKeys,
    this.sppService, // ← SPP service to reuse (prevents nonce reuse)
    this.sppV2Handler, // ← SPP V2 handler from BLE auth (for orchestrator to use in transition)
  });

  final bool success;
  final String? errorMessage;
  final EncryptionKeys? encryptionKeys;
  final XiaomiSppService? sppService; // ← Shared SPP service instance
  final SppV2ProtocolHandler?
      sppV2Handler; // ← BLE handler for transition to BT_CLASSIC

  static AuthResult failure(final String message) =>
      AuthResult(success: false, errorMessage: message);

  static AuthResult succeed(
    final EncryptionKeys keys, {
    final XiaomiSppService? sppService,
    final SppV2ProtocolHandler? sppV2Handler,
  }) =>
      AuthResult(
        success: true,
        encryptionKeys: keys,
        sppService: sppService,
        sppV2Handler: sppV2Handler,
      );
}

/// Claves de encriptación derivadas del handshake
class EncryptionKeys {
  /// Create from JSON format
  factory EncryptionKeys.fromJson(final Map<String, dynamic> json) {
    return EncryptionKeys(
      encryptionKey: _hexToBytes(json['encryptionKey'] as String),
      decryptionKey: _hexToBytes(json['decryptionKey'] as String),
      encryptionNonce: _hexToBytes(json['encryptionNonce'] as String),
      decryptionNonce: _hexToBytes(json['decryptionNonce'] as String),
      authKey: json.containsKey('authKey')
          ? _hexToBytes(json['authKey'] as String)
          : null, // Backward compatibility
    );
  }
  const EncryptionKeys({
    required this.encryptionKey,
    required this.decryptionKey,
    required this.encryptionNonce,
    required this.decryptionNonce,
    this.authKey, // ← NEW: Original auth key for session nonce calculation
  });

  final Uint8List encryptionKey; // 16 bytes
  final Uint8List decryptionKey; // 16 bytes
  final Uint8List encryptionNonce; // 4 bytes
  final Uint8List decryptionNonce; // 4 bytes
  final Uint8List? authKey; // 16 bytes - Original auth key for NONCE handshake

  // Secure storage instance for encryption keys
  static const _storage = FlutterSecureStorage();

  @override
  String toString() {
    return 'EncryptionKeys(encKey: ${encryptionKey.length} bytes, '
        'decKey: ${decryptionKey.length} bytes)';
  }

  /// Convert to JSON-compatible format (hex strings)
  Map<String, String> toJson() {
    final Map<String, String> json = {
      'encryptionKey': _bytesToHex(encryptionKey),
      'decryptionKey': _bytesToHex(decryptionKey),
      'encryptionNonce': _bytesToHex(encryptionNonce),
      'decryptionNonce': _bytesToHex(decryptionNonce),
    };
    if (authKey != null) {
      json['authKey'] = _bytesToHex(authKey!);
    }
    return json;
  }

  /// Save encryption keys to secure storage
  ///
  /// **Storage key:** `xiaomi_encryption_keys_{deviceId}`
  /// **Format:** JSON with hex strings
  Future<void> save(final String deviceId) async {
    try {
      final json = toJson();
      final jsonString = jsonEncode(json);
      await _storage.write(
        key: 'xiaomi_encryption_keys_$deviceId',
        value: jsonString,
      );
      debugPrint('✅ Saved encryption keys for device: $deviceId');
    } catch (e) {
      debugPrint('❌ Failed to save encryption keys: $e');
      rethrow;
    }
  }

  /// Load encryption keys from secure storage
  ///
  /// **Returns:** EncryptionKeys or null if not found
  static Future<EncryptionKeys?> load(final String deviceId) async {
    try {
      final jsonString = await _storage.read(
        key: 'xiaomi_encryption_keys_$deviceId',
      );

      if (jsonString == null) {
        debugPrint('⚠️ No encryption keys found for device: $deviceId');
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return EncryptionKeys.fromJson(json);
    } on Exception catch (e) {
      debugPrint('❌ Failed to load encryption keys: $e');
      return null;
    }
  }

  /// Delete encryption keys from secure storage
  static Future<void> delete(final String deviceId) async {
    try {
      await _storage.delete(key: 'xiaomi_encryption_keys_$deviceId');
      debugPrint('🗑️ Deleted encryption keys for device: $deviceId');
    } on Exception catch (e) {
      debugPrint('❌ Failed to delete encryption keys: $e');
      rethrow;
    }
  }

  // Helper methods
  static String _bytesToHex(final Uint8List bytes) {
    return bytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List _hexToBytes(final String hex) {
    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }
}

/// Servicio de autenticación Xiaomi
///
/// **Workflow:**
/// 1. Cargar credentials (authKey) desde secure storage
/// 2. Generar phoneNonce aleatorio (16 bytes)
/// 3. Enviar phoneNonce al dispositivo → esperar watchNonce
/// 4. Derivar encryption keys usando HMAC-SHA256
/// 5. Verificar watchNonce HMAC
/// 6. Enviar AuthStep3 (encrypted nonces + device info)
/// 7. Esperar confirmación → autenticación completa
///
/// **Uso:**
/// ```dart
/// final authService = XiaomiAuthService(
///   deviceId: 'AA:BB:CC:DD:EE:FF',
///   bleService: bleService,
/// );
///
/// final result = await authService.authenticate();
/// if (result.success) {
///   print('✅ Authenticated! Keys: ${result.encryptionKeys}');
/// } else {
///   print('❌ Auth failed: ${result.errorMessage}');
/// }
/// ```
class XiaomiAuthService {
  XiaomiAuthService({
    required this.deviceId,
    required this.bleService,
    required this.deviceImplementation,
    this.sppService, // ← For bonded devices that skip BLE auth
    this.btClassicService, // ← For BT_CLASSIC transition after BLE auth
  });

  final String deviceId;
  final BleService bleService;
  final DeviceImplementation deviceImplementation;
  final XiaomiSppService? sppService; // ← BT_CLASSIC SPP service (bonded path)
  final BluetoothClassicService?
      btClassicService; // ← BT_CLASSIC service for transition

  // Auth state
  AuthState _state = AuthState.idle;
  XiaomiDeviceCredentials? _credentials;

  // Nonces y keys
  Uint8List? _phoneNonce;
  Uint8List? _watchNonce;
  EncryptionKeys? _encryptionKeys;

  // Stream para respuestas del dispositivo
  StreamSubscription<Uint8List>? _dataSubscription;
  Completer<AuthResult>? _authCompleter;

  // 🔧 SPP Protocol support
  XiaomiAuthConfig? _sppConfig;
  int _frameCounter = 0;
  int _encryptionCounter = 0;
  SppProtocolVersion _sppVersion = SppProtocolVersion.v1; // Default to V1

  // 🔄 SPP V2 Protocol Handler (initialized if version == 2)
  SppV2ProtocolHandler? _sppV2Handler;

  // 🔌 Transport abstraction (BLE during authentication)
  SppTransport? _transport;

  // Command types
  static const _commandTypeAuth = 1;
  static const _cmdNonce = 26;
  static const _cmdAuth = 27;

  /// Iniciar proceso de autenticación
  ///
  /// **Returns:** AuthResult con success=true si autenticación OK
  ///
  /// **Throws:** Exception si dispositivo no conectado o credentials inválidas
  Future<AuthResult> authenticate() async {
    if (_state != AuthState.idle && _state != AuthState.failed) {
      debugPrint('⚠️ Authentication already in progress: $_state');
      return AuthResult.failure('Authentication already in progress');
    }

    try {
      // 1. Load credentials and encryption keys
      _credentials = await XiaomiDeviceCredentials.load(deviceId);
      if (_credentials == null) {
        return AuthResult.failure(
          'No credentials found. Please pair device first.',
        );
      }

      debugPrint('🔑 Loaded credentials: $_credentials');

      // 1.5. Load saved encryption keys (includes authKey for NONCE handshakes)
      _encryptionKeys = await EncryptionKeys.load(deviceId);
      if (_encryptionKeys != null) {
        debugPrint('🔑 Loaded encryption keys from storage');
        if (_encryptionKeys!.authKey != null) {
          debugPrint('   ✅ authKey available for session nonce calculation');
        } else {
          debugPrint('   ⚠️ authKey not in saved keys (old format?)');
        }
      } else {
        debugPrint('⚠️ No saved encryption keys found');
      }

      // 2. Load SPP protocol configuration from JSON
      await _loadSppConfig();

      // 3. Initialize BLE SPP transport (abstraction layer)
      final authConfig = deviceImplementation.authentication;
      _transport = BleSppTransport(
        deviceId: deviceId,
        bleService: bleService,
        serviceUuid: authConfig.serviceUuid!,
        writeCharacteristicUuid: authConfig.commandWriteUuid!,
        readCharacteristicUuid: authConfig.commandReadUuid!,
      );

      debugPrint('� Initialized BleSppTransport:');
      debugPrint('   Service: ${authConfig.serviceUuid}');
      debugPrint('   Write: ${authConfig.commandWriteUuid}');
      debugPrint('   Read: ${authConfig.commandReadUuid}');

      // 3.5. CRÍTICO: Obtener device real con forceScan (evita cache stale)
      debugPrint('🔄 Getting FRESH device instance (forceScan=true)...');
      final bleDevice = await bleService.getBluetoothDeviceAsync(deviceId);

      debugPrint(
        '✅ Got device: ${bleDevice.platformName} (${bleDevice.remoteId.str})',
      );

      // ✅ BONDING ANTES DE AUTENTICACIÓN (evita race conditions)
      // Separamos responsabilidades:
      // 1. Bonding = OS (cifrado BLE, pairing)
      // 2. Auth = App (protocolo Xiaomi, authKey)
      debugPrint('🔐 Preparing device with bonding BEFORE authentication...');

      final isBondedDevice = await bleService.isDeviceBonded(deviceId);

      if (!isBondedDevice) {
        // 🤝 Primera vez: Hacer bonding completo ANTES de auth
        debugPrint('   🤝 Device not bonded - initiating bonding cycle...');

        await bleService.prepareDeviceWithBonding(
          deviceId: deviceId,
          timeout: const Duration(seconds: 30),
        );

        debugPrint('   ✅ Bonding completed successfully');
        debugPrint('   ⏰ Waiting for bonding to settle (3 seconds)...');

        // Esperar a que el bonding se asiente completamente
        await Future.delayed(const Duration(seconds: 3));

        debugPrint('   🔄 Reconnecting for authentication...');
        await bleService.connectDevice(deviceId);
      } else {
        // ✅ Ya bonded: Solo conectar BLE
        debugPrint('   ✅ Device already bonded - connecting BLE...');
        final device = bleService.getBluetoothDevice(deviceId);

        if (device.isConnected) {
          debugPrint('   Forcing disconnect (fixes stale connection state)...');
          await device.disconnect();
          await Future.delayed(const Duration(milliseconds: 1000));
        }

        await bleService.connectDevice(deviceId);
      }

      // Verificar conexión descubriendo servicios
      debugPrint('   🔍 Discovering services...');
      List<fbp.BluetoothService> services;
      try {
        services =
            await bleService.getBluetoothDevice(deviceId).discoverServices();
        debugPrint(
          '   ✅ Ready for authentication! Services: ${services.length}',
        );
      } on fbp.FlutterBluePlusException catch (e) {
        // ⚠️ Xiaomi Band 10 rechaza suscripción a 2a05 (Service Changed) con error 129
        // Esto es esperado y NO es fatal - el dispositivo simplemente no permite
        // suscribirse a esa característica del sistema
        if (e.code == 129 && (e.description?.contains('2a05') ?? false)) {
          debugPrint(
            '⚠️ Device rejected Service Changed subscription (2a05) - this is OK',
          );
          debugPrint(
            '   Reason: Xiaomi devices don\'t allow system characteristic subscriptions',
          );
          debugPrint('   Continuing with authentication...');

          // Retry sin intentar subscribirse a Service Changed
          // flutter_blue_plus debería cachear que ya intentó y no reintentarlo
          await Future.delayed(const Duration(milliseconds: 500));
          services =
              await bleService.getBluetoothDevice(deviceId).discoverServices();
          debugPrint('   ✅ Services discovered on retry: ${services.length}');
        } else {
          rethrow; // Otros errores sí son fatales
        }
      }

      if (services.isEmpty) {
        throw Exception('Connected but no services found - device not ready');
      }

      // 4. Request larger MTU for SPP packets (Gadgetbridge uses 247)
      await _requestMtu();

      // 5. Subscribirse a notificaciones del dispositivo
      await _subscribeToNotifications();

      // 6. Request SPP protocol version (CRITICAL - Gadgetbridge does this first!)
      await _requestSppVersion();

      // 7. Branch según SPP version detectada
      if (_sppVersion == SppProtocolVersion.v2) {
        debugPrint('🔄 Using SPP V2 authentication flow (Band 10+)');
        return await _authenticateV2();
      } else {
        debugPrint('🔄 Using SPP V1 authentication flow (Band 9 or earlier)');
        return await _authenticateV1();
      }
    } on Exception catch (e) {
      _state = AuthState.failed;
      debugPrint('❌ Authentication exception: $e');
      return AuthResult.failure('Authentication error: $e');
    } finally {
      await _dataSubscription?.cancel();
      _dataSubscription = null;

      // ✅ CRITICAL: Only dispose handler on failure, keep it for time sync and future commands
      if (_state != AuthState.authenticated) {
        debugPrint('🧹 Disposing SPP V2 handler due to auth failure');
        await _sppV2Handler?.dispose();
        _sppV2Handler = null;
      } else {
        debugPrint('✅ Keeping SPP V2 handler active for post-auth commands');
      }
    }
  }

  /// SPP V1 Authentication Flow (Band 9)
  ///
  /// Traditional 3-step handshake using SPP V1 protocol.
  Future<AuthResult> _authenticateV1() async {
    try {
      // 1. Generar phoneNonce aleatorio
      _phoneNonce = XiaomiCrypto.generateNonce(16);
      debugPrint('📱 Generated phoneNonce: ${_phoneNonce!.length} bytes');

      // 2. Enviar Step 1: PhoneNonce (V1)
      await _sendPhoneNonce();
      await _sendPhoneNonce(); // Enviar 2 veces (Gadgetbridge behavior)

      // 3. Esperar respuesta del dispositivo (con timeout)
      _authCompleter = Completer<AuthResult>();
      final result = await _authCompleter!.future.timeout(
        const Duration(seconds: 60), // ✅ Aumentado de 10s a 60s
        onTimeout: () {
          debugPrint('⏱️ Authentication timeout');
          return AuthResult.failure('Authentication timeout');
        },
      );

      if (result.success) {
        _state = AuthState.authenticated;
        debugPrint('✅ SPP V1: Authentication successful!');
      } else {
        _state = AuthState.failed;
        debugPrint('❌ SPP V1: Authentication failed: ${result.errorMessage}');
      }

      return result;
    } on Exception catch (e) {
      debugPrint('❌ SPP V1: Authentication error: $e');
      return AuthResult.failure('V1 auth error: $e');
    }
  }

  /// SPP V2 Authentication Flow (Band 10+)
  ///
  /// Uses SppV2ProtocolHandler for session management and data transfer.
  Future<AuthResult> _authenticateV2() async {
    try {
      // 1. Generar phoneNonce aleatorio
      _phoneNonce = XiaomiCrypto.generateNonce(16);
      debugPrint(
        '📱 SPP V2: Generated phoneNonce: ${_phoneNonce!.length} bytes',
      );

      // 2. Initialize SPP V2 handler (will trigger session handshake)
      await _initializeSppV2Handler();

      // 3. Handler will call _sendPhoneNonceV2() when session is established

      // 4. Esperar respuesta del dispositivo (con timeout)
      _authCompleter = Completer<AuthResult>();
      debugPrint(
        '⏳ SPP V2: Waiting for authentication to complete (60s timeout)...',
      );

      final result = await _authCompleter!.future.timeout(
        const Duration(seconds: 60), // ✅ Aumentado de 15s a 60s para debugging
        onTimeout: () {
          debugPrint(
            '⏱️ SPP V2: Authentication timeout - watchNonce never arrived!',
          );
          return AuthResult.failure('Authentication timeout (V2)');
        },
      );

      debugPrint(
        '🔍 SPP V2: Auth completed with result.success = ${result.success}',
      );

      if (result.success) {
        _state = AuthState.authenticated;
        debugPrint('✅ SPP V2: Authentication successful!');
      } else {
        _state = AuthState.failed;
        debugPrint('❌ SPP V2: Authentication failed: ${result.errorMessage}');
      }

      debugPrint(
        '📤 SPP V2: Returning AuthResult to orchestrator (success=${result.success})',
      );
      return result;
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Authentication error: $e');
      return AuthResult.failure('V2 auth error: $e');
    }
  }

  /// Auto-detectar características correctas del servicio FE95
  ///
  /// Protocolo V1 (Smart Band 9): 0051 (TX/write), 0052 (RX/notify)
  /// Protocolo V2 (Smart Band 10): 005E (RX/notify), 005F (TX/write)
  ///
  /// IMPORTANTE: V2 tiene características SEPARADAS, no combinadas.
  /// - 005E: Solo para NOTIFY (receive from device)
  /// - 005F: Solo para WRITE (send to device)
  ///
  /// Basado en Gadgetbridge: XiaomiBleProtocolV2.java
  ///
  /// 🎯 **NUEVO ENFOQUE DINÁMICO**:
  /// - Lee `command_write_uuid` y `command_read_uuid` directamente del JSON
  /// - CERO lógica hardcodeada de detección de protocolos
  /// - Solo valida que las características existan en el dispositivo real
  Future<void> _loadSppConfig() async {
    try {
      final deviceType = deviceImplementation.deviceType;
      debugPrint('📄 Loading SPP config for device type: $deviceType');

      _sppConfig = await XiaomiDeviceConfigLoader.loadAuthConfig(deviceType);
      _sppVersion = _sppConfig!.sppProtocol.defaultVersion;

      debugPrint('✅ SPP Config loaded: version=$_sppVersion');
      debugPrint(
        '   Version detection: ${_sppConfig!.sppProtocol.versionDetection?.enabled}',
      );

      // ✅ Version detection implemented via SppVersionDetector in _requestSppVersion()
      if (_sppConfig!.sppProtocol.versionDetection?.enabled ?? false) {
        debugPrint(
          '✅ Version detection is enabled (handled by SppVersionDetector)',
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ Failed to load SPP config: $e');
      debugPrint('⚠️ Falling back to SPP V1 default');
      _sppVersion = SppProtocolVersion.v1;
    }
  }

  /// Request larger MTU for SPP packets
  ///
  /// SPP V1 packets can be larger than 20 bytes (default BLE MTU).
  /// Gadgetbridge requests MTU 247 to accommodate full packets.
  Future<void> _requestMtu() async {
    try {
      debugPrint('📡 Requesting MTU 247 for SPP packets...');

      final mtu = await bleService.requestMtu(deviceId: deviceId, mtu: 247);

      debugPrint('✅ MTU negotiated: $mtu bytes');
    } on Exception catch (e) {
      debugPrint('⚠️ MTU request failed: $e');
      debugPrint('⚠️ Will use default MTU (20 bytes) - may need fragmentation');
    }
  }

  /// Request SPP protocol version from device
  ///
  /// **IMPORTANTE**: JSON-driven version detection (Fixed for Band 10)
  ///
  /// LOGIC (based on Gadgetbridge XiaomiSppSupport.java):
  /// 1. If JSON says "version": "v2" → ASSUME V2 directly (no VERSION request)
  /// 2. If JSON says "version": "v1" + "version_detection.enabled": true →
  ///    Send VERSION request and auto-switch to V2 if response[0] >= 2
  /// 3. If JSON says "version": "v1" without detection → ASSUME V1 directly
  ///
  /// Band 10 case: JSON says "v2" → Skip VERSION request, go straight to V2
  /// Band 9 case: JSON says "v1" + detection → Send VERSION request, stay V1
  ///
  /// Saves detected version in _sppVersion for later use.
  Future<void> _requestSppVersion() async {
    debugPrint('📡 Determining SPP protocol version...');

    try {
      // Check if JSON already specifies V2
      if (_sppVersion == SppProtocolVersion.v2) {
        debugPrint('✅ JSON specifies V2 → Using SPP V2 directly (Band 10+)');
        debugPrint('   Skipping VERSION request (device is V2-only)');
        return; // No need to detect, JSON says V2
      }

      // Check if version detection is enabled
      final versionDetectionEnabled =
          _sppConfig?.sppProtocol.versionDetection?.enabled ?? false;

      if (!versionDetectionEnabled) {
        debugPrint('✅ JSON specifies V1 → Using SPP V1 directly (Band 9)');
        debugPrint('   Version detection disabled in JSON');
        return; // No detection, assume V1 from JSON
      }

      // Only V1 devices with detection enabled reach here
      debugPrint(
        '🔍 JSON says V1 + detection enabled → Sending VERSION request...',
      );

      // Use SppVersionDetector for automatic version detection
      final detector = SppVersionDetector(bleService);
      final authConfig = deviceImplementation.authentication;

      final result = await detector.detectVersion(
        deviceId: deviceId,
        commandWriteUuid: authConfig.commandWriteUuid!,
      );

      debugPrint('🎯 SPP Version Detection Result:');
      debugPrint('   Version: ${result.version}');
      debugPrint('   Detected from response: ${result.detectedFromResponse}');
      debugPrint('   Reason: ${result.reason}');

      // Auto-switch to V2 if device responded with version >= 2
      if (result.version == 2 && result.detectedFromResponse) {
        _sppVersion = SppProtocolVersion.v2;
        debugPrint('🔄 Auto-switched to SPP V2 (device reported version >= 2)');
      } else {
        debugPrint(
          '📌 Staying on SPP V1 (device reported version < 2 or timeout)',
        );
      }
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to detect SPP version: $e');
      debugPrint('Stack trace: $stackTrace');
      // Keep JSON default on error
      debugPrint('⚠️  Keeping JSON default: $_sppVersion');
    }
  }

  /// Initialize SPP V2 Protocol Handler (only if version == V2)
  ///
  /// Creates and configures SppV2ProtocolHandler with callbacks for:
  /// - Session established → start authentication
  /// - Auth data received → handle watch nonce and auth responses
  ///
  /// Based on Gadgetbridge XiaomiSppProtocolV2.java
  Future<void> _initializeSppV2Handler() async {
    if (_sppVersion != SppProtocolVersion.v2) {
      debugPrint('⏭️ Skipping SPP V2 handler init (version is V1)');
      return;
    }

    debugPrint('🔄 Initializing SPP V2 Protocol Handler...');

    try {
      // Dispose previous handler if exists (prevents duplicate listeners)
      if (_sppV2Handler != null) {
        debugPrint('🧹 Disposing previous SPP V2 handler...');
        await _sppV2Handler!.dispose();
        _sppV2Handler = null;
      }

      // ✅ PHASE 4: Load SPP V2 config from device JSON
      if (!v2_config.SppV2Config.isInitialized) {
        debugPrint('📋 Loading SPP V2 config from device JSON...');
        final deviceType = deviceImplementation.deviceType;
        final jsonPath =
            'packages/wearable_sensors/assets/device_implementations/$deviceType.json';
        final jsonString = await rootBundle.loadString(jsonPath);
        final deviceJson = jsonDecode(jsonString) as Map<String, dynamic>;

        // Initialize global SPP V2 config
        v2_config.SppV2Config.initialize(deviceJson);
        debugPrint('✅ SPP V2 config initialized from $deviceType.json');
      }

      // Create handler instance
      _sppV2Handler = SppV2ProtocolHandler(bleService);

      // Configure UUIDs from device implementation
      final authConfig = deviceImplementation.authentication;
      _sppV2Handler!.configureUuids(
        serviceUuid: authConfig.serviceUuid!,
        commandWriteUuid: authConfig.commandWriteUuid!,
        commandReadUuid: authConfig.commandReadUuid!,
      );

      // Configure callback: Session established → start authentication
      _sppV2Handler!.onSessionEstablished = () async {
        debugPrint('✅ SPP V2: Session established, starting authentication...');

        // ✅ FIXED: NO delay - Gadgetbridge sends phoneNonce IMMEDIATELY
        // The delay was causing the device to not respond with watchNonce
        await _sendPhoneNonceV2();
      };

      // Configure callback: Auth data received → handle responses
      _sppV2Handler!.onAuthDataReceived = (final data) {
        debugPrint('🔐 SPP V2: Received auth data (${data.length} bytes)');
        _handleAuthDataV2(data);
      };

      // ✅ NEW: Handle system command responses (battery, device info, etc.)
      _sppV2Handler!.onSystemCommandReceived = (final data) {
        debugPrint('🔋 SPP V2: Received system command (${data.length} bytes)');
        _handleSystemCommandDataV2(data);
      };

      // Initialize session (sends SESSION_CONFIG request)
      await _sppV2Handler!.initializeSession(deviceId);

      debugPrint('✅ SPP V2 Protocol Handler initialized successfully');
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize SPP V2 handler: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('SPP V2 initialization failed: $e');
    }
  }

  // ========================================================================
  // SPP V2 AUTHENTICATION METHODS
  // ========================================================================

  /// Send Step 1 (V2): PhoneNonce via SPP V2
  ///
  /// Uses SppV2ProtocolHandler to send phone nonce on authentication channel.
  /// Protocol: Send via DATA packet, channel=authentication (2)
  Future<void> _sendPhoneNonceV2() async {
    try {
      debugPrint('📤 SPP V2: Sending phoneNonce...');
      debugPrint(
        '   🔑 PhoneNonce bytes: ${_phoneNonce!.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      final command = pb.Command.create()
        ..type = _commandTypeAuth
        ..subtype = _cmdNonce
        ..auth = (pb.Auth.create()
          ..phoneNonce = (pb.PhoneNonce.create()..nonce = _phoneNonce!));

      final payload = Uint8List.fromList(command.writeToBuffer());

      debugPrint('📦 SPP V2: Protobuf Command details:');
      debugPrint('   Type: $_commandTypeAuth (AUTH)');
      debugPrint('   Subtype: $_cmdNonce (NONCE)');
      debugPrint('   Payload length: ${payload.length} bytes');
      debugPrint(
        '   Payload hex: ${payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // ✅ Route to correct handler: BLE (sppV2Handler) or BT_CLASSIC (sppService)
      if (sppService != null) {
        // BT_CLASSIC path (bonded devices with saved keys)
        debugPrint('   📡 Sending via BT_CLASSIC SPP service...');
        debugPrint('   🔓 IMPORTANT: NONCE must use AUTHENTICATION channel');

        final response = await sppService!.sendAuthenticationCommand(
          command: command, // ← Uses authentication channel, unencrypted
        );

        // Process WATCH_NONCE response immediately
        if (response != null) {
          debugPrint('   ✅ Received WATCH_NONCE response, processing...');
          // Response is already a Command, route directly to data handler
          _handleAuthDataV2(response.writeToBuffer());
        } else {
          debugPrint('   ❌ No response received for NONCE command');
        }
      } else if (_sppV2Handler != null) {
        // BLE path (initial authentication)
        debugPrint('   📡 Sending via BLE SPP V2 handler...');
        await _sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.authentication,
          payload: payload,
        );
      } else {
        throw Exception(
          'No SPP transport available (neither BLE nor BT_CLASSIC)',
        );
      }

      _state = AuthState.waitingWatchNonce;
      debugPrint('✅ SPP V2: PhoneNonce sent successfully');
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to send phoneNonce: $e');
      _safeCompleteAuth(AuthResult.failure('Failed to send nonce: $e'));
    }
  }

  /// Handle incoming auth data from SPP V2
  ///
  /// Called by SppV2ProtocolHandler when auth data is received.
  /// Decodes protobuf Command and routes to appropriate handler.
  void _handleAuthDataV2(final Uint8List data) {
    try {
      debugPrint('🔐 SPP V2: Decoding auth data (${data.length} bytes)');
      debugPrint(
        '   📥 Raw data hex: ${data.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Decode protobuf Command
      final command = pb.Command.fromBuffer(data);
      debugPrint(
        '📦 SPP V2: Received command type=${command.type}, subtype=${command.subtype}',
      );
      debugPrint('   hasAuth: ${command.hasAuth()}');
      if (command.hasAuth()) {
        debugPrint('   hasWatchNonce: ${command.auth.hasWatchNonce()}');
        debugPrint('   hasPhoneNonce: ${command.auth.hasPhoneNonce()}');
      }

      // Route to appropriate handler
      if (command.type == _commandTypeAuth) {
        if (command.subtype == _cmdNonce &&
            command.hasAuth() &&
            command.auth.hasWatchNonce()) {
          debugPrint('⌚ SPP V2: Received watchNonce - routing to handler');
          _handleWatchNonceV2(command);
        } else if (command.subtype == _cmdAuth) {
          debugPrint('✅ SPP V2: Received auth response - routing to handler');
          _handleAuthResponseV2(command);
        } else {
          debugPrint('⚠️  SPP V2: Unknown auth subcommand: ${command.subtype}');
          debugPrint(
            '      Command details: type=${command.type}, hasAuth=${command.hasAuth()}',
          );
        }
      } else if (command.type == 2) {
        // System commands (type=2): battery, device info, device state, etc.
        debugPrint(
          '🔋 SPP V2: Received system command response (subtype=${command.subtype})',
        );
        _handleSystemCommandResponse(command);
      } else {
        debugPrint('⚠️  SPP V2: Unknown command type: ${command.type}');
      }
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to handle auth data: $e');
      _safeCompleteAuth(AuthResult.failure('Auth data error: $e'));
    }
  }

  /// Handle incoming system command data from SPP V2
  ///
  /// Called by SppV2ProtocolHandler when system command data is received.
  /// Decodes protobuf Command and routes to _handleSystemCommandResponse().
  void _handleSystemCommandDataV2(final Uint8List data) {
    try {
      debugPrint(
        '🔋 SPP V2: Decoding system command data (${data.length} bytes)',
      );
      debugPrint(
        '   📥 Raw data hex: ${data.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Decode protobuf Command
      final command = pb.Command.fromBuffer(data);
      debugPrint(
        '📦 SPP V2: Received system command type=${command.type}, subtype=${command.subtype}',
      );

      // Route to system command handler
      _handleSystemCommandResponse(command);
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to decode system command data: $e');
    }
  }

  /// Handle Step 2 (V2): WatchNonce response
  void _handleWatchNonceV2(final pb.Command command) {
    try {
      final watchNonce = command.auth.watchNonce;
      _watchNonce = Uint8List.fromList(watchNonce.nonce);
      final watchHmac = Uint8List.fromList(watchNonce.hmac);

      debugPrint('⌚ SPP V2: Received watchNonce: ${_watchNonce!.length} bytes');

      // Get authKey: from saved keys if available, otherwise from credentials
      Uint8List authKey;
      if (_encryptionKeys?.authKey != null) {
        authKey = _encryptionKeys!.authKey!;
        debugPrint('🔑 Using saved authKey for session nonce calculation');
      } else if (_credentials != null) {
        authKey = _credentials!.authKeyBytes;
        debugPrint(
          '🔑 Using credentials authKey for session nonce calculation',
        );
      } else {
        debugPrint('❌ No authKey available (neither saved nor in credentials)');
        _safeCompleteAuth(
          AuthResult.failure('No authKey for session nonce calculation'),
        );
        return;
      }

      // Derive encryption keys (same algorithm as V1)
      final keyMaterial = XiaomiCrypto.computeAuthStep3Hmac(
        authKey,
        _phoneNonce!,
        _watchNonce!,
      );

      final decryptionKey = keyMaterial.sublist(0, 16);
      final encryptionKey = keyMaterial.sublist(16, 32);
      final decryptionNonce = keyMaterial.sublist(32, 36);
      final encryptionNonce = keyMaterial.sublist(36, 40);

      _encryptionKeys = EncryptionKeys(
        encryptionKey: encryptionKey,
        decryptionKey: decryptionKey,
        encryptionNonce: encryptionNonce,
        decryptionNonce: decryptionNonce,
        authKey: authKey, // ← Save for future NONCE handshakes
      );

      debugPrint('🔐 SPP V2: Derived encryption keys');

      // Configure encryption keys in SPP V2 handler for post-auth commands
      if (_sppV2Handler != null) {
        _sppV2Handler!.setEncryptionKeys(_encryptionKeys!);
        debugPrint('✅ SPP V2: Encryption keys configured in handler');
      }

      // ✅ CRITICAL: Update encryption keys in SPP service (BT_CLASSIC path)
      if (sppService != null) {
        sppService!.updateEncryptionKeys(_encryptionKeys!);
        debugPrint('✅ SPP V2: Encryption keys updated in SPP service');
      }

      // Verify watchNonce HMAC
      final expectedHmac = XiaomiCrypto.hmacSHA256(
        decryptionKey,
        Uint8List.fromList([..._watchNonce!, ..._phoneNonce!]),
      );

      if (!_bytesEqual(expectedHmac, watchHmac)) {
        debugPrint('❌ SPP V2: Watch HMAC verification failed!');
        _safeCompleteAuth(AuthResult.failure('Watch HMAC mismatch'));
        return;
      }

      debugPrint('✅ SPP V2: Watch HMAC verified');

      // Send Step 3
      _sendAuthStep3V2();
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to handle watchNonce: $e');
      _safeCompleteAuth(AuthResult.failure('WatchNonce error: $e'));
    }
  }

  /// Send Step 3 (V2): Encrypted device info via SPP V2
  Future<void> _sendAuthStep3V2() async {
    try {
      _state = AuthState.sendingAuthStep3;
      debugPrint('📤 SPP V2: Sending AuthStep3...');

      // Build AuthDeviceInfo (same structure as V1 - basado en Gadgetbridge)
      final deviceInfo = pb.AuthDeviceInfo.create()
        ..unknown1 = 0
        ..phoneApiLevel =
            await _getPhoneApiLevel() // ✅ API level real del sistema
        ..phoneName = await _getPhoneName() // ✅ Modelo de dispositivo real
        ..unknown3 = 224
        ..region = _getDeviceRegion(); // ✅ Región real del sistema

      // Encrypt device info using encryptionKey
      final encryptedDeviceInfo = XiaomiCrypto.encryptCCM(
        _encryptionKeys!.encryptionKey,
        _buildNonceForEncryption(0), // Packet counter = 0
        deviceInfo.writeToBuffer(),
      );

      // Compute encrypted nonces HMAC
      final encryptedNonces = XiaomiCrypto.hmacSHA256(
        _encryptionKeys!.encryptionKey,
        Uint8List.fromList([..._phoneNonce!, ..._watchNonce!]),
      );

      // Build AuthStep3
      final authStep3 = pb.AuthStep3.create()
        ..encryptedNonces = encryptedNonces
        ..encryptedDeviceInfo = encryptedDeviceInfo;

      // Build Command
      final command = pb.Command.create()
        ..type = _commandTypeAuth
        ..subtype = _cmdAuth
        ..auth = (pb.Auth.create()..authStep3 = authStep3);

      final payload = Uint8List.fromList(command.writeToBuffer());

      // ✅ Route to correct handler: BLE (sppV2Handler) or BT_CLASSIC (sppService)
      if (sppService != null) {
        // BT_CLASSIC path (bonded devices with saved keys)
        debugPrint('   📡 Sending AuthStep3 via BT_CLASSIC SPP service...');

        final response = await sppService!.sendAuthenticationCommand(
          command: command, // ← Uses authentication channel
        );

        // Process auth response immediately
        if (response != null) {
          debugPrint('   ✅ Received AUTH response, processing...');
          _handleAuthResponseV2(response);
        } else {
          debugPrint('   ❌ No response received for AUTH command');
        }
      } else if (_sppV2Handler != null) {
        // BLE path (initial authentication)
        debugPrint('   📡 Sending AuthStep3 via BLE SPP V2 handler...');
        await _sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.authentication,
          payload: payload,
        );
      } else {
        throw Exception(
          'No SPP transport available (neither BLE nor BT_CLASSIC)',
        );
      }

      debugPrint('✅ SPP V2: AuthStep3 sent (${payload.length} bytes)');
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to send AuthStep3: $e');
      _safeCompleteAuth(AuthResult.failure('AuthStep3 error: $e'));
    }
  }

  /// Handle auth response (success/failure)
  Future<void> _handleAuthResponseV2(final pb.Command command) async {
    try {
      // Check success (same logic as V1)
      final isSuccess = command.subtype == _cmdAuth ||
          (command.hasAuth() && command.auth.status == 1);

      debugPrint('📨 SPP V2: Auth response - success=$isSuccess');

      if (isSuccess) {
        debugPrint('✅ SPP V2: Authentication successful!');

        // ✅ GADGETBRIDGE PATTERN: Send initialization commands IMMEDIATELY
        // This matches XiaomiSupport.onAuthSuccess() behavior
        debugPrint('📤 SPP V2: Sending post-auth initialization commands...');
        try {
          await _sendPostAuthInitialization();
          debugPrint(
            '✅ SPP V2: Post-auth initialization completed successfully',
          );
        } on Exception catch (e) {
          debugPrint('⚠️ SPP V2: Post-auth initialization failed: $e');
          // Non-fatal - continue with auth flow
        }

        // ✅ AUTH COMPLETE: Return sppV2Handler for orchestrator to use
        // Orchestrator will handle transition to BT_CLASSIC (if needed)
        // Don't do transition here - that's the orchestrator's responsibility
        debugPrint('✅ SPP V2: BLE authentication complete');
        debugPrint(
          '   → Returning sppV2Handler to orchestrator for transition',
        );

        _safeCompleteAuth(
          AuthResult.succeed(
            _encryptionKeys!,
            sppV2Handler: _sppV2Handler,
          ),
        );
      } else {
        debugPrint('❌ SPP V2: Authentication failed: status=${command.status}');
        _safeCompleteAuth(
          AuthResult.failure('Auth rejected by device: ${command.status}'),
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Failed to handle auth response: $e');
      _safeCompleteAuth(AuthResult.failure('Auth response error: $e'));
    }
  }

  /// Handle system command responses (battery, device info, device state, etc.)
  ///
  /// Called when a Command with type=2 (System) is received via SPP V2.
  /// Parses the response and emits battery level to the orchestrator's battery stream.
  void _handleSystemCommandResponse(final pb.Command command) {
    try {
      debugPrint(
        '🔋 SPP V2: Processing system command response (type=${command.type}, subtype=${command.subtype})',
      );

      // Handle battery response (subtype=1)
      if (command.subtype == 1) {
        final batteryLevel = parseBatteryFromCommand(command);

        if (batteryLevel != null) {
          debugPrint('🔋 SPP V2: Battery level received: $batteryLevel%');
          debugPrint('✅ Battery response successfully parsed!');

          // TODO: Emit to battery stream
          // For now, the orchestrator will handle this via polling/retry
          // In future, we can add a battery callback or stream here
        } else {
          debugPrint('⚠️  SPP V2: Could not parse battery level from response');
          debugPrint('      Command has system: ${command.hasSystem()}');
          if (command.hasSystem()) {
            debugPrint('      System has power: ${command.system.hasPower()}');
            if (command.system.hasPower()) {
              debugPrint(
                '      Power has battery: ${command.system.power.hasBattery()}',
              );
            }
          }
        }
      } else {
        // Other system commands (device info, device state, etc.)
        debugPrint(
          '📝 SPP V2: System command subtype ${command.subtype} received (not yet handled)',
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Error handling system command response: $e');
    }
  }

  // ========================================================================
  // SPP V1 METHODS (ORIGINAL)
  // ========================================================================

  /// Send SPP V1 packet
  ///
  /// Encapsulates protobuf command in SPP V1 packet format and sends to device
  Future<void> _sendSppPacket({
    required final XiaomiSppChannel channel,
    required final Uint8List payload,
    final bool needsResponse = false,
  }) async {
    try {
      debugPrint('📦 Building SPP V1 packet for channel: $channel');

      final packet = XiaomiSppPacketV1Builder()
          .setChannel(channel)
          .setOpCode(XiaomiSppV1Constants.opcodeSend)
          .setFrameSerial(_frameCounter++)
          .setNeedsResponse(needsResponse)
          .setPayload(payload)
          .build();

      debugPrint('📦 SPP Packet: $packet');

      // Encode packet (with encryption if needed AND keys available)
      Uint8List Function(Uint8List)? encryptFn;
      if (packet.dataType == XiaomiSppV1Constants.dataTypeEncrypted &&
          _encryptionKeys != null) {
        // 🎯 CRITICAL FIX: Use DYNAMIC nonce per packet (not static)
        // Format: encryptionNonce(4B) + zeros(4B) + sequenceCounter(4B)
        // Each packet needs unique nonce based on its sequence number
        final dynamicNonce = _buildNonceForEncryption(_encryptionCounter);
        encryptFn = (final data) {
          // Use XiaomiCrypto.encryptCCM for encryption with dynamic nonce
          return XiaomiCrypto.encryptCCM(
            _encryptionKeys!.encryptionKey,
            dynamicNonce,
            data,
          );
        };
      }

      final packetBytes = packet.encode(
        encryptFn: encryptFn,
        encryptionCounter: _encryptionCounter++,
      );

      debugPrint('📤 Sending SPP packet (${packetBytes.length} bytes)');
      debugPrint(
        '   Hex: ${packetBytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Write to device via transport abstraction
      await _transport!.sendData(packetBytes);

      debugPrint('✅ SPP packet sent successfully via transport');
    } catch (e) {
      debugPrint('❌ Failed to send SPP packet: $e');
      rethrow;
    }
  }

  /// Handle SPP notification from device
  ///
  /// Decodes SPP V1 packet and delegates to appropriate handler
  void _handleSppNotification(final List<int> data) {
    try {
      debugPrint('📨 Decoding SPP notification (${data.length} bytes)');

      final packet = XiaomiSppPacketV1.decode(Uint8List.fromList(data));
      if (packet == null) {
        debugPrint('❌ Failed to decode SPP packet');
        return;
      }

      debugPrint('📨 Received SPP packet: $packet');

      // Decrypt payload if needed AND keys available
      Uint8List Function(Uint8List)? decryptFn;
      if (packet.dataType == XiaomiSppV1Constants.dataTypeEncrypted &&
          _encryptionKeys != null) {
        decryptFn = (final data) {
          return XiaomiCrypto.decryptCCM(
            _encryptionKeys!.decryptionKey,
            _encryptionKeys!.decryptionNonce,
            data,
          );
        };
      }

      final decryptedPayload = packet.getDecryptedPayload(decryptFn: decryptFn);
      debugPrint('📨 Decrypted payload: ${decryptedPayload.length} bytes');

      // Delegate based on channel
      switch (packet.channel) {
        case XiaomiSppChannel.authentication:
        case XiaomiSppChannel.protobufCommand:
          _handleAuthProtobufPayload(decryptedPayload);
          break;
        case XiaomiSppChannel.version:
          _handleVersionResponse(decryptedPayload);
          break;
        default:
          debugPrint('⚠️ Unhandled SPP channel: ${packet.channel}');
      }
    } on Exception catch (e) {
      debugPrint('❌ Error handling SPP notification: $e');
    }
  }

  /// Handle version response (for future version detection)
  void _handleVersionResponse(final Uint8List payload) {
    debugPrint(
      '📨 Version response: ${payload.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    // ✅ V2 protocol now fully implemented via SppVersionDetector + SppV2ProtocolHandler
    // This handler is legacy code, kept for backward compatibility with old version detection logic
    if (payload.isNotEmpty && payload[0] >= 2) {
      debugPrint(
        '✅ Device reports SPP version >= 2 (handled by SppVersionDetector)',
      );
    }
  }

  /// Handle authentication protobuf payload
  void _handleAuthProtobufPayload(final Uint8List payload) {
    try {
      // Parse protobuf command
      final command = pb.Command.fromBuffer(payload);
      debugPrint(
        '📨 Received auth command: type=${command.type}, subtype=${command.subtype}',
      );

      // Delegate to existing handlers based on command type/subtype
      if (command.type == _commandTypeAuth) {
        if (command.subtype == _cmdNonce) {
          _handleWatchNonce(command);
        } else if (command.subtype == _cmdAuth) {
          _handleAuthResponse(command);
        }
      }
    } on Exception catch (e) {
      debugPrint('❌ Failed to parse protobuf payload: $e');
    }
  }

  /// Subscribe to device notifications via transport abstraction
  Future<void> _subscribeToNotifications() async {
    try {
      // Cancel previous subscription
      await _dataSubscription?.cancel();

      // Initialize transport (enables BLE notifications internally)
      await _transport!.initialize();

      debugPrint('✅ Transport initialized and notifications enabled');

      // For V2: SppV2ProtocolHandler already has its own listener
      // For V1: Subscribe to transport data stream
      if (_sppVersion == SppProtocolVersion.v1) {
        // Listen to transport data stream (filtered by UUIDs)
        _dataSubscription = _transport!.dataStream.listen((final data) {
          debugPrint('🔔 TRANSPORT DATA RECEIVED: size=${data.length} bytes');
          _handleIncomingData(data);
        });

        debugPrint('🔔 Listening to transport data stream (V1)');
      } else {
        debugPrint('🔔 Notifications enabled (V2 - handler manages listener)');
      }
    } on Exception catch (e) {
      debugPrint('❌ Failed to subscribe to notifications: $e');
      rethrow;
    }
  }

  /// Handle incoming SPP data from transport
  void _handleIncomingData(final Uint8List data) {
    debugPrint('🔔 RAW SPP DATA: size=${data.length} bytes');

    debugPrint('  ✅ Processing SPP notification...');

    try {
      // Use SPP protocol parser
      _handleSppNotification(data);
    } on Exception catch (e) {
      debugPrint('❌ Failed to handle incoming data: $e');
      _safeCompleteAuth(AuthResult.failure('Failed to parse SPP response: $e'));
    }
  }

  /// Send Step 1: PhoneNonce
  Future<void> _sendPhoneNonce() async {
    try {
      final command = pb.Command.create()
        ..type = _commandTypeAuth
        ..subtype = _cmdNonce
        ..auth = (pb.Auth.create()
          ..phoneNonce = (pb.PhoneNonce.create()..nonce = _phoneNonce!));

      // Use SPP protocol with AUTHENTICATION channel (no encryption yet)
      final payload = command.writeToBuffer();
      await _sendSppPacket(
        channel:
            XiaomiSppChannel.authentication, // Uses dataType=AUTH (plaintext)
        payload: payload,
        needsResponse: true,
      );

      _state = AuthState.waitingWatchNonce;
      debugPrint('📤 Sent phoneNonce via SPP protocol (AUTH channel)');
    } on Exception catch (e) {
      debugPrint('❌ Failed to send phoneNonce: $e');
      _safeCompleteAuth(AuthResult.failure('Failed to send nonce: $e'));
    }
  }

  /// Handle Step 2: WatchNonce response
  void _handleWatchNonce(final pb.Command command) {
    try {
      if (!command.hasAuth() || !command.auth.hasWatchNonce()) {
        throw Exception('Invalid watchNonce response');
      }

      final watchNonce = command.auth.watchNonce;
      _watchNonce = Uint8List.fromList(watchNonce.nonce);
      final watchHmac = Uint8List.fromList(watchNonce.hmac);

      debugPrint('⌚ Received watchNonce: ${_watchNonce!.length} bytes');

      // Derive encryption keys using HMAC-SHA256
      final keyMaterial = XiaomiCrypto.computeAuthStep3Hmac(
        _credentials!.authKeyBytes,
        _phoneNonce!,
        _watchNonce!,
      );

      final decryptionKey = keyMaterial.sublist(0, 16);
      final encryptionKey = keyMaterial.sublist(16, 32);
      final decryptionNonce = keyMaterial.sublist(32, 36);
      final encryptionNonce = keyMaterial.sublist(36, 40);

      _encryptionKeys = EncryptionKeys(
        encryptionKey: encryptionKey,
        decryptionKey: decryptionKey,
        encryptionNonce: encryptionNonce,
        decryptionNonce: decryptionNonce,
        authKey:
            _credentials!.authKeyBytes, // ← Save for future NONCE handshakes
      );

      debugPrint('🔐 Derived encryption keys: $_encryptionKeys');

      // Verify watchNonce HMAC
      final expectedHmac = XiaomiCrypto.hmacSHA256(
        decryptionKey,
        Uint8List.fromList([..._watchNonce!, ..._phoneNonce!]),
      );

      if (!_bytesEqual(expectedHmac, watchHmac)) {
        debugPrint('❌ Watch HMAC verification failed!');
        _safeCompleteAuth(AuthResult.failure('Watch HMAC mismatch'));
        return;
      }

      debugPrint('✅ Watch HMAC verified');

      // Send Step 3: Encrypted device info
      _sendAuthStep3();
    } on Exception catch (e) {
      debugPrint('❌ Failed to handle watchNonce: $e');
      _safeCompleteAuth(AuthResult.failure('WatchNonce error: $e'));
    }
  }

  /// Send Step 3: Encrypted device info
  Future<void> _sendAuthStep3() async {
    try {
      _state = AuthState.sendingAuthStep3;

      // Build AuthDeviceInfo (basado en Gadgetbridge XiaomiAuthService.java)
      final deviceInfo = pb.AuthDeviceInfo.create()
        ..unknown1 = 0
        ..phoneApiLevel =
            await _getPhoneApiLevel() // ✅ API level real del sistema
        ..phoneName = await _getPhoneName() // ✅ Modelo de dispositivo real
        ..unknown3 = 224
        ..region = _getDeviceRegion(); // ✅ Región real del sistema

      // Encrypt device info using encryptionKey
      final encryptedDeviceInfo = XiaomiCrypto.encryptCCM(
        _encryptionKeys!.encryptionKey,
        _buildNonceForEncryption(0), // Packet counter = 0
        deviceInfo.writeToBuffer(),
      );

      // Compute encrypted nonces HMAC
      final encryptedNonces = XiaomiCrypto.hmacSHA256(
        _encryptionKeys!.encryptionKey,
        Uint8List.fromList([..._phoneNonce!, ..._watchNonce!]),
      );

      // Build AuthStep3
      final authStep3 = pb.AuthStep3.create()
        ..encryptedNonces = encryptedNonces
        ..encryptedDeviceInfo = encryptedDeviceInfo;

      // Build Command
      final command = pb.Command.create()
        ..type = _commandTypeAuth
        ..subtype = _cmdAuth
        ..auth = (pb.Auth.create()..authStep3 = authStep3);

      // Use SPP protocol instead of chunked
      final payload = command.writeToBuffer();
      await _sendSppPacket(
        channel: XiaomiSppChannel.protobufCommand,
        payload: payload,
        needsResponse: true,
      );

      debugPrint('📤 Sent AuthStep3 via SPP protocol');
    } on Exception catch (e) {
      debugPrint('❌ Failed to send AuthStep3: $e');
      _safeCompleteAuth(AuthResult.failure('AuthStep3 error: $e'));
    }
  }

  /// Handle auth response (Step 4)
  void _handleAuthResponse(final pb.Command command) {
    try {
      final isSuccess = command.subtype == _cmdAuth ||
          (command.hasAuth() && command.auth.status == 1);

      if (isSuccess) {
        debugPrint('✅ Authentication successful!');

        // ✅ Sync current time with device (like Gadgetbridge) - with delay
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            await syncCurrentTime();
            debugPrint('✅ SPP V1: Time synchronization completed');
          } on Exception catch (e) {
            debugPrint('⚠️ SPP V1: Time sync failed: $e');
            // Non-fatal - continue with auth success
          }
        });

        // ✅ CRITICAL: Safely complete auth to avoid "Bad state: Future already completed"
        _safeCompleteAuth(AuthResult.succeed(_encryptionKeys!));
      } else {
        debugPrint('❌ Authentication failed: status=${command.status}');
        _safeCompleteAuth(AuthResult.failure('Device rejected authentication'));
      }
    } on Exception catch (e) {
      debugPrint('❌ Failed to handle auth response: $e');
      _safeCompleteAuth(AuthResult.failure('Auth response error: $e'));
    }
  }

  /// Send command to device via BLE write characteristic
  ///
  /// **Xiaomi BLE Protocol (basado en Gadgetbridge XiaomiCharacteristic.java):**
  ///
  /// SINGLE PACKET (protobuf <= 16 bytes):
  ///   - Enviar: [chunk_id (2)] + [type (1)] + [encrypted (1)] + [protobuf]
  ///   - Total: 4 bytes header + protobuf
  ///
  /// CHUNKED PROTOCOL (protobuf > 16 bytes):
  ///   1. Enviar chunked start request: [0x00, 0x00, 0x00, 0x00, numChunks (2)]
  ///   2. Chunkear PROTOBUF PURO (sin wrapper)
  /// Build 12-byte nonce for AES-CCM encryption
  ///
  /// Format: encryptionNonce (4 bytes) + zeros (4 bytes) + packetCounter (4 bytes)
  Uint8List _buildNonceForEncryption(final int packetCounter) {
    final nonce = Uint8List(12);
    nonce.setRange(0, 4, _encryptionKeys!.encryptionNonce);
    // Bytes 4-7: zeros
    // Bytes 8-11: packet counter (little endian)
    final counterBytes = ByteData(4)
      ..setUint32(0, packetCounter, Endian.little);
    nonce.setRange(8, 12, counterBytes.buffer.asUint8List());
    return nonce;
  }

  /// Compare two byte arrays
  bool _bytesEqual(final Uint8List a, final Uint8List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Obtener API level real del sistema Android
  ///
  /// Basado en Gadgetbridge: Build.VERSION.SDK_INT
  /// - Android 10 (API 29), Android 11 (API 30), Android 12 (API 31), etc.
  /// - iOS: Usa versión aproximada (iOS 15 ≈ API 31)
  Future<double> _getPhoneApiLevel() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final apiLevel = androidInfo.version.sdkInt.toDouble();
        debugPrint(
          '📱 Android API level: $apiLevel (${androidInfo.version.release})',
        );
        return apiLevel;
      } else if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        // Convertir iOS version a API level aproximado
        final iosVersion = iosInfo.systemVersion;
        final majorVersion = int.tryParse(iosVersion.split('.').first) ?? 15;
        final approximateApiLevel =
            (majorVersion + 16).toDouble(); // iOS 15 ≈ API 31
        debugPrint(
          '📱 iOS version: $iosVersion → API level: $approximateApiLevel',
        );
        return approximateApiLevel;
      } else {
        debugPrint('⚠️ Unknown platform, using fallback API level 31');
        return 31.0;
      }
    } on Exception catch (e) {
      debugPrint('⚠️ Error getting API level: $e, using fallback 31');
      return 31.0;
    }
  }

  /// Obtener modelo real del dispositivo
  ///
  /// Basado en Gadgetbridge: Build.MODEL
  /// - Android: "Pixel 7", "SM-G998B", "OnePlus 9 Pro", etc.
  /// - iOS: "iPhone14,2", "iPad13,1", etc.
  Future<String> _getPhoneName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final phoneName = androidInfo.model;
        debugPrint('📱 Android model: $phoneName');
        return phoneName;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        final phoneName = iosInfo.model;
        debugPrint('📱 iOS model: $phoneName');
        return phoneName;
      } else {
        debugPrint('⚠️ Unknown platform, using fallback name "Unknown"');
        return 'Unknown';
      }
    } on Exception catch (e) {
      debugPrint('⚠️ Error getting phone name: $e, using fallback');
      return Platform.isAndroid ? 'Android' : 'iOS';
    }
  }

  /// Obtener región del dispositivo basado en Locale del sistema
  ///
  /// Basado en Gadgetbridge XiaomiAuthService.java:
  /// ```java
  /// .setRegion(Locale.getDefault().getLanguage().substring(0, 2).toUpperCase(Locale.ROOT))
  /// ```
  ///
  /// **Ejemplos:**
  /// - 'en_US' → 'EN'
  /// - 'es_ES' → 'ES'
  /// - 'zh_CN' → 'ZH'
  String _getDeviceRegion() {
    try {
      // Obtener idioma del sistema (ej: 'en', 'es', 'zh')
      final systemLocale = Platform.localeName; // ej: 'en_US', 'es_ES'
      final languageCode = systemLocale.split('_').first; // ej: 'en', 'es'

      // Convertir a mayúsculas como hace Gadgetbridge
      final region = languageCode.toUpperCase();

      debugPrint('📍 System locale: $systemLocale → Region: $region');
      return region;
    } on Exception catch (e) {
      debugPrint('⚠️ Error getting system locale: $e, using fallback "EN"');
      return 'EN'; // Fallback a inglés si hay error
    }
  }

  /// Public API: Start encrypted handshake (NONCE exchange)
  ///
  /// **Gadgetbridge Pattern**: Called EVERY TIME after SESSION_CONFIG response,
  /// even with saved keys. This negotiates session-specific encryption nonces.
  ///
  /// **Flow**:
  /// 1. Generate new phone nonce
  /// 2. Send NONCE command (type=1, subtype=26)
  /// 3. Wait for WATCH_NONCE response
  /// 4. Send AUTH step 3 (type=1, subtype=27)
  /// 5. Wait for AUTH success
  /// 6. THEN commands are ready
  ///
  /// **Usage**: Call after SESSION_CONFIG response from device
  Future<void> startEncryptedHandshake() async {
    debugPrint('');
    debugPrint('🔐 ════════════════════════════════════════════════');
    debugPrint('🔐 STARTING ENCRYPTED HANDSHAKE (Gadgetbridge pattern)');
    debugPrint('🔐 ════════════════════════════════════════════════');
    debugPrint('');

    // Generate new phone nonce (16 bytes)
    _phoneNonce = Uint8List(16);
    final random = Random.secure();
    for (var i = 0; i < 16; i++) {
      _phoneNonce![i] = random.nextInt(256);
    }

    debugPrint('   🔑 Generated new phone nonce for this session');
    debugPrint(
      '   📦 Nonce: ${_phoneNonce!.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    // Send phone nonce (step 1)
    await _sendPhoneNonceV2();

    debugPrint('   ⏳ Waiting for WATCH_NONCE and AUTH success...');
    debugPrint('');
  }

  /// Load saved credentials and encryption keys from secure storage
  ///
  /// **Usage:** Call this when connecting via BT_CLASSIC with saved keys
  /// to ensure credentials are available for NONCE handshake.
  ///
  /// **Purpose:** BT_CLASSIC reconnections skip BLE auth but still need
  /// the authKey from credentials for session nonce calculation.
  Future<void> loadSavedCredentials() async {
    debugPrint('🔑 Loading saved credentials for BT_CLASSIC reconnection...');

    // Load credentials (contains authKey from original ECDH)
    _credentials = await XiaomiDeviceCredentials.load(deviceId);
    if (_credentials != null) {
      debugPrint('   ✅ Credentials loaded (authKey available)');
    } else {
      debugPrint('   ⚠️ No saved credentials found');
    }

    // Load encryption keys (contains session keys + authKey backup)
    _encryptionKeys = await EncryptionKeys.load(deviceId);
    if (_encryptionKeys != null) {
      debugPrint('   ✅ Encryption keys loaded');
      if (_encryptionKeys!.authKey != null) {
        debugPrint('   ✅ authKey also in encryption keys (fallback available)');
      }
    } else {
      debugPrint('   ⚠️ No saved encryption keys found');
    }

    // Load SPP protocol configuration
    await _loadSppConfig();
  }

  /// Public API: Send post-authentication initialization commands
  ///
  /// **Usage:** Call this after BT_CLASSIC connection is ready for bonded devices
  /// that skip BLE authentication.
  ///
  /// For non-bonded devices, this is called automatically after successful auth.
  /// 🧪 TEST: Send battery command only (after SESSION_CONFIG)
  Future<void> sendBatteryCommand() async {
    const int systemCommandType = 2;
    const int cmdBattery = 1;

    debugPrint('🔋 Sending battery command (type=2, subtype=1)...');
    await _sendCommand(systemCommandType, cmdBattery, 'get battery state');
  }

  Future<void> sendPostAuthInitialization() async {
    await _sendPostAuthInitialization();
  }

  /// Send basic commands after authentication to prevent device disconnection
  ///
  /// Based on Gadgetbridge behavior - sends essential commands immediately
  /// after auth success to keep the device engaged and prevent timeout disconnect.
  Future<void> _sendPostAuthInitialization() async {
    try {
      debugPrint(
        '🔧 SPP V2: Starting comprehensive post-auth initialization...',
      );

      // ✨ NEW: Use dedicated initialization service instead of inline code
      // This keeps auth_service ONLY for authentication, not initialization
      final initService = XiaomiInitializationService(
        deviceId: deviceId,
        sppService: sppService,
        sppV2Handler: _sppV2Handler,
      );

      // Run full post-auth initialization (system service + health service + realtime stats)
      await initService.initializePostAuth();

      debugPrint('✅ SPP V2: Comprehensive post-auth initialization completed');
    } on Exception catch (e) {
      debugPrint('❌ SPP V2: Post-auth initialization failed: $e');
      rethrow;
    }
  }

  /// Generic command sender for protobuf commands (post-authentication)
  /// All post-auth commands MUST be encrypted via SPP V2 handler
  Future<void> _sendCommand(
    final int commandType,
    final int subType,
    final String description,
  ) async {
    debugPrint(
      '📤 Sending encrypted command: $description (type: $commandType, subtype: $subType)',
    );

    // ✅ CRITICAL: Send MINIMAL command like Gadgetbridge
    // Device ONLY accepts simple {type, subtype} for GET requests
    // Adding empty nested messages (system, health) causes device to ACK but NOT respond
    final command = pb.Command()
      ..type = commandType
      ..subtype = subType;

    // ❌ DO NOT add empty system/health fields for GET requests
    // Gadgetbridge logs show: "08021001" (4 bytes) for battery request
    // NOT "08021001220212 00" (8 bytes) with empty system.power

    // Device responds WITH the field populated:
    // Response: "08021001220C120A0A08084610021A020801"
    // = {type:2, subtype:1, system:{power:{battery:{level:70, state:2}}}}

    // Post-auth commands MUST use SPP V2 handler with encryption
    if (_sppVersion == SppProtocolVersion.v2 && _sppV2Handler != null) {
      // Path 1: BLE auth flow - use handler
      debugPrint('📤 Routing to SPP V2 handler (encrypted channel)');
      final payload = command.writeToBuffer();
      await _sppV2Handler!.sendData(
        deviceId,
        channel: SppV2Channel.protobufCommand,
        payload: payload,
        encrypted: true, // 🔐 CRITICAL: Post-auth commands must be encrypted
      );
      debugPrint('✅ Encrypted command sent successfully');
    } else if (sppService != null) {
      // Path 2: Bonded device flow - use SppService directly
      debugPrint('📤 Routing to SPP service (bonded device path)');
      await sppService!.sendProtobufCommand(
        command: command, // Send protobuf Command directly
      );
      debugPrint('✅ Command sent via SPP service');
    } else {
      debugPrint('❌ Cannot send encrypted command: No transport available');
      debugPrint('   SPP Version: $_sppVersion');
      debugPrint('   Handler available: ${_sppV2Handler != null}');
      debugPrint('   SppService available: ${sppService != null}');
      throw Exception(
        'SPP V2 handler or SppService required for post-auth encrypted commands',
      );
    }
  }

  /// Sincronizar hora del sistema con el dispositivo
  ///
  /// Basado en Gadgetbridge XiaomiSystemService.setCurrentTime()
  ///
  /// **Protocolo:**
  /// - Command type: 2 (System)
  /// - Subtype: 3 (Clock)
  /// - Payload: Clock protobuf con Time, Date, TimeZone
  ///
  /// **Envía:**
  /// - Fecha y hora actual del sistema
  /// - Zona horaria y offset DST
  /// - Formato 12/24 horas (por defecto 24h)
  Future<void> syncCurrentTime() async {
    try {
      debugPrint('🕐 Synchronizing current time with device...');

      // Get current date and time (local + UTC)
      final now = DateTime.now();
      final utcNow = now.toUtc(); // ✨ Convert to UTC
      final timeZone = now.timeZoneOffset;

      // ✨ NEW: Calculate DST offset
      final dstOffsetMinutes = _calculateDstOffsetMinutes(now);

      debugPrint('🕐 RAW SYSTEM TIME:');
      debugPrint('   Local time: $now');
      debugPrint('   UTC time: $utcNow');
      debugPrint('   TimeZone offset: $timeZone (${timeZone.inMinutes} min)');
      debugPrint('   DST offset: $dstOffsetMinutes min');

      // Detect if system uses 24-hour format (default on mobile)
      final is24HourFormat = true; // TODO: Get from user configuration

      // ✨ CRITICAL: Use UTC time, not local (Gadgetbridge compatibility)
      final timeToSend = utcNow;

      // Create protobuf Clock
      final clock = pb.Clock.create()
        ..time = (pb.Time.create()
          ..hour = timeToSend.hour // ✨ UTC, not local
          ..minute = timeToSend.minute
          ..second = timeToSend.second
          ..millisecond = timeToSend.millisecond)
        ..date = (pb.Date.create()
          ..year = timeToSend.year // ✨ UTC, not local
          ..month = timeToSend.month
          ..day = timeToSend.day)
        ..timezone = (pb.TimeZone.create()
          ..zoneOffset =
              (timeZone.inMinutes / 15).floor() // Use floor like Gadgetbridge
          ..dstOffset =
              (dstOffsetMinutes / 15).floor() // ✨ NEW: Calculate DST offset
          ..name = timeZone.toString()) // E.g: "+02:00"
        ..isNot24hour = !is24HourFormat;

      final command = pb.Command.create()
        ..type = 2 // COMMAND_TYPE (System)
        ..subtype = 3 // CMD_CLOCK
        ..system = (pb.System.create()..clock = clock);

      final payload = Uint8List.fromList(command.writeToBuffer());

      debugPrint('🕐 SENDING TO DEVICE:');
      debugPrint(
        '   📅 Date: ${timeToSend.year}-${timeToSend.month.toString().padLeft(2, '0')}-${timeToSend.day.toString().padLeft(2, '0')}',
      );
      debugPrint(
        '   🕐 Time (UTC): ${timeToSend.hour.toString().padLeft(2, '0')}:${timeToSend.minute.toString().padLeft(2, '0')}:${timeToSend.second.toString().padLeft(2, '0')}.${timeToSend.millisecond}',
      );
      debugPrint(
        '   🌍 Timezone: ${timeZone.toString()} (offset: ${(timeZone.inMinutes / 15).floor()} units of 15min)',
      );
      final dstHours = dstOffsetMinutes ~/ 60;
      debugPrint(
        '   🌞 DST Offset: ${(dstOffsetMinutes / 15).floor()} units ($dstHours hours)',
      );
      debugPrint('   ⏰ 24h format: $is24HourFormat');
      debugPrint('   📦 Clock protobuf values:');
      debugPrint(
        '      hour: ${clock.time.hour}, minute: ${clock.time.minute}, second: ${clock.time.second}',
      );
      debugPrint(
        '      year: ${clock.date.year}, month: ${clock.date.month}, day: ${clock.date.day}',
      );
      debugPrint(
        '      zoneOffset: ${clock.timezone.zoneOffset}, dstOffset: ${clock.timezone.dstOffset}',
      );
      debugPrint('      isNot24hour: ${clock.isNot24hour}');

      debugPrint('   🎯 Command details:');
      debugPrint('      type: ${command.type} (should be 2 for System)');
      debugPrint('      subtype: ${command.subtype} (should be 3 for Clock)');
      debugPrint('      payload size: ${payload.length} bytes');
      debugPrint('      SPP version: $_sppVersion');

      // Send command according to SPP protocol
      if (_sppVersion == SppProtocolVersion.v2) {
        // SPP V2: Use SppV2ProtocolHandler
        await _sppV2Handler!.sendData(
          deviceId,
          channel: SppV2Channel.protobufCommand, // Channel for system commands
          payload: payload,
        );
        debugPrint('✅ Time sync sent via SPP V2');
      } else {
        // SPP V1: Use traditional V1 protocol
        await _sendSppPacket(
          channel: XiaomiSppChannel.protobufCommand,
          payload: payload,
        );
        debugPrint('✅ Time sync sent via SPP V1');
      }

      debugPrint(
        '🕐 Current time synchronization completed (UTC: ${utcNow.hour}:${utcNow.minute}, Zone: UTC+${timeZone.inMinutes ~/ 60}, DST: ${dstOffsetMinutes ~/ 60}h)',
      );
    } on Exception catch (e) {
      debugPrint('❌ Failed to sync time: $e');
      // No-fatal: time sync failure shouldn't break authentication
    }
  }

  /// Complete BT_CLASSIC transition and validate connection
  ///
  /// This method is called AFTER successful BLE authentication.
  /// It performs:
  /// Safely complete auth completer (prevents "Bad state: Future already completed" errors)
  Future<void> _safeCompleteAuth(final AuthResult result) async {
    if (_authCompleter != null && !_authCompleter!.isCompleted) {
      // ✅ CRITICAL: Save encryption keys on successful authentication
      if (result.success && result.encryptionKeys != null) {
        try {
          await result.encryptionKeys!.save(deviceId);
          debugPrint('💾 Encryption keys saved for future connections');
        } on Exception catch (e) {
          debugPrint('⚠️ Failed to save encryption keys: $e');
          // Continue anyway - not critical for current session
        }
      }

      _authCompleter!.complete(result);
    } else {
      debugPrint(
        '⚠️ Auth completer already completed or null, ignoring: ${result.success ? "SUCCESS" : result.errorMessage}',
      );
    }
  }

  /// Cleanup resources
  /// Calculate DST (Daylight Saving Time) offset in minutes
  ///
  /// In Spain:
  /// - Winter (Oct-Mar): UTC+1 (no DST)
  /// - Summer (Mar-Oct): UTC+2 (DST = +1 hour)
  ///
  /// Returns: DST offset in minutes (0 or 60)
  int _calculateDstOffsetMinutes(DateTime time) {
    // Compare difference between local time and UTC
    // If 2 hours = Summer time (DST active)
    final localToUtcDiff = time.difference(time.toUtc()).inHours;

    if (localToUtcDiff == 2) {
      // Summer time (UTC+2) = DST active
      return 60; // DST offset = 1 hour
    }

    // Winter time (UTC+1) = no DST
    return 0;
  }

  // 🔌 Getters for post-auth services (used by InitializationService)
  SppV2ProtocolHandler? getSppV2Handler() => _sppV2Handler;
  XiaomiSppService? getSppService() => sppService;

  void dispose() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    _authCompleter = null;
    _state = AuthState.idle;
  }
}
