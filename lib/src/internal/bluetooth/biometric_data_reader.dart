// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// 🎯 Biometric Data Reader - Universal Data Access Layer
///
/// Abstracción unificada para leer datos biométricos desde CUALQUIER dispositivo,
/// independientemente del transport (BLE, BT_CLASSIC, REST API, HealthKit, etc).
///
/// **Arquitectura**:
/// - Auto-detecta device implementation desde JSON
/// - Routing automático según transport disponible
/// - Parsea con ParserRegistry
/// - Retorna siempre BiometricSample (formato unificado)
///
/// **Ejemplo de uso**:
/// ```dart
/// // ✅ LIMPIO: Singleton con auto-discovery
/// final reader = BiometricDataReader();
///
/// // ✅ Funciona con CUALQUIER dispositivo (auto-detect transport)
/// final battery = await reader.readBattery('device_id');
/// // → Xiaomi Band 10: SPP protobuf (auto-descubre el service)
/// // → Xiaomi Band 8: BLE characteristic 0x2A19
/// // → Polar H10: BLE characteristic 0x2A19
/// // → Apple Watch: HealthKit bridge (futuro)
///
/// // ✅ Subscribe para streaming data
/// await reader.enableRealtimeStats('device_id', true);
/// reader.subscribeToRealtimeStats('device_id').listen((sample) {
///   print('📊 ${sample.dataType}: ${sample.value}');
/// });
/// ```
///
/// **Extensibilidad**:
/// Para agregar nuevo dispositivo/transport:
/// 1. Crear device implementation JSON (e.g., polar_h10.json)
/// 2. Agregar parser a ParserRegistry (e.g., 'polar_heart_rate')
/// 3. ¡Listo! BiometricDataReader lo detecta automáticamente
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wearable_sensors/src/api/enums/sensor_type.dart';
import 'package:wearable_sensors/src/internal/bluetooth/device_connection_manager.dart';
import 'package:wearable_sensors/src/internal/models/biometric_sample.dart';
import 'package:wearable_sensors/src/internal/services/battery_polling_service.dart';
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';
import 'package:wearable_sensors/src/internal/parsers/parser_registry.dart';
import 'package:wearable_sensors/src/internal/bluetooth/ble_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_protobuf_commands.dart';
import 'package:wearable_sensors/src/internal/models/generated/xiaomi.pb.dart'
    as pb;

// TODO: Update these imports when remaining services are migrated
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_spp_service.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_connection_orchestrator.dart';

/// Biometric Data Reader - Universal data access layer (Singleton)
///
/// **Features**:
/// - ✅ Singleton con auto-discovery de services
/// - ✅ Transport-agnostic (BLE, SPP, API, HealthKit)
/// - ✅ Auto-detection via device implementation JSON
/// - ✅ Unified BiometricSample output
/// - ✅ ParserRegistry integration
/// - ✅ Extensible para nuevos devices/transports
class BiometricDataReader {
  factory BiometricDataReader() => _instance;
  // ✅ SINGLETON PATTERN
  BiometricDataReader._internal();
  static final BiometricDataReader _instance = BiometricDataReader._internal();

  // Services (lazy initialization)
  BleService? _bleService;
  final DeviceConnectionManager _connectionManager = DeviceConnectionManager();

  // ✅ FASE 1: Battery Polling Service (inicializado lazy)
  BatteryPollingService? _batteryPollingService;

  // Cache de device implementations para evitar recargas
  final Map<String, DeviceImplementation> _deviceImplCache = {};

  /// Obtiene o inicializa BatteryPollingService
  /// Usa getter lazy para inicializar solo cuando se necesita
  BatteryPollingService get batteryPollingService {
    _batteryPollingService ??= BatteryPollingService(
      pollFunction: () => _performBatteryPoll(),
    );
    return _batteryPollingService!;
  }

  /// Realiza un poll individual de batería
  /// Retorna el nivel de batería (0-100) o null si falla
  Future<int?> _performBatteryPoll() async {
    try {
      // ✅ FASE 1: Get currently connected device from DeviceConnectionManager
      // The active orchestrator will have the correct SPP service ready
      final activeDevice =
          _connectionManager.activeConnections.keys.firstOrNull;

      if (activeDevice == null) {
        debugPrint('⚠️  No device currently connected');
        return null;
      }

      debugPrint('🔋 BatteryPollingService performing poll for $activeDevice');

      // ✅ FASE 1: Read battery via universal read() method
      // This will auto-route to SPP or BLE depending on device type
      final batterySample = await read(activeDevice, SensorType.battery);

      if (batterySample != null) {
        // ✅ Convert double to int (battery values come as double from all parsers)
        final batteryLevel = (batterySample.value).toInt();

        if (batteryLevel >= 0 && batteryLevel <= 100) {
          debugPrint('   ✅ Battery poll successful: $batteryLevel%');
          return batteryLevel;
        } else {
          debugPrint(
            '   ⚠️  Battery poll returned invalid value: $batteryLevel',
          );
          return null;
        }
      } else {
        debugPrint('   ⚠️  Battery poll returned null sample');
        return null;
      }
    } on Exception catch (e) {
      debugPrint('❌ Battery poll failed: $e');
      return null;
    }
  }

  /// **Lazy Initialization**: Obtiene BleService (crea si no existe)
  BleService _getBleService() {
    _bleService ??= BleService();
    return _bleService!;
  }

  /// 🎯 READ - Lectura one-shot de un data type específico
  ///
  /// **API Universal**: Funciona con CUALQUIER dispositivo/transport
  ///
  /// **Parámetros**:
  /// - [deviceId]: MAC address del dispositivo
  /// - [sensorType]: Tipo de dato a leer (SensorType enum)
  ///
  /// **Returns**: BiometricSample con el valor leído, o null si falla
  ///
  /// **Routing automático**:
  /// 1. Load device implementation JSON
  /// 2. Check if sensorType has BLE characteristic → read via BLE
  /// 3. Else check if device supports SPP → read via SPP protobuf
  /// 4. Else check if device has API/HealthKit → read via API (futuro)
  /// 5. Parse con ParserRegistry
  ///
  /// **Ejemplo**:
  /// ```dart
  /// // Xiaomi Band 10 (SPP): battery via protobuf command
  /// final battery = await reader.read('AA:BB:CC:DD:EE:FF', SensorType.battery);
  ///
  /// // Polar H10 (BLE): heart_rate via characteristic 0x2A37
  /// final hr = await reader.read('11:22:33:44:55:66', SensorType.heartRate);
  /// ```
  Future<BiometricSample?> read(
    final String deviceId,
    final SensorType sensorType,
  ) async {
    try {
      final dataType = sensorType.internalDataType;
      debugPrint('🎯 BiometricDataReader.read($deviceId, $dataType)');

      // 1. Load device implementation (con cache)
      final deviceImpl = await _getDeviceImplementation(deviceId);

      // 2. ✅ PRIORITIZE SPP for encrypted devices (Xiaomi Band 9/10)
      // SPP devices are always connected via BT_CLASSIC when ready for data reads.
      // BLE characteristics may be disabled for security or availability reasons.
      if (deviceImpl.authentication.protocol.startsWith('xiaomi_spp')) {
        // ✅ SPP path (Xiaomi Mi Band 9/10)
        // Supports: 'xiaomi_spp', 'xiaomi_spp_v1', 'xiaomi_spp_v2', etc.
        debugPrint(
          '   → Transport: BT_CLASSIC SPP (${deviceImpl.authentication.protocol}) [PRIORITIZED]',
        );
        return await _readViaSpp(deviceId, dataType, deviceImpl);
      }

      // 3. Fallback: Check for BLE characteristic
      final charInfo = deviceImpl.getCharacteristicForDataType(dataType);
      if (charInfo != null) {
        // ✅ BLE path (for non-SPP devices)
        debugPrint(
          '   → Transport: BLE (characteristic ${charInfo.characteristicUuid})',
        );
        return await _readViaBle(deviceId, charInfo);
      } else {
        // ❌ Unsupported
        throw UnsupportedError(
          'Data type "$dataType" not available on $deviceId '
          '(no BLE characteristic, no SPP support)',
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ BiometricDataReader.read failed: $e');
      return null;
    }
  }

  /// 🔄 SUBSCRIBE - Streaming de un data type específico
  ///
  /// **API Universal**: Funciona con CUALQUIER dispositivo/transport
  ///
  /// **Parámetros**:
  /// - [deviceId]: MAC address del dispositivo
  /// - [sensorType]: Tipo de dato a leer (SensorType enum)
  ///
  /// **Returns**: Stream de BiometricSample con valores continuos
  ///
  /// **Routing automático**:
  /// 1. Load device implementation JSON
  /// 2. ✅ PRIORITIZE SPP for Xiaomi devices (NEVER fallback to BLE)
  /// 3. Check if sensorType has BLE characteristic → subscribe via BLE (non-SPP only)
  /// 4. Parse cada notificación con ParserRegistry
  ///
  /// **Ejemplo**:
  /// ```dart
  /// // Polar H10: heart_rate streaming via BLE
  /// reader.subscribe('11:22:33:44:55:66', SensorType.heartRate).listen((sample) {
  ///   print('HR: ${sample.value} BPM');
  /// });
  ///
  /// // Xiaomi Band 8: activity_data streaming via SPP ONLY
  /// reader.subscribe('AA:BB:CC:DD:EE:FF', SensorType.movement).listen((sample) {
  ///   print('Movement: ${sample.value}');
  /// });
  /// ```
  Stream<BiometricSample> subscribe(
    final String deviceId,
    final SensorType sensorType,
  ) async* {
    try {
      final dataType = sensorType.internalDataType;
      debugPrint('🔄 BiometricDataReader.subscribe($deviceId, $dataType)');

      // 1. Load device implementation
      final deviceImpl = await _getDeviceImplementation(deviceId);

      // 2. ✅ PRIORITIZE SPP for encrypted devices (Xiaomi Band 9/10)
      // SPP devices are always connected via BT_CLASSIC when ready for streaming.
      // ❌ NEVER attempt BLE for SPP devices - causes connection conflicts
      if (deviceImpl.authentication.protocol.startsWith('xiaomi_spp')) {
        // ✅ SPP path (Xiaomi Mi Band 9/10)
        debugPrint(
          '   → Transport: BT_CLASSIC SPP (${deviceImpl.authentication.protocol}) [PRIORITIZED]',
        );
        // Subscribe to realtime stats and filter by sensor type
        yield* subscribeToRealtimeStats(deviceId).where((sample) {
          // Filter only samples matching this sensorType
          return sample.sensorType == sensorType;
        });
        return; // ✅ CRITICAL: Return immediately - NO BLE fallback for SPP devices
      }

      // 3. Fallback: Check for BLE characteristic (non-SPP devices only)
      final charInfo = deviceImpl.getCharacteristicForDataType(dataType);

      if (charInfo != null) {
        // ✅ BLE streaming path (for non-SPP devices)
        debugPrint(
          '   → Transport: BLE streaming (characteristic ${charInfo.characteristicUuid})',
        );
        yield* _subscribeViaBle(deviceId, charInfo);
      } else {
        // ❌ Unsupported
        throw UnsupportedError(
          'Streaming for "$dataType" not supported on $deviceId',
        );
      }
    } on Exception catch (e) {
      debugPrint('❌ BiometricDataReader.subscribe failed: $e');
    }
  }

  // ============================================================================
  // REALTIME STATS (Xiaomi Band 9/10) - Multi-sensor streaming
  // ============================================================================

  /// 🔄 Enable/Disable Realtime Stats Streaming
  ///
  /// **Auto-Discovery Helper**: Obtiene el XiaomiSppService del orchestrator
  ///
  /// **Returns**: XiaomiSppService si el dispositivo está conectado, null si no
  ///
  /// **Ventajas**:
  /// - ✅ UI no necesita saber sobre XiaomiConnectionOrchestrator
  /// - ✅ Auto-descubre el service correcto
  /// - ✅ Funciona para cualquier dispositivo Xiaomi conectado
  XiaomiSppService? _getSppServiceForDevice(final String deviceId) {
    debugPrint('🔍 _getSppServiceForDevice called for $deviceId');
    debugPrint(
      '   Active connections: ${_connectionManager.activeConnections.keys.toList()}',
    );

    final orchestrator = _connectionManager.activeConnections[deviceId];
    debugPrint('   Orchestrator type: ${orchestrator?.runtimeType}');

    if (orchestrator is XiaomiConnectionOrchestrator) {
      debugPrint('   ✅ Found XiaomiConnectionOrchestrator');
      final spp = orchestrator.sppService;
      debugPrint('   SPP service: ${spp != null ? "available" : "null"}');
      debugPrint('   SPP isReady: ${spp?.isReady}');
      return spp;
    }

    debugPrint('   ❌ Orchestrator is not XiaomiConnectionOrchestrator');
    return null;
  }

  /// **Xiaomi Band 9/10 Only**: Controla el streaming de múltiples sensores
  /// (HR, movement, steps, calories) vía SPP protobuf.
  ///
  /// **✅ AUTO-DISCOVERY**: No requiere pasar XiaomiSppService, lo descubre automáticamente
  ///
  /// **⚠️ CRITICAL**: First call automatically configures HR monitoring if starting.
  ///
  /// **Parámetros**:
  /// - [deviceId]: MAC address del dispositivo Xiaomi
  /// - [enable]: true para iniciar streaming, false para detener
  ///
  /// **Protocol**:
  /// - Config HR: Command { type: 8, subtype: 11 } (REQUIRED BEFORE START)
  /// - Start:     Command { type: 8, subtype: 45 }
  /// - Stop:      Command { type: 8, subtype: 46 }
  /// - Events:    Command { type: 8, subtype: 47 } (~1/second)
  ///
  /// **Battery Impact**: ~5-10% por hora cuando activo
  ///
  /// **Ejemplo (LIMPIO)**:
  /// ```dart
  /// final reader = BiometricDataReader(); // ✅ Singleton
  ///
  /// // ✅ AUTO-configura HR monitoring (solo primera vez)
  /// await reader.enableRealtimeStats(deviceId, true);
  ///
  /// // ... monitor sleep for 8 hours ...
  ///
  /// await reader.enableRealtimeStats(deviceId, false);
  /// ```
  ///
  /// **Nota**: Usar [subscribeToRealtimeStats] para recibir los datos.
  Future<void> enableRealtimeStats(
    final String deviceId,
    final bool enable,
  ) async {
    // ✅ AUTO-DISCOVERY: Obtener SPP service del orchestrator
    final sppService = _getSppServiceForDevice(deviceId);

    if (sppService == null) {
      throw StateError(
        'Device $deviceId not connected via BT_CLASSIC. '
        'Cannot enable realtime stats.',
      );
    }

    if (!sppService.isReady) {
      throw StateError('SPP service not ready for device $deviceId');
    }

    try {
      if (enable) {
        // 🎯 **CRITICAL FIX (User Discovery)**:
        // Device requires CONFIG_HEART_RATE_SET (subtype=11) BEFORE START_REALTIME_STATS (subtype=45)
        //
        // **Evidence from logs**:
        // - Post-auth init WORKS: sends CONFIG (11) → then START (45) → device streams
        // - Manual activation FAILS: only sends START (45) → device ignores it
        //
        // **Payload**: This is the EXACT CONFIG sent during post-auth initialization:
        // Hex: 08 08 10 0b 52 18 42 16 08 00 10 00 18 00 20 00 2a 02 08 00 38 01 42 04 08 00 10 00 48 02
        // Decoded:
        // - type=8 (health)
        // - subtype=11 (CONFIG_HEART_RATE_SET)
        // - Health message with continuous mode parameters

        debugPrint(
          '🔄 [enableRealtimeStats] Preparing device for HR streaming...',
        );
        debugPrint(
          '   📤 STEP 1: Sending CONFIG_HEART_RATE_SET (subtype=11)...',
        );

        // Step 1: Send CONFIG command (fire-and-forget, like post-auth does)
        try {
          final configPayload = Uint8List.fromList([
            0x08,
            0x08,
            0x10,
            0x0b,
            0x52,
            0x18,
            0x42,
            0x16,
            0x08,
            0x00,
            0x10,
            0x00,
            0x18,
            0x00,
            0x20,
            0x00,
            0x2a,
            0x02,
            0x08,
            0x00,
            0x38,
            0x01,
            0x42,
            0x04,
            0x08,
            0x00,
            0x10,
            0x00,
            0x48,
            0x02,
          ]);

          final configCommand = pb.Command.fromBuffer(configPayload);
          await sppService.sendProtobufCommand(
            command: configCommand,
            expectsResponse: false, // Fire-and-forget
          );
          debugPrint('   ✅ CONFIG sent successfully');
        } catch (e) {
          debugPrint(
            '   ⚠️  CONFIG send failed: $e (continuing with START anyway...)',
          );
        }

        // Wait for device to process CONFIG
        debugPrint('   ⏱️  Waiting 150ms for device to process CONFIG...');
        await Future.delayed(const Duration(milliseconds: 150));

        // Step 2: Send START command
        debugPrint(
          '   📤 STEP 2: Sending START_REALTIME_STATS (subtype=45)...',
        );
        final startCommand = createRealtimeStatsStartRequest();

        await sppService.sendProtobufCommand(
          command: startCommand,
          expectsResponse: false,
        );

        debugPrint('   ✅ START sent successfully');
        debugPrint('   📊 Device should now stream HR data (subtype=47)');

        // Wait for device to prepare streaming
        debugPrint('   ⏱️  Waiting 200ms for device to prepare streaming...');
        await Future.delayed(const Duration(milliseconds: 200));
        debugPrint('   ✅ Device ready for streaming!');
      } else {
        // STOP: Just send the STOP command
        debugPrint('🔄 [enableRealtimeStats] Stopping HR streaming...');
        debugPrint('   📤 Sending STOP_REALTIME_STATS (subtype=46)...');

        final stopCommand = createRealtimeStatsStopRequest();

        await sppService.sendProtobufCommand(
          command: stopCommand,
          expectsResponse: false,
        );

        debugPrint('   ✅ STOP sent successfully');
        debugPrint('   ℹ️  Device will stop sending subtype=47 events');
      }
    } on Exception catch (e) {
      debugPrint('❌ enableRealtimeStats failed: $e');
      rethrow;
    }
  }

  /// 📊 Subscribe to Realtime Stats Stream
  ///
  /// **Xiaomi Band 9/10 Only**: Retorna stream de múltiples sensores
  /// (HR, movement, steps, calories, standing) a ~1 sample/segundo.
  ///
  /// **✅ AUTO-DISCOVERY**: No requiere pasar XiaomiSppService, lo descubre automáticamente
  ///
  /// **Parámetros**:
  /// - [deviceId]: MAC address del dispositivo Xiaomi
  ///
  /// **Returns**: Stream de BiometricSample con datos de múltiples sensores
  ///
  /// **Tipos de datos**:
  /// - heart_rate (BPM)
  /// - movement (intensity proxy 0-100)
  /// - steps (count)
  /// - calories (kcal)
  /// - standing (hours)
  ///
  /// **Ejemplo completo (LIMPIO)**:
  /// ```dart
  /// final reader = BiometricDataReader(); // ✅ Singleton
  ///
  /// // 1. Enable streaming (auto-discovery!)
  /// await reader.enableRealtimeStats(deviceId, true);
  ///
  /// // 2. Subscribe to multi-sensor stream
  /// final subscription = reader.subscribeToRealtimeStats(deviceId).listen((sample) {
  ///   switch (sample.dataType) {
  ///     case 'heart_rate':
  ///       print('HR: ${sample.value} BPM');
  ///       break;
  ///     case 'movement':
  ///       print('Movement: ${sample.value}');
  ///       break;
  ///     case 'steps':
  ///       print('Steps: ${sample.value}');
  ///       break;
  ///   }
  /// });
  ///
  /// // 3. Stop cuando termine
  /// await subscription.cancel();
  /// ```
  ///
  /// **Nota**: Al cancelar la suscripción (subscription.cancel()), se envía
  /// automáticamente el comando STOP al dispositivo para ahorrar batería.
  Stream<BiometricSample> subscribeToRealtimeStats(
    final String deviceId,
  ) async* {
    // ✅ AUTO-DISCOVERY: Obtener SPP service del orchestrator
    final sppService = _getSppServiceForDevice(deviceId);

    if (sppService == null) {
      throw StateError(
        'Device $deviceId not connected via BT_CLASSIC. '
        'Cannot subscribe to realtime stats.',
      );
    }

    if (!sppService.isReady) {
      throw StateError('SPP service not ready for device $deviceId');
    }

    try {
      debugPrint('📊 Subscribing to realtime stats for $deviceId');
      debugPrint('   🔍 Listening to SPP data stream...');

      // Subscribe to SPP data stream
      await for (final packet in sppService.dataStream) {
        debugPrint(
          '   📦 Received packet: deviceId=${packet.deviceId}, size=${packet.data.length}, channel=${packet.channel}',
        );

        if (packet.deviceId != deviceId) {
          debugPrint('   ⏭️  Skipping packet from different device');
          continue;
        }

        // ✅ CRITICAL: Check packet channel to determine how to process
        if (packet.channel == 'activity') {
          // Activity channel: Raw sensor data, often contains realtime stats
          debugPrint(
            '   📊 Activity channel detected - attempting to parse sensor data',
          );
          debugPrint(
            '   📋 Payload size: ${packet.data.length} bytes',
          );

          // Try to parse using the xiaomi realtime stats multi-parser.
          // This parser handles:
          // 1. Direct protobuf Command (type=8, subtype=47)
          // 2. Embedded protobuf (scans offsets up to 32 bytes)
          // 3. Returns null if not a valid realtime stats event
          final parser = ParserRegistry.getMultiParser(
            'xiaomi_spp_realtime_stats',
          );

          if (parser != null) {
            try {
              debugPrint(
                '   🔍 Attempting to parse activity payload with xiaomi_spp_realtime_stats parser...',
              );
              final samples = parser(packet.data);
              if (samples != null && samples.isNotEmpty) {
                debugPrint(
                  '   ✅ Successfully parsed ${samples.length} samples from activity channel',
                );
                for (final sample in samples) {
                  debugPrint(
                    '   📊 Yielding: ${sample.sensorType.displayName} = ${sample.value}',
                  );
                  yield sample;
                }
                continue; // processed this packet
              } else {
                debugPrint(
                  '   ⚠️  Parser returned null or empty (not a realtime stats event)',
                );
                // This is not an error - activity channel might contain other data types
                continue;
              }
            } on Exception catch (e) {
              debugPrint('   ⚠️  Activity parser threw exception: $e');
              debugPrint(
                '   📋 Payload (hex): ${packet.data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
              );
              // Continue to next packet - this activity data wasn't parseable as realtime stats
              continue;
            }
          } else {
            debugPrint(
              '   ❌ Parser "xiaomi_spp_realtime_stats" not found in registry',
            );
            debugPrint(
              '   📋 Available parsers: ${ParserRegistry.availableParsers}',
            );
            continue;
          }
        }

        // protobuf_command channel: Standard Command protobuf
        debugPrint('   🔧 Protobuf command channel detected');

        // Decode protobuf command
        pb.Command? command;
        try {
          command = pb.Command.fromBuffer(packet.data);
          debugPrint(
            '   ✅ Decoded command: type=${command.type}, subtype=${command.subtype}',
          );
        } on Exception catch (e) {
          debugPrint('⚠️  Failed to decode protobuf: $e');
          continue;
        }

        // Filter realtime stats events (type=8, subtype=47)
        if (!isRealtimeStatsEvent(command)) {
          debugPrint(
            '   ⏭️  Skipping non-realtime-stats command (type=${command.type}, subtype=${command.subtype})',
          );
          continue;
        }

        debugPrint('   🎯 Processing realtime stats event...');

        // Parse multi-sensor data
        final parser = ParserRegistry.getMultiParser(
          'xiaomi_spp_realtime_stats',
        );
        if (parser == null) {
          debugPrint('❌ Parser "xiaomi_spp_realtime_stats" not found');
          continue;
        }

        final samples = parser(packet.data);
        if (samples == null || samples.isEmpty) {
          debugPrint('   ⚠️  Parser returned null or empty samples');
          continue;
        }

        debugPrint('   ✅ Parsed ${samples.length} samples');

        // Yield cada sensor individualmente
        for (final sample in samples) {
          debugPrint(
            '   📊 Yielding: ${sample.sensorType.displayName} = ${sample.value}',
          );
          yield sample;
        }
      }
    } on Exception catch (e) {
      debugPrint('❌ subscribeToRealtimeStats failed: $e');
    } finally {
      // ✅ CRITICAL: Auto-stop al cancelar la suscripción
      debugPrint('   🧹 Cleaning up realtime stats subscription for $deviceId');

      try {
        await enableRealtimeStats(deviceId, false);
        debugPrint('   ✅ Auto-stopped realtime stats on subscription cancel');
      } on Exception catch (e) {
        debugPrint('   ⚠️  Failed to auto-stop realtime stats: $e');
      }
    }
  }

  /// ❤️ Measure Heart Rate (One-shot)
  ///
  /// **Xiaomi Band 9/10 Only**: Mide heart rate una vez (no streaming).
  ///
  /// **Parámetros**:
  /// - [deviceId]: MAC address del dispositivo Xiaomi
  /// - [timeout]: Tiempo máximo de espera (default: 10 segundos)
  ///
  /// **Returns**: BiometricSample con HR, o null si timeout/error
  ///
  /// **Implementation**:
  /// 1. Start realtime stats
  /// 2. Wait for first valid HR sample
  /// 3. Auto-stop después de recibir el dato
  ///
  /// **Ejemplo**:
  /// ```dart
  /// // UI button "Measure HR"
  /// final hrSample = await reader.measureHeartRate(deviceId);
  ///
  /// if (hrSample != null) {
  ///   print('Your HR: ${hrSample.value} BPM');
  /// } else {
  ///   print('Failed to measure HR');
  /// }
  /// ```
  ///
  /// **Nota**: Más eficiente que streaming continuo si solo necesitas
  /// una medición puntual (UI button, validation check, etc).
  Future<BiometricSample?> measureHeartRate(
    final String deviceId, {
    final Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      debugPrint(
        '❤️  Measuring heart rate for $deviceId (timeout: ${timeout.inSeconds}s)',
      );

      // 1. Start realtime stats
      await enableRealtimeStats(deviceId, true);

      // 2. Wait for first valid HR sample
      final hrSample = await subscribeToRealtimeStats(deviceId)
          .where((final sample) => sample.sensorType == SensorType.heartRate)
          .where(
            (final sample) => sample.value >= 40 && sample.value <= 220,
          ) // Valid HR range
          .timeout(
        timeout,
        onTimeout: (final sink) {
          debugPrint('   ⏱️  Timeout waiting for HR sample');
          sink.close();
        },
      ).first;

      // 3. Auto-stop streaming
      await enableRealtimeStats(deviceId, false);

      debugPrint('   ✅ Measured HR: ${hrSample.value} BPM');
      return hrSample;
    } on Exception catch (e) {
      debugPrint('❌ measureHeartRate failed: $e');

      // Ensure streaming is stopped even if error
      try {
        await enableRealtimeStats(deviceId, false);
      } on Exception {
        // Ignore cleanup errors
      }

      return null;
    }
  }

  // ============================================================================
  // TRANSPORT ADAPTERS (PRIVADOS)
  // ============================================================================

  /// Read via BLE characteristic (one-shot)
  ///
  /// **✅ AUTO-INITIALIZATION**: Crea BleService si no existe
  Future<BiometricSample?> _readViaBle(
    final String deviceId,
    final CharacteristicInfo charInfo,
  ) async {
    try {
      debugPrint(
        '📖 Reading BLE characteristic ${charInfo.characteristicUuid}...',
      );

      // ✅ Use BleService.readCharacteristic() for one-shot read
      final bytes = await _getBleService().readCharacteristic(
        deviceId: deviceId,
        serviceUuid: charInfo.serviceUuid,
        characteristicUuid: charInfo.characteristicUuid,
      );

      if (bytes == null) {
        debugPrint('   ⚠️  Read returned null');
        return null;
      }

      debugPrint('   📥 Read ${bytes.length} bytes');

      // Parse con ParserRegistry
      final parserName = charInfo.parser;
      if (parserName == null) {
        debugPrint(
          '   ⚠️  No parser defined for ${charInfo.characteristicName}',
        );
        return null;
      }

      final parser = ParserRegistry.getParser(parserName);
      if (parser == null) {
        debugPrint('   ⚠️  Parser "$parserName" not found in registry');
        return null;
      }

      final sample = parser(bytes);
      if (sample != null) {
        debugPrint('   ✅ Parsed value: ${sample.value}');
      }

      return sample;
    } on Exception catch (e) {
      debugPrint('❌ BLE read failed: $e');
      return null;
    }
  }

  /// Subscribe via BLE characteristic (streaming)
  ///
  /// **✅ AUTO-INITIALIZATION**: Crea BleService si no existe
  Stream<BiometricSample> _subscribeViaBle(
    final String deviceId,
    final CharacteristicInfo charInfo,
  ) async* {
    final bleService = _getBleService();

    // Subscribe to raw BLE data stream
    await bleService.subscribeToDataType(
      deviceId: deviceId,
      dataType: charInfo.characteristicName,
      onData: (final data) {
        // Datos procesados vía rawBleDataStream
      },
    );

    // Filter and parse raw BLE data stream
    await for (final packet in bleService.rawBleDataStream) {
      if (packet.deviceId == deviceId &&
          packet.characteristicUuid.toLowerCase() ==
              charInfo.characteristicUuid.toLowerCase()) {
        // Parse con ParserRegistry
        final parserName = charInfo.parser;
        if (parserName == null) {
          debugPrint(
            '⚠️  No parser defined for ${charInfo.characteristicName}',
          );
          continue;
        }

        final parser = ParserRegistry.getParser(parserName);
        if (parser == null) {
          debugPrint('⚠️  Parser "$parserName" not found in registry');
          continue;
        }

        final sample = parser(packet.rawData);
        if (sample != null) {
          yield sample;
        }
      }
    }
  }

  /// Read via SPP protobuf command (one-shot)
  ///
  /// **✅ AUTO-DISCOVERY**: Obtiene SPP service del orchestrator automáticamente
  /// **✅ UNIVERSAL**: Funciona con cualquier dispositivo SPP (Xiaomi, etc.)
  ///
  /// **Protocol**:
  /// 1. Obtener SPP service de DeviceConnectionManager.activeConnections
  /// 2. Verificar que esté listo (connected via BT_CLASSIC)
  /// 3. Mapear dataType → protobuf command (battery, device_info, etc.)
  /// 4. Enviar comando y esperar respuesta
  /// 5. Parsear respuesta con ParserRegistry
  Future<BiometricSample?> _readViaSpp(
    final String deviceId,
    final String dataType,
    final DeviceImplementation deviceImpl,
  ) async {
    // ✅ AUTO-DISCOVERY: Obtener SPP service del orchestrator
    final sppService = _getSppServiceForDevice(deviceId);

    if (sppService == null) {
      debugPrint('❌ Device $deviceId not connected via BT_CLASSIC');
      debugPrint('   💡 Ensure device is in STREAMING state before reading');
      return null;
    }

    if (!sppService.isReady) {
      debugPrint('❌ SPP service not ready for device $deviceId');
      debugPrint('   - sppService.isReady: ${sppService.isReady}');
      debugPrint(
        '   💡 Connection may still be initializing, try again in a moment',
      );
      return null;
    }

    try {
      // Map dataType → SPP command
      pb.Command? request;
      String? parserName;

      switch (dataType) {
        case 'battery':
          request = createBatteryRequest();
          parserName = 'xiaomi_spp_battery';
          break;

        // Agregar más data types aquí:
        // case 'device_info':
        //   request = createDeviceInfoRequest();
        //   parserName = 'xiaomi_spp_device_info';
        //   break;

        default:
          throw UnsupportedError(
            'SPP data type "$dataType" not implemented yet',
          );
      }

      // Send protobuf command
      debugPrint(
        '   📤 Sending SPP command: type=${request.type}, subtype=${request.subtype}',
      );
      final response = await sppService.sendProtobufCommand(command: request);

      if (response == null) {
        debugPrint('   ⚠️  No response from device (timeout or error)');
        debugPrint('   💡 Device may have disconnected or timed out');
        return null;
      }

      debugPrint(
        '   📥 Received response: type=${response.type}, subtype=${response.subtype}',
      );

      // Parse con ParserRegistry
      final parser = ParserRegistry.getParser(parserName);
      if (parser == null) {
        debugPrint('❌ Parser "$parserName" not found in registry');
        debugPrint('   💡 Make sure parser is registered in ParserRegistry');
        return null;
      }

      final sample = parser(response.writeToBuffer());
      if (sample != null) {
        debugPrint('   ✅ Parsed value: ${sample.value}');
      } else {
        debugPrint('   ⚠️  Parser returned null');
      }
      return sample;
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ SPP read failed: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Get device implementation con cache
  Future<DeviceImplementation> _getDeviceImplementation(
    final String deviceId,
  ) async {
    if (_deviceImplCache.containsKey(deviceId)) {
      return _deviceImplCache[deviceId]!;
    }

    // ✅ CRITICAL: Get the actual device implementation ID (NOT UI type)
    // The active orchestrator knows the technical implementation (e.g., xiaomi_smart_band_10)
    // This is DIFFERENT from deviceTypeId which is for UI (e.g., xiaomi_mi_band)
    final orchestrator = _connectionManager.activeConnections[deviceId];
    if (orchestrator != null) {
      final implId = orchestrator.discoveredDeviceTypeId;
      if (implId != null && implId != 'unknown') {
        debugPrint(
          '   🔍 Retrieved implementation ID from orchestrator: $implId',
        );
        try {
          final deviceImpl = await DeviceImplementationLoader.load(implId);
          _deviceImplCache[deviceId] = deviceImpl;
          debugPrint('   📱 Device implementation: ${deviceImpl.deviceType}');
          debugPrint(
            '   🔐 Auth protocol: ${deviceImpl.authentication.protocol}',
          );
          return deviceImpl;
        } on Exception catch (e) {
          debugPrint(
            '   ⚠️  Failed to load implementation $implId: $e',
          );
        }
      }
    }

    // ❌ Fallback: Load desde JSON (auto-detect device type)
    final deviceImpl = await DeviceImplementationLoader.loadOrGeneric(deviceId);
    _deviceImplCache[deviceId] = deviceImpl;

    debugPrint('   📱 Device type: ${deviceImpl.deviceType}');
    debugPrint('   🔐 Auth protocol: ${deviceImpl.authentication.protocol}');

    return deviceImpl;
  }

  /// Clear cache (útil para tests o cuando cambia configuración)
  void clearCache() {
    _deviceImplCache.clear();
  }
}
