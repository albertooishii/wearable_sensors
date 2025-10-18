// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// 📡 Bluetooth Service - Dream Incubator
// Servicio de bajo nivel para comunicación Bluetooth con dispositivos wearables

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // ✅ Para PlatformException
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:wearable_sensors/src/internal/config/supported_devices_config.dart';
import 'package:wearable_sensors/src/internal/models/bluetooth_connection_state.dart';

import 'package:wearable_sensors/src/internal/models/bluetooth_device.dart';
import 'package:wearable_sensors/src/internal/services/permissions_service.dart';
import 'package:wearable_sensors/wearable_sensors.dart';
import 'package:wearable_sensors/src/internal/utils/ble_uuid_utils.dart';
import 'package:wearable_sensors/src/internal/utils/device_implementation_loader.dart';
import 'package:wearable_sensors/src/internal/vendors/xiaomi/xiaomi_auth_service.dart';

/// Paquete de datos BLE crudos emitido por el BleService
class BleDataPacket {
  const BleDataPacket({
    required this.deviceId,
    required this.serviceUuid,
    required this.characteristicUuid,
    required this.rawData,
    required this.timestamp,
  });

  final String deviceId;
  final String serviceUuid;
  final String characteristicUuid;
  final List<int> rawData;
  final DateTime timestamp;

  @override
  String toString() =>
      'BleDataPacket(device: $deviceId, service: $serviceUuid, char: $characteristicUuid, data: ${rawData.length} bytes)';
}

/// Servicio de bajo nivel para comunicación Bluetooth y descubrimiento de dispositivos
class BleService {
  factory BleService() => _instance;
  BleService._internal() {
    // ✅ Xiaomi authentication service initialized lazily per device
    // No need for singleton - cada dispositivo tendrá su propia instancia

    // 🔧 Escuchar cambios en el estado de scanning desde flutter_blue_plus
    fbp.FlutterBluePlus.isScanning.listen((final scanning) {
      if (_isScanning != scanning) {
        _isScanning = scanning;
        _updateConnectionState(_connectionState.copyWith(isScanning: scanning));
        debugPrint(
          '📡 Scan state changed: ${scanning ? "SCANNING" : "STOPPED"}',
        );
      }
    });
  }
  static final BleService _instance = BleService._internal();

  // ✅ Xiaomi authentication services (one per device)
  final Map<String, XiaomiAuthService> _xiaomiAuthServices = {};

  // Streams principales (pueden recrearse después de dispose)
  StreamController<BluetoothConnectionState> _connectionStateController =
      StreamController<BluetoothConnectionState>.broadcast();
  StreamController<BluetoothDevice> _rawBleDeviceController =
      StreamController<BluetoothDevice>.broadcast();
  StreamController<BleDataPacket> _rawBleDataController =
      StreamController<BleDataPacket>.broadcast();

  // Estado interno BLE puro
  final Map<String, StreamSubscription> _connectionStreams = {};

  // 🆕 NEW ARCHITECTURE: Device type cache y scanned devices
  final Map<String, String> _deviceTypes = {}; // deviceId → deviceType
  final Map<String, BluetoothDevice> _scannedDevices =
      {}; // deviceId → BluetoothDevice
  final Map<String, fbp.BluetoothDevice> _connectedDevices =
      {}; // deviceId → fbp.BluetoothDevice (cache de instancias)

  // 🔧 NUEVO: Cache de servicios descubiertos para evitar rediscoverServices en cada write
  final Map<String, List<fbp.BluetoothService>> _discoveredServices =
      {}; // deviceId → List<BluetoothService>

  // 🔧 NUEVO: Tracking de subscriptions de características para evitar duplicación
  final Map<String, StreamSubscription> _characteristicSubscriptions =
      {}; // "deviceId:characteristicUuid" → StreamSubscription

  // Cache para evitar logs repetitivos
  final Set<String> _loggedDevices = <String>{};
  bool _isScanning = false;
  bool _isInitialized = false;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.initial();

  // Stream subscription para el scan (para poder cancelarlo)
  StreamSubscription<List<fbp.ScanResult>>? _scanSubscription;

  // Getters públicos - Solo streams BLE puros
  Stream<BluetoothDevice> get rawBleDevicesStream =>
      _rawBleDeviceController.stream;
  Stream<BleDataPacket> get rawBleDataStream => _rawBleDataController.stream;

  // Getter para acceder al controller desde upper service layer
  StreamController<BleDataPacket> get rawBleDataStreamController =>
      _rawBleDataController;

  // Getter para estado de conexión
  BluetoothConnectionState get connectionState => _connectionState;
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  /// Recrear StreamControllers si fueron cerrados previamente
  void _recreateControllersIfClosed() {
    if (_rawBleDeviceController.isClosed) {
      debugPrint('🔄 Recreating closed _rawBleDeviceController');
      _rawBleDeviceController = StreamController<BluetoothDevice>.broadcast();
    }

    if (_connectionStateController.isClosed) {
      debugPrint('🔄 Recreating closed _connectionStateController');
      _connectionStateController =
          StreamController<BluetoothConnectionState>.broadcast();
    }

    if (_rawBleDataController.isClosed) {
      debugPrint('🔄 Recreating closed _rawBleDataController');
      _rawBleDataController = StreamController<BleDataPacket>.broadcast();
    }
  }

  /// Inicializar servicio y verificar permisos
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('🔧 Disposing BleService...');
      return;
    }

    try {
      // 🔄 Recrear StreamControllers si fueron cerrados anteriormente
      _recreateControllersIfClosed();

      await _checkBluetoothPermissions();
      await _checkBluetoothState();

      // Escuchar cambios en el estado de Bluetooth con flutter_blue_plus
      fbp.FlutterBluePlus.adapterState.listen((final state) {
        _updateConnectionState(
          _connectionState.copyWith(
            isBluetoothEnabled: state == fbp.BluetoothAdapterState.on,
            isBluetoothAvailable:
                state != fbp.BluetoothAdapterState.unavailable,
          ),
        );
      });

      // 🔗 Escuchar cambios de estado de conexión automáticos
      // Nota: universal_ble no tiene un callback directo onConnectionChange,
      // pero podemos detectar conexiones automáticas en el método connectDevice

      // 🗑️ REMOVED: Global UniversalBle.onValueChange callback
      // Ahora usamos characteristic.onValueReceived directamente (API moderna)

      // 🗑️ REMOVED: Loading system devices - upper service layer handles this now

      _isInitialized = true;
      debugPrint('🔵 BleService initialized successfully');
    } on Exception catch (e) {
      debugPrint('❌ BleService initialization failed: $e');
      _updateConnectionState(
        _connectionState.copyWith(errorMessage: 'Initialization failed: $e'),
      );
    }
  }

  /// Verificar y solicitar permisos de Bluetooth
  Future<void> _checkBluetoothPermissions() async {
    final allGranted = await PermissionsService.areAllPermissionsGranted();

    if (!allGranted) {
      debugPrint('⚠️ Some Bluetooth permissions missing. Requesting...');
      await PermissionsService.requestBluetoothPermissions();
      // Location permissions removed - not needed on Android 12+ with BLUETOOTH_SCAN neverForLocation flag
    }

    final finalCheck = await PermissionsService.areAllPermissionsGranted();

    _updateConnectionState(
      _connectionState.copyWith(hasPermissions: finalCheck),
    );
  }

  /// Verificar estado de Bluetooth del dispositivo
  Future<void> _checkBluetoothState() async {
    try {
      final adapterState = await fbp.FlutterBluePlus.adapterState.first;
      _updateConnectionState(
        _connectionState.copyWith(
          isBluetoothEnabled: adapterState == fbp.BluetoothAdapterState.on,
          isBluetoothAvailable:
              adapterState != fbp.BluetoothAdapterState.unavailable,
        ),
      );
    } on Exception catch (e) {
      debugPrint('❌ Error checking Bluetooth state: $e');
      _updateConnectionState(
        _connectionState.copyWith(
          isBluetoothAvailable: false,
          errorMessage: 'Bluetooth check failed: $e',
        ),
      );
    }
  }

  /// Actualizar estado de conexión y notificar listeners
  void _updateConnectionState(final BluetoothConnectionState newState) {
    _connectionState = newState;
    _connectionStateController.add(_connectionState);
  }

  /// 🆕 Obtener instancia de fbp.BluetoothDevice del cache o crear nueva
  ///
  /// **IMPORTANTE**: Siempre intenta usar instancias REALES del cache primero:
  /// - Devices de bondedDevices (getSystemDevices)
  /// - Devices de scan results (startScanning)
  ///
  /// Solo crea nueva instancia con fromId() como último recurso.
  ///
  /// **IMPORTANTE**: fromId() crea dispositivos SIN NOMBRE, causando "Pair with null" en Android.
  /// Siempre intentar usar dispositivos del scan cache primero.
  ///
  /// **OPTIMIZACIÓN**: Usa filtrado nativo con withRemoteIds para encontrar dispositivos específicos.
  ///
  /// **Parameters:**
  /// - [deviceId]: MAC address del dispositivo
  Future<fbp.BluetoothDevice> getBluetoothDeviceAsync(
    final String deviceId,
  ) async {
    // Paso 1: Verificar cache con servicios descubiertos
    if (_connectedDevices.containsKey(deviceId)) {
      final cachedDevice = _connectedDevices[deviceId]!;
      final hasServices = _discoveredServices.containsKey(deviceId) &&
          _discoveredServices[deviceId]!.isNotEmpty;

      if (hasServices) {
        return cachedDevice; // Cache hit - fast path
      }
      debugPrint('⚠️ Cached device $deviceId has NO services, will rescan');
    }

    // Paso 2: Quick scan con filtrado nativo
    final scannedDevice = await _quickScanForDevice(deviceId);
    if (scannedDevice != null) {
      return scannedDevice;
    }

    // 🔴 FALLBACK: Crear instancia sin nombre (último recurso)
    debugPrint('⚠️⚠️⚠️ Creating device without name for $deviceId');
    debugPrint('   ⚠️ Android will show "Pair with null"');
    debugPrint('   ⚠️ User should scan for device first!');
    final fakeDevice = fbp.BluetoothDevice.fromId(deviceId);
    _connectedDevices[deviceId] = fakeDevice;
    return fakeDevice;
  }

  /// Quick scan con filtrado nativo por MAC address
  Future<fbp.BluetoothDevice?> _quickScanForDevice(
    final String deviceId,
  ) async {
    try {
      // ⚠️ IMPORTANTE: No interrumpir scan principal si está activo
      final isScanningNow = await fbp.FlutterBluePlus.isScanning.first;
      if (isScanningNow && _isScanning) {
        debugPrint(
          '⏸️  Main scan active - skipping quick scan to avoid interruption',
        );
        debugPrint('   💡 Device will be found by main scan');
        return null;
      }

      debugPrint('🔍 Quick scan for device with native filter...');

      await fbp.FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        withRemoteIds: [deviceId], // Filtrado nativo
      );

      final scanResults = await fbp.FlutterBluePlus.scanResults.first;
      await fbp.FlutterBluePlus.stopScan();

      if (scanResults.isNotEmpty) {
        final foundDevice = scanResults.first.device;
        debugPrint('✅ Device found: ${foundDevice.platformName} ($deviceId)');
        _connectedDevices[deviceId] = foundDevice;
        return foundDevice;
      }

      debugPrint('⚠️ Device $deviceId not found after scan');
      return null;
    } on Exception catch (e) {
      debugPrint('⚠️ Quick scan failed: $e');
      return null;
    }
  }

  /// Synchronous version - tries cache and lastScanResults only (no async scan)
  fbp.BluetoothDevice _getBluetoothDevice(final String deviceId) {
    // Intentar obtener del cache (instancia REAL)
    if (_connectedDevices.containsKey(deviceId)) {
      // debugPrint('🎯 Using cached real fbp.BluetoothDevice for $deviceId'); // ⚡ Commented - cache hits are normal
      return _connectedDevices[deviceId]!;
    }

    // Intentar obtener de scan results (tiene nombre!)
    final scanResults = fbp.FlutterBluePlus.lastScanResults;

    // Usar orElse en vez de try-catch para evitar StateError
    final scannedDevice = scanResults.cast<fbp.ScanResult?>().firstWhere(
          (final result) =>
              result?.device.remoteId.str.toLowerCase() ==
              deviceId.toLowerCase(),
          orElse: () => null,
        );

    if (scannedDevice != null) {
      debugPrint(
        '✅ Found device in scan results: ${scannedDevice.device.platformName} ($deviceId)',
      );
      _connectedDevices[deviceId] = scannedDevice.device;
      return scannedDevice.device;
    }

    // Device not found in scan results
    debugPrint('⚠️ Device $deviceId not found in scan results');

    // 🔴 FALLBACK: Crear nueva instancia usando flutter_blue_plus
    // ⚠️ WARNING: Esto crea un dispositivo SIN NOMBRE → "Pair with null" en Android!
    debugPrint(
      '⚠️⚠️⚠️ Creating NEW fbp.BluetoothDevice.fromId() for $deviceId',
    );
    debugPrint(
      '   ⚠️ This device has NO NAME → Android will show "Pair with null"',
    );
    debugPrint('   ⚠️ Recommend scanning first to get device name!');
    final device = fbp.BluetoothDevice.fromId(deviceId);
    _connectedDevices[deviceId] = device; // Guardar en cache
    return device;
  }

  /// Refrescar dispositivos emparejados del sistema
  //  REMOVED: refreshSystemDevices() - upper service layer handles system devices directly

  /// Verificar si un dispositivo está en los resultados del escaneo

  /// Verificar si un dispositivo está bonded (paired)
  /// Retorna true si está bonded, false en caso contrario
  Future<bool> isDeviceBonded(final String deviceId) async {
    try {
      final bleDevice = fbp.BluetoothDevice.fromId(deviceId);
      final bondState = await bleDevice.bondState.first;
      return bondState == fbp.BluetoothBondState.bonded;
    } on Exception catch (e) {
      debugPrint('❌ Error checking bond state for $deviceId: $e');
      return false;
    }
  }

  /// Verificar si el adaptador Bluetooth está encendido
  /// Retorna true si Bluetooth está ON, false en caso contrario

  /// Obtener la lista de dispositivos BLE conectados actualmente
  /// Retorna lista de device IDs (MAC addresses)

  /// Obtener instancia de BluetoothDevice de flutter_blue_plus
  /// SOLO para uso interno de servicios de bajo nivel (xiaomi_auth_service)
  fbp.BluetoothDevice? getFlutterBlueDevice(final String deviceId) {
    return _connectedDevices[deviceId];
  }

  /// ✅ SIMPLE: Crear fbp.BluetoothDevice directamente desde ID
  ///
  /// Wrapper directo de flutter_blue_plus BluetoothDevice.fromId()
  ///
  /// **Parámetros:**
  /// - [deviceId]: MAC address del dispositivo (ej: 'AA:BB:CC:DD:EE:FF')
  ///
  /// **Retorna:**
  /// - [fbp.BluetoothDevice] instancia lista para usar
  ///
  /// **Uso:**
  /// ```dart
  /// final device = bleService.getBluetoothDevice('AA:BB:CC:DD:EE:FF');
  /// await device.connect();
  /// ```
  fbp.BluetoothDevice getBluetoothDevice(final String deviceId) {
    return fbp.BluetoothDevice.fromId(deviceId);
  }

  /// Detener escaneo activo
  Future<void> stopScanning() async {
    if (!_isScanning) {
      return;
    }

    try {
      await fbp.FlutterBluePlus.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      _isScanning = false;
      debugPrint('🛑 Bluetooth scan stopped');
    } on Exception catch (e) {
      debugPrint('❌ Error stopping scan: $e');
    }
  }

  /// Comenzar escaneo de dispositivos wearables
  Future<void> startScanning({
    final Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_isScanning) {
      debugPrint('🔍 Already scanning, skipping...');
      return;
    }

    if (!_connectionState.isReady) {
      debugPrint('❌ Cannot scan - Bluetooth not ready');
      throw Exception('Bluetooth not ready: ${_connectionState.errorMessage}');
    }

    // Limpiar cache de logs para permitir logging de dispositivos en nuevo scan
    _loggedDevices.clear();

    try {
      debugPrint('🔍 Starting Bluetooth scan for BLE devices...');

      // 🔧 IMPORTANTE: Cancelar subscription ANTES de iniciar nuevo scan
      await _scanSubscription?.cancel();
      _scanSubscription = null;

      // 🔧 IMPORTANTE: Asegurar que no hay scan previo activo
      if (await fbp.FlutterBluePlus.isScanning.first) {
        debugPrint('⚠️ Previous scan still active, stopping it first...');
        await fbp.FlutterBluePlus.stopScan();
        await Future.delayed(
          const Duration(milliseconds: 300),
        ); // Wait for cleanup
      }

      // Comenzar escaneo con flutter_blue_plus
      // ✅ flutter_blue_plus maneja el timeout automáticamente y detiene el scan
      await fbp.FlutterBluePlus.startScan(timeout: timeout);

      // Escuchar resultados del escaneo
      _scanSubscription = fbp.FlutterBluePlus.scanResults.listen((
        final results,
      ) {
        for (final result in results) {
          final device = result.device;

          // Log solo si es la primera vez que vemos este dispositivo
          final deviceKey = '${device.platformName}-${device.remoteId.str}';
          if (!_loggedDevices.contains(deviceKey)) {
            debugPrint(
              '📡 BLE Device Found: "${device.platformName.isNotEmpty ? device.platformName : 'Unknown Device'}" (${device.remoteId.str})',
            );
            _loggedDevices.add(deviceKey);
          }

          // ❌ DISABLED: Temp connections cause infinite loop and battery drain
          // Services will be discovered when user explicitly connects
          // _discoverServicesForScannedDevice(device, result);

          // ✅ OPTIMIZED: Just emit device with advertisement data
          _emitScannedDeviceWithAdvertisementData(device, result);
        }
      });
    } on Exception catch (e) {
      debugPrint('❌ Error during scan: $e');
      // 🔧 Detener scan en caso de error - el stream actualizará _isScanning
      await fbp.FlutterBluePlus.stopScan();
      _updateConnectionState(
        _connectionState.copyWith(
          isScanning: false,
          errorMessage: 'Scan failed: $e',
        ),
      );
      rethrow;
    }
  }

  /// ✅ OPTIMIZED: Emit scanned device using ONLY advertisement data (no temp connection)
  ///
  /// **Benefits:**
  /// - No battery drain from temp connections
  /// - No connection loop issues
  /// - Faster scan results
  /// - Services discovered when user explicitly connects
  ///
  /// **Parameters:**
  /// - [device]: FlutterBluePlus device from scan result
  /// - [scanResult]: Scan result with advertisement data
  void _emitScannedDeviceWithAdvertisementData(
    final fbp.BluetoothDevice device,
    final fbp.ScanResult scanResult,
  ) {
    final deviceId = device.remoteId.str;
    final deviceName =
        device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';

    // 🎯 CRÍTICO: Cachear el device REAL del scan para uso posterior
    // Esto evita crear una nueva instancia con fromId() que puede fallar
    _connectedDevices[deviceId] = device;

    // Create device using ONLY advertisement data (no connection required)
    final scannedDevice = BluetoothDevice.fromBasicInfo(
      deviceId: deviceId,
      name: deviceName,
      services: scanResult.advertisementData.serviceUuids
          .map((final s) => BleUuidUtils.toShortUuid(s.toString()))
          .toList(),
      rssi: scanResult.rssi,
      paired: false,
      isSystemDevice: false,
    );

    // Cache and emit
    _scannedDevices[deviceId] = scannedDevice;
    _rawBleDeviceController.add(scannedDevice);
  }

  /// 🔍 Obtener dispositivos BONDED (emparejados en Android Settings)
  ///
  /// ⚠️ **CRITICAL BUG ENCONTRADO** - Issue flutter_blue_plus #1226:
  /// `FlutterBluePlus.systemDevices()` en Android está ROTO:
  /// - Internamente llama a: `mBluetoothManager.getConnectedDevices(BluetoothProfile.GATT)`
  /// - En Android 11-12, este método SIEMPRE retorna lista vacía
  /// - Es un **bug de AOSP (Android OS)**, no fixeable a nivel flutter_blue_plus
  /// - Confirmado por el mantenedor: "open a issue with AOSP if its broken"
  ///
  /// ✅ **SOLUCIÓN - Usar bondedDevices en vez de systemDevices**:
  /// `FlutterBluePlus.bondedDevices` SÍ funciona de forma confiable en Android:
  /// - Retorna dispositivos emparejados via Android Settings → Bluetooth
  /// - Funciona en TODAS las versiones de Android
  /// - **REQUISITO**: Usuario debe emparejar Smart Band 10 en Settings primero
  ///
  /// **WORKFLOW ESPERADO**:
  /// 1. Usuario empareja Smart Band 10 en Android Settings → Bluetooth
  /// 2. Este método retorna Smart Band 10 en la lista
  /// 3. Llamar device.connect() para conectar TU app al dispositivo
  ///
  /// **Referencias**:
  /// - Issue: https://github.com/chipweinberger/flutter_blue_plus/issues/1226
  /// - Android docs: https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#getBondedDevices()
  Future<List<BluetoothDevice>> getSystemDevices() async {
    try {
      debugPrint('🔍 Getting BONDED devices (paired in Android Settings)...');
      debugPrint('📱 Platform: Android');
      debugPrint('🚀 Using: FlutterBluePlus.bondedDevices');

      // ✅ PASO 1: Obtener dispositivos ya conectados a nivel de sistema (GROUND TRUTH)
      final alreadyConnectedDevices = fbp.FlutterBluePlus.connectedDevices;
      final alreadyConnectedIds = alreadyConnectedDevices
          .map((final d) => d.remoteId.str.toUpperCase())
          .toSet();

      debugPrint(
        '🔍 Already connected devices at system level: ${alreadyConnectedIds.length}',
      );
      for (final d in alreadyConnectedDevices) {
        debugPrint('   ✅ ${d.platformName} (${d.remoteId.str})');
      }

      // ✅ PASO 2: Get bonded (paired) devices - RELIABLE on Android
      // Unlike systemDevices (broken), bondedDevices works consistently
      final bondedDevices = await fbp.FlutterBluePlus.bondedDevices;

      debugPrint('Bonded devices:');
      for (final device in bondedDevices) {
        final deviceId = device.remoteId.str;
        final deviceName = device.platformName.isNotEmpty
            ? device.platformName
            : 'Unknown Device';

        debugPrint('═══════════════════════════════════════════════════');
        debugPrint('📱 Device: $deviceName ($deviceId)');

        // 1️⃣ Estado ANTES de intentar conectar
        final bondStateBefore = await device.bondState.first;
        final isConnectedBefore = device.isConnected;
        final connectionStateBefore = await device.connectionState.first;

        debugPrint('   🔐 Bond State: $bondStateBefore');
        debugPrint('   🔗 Is Connected (sync): $isConnectedBefore');
        debugPrint('   📡 Connection State (stream): $connectionStateBefore');
        debugPrint('   🔄 AutoConnect Enabled: ${device.isAutoConnectEnabled}');

        // 🔧 FIX: Verificar estado REAL con connectedDevices (más confiable)
        final actuallyConnected = alreadyConnectedIds.contains(
          deviceId.toUpperCase(),
        );
        debugPrint(
          '   🎯 Actually connected (system level): $actuallyConnected',
        );

        // 2️⃣ Simplemente cachear los dispositivos bonded sin conectar automáticamente
        if (actuallyConnected) {
          debugPrint('   ✅ Already connected at system level, caching device');
          // 🎯 Cachear el device conectado para uso posterior
          _connectedDevices[deviceId] = device;
        } else {
          debugPrint(
            '   📋 Device bonded but not connected (user can connect manually)',
          );
          // También cacheamos dispositivos bonded aunque no estén conectados
          _connectedDevices[deviceId] = device;
        }

        debugPrint('═══════════════════════════════════════════════════');
      }

      if (bondedDevices.isEmpty) {
        return [];
      }

      // Convert fbp.BluetoothDevice → our BluetoothDevice model
      final bluetoothDevices = <BluetoothDevice>[];

      for (final device in bondedDevices) {
        final deviceId = device.remoteId.str;
        final deviceName = device.platformName.isNotEmpty
            ? device.platformName
            : 'System Device';

        debugPrint('   📱 System Device: $deviceName ($deviceId)');

        // 🎯 CRÍTICO: Cachear el device REAL de bondedDevices para uso posterior
        // Esto evita crear una nueva instancia con fromId() que puede fallar
        _connectedDevices[deviceId] = device;
        debugPrint(
          '   ✅ Cached real fbp.BluetoothDevice instance for $deviceId',
        );

        final bluetoothDevice = BluetoothDevice.fromBasicInfo(
          deviceId: deviceId,
          name: deviceName,
          services: [], // Will be discovered on connection
          rssi: null,
          paired: true,
          isSystemDevice: true, // ✅ Mark as system device
        );

        bluetoothDevices.add(bluetoothDevice);
      }

      debugPrint(
        '✅ Converted ${bluetoothDevices.length} system devices to BluetoothDevice',
      );
      debugPrint(
        '✅ Cached ${bondedDevices.length} real fbp.BluetoothDevice instances',
      );
      return bluetoothDevices;
    } on Exception catch (e, stackTrace) {
      debugPrint('❌ Error getting system devices: $e');
      debugPrint('📜 Stack trace: $stackTrace');
      return [];
    }
  }

  // ❌ REMOVED: pairDevice() function - REDUNDANT
  //
  // Razón: En Android, el pairing ocurre automáticamente durante bleDevice.connect()
  // No necesitamos una función separada para pairing - connectDevice() ya lo incluye
  //
  // Migración: Usar connectDevice() directamente que ya incluye pairing implícito

  /// 🔌 Conectar BLE básico SIN autenticación (para uso interno)
  ///
  /// Solo establece la conexión BLE y descubre servicios.
  /// NO ejecuta autenticación Xiaomi ni lógica de alto nivel.
  ///
  /// **Uso interno**: XiaomiAuthService para reconexión limpia
  Future<fbp.BluetoothDevice> connectBleOnly(final String deviceId) async {
    try {
      debugPrint('🔌 Establishing basic BLE connection: $deviceId');

      final bleDevice = await getBluetoothDeviceAsync(deviceId);

      if (!bleDevice.isConnected) {
        await bleDevice.connect(mtu: null, license: fbp.License.free);
        debugPrint('✅ BLE connected');
      } else {
        debugPrint('✅ Already connected');
      }

      // Discover services to verify connection is real
      final services = await bleDevice.discoverServices();
      debugPrint('✅ Services discovered: ${services.length}');

      return bleDevice;
    } catch (e) {
      debugPrint('❌ BLE connection failed: $e');
      rethrow;
    }
  }

  /// ✅ SIMPLIFICADO: Conectar a dispositivo con flutter_blue_plus directo
  Future<ConnectionResult> connectDevice(final String deviceId) async {
    try {
      debugPrint('🔗 Connecting to device: $deviceId (includes auto-pairing)');
      final stopwatch = Stopwatch()..start();

      // 🧼 CRÍTICO: Limpiar cache GATT antes de conectar (reconexiones)
      if (_connectedDevices.containsKey(deviceId)) {
        debugPrint('🧼 Previous connection detected, refreshing GATT cache...');
        await _refreshGattCache(deviceId);
      }

      // ✅ Paso 1: Obtener dispositivo y conectar (incluye pairing automático)
      final bleDevice = await getBluetoothDeviceAsync(deviceId);
      _connectedDevices[deviceId] = bleDevice;

      if (!bleDevice.isConnected) {
        // 🔧 Usar autoConnect=false para evitar problemas de cache
        // Según la investigación, autoConnect puede agravar problemas de cache GATT
        // Note: flutter_blue_plus handles pairing automatically during connect()
        await bleDevice.connect(mtu: null, license: fbp.License.free);
        debugPrint('✅ BLE connection established (pairing included)');
      } else {
        debugPrint('✅ Device already connected, reusing connection');
      }

      // 🔧 Configurar listeners oficiales de flutter_blue_plus
      _setupServicesResetListener(deviceId, bleDevice);
      _setupConnectionStateListener(deviceId, bleDevice);

      // PASO 2: Detectar si requiere autenticación Xiaomi
      final deviceName =
          _scannedDevices[deviceId]?.name ?? bleDevice.platformName;
      final deviceConfig = await SupportedDevicesConfig.detectDevice(
        deviceName,
      );

      if (deviceConfig != null && deviceConfig.requiresAuth) {
        debugPrint('✅ Xiaomi device detected, starting authentication...');

        // Cargar implementation y crear auth service
        final deviceImpl = await DeviceImplementationLoader.load(
          deviceConfig.deviceType,
        );
        final authService = XiaomiAuthService(
          deviceId: deviceId,
          bleService: this,
          deviceImplementation: deviceImpl,
        );
        _xiaomiAuthServices[deviceId] = authService;
        _deviceTypes[deviceId] = deviceConfig.deviceType;

        // Código simplificado para reemplazar líneas 784-827
        // Autenticar directamente (XiaomiAuthService hará discoverServices internamente)
        final authResult = await authService.authenticate();

        if (!authResult.success) {
          // Verificar si es problema de authKey faltante
          if (authResult.errorMessage?.contains('No credentials found') ==
              true) {
            debugPrint('⚠️ No authKey found, need extraction');
            return ConnectionResult.failure(deviceId, 'authkey_required');
          }

          // Otros errores de autenticación
          debugPrint('❌ Authentication failed: ${authResult.errorMessage}');
          _xiaomiAuthServices.remove(deviceId);
          return ConnectionResult.failure(
            deviceId,
            authResult.errorMessage ?? 'Authentication failed',
          );
        }

        debugPrint('✅ Authentication successful!');
        stopwatch.stop();
        return ConnectionResult.success(
          deviceId,
          connectionTime: stopwatch.elapsed,
        );
      }

      // PASO 3: Dispositivo no-Xiaomi (genérico)
      debugPrint('📱 Generic BLE device, no authentication needed');
      _deviceTypes[deviceId] = 'generic';
      debugPrint(
        '✅ Connection completed in ${stopwatch.elapsedMilliseconds}ms',
      );

      return ConnectionResult.success(
        deviceId,
        connectionTime: stopwatch.elapsed,
      );
    } on PlatformException catch (e) {
      final errorCode = _parseGattErrorCode(e.message);
      debugPrint('❌ Connection failed: $e (code: $errorCode)');

      // 🚨 Detectar si es un error de cache GATT corrupto
      if (_isGattCacheError(errorCode, e.message)) {
        debugPrint(
          '🧼 GATT cache error detected, attempting refresh and retry...',
        );
        await _refreshGattCache(deviceId);

        // Opción: Podríamos reintentar aquí, pero mejor dejamos que sea manual
        // para evitar bucles infinitos
        debugPrint('💡 Try reconnecting after GATT cache refresh');
      }

      return ConnectionResult.failure(
        deviceId,
        e.message ?? e.toString(),
        errorCode: errorCode,
      );
    } on Exception catch (e) {
      debugPrint('❌ Connection failed: $e');

      // 🚨 También verificar errores generales que podrían ser cache
      if (_isGattCacheError(null, e.toString())) {
        debugPrint('🧼 Potential GATT cache issue detected in generic error');
        await _refreshGattCache(deviceId);
      }

      return ConnectionResult.failure(deviceId, e.toString());
    }
  }

  /// 🧼 Limpiar cache GATT corrupto (Solución común para Android BLE)
  /// Esta función resuelve el problema donde después de una desconexión,
  /// las reconexiones fallan por cache GATT corrupto
  Future<void> _refreshGattCache(final String deviceId) async {
    try {
      debugPrint(
        '🧼 Clearing GATT cache using official flutter_blue_plus method: $deviceId',
      );

      final bleDevice = _getBluetoothDevice(deviceId);

      // 🔧 Método 1: Usar el método oficial clearGattCache() de flutter_blue_plus
      try {
        await bleDevice.clearGattCache();
        debugPrint('✅ Official clearGattCache() completed successfully');
      } on Exception catch (e) {
        debugPrint('⚠️ Official clearGattCache() failed: $e');

        // 🔧 Fallback: Método manual si el oficial falla
        if (bleDevice.isConnected) {
          await bleDevice.discoverServices();
          debugPrint('✅ Fallback: manual service rediscovery completed');
        }
      }

      // 🔧 Método 2: Limpiar cache local de nuestro servicio
      _discoveredServices.remove(deviceId);

      // 🔧 Método 3: Cancelar subscriptions para evitar referencias stale
      final keysToRemove = _characteristicSubscriptions.keys
          .where((final key) => key.startsWith('$deviceId:'))
          .toList();

      for (final key in keysToRemove) {
        await _characteristicSubscriptions[key]?.cancel();
        _characteristicSubscriptions.remove(key);
      }

      debugPrint('✅ GATT cache cleanup completed for $deviceId');
    } on Exception catch (e) {
      debugPrint('❌ Error refreshing GATT cache: $e');
    }
  }

  /// Configurar listener oficial onServicesReset de flutter_blue_plus
  void _setupServicesResetListener(
    final String deviceId,
    final fbp.BluetoothDevice bleDevice,
  ) {
    // Usar el stream oficial para detectar cuando los servicios cambian
    bleDevice.onServicesReset.listen(
      (_) {
        debugPrint(
          '🔄 Services Reset detected for $deviceId - re-discovering services',
        );
        // Ejecutar redescubrimiento de forma asíncrona pero no bloquear el listener
        _handleServicesReset(deviceId, bleDevice);
      },
      onError: (final error) {
        debugPrint('❌ onServicesReset stream error for $deviceId: $error');
      },
    );
  }

  /// Manejar reset de servicios de forma asíncrona
  Future<void> _handleServicesReset(
    final String deviceId,
    final fbp.BluetoothDevice bleDevice,
  ) async {
    try {
      // Re-descubrir servicios cuando cambian (método oficial)
      await bleDevice.discoverServices();
      debugPrint('✅ Service rediscovery completed after Services Reset');
    } on Exception catch (e) {
      debugPrint('❌ Error re-discovering services after reset: $e');
    }
  }

  /// Configurar listener oficial connectionState de flutter_blue_plus
  void _setupConnectionStateListener(
    final String deviceId,
    final fbp.BluetoothDevice bleDevice,
  ) {
    // Usar el stream oficial para monitorear estados de conexión
    bleDevice.connectionState.listen(
      (final fbp.BluetoothConnectionState state) async {
        debugPrint('🔗 Connection state changed for $deviceId: $state');

        if (state == fbp.BluetoothConnectionState.disconnected) {
          // Usar la propiedad oficial disconnectReason de flutter_blue_plus
          final disconnectReason = bleDevice.disconnectReason;
          if (disconnectReason != null) {
            debugPrint(
              '📊 Official disconnect reason: ${disconnectReason.code} - ${disconnectReason.description}',
            );

            // Detectar problemas de GATT cache usando códigos oficiales
            if (_isGattCacheError(
              disconnectReason.code?.toString(),
              disconnectReason.description,
            )) {
              debugPrint(
                '🧼 GATT cache corruption detected, refreshing cache...',
              );
              await _refreshGattCache(deviceId);
            }
          }

          // Según la documentación oficial: "you must always re-discover services after disconnection!"
          debugPrint(
            '🔄 Connection lost - will need to re-discover services on next connect',
          );
          _discoveredServices.remove(deviceId);
        }
      },
      onError: (final error) {
        debugPrint('❌ connectionState stream error for $deviceId: $error');
      },
    );
  }

  /// Desconectar dispositivo (SOLO desconexión BLE de bajo nivel)
  Future<void> disconnectDevice(final String deviceId) async {
    try {
      debugPrint('🔌 Disconnecting BLE device: $deviceId');

      // Cancelar monitoreo de conexión
      stopConnectionMonitoring(deviceId);

      // 🔧 NUEVO: Limpiar cache de servicios descubiertos
      _discoveredServices.remove(deviceId);

      // 🔧 NUEVO: Cancelar todas las subscriptions de características de este dispositivo
      final keysToRemove = _characteristicSubscriptions.keys
          .where((final key) => key.startsWith('$deviceId:'))
          .toList();

      for (final key in keysToRemove) {
        debugPrint('🧹 Canceling characteristic subscription: $key');
        await _characteristicSubscriptions[key]?.cancel();
        _characteristicSubscriptions.remove(key);
      }

      // Desconectar Bluetooth usando flutter_blue_plus
      final bleDevice = _getBluetoothDevice(deviceId);
      await bleDevice.disconnect();

      // 🧼 CRÍTICO: Limpiar cache GATT después de desconexión
      await _refreshGattCache(deviceId);

      debugPrint('✅ BLE device $deviceId disconnected successfully');
    } on Exception catch (e) {
      debugPrint('❌ Error disconnecting BLE device $deviceId: $e');
    }
  }

  /// Obtener estado detallado de un dispositivo BLE puro
  Future<WearableDevice> getDeviceStatus(final String deviceId) async {
    try {
      // Crear instancia BLE pura sin conocer WearableDevice
      final bleDevice = _getBluetoothDevice(deviceId);

      // Verificar conexión BLE
      final isConnected = bleDevice.isConnected;

      return WearableDevice(
        deviceId: deviceId,
        name: 'BLE Device', // Default name
        deviceTypeId: 'smartwatch',
        connectionState: isConnected
            ? ConnectionState.connected
            : ConnectionState.disconnected,
        rssi: -60, // Default RSSI for BLE
        lastSeen: DateTime.now(),
      );
    } on Exception catch (e) {
      debugPrint('❌ Error getting BLE device status: $e');
      return WearableDevice(
        deviceId: deviceId,
        name: 'BLE Device',
        deviceTypeId: 'smartwatch',
        connectionState: ConnectionState.error,
        rssi: -100, // Very weak signal
        lastSeen: DateTime.now(),
      );
    }
  }

  ///
  /// **NEW STRATEGY**:
  /// - Battery reading is now EXCLUSIVELY done via BT_CLASSIC SPP protocol
  /// - Handled by XiaomiConnectionOrchestrator._readBatteryViaBtClassic()
  /// - Called AFTER authentication completes successfully
  /// - No BLE characteristic access during or immediately after auth
  ///
  /// **Migration Path**:
  /// - getDeviceStatus() → Should use orchestrator.batteryStream instead
  /// - enrichDeviceMetadata() → Skip battery reading during enrichment
  /// - Any UI code → Subscribe to orchestrator.batteryStream  /// Monitorear estado de conexión usando Universal BLE connectionStream con callbacks

  /// Detener monitoreo de conexión para un dispositivo específico
  void stopConnectionMonitoring(final String deviceId) {
    _connectionStreams[deviceId]?.cancel();
    _connectionStreams.remove(deviceId);

    debugPrint('📡 Stopped connection monitoring for device: $deviceId');
  }

  /// Descubrir servicios BLE de un dispositivo (debe estar conectado)
  Future<List<String>> discoverServices(final String deviceId) async {
    try {
      debugPrint('🔍 Discovering BLE services for device: $deviceId');

      // Crear instancia BLE pura
      final bleDevice = _getBluetoothDevice(deviceId);

      // Verificar conexión BLE
      final isConnected = bleDevice.isConnected;
      if (!isConnected) {
        debugPrint('⚠️ Device $deviceId not connected, connecting first...');
        // ⚠️ mtu: null es REQUERIDO cuando se usa autoConnect (incompatible)
        await bleDevice.connect(
          autoConnect: true,
          mtu: null, // Required with autoConnect
          timeout: const Duration(seconds: 15),
          license: fbp.License.free,
        );
        debugPrint('🔗 Connected to device for service discovery');
      }

      // Descubrir servicios usando flutter_blue_plus
      final services = await bleDevice.discoverServices();
      final serviceUuids =
          services.map((final s) => s.serviceUuid.toString()).toList();

      debugPrint('✅ Discovered ${serviceUuids.length} services for $deviceId');
      for (final uuid in serviceUuids) {
        final shortUuid = uuid.length >= 8
            ? uuid.substring(4, 8).toUpperCase()
            : uuid.toUpperCase();
        debugPrint('   📡 $uuid (short: $shortUuid)');
      }

      return serviceUuids;
    } on Exception catch (e) {
      debugPrint('❌ Error discovering services for $deviceId: $e');
      return [];
    }
  }

  /// 📝 Escribir valor a una característica BLE específica
  ///
  /// Método público para que upper services (como XiaomiKeepAliveService)
  /// puedan escribir comandos BLE sin importar universal_ble directamente.
  ///
  /// [deviceId] - ID del dispositivo BLE
  /// [serviceUuid] - UUID del servicio (puede ser short UUID como '180D' o full UUID)
  /// [characteristicUuid] - UUID de la característica
  /// [value] - Bytes a escribir
  /// [withResponse] - Si esperar respuesta del dispositivo (default: true)

  /// 🔔 Habilitar/deshabilitar notificaciones en una característica BLE
  ///
  /// Método público para que upper services puedan suscribirse a notificaciones.
  ///
  /// [deviceId] - ID del dispositivo BLE
  /// [serviceUuid] - UUID del servicio
  /// [characteristicUuid] - UUID de la característica
  /// [enable] - true para habilitar, false para deshabilitar
  Future<void> setNotifiable({
    required final String deviceId,
    required final String serviceUuid,
    required final String characteristicUuid,
    required final bool enable,
  }) async {
    try {
      debugPrint(
        '🐛 DEBUG: setNotifiable called - ${enable ? 'ENABLE' : 'DISABLE'} for $characteristicUuid on $deviceId',
      );
      debugPrint('🐛 DEBUG: Service UUID: $serviceUuid');

      // Crear instancia BLE pura
      final bleDevice = _getBluetoothDevice(deviceId);

      // Verificar conexión BLE
      final isConnected = bleDevice.isConnected;
      debugPrint('🐛 DEBUG: Device isConnected: $isConnected');
      if (!isConnected) {
        throw Exception('Device $deviceId not connected');
      }

      // 🎯 Expandir UUIDs cortos a completos para flutter_blue_plus
      final fullServiceUuid = BleUuidUtils.expandUuid(serviceUuid);
      final fullCharUuid = BleUuidUtils.expandUuid(characteristicUuid);

      debugPrint(
        '🔍 Expanded UUIDs: $serviceUuid → $fullServiceUuid, $characteristicUuid → $fullCharUuid',
      );

      // Obtener la característica
      debugPrint(
        '🐛 DEBUG: Getting characteristic $fullCharUuid from service $fullServiceUuid...',
      );

      // 🔧 CRITICAL FIX: Use cached services to avoid re-triggering GATT_INTERNAL_ERROR (129)
      // on Xiaomi devices that reject re-subscription to Service Changed (2a05)
      List<fbp.BluetoothService> services;
      if (_discoveredServices.containsKey(deviceId)) {
        debugPrint('✅ Using cached services for $deviceId');
        services = _discoveredServices[deviceId]!;
      } else {
        debugPrint('🔍 Discovering services for $deviceId (first time)...');
        services = await bleDevice.discoverServices();
        _discoveredServices[deviceId] = services;
        debugPrint('   ✅ Cached ${services.length} services');
      }

      // Buscar servicio (with UUID normalization - same as _discoverCharacteristics)
      final normalizedServiceTarget = _normalizeUuidForComparison(
        fullServiceUuid,
      );
      debugPrint(
        '🔍 Looking for service: $fullServiceUuid → normalized: $normalizedServiceTarget',
      );

      final service = services.firstWhere(
        (final s) =>
            _normalizeUuidForComparison(s.serviceUuid.toString()) ==
            normalizedServiceTarget,
        orElse: () => throw Exception(
          'Service "$fullServiceUuid" not found. Available services: ${services.map((final s) => s.serviceUuid.toString()).join(", ")}',
        ),
      );

      debugPrint('✅ Service found: ${service.serviceUuid}');

      // Buscar característica (with UUID normalization)
      final normalizedCharTarget = _normalizeUuidForComparison(fullCharUuid);
      debugPrint(
        '🔍 Looking for characteristic: $fullCharUuid → normalized: $normalizedCharTarget',
      );

      final characteristic = service.characteristics.firstWhere(
        (final c) =>
            _normalizeUuidForComparison(c.characteristicUuid.toString()) ==
            normalizedCharTarget,
        orElse: () => throw Exception(
          'Characteristic "$fullCharUuid" not found in service "$fullServiceUuid". Available: ${service.characteristics.map((final c) => c.characteristicUuid.toString()).join(", ")}',
        ),
      );
      debugPrint('🐛 DEBUG: Characteristic obtained successfully');

      // Habilitar/deshabilitar notificaciones
      if (enable) {
        debugPrint('🐛 DEBUG: Calling characteristic.setNotifyValue(true)...');
        await characteristic.setNotifyValue(true);
        debugPrint('🐛 DEBUG: Subscribe completed');

        debugPrint(
          '🐛 DEBUG: Setting up onValueReceived listener for $characteristicUuid...',
        );

        // ✅ CRITICAL FIX: Cancel previous subscription if exists (prevent duplicates)
        final subscriptionKey = '$deviceId:$characteristicUuid';
        if (_characteristicSubscriptions.containsKey(subscriptionKey)) {
          debugPrint('🧹 Canceling previous subscription for $subscriptionKey');
          await _characteristicSubscriptions[subscriptionKey]?.cancel();
          _characteristicSubscriptions.remove(subscriptionKey);
        }

        // ✅ Mejor práctica: Auto-cleanup cuando hay error o disconnect
        final subscription = characteristic.onValueReceived.listen(
          (final value) {
            // 🔴 TEST #13: LOG COMPLETAMENTE RAW - SIN FILTROS
            debugPrint(
              '🐛 DEBUG: [$characteristicUuid] RAW notification! Length: ${value.length}, Bytes: ${value.toList()}',
            );

            // 🆕 EMIT to rawBleDataStream for upper services to consume
            final bleDataPacket = BleDataPacket(
              deviceId: deviceId,
              serviceUuid: serviceUuid,
              characteristicUuid: characteristicUuid,
              rawData: value.toList(),
              timestamp: DateTime.now(),
            );
            _rawBleDataController.add(bleDataPacket);
          },
          onError: (final error, final stackTrace) {
            // 🔴 TEST #13: LOG EXPLÍCITO DE ERRORES
            debugPrint(
              '🐛 DEBUG: [$characteristicUuid] Listener ERROR: $error',
            );
          },
          onDone: () {
            // 🔴 TEST #13: LOG CUANDO LISTENER SE CIERRA
            debugPrint('🐛 DEBUG: [$characteristicUuid] Listener DONE');
            _characteristicSubscriptions.remove(subscriptionKey); // Cleanup
          },
          cancelOnError:
              false, // 🔴 TEST #13: NO CANCELAR EN ERROR - ver si hay errores silenciosos
        );

        // ✅ Store subscription for later cleanup
        _characteristicSubscriptions[subscriptionKey] = subscription;

        // ✅ Auto-cleanup cuando el dispositivo se desconecta
        bleDevice.cancelWhenDisconnected(subscription);

        debugPrint('✅ Notifications enabled for $characteristicUuid');
      } else {
        // Disable notifications - also cleanup subscription
        await characteristic.setNotifyValue(false);

        final subscriptionKey = '$deviceId:$characteristicUuid';
        if (_characteristicSubscriptions.containsKey(subscriptionKey)) {
          debugPrint(
            '🧹 Canceling subscription for $subscriptionKey (disable)',
          );
          await _characteristicSubscriptions[subscriptionKey]?.cancel();
          _characteristicSubscriptions.remove(subscriptionKey);
        }

        debugPrint('✅ Notifications disabled for $characteristicUuid');
      }
    } on Exception catch (e) {
      debugPrint('❌ Error setting notifiable: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 🆕 GENERIC SERVICE SUBSCRIPTION (NEW ARCHITECTURE)
  // ============================================================================

  /// 🎯 API SÚPER SIMPLE - Suscribirse a un data type usando device implementation JSONs
  ///
  /// Este es el método ÚNICO y PRINCIPAL para suscribirse a características.
  /// Detecta automáticamente el device type, carga su implementation JSON,
  /// y se suscribe a la característica correcta.
  ///
  /// [deviceId] - ID del dispositivo BLE
  /// [dataType] - Tipo de dato ('heart_rate', 'battery', 'spo2', 'temperature', etc.)
  /// [onData] - Callback para recibir datos
  /// [onError] - Callback opcional para errores
  ///
  /// Returns: StreamSubscription o null si no se encuentra el data type
  ///
  /// Ejemplo:
  /// ```dart
  /// await bleService.subscribeToDataType(
  ///   deviceId: 'XX:XX:XX:XX:XX:XX',
  ///   dataType: 'heart_rate',
  ///   onData: (data) => print('HR: $data'),
  /// );
  /// ```
  Future<StreamSubscription<BleDataPacket>?> subscribeToDataType({
    required final String deviceId,
    required final String dataType,
    required final Function(List<int> data) onData,
    final Function(Object error)? onError,
  }) async {
    try {
      debugPrint(
        '[BleService] 🎯 Subscribing to $dataType for device $deviceId',
      );

      // 1️⃣ Obtener device type (con cache) o fallback a generic
      final deviceType = _deviceTypes[deviceId] ?? 'generic';
      debugPrint('[BleService] 📱 Device type: $deviceType');

      // 2️⃣ Cargar device implementation (con fallback automático a generic)
      final deviceImpl = await DeviceImplementationLoader.loadOrGeneric(
        deviceType,
      );

      // 3️⃣ Buscar característica usando el index (O(1) lookup)
      final charInfo = deviceImpl.getCharacteristicForDataType(dataType);

      if (charInfo == null) {
        debugPrint(
          '[BleService] ❌ Data type "$dataType" not found in $deviceType implementation',
        );
        debugPrint(
          '[BleService]  Supported data types: ${deviceImpl.getSupportedDataTypes().join(', ')}',
        );
        onError?.call(
          Exception(
            'Data type "$dataType" not supported by $deviceType device',
          ),
        );
        return null;
      }

      debugPrint(
        '[BleService] ✅ Found characteristic: ${charInfo.characteristicName} '
        '(${charInfo.characteristicUuid})',
      );

      // 4️⃣ Suscribirse usando el método genérico de bajo nivel
      return await _subscribeToCharacteristic(
        deviceId: deviceId,
        serviceUuid: charInfo.serviceUuid,
        characteristicUuid: charInfo.characteristicUuid,
        onData: onData,
        onError: onError,
      );
    } on Exception catch (e) {
      debugPrint('[BleService] ❌ Error subscribing to $dataType: $e');
      onError?.call(e);
      return null;
    }
  }

  /// Desuscribirse de un data type
  ///
  /// [deviceId] - ID del dispositivo BLE
  /// [dataType] - Tipo de dato ('heart_rate', 'battery', 'spo2', etc.)
  ///
  /// Ejemplo:
  /// ```dart
  /// await bleService.unsubscribeFromDataType(
  ///   deviceId: 'XX:XX:XX:XX:XX:XX',
  ///   dataType: 'heart_rate',
  /// );
  /// ```
  Future<void> unsubscribeFromDataType({
    required final String deviceId,
    required final String dataType,
  }) async {
    try {
      debugPrint(
        '[BleService] 🛑 Unsubscribing from $dataType for device $deviceId',
      );

      // 1️⃣ Obtener device type (con cache) o fallback a generic
      final deviceType = _deviceTypes[deviceId] ?? 'generic';
      debugPrint('[BleService] 📱 Device type: $deviceType');

      // 2️⃣ Cargar device implementation (con fallback automático a generic)
      final deviceImpl = await DeviceImplementationLoader.loadOrGeneric(
        deviceType,
      );

      // 3️⃣ Buscar característica usando el index (O(1) lookup)
      final charInfo = deviceImpl.getCharacteristicForDataType(dataType);

      if (charInfo == null) {
        debugPrint(
          '[BleService] ❌ Data type "$dataType" not found in $deviceType implementation',
        );
        throw Exception(
          'Data type "$dataType" not supported by $deviceType device',
        );
      }

      debugPrint(
        '[BleService] ✅ Found characteristic: ${charInfo.characteristicName} '
        '(${charInfo.characteristicUuid})',
      );

      // 4️⃣ Desuscribirse usando setNotifiable con enable: false
      await setNotifiable(
        deviceId: deviceId,
        serviceUuid: charInfo.serviceUuid,
        characteristicUuid: charInfo.characteristicUuid,
        enable: false,
      );

      debugPrint('[BleService] ✅ Successfully unsubscribed from $dataType');
    } on Exception catch (e) {
      debugPrint('[BleService] ❌ Error unsubscribing from $dataType: $e');
      rethrow;
    }
  }

  /// 🔔 Suscribirse a notificaciones de una característica específica (MÉTODO PRIVADO)
  ///
  /// Método genérico de BAJO NIVEL para suscribirse a características BLE.
  /// ⚠️ NO usar directamente - usar subscribeToDataType() en su lugar.
  ///
  /// [deviceId] - ID del dispositivo BLE
  /// [serviceUuid] - UUID del servicio (puede ser short UUID como 'FE95')
  /// [characteristicUuid] - UUID de la característica
  /// [onData] - Callback para recibir datos de notificaciones
  /// [onError] - Callback opcional para errores
  ///
  /// Returns: StreamSubscription para cancelar la suscripción más tarde
  Future<StreamSubscription<BleDataPacket>> _subscribeToCharacteristic({
    required final String deviceId,
    required final String serviceUuid,
    required final String characteristicUuid,
    required final Function(List<int> data) onData,
    final Function(Object error)? onError,
  }) async {
    try {
      debugPrint(
        '[BleService] 📡 Subscribing to $characteristicUuid on $deviceId',
      );

      // Habilitar notificaciones en la característica
      await setNotifiable(
        deviceId: deviceId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        enable: true,
      );

      // Filtrar el stream de datos crudos para esta característica específica
      final subscription = rawBleDataStream
          .where(
        (final packet) =>
            packet.deviceId == deviceId &&
            packet.characteristicUuid.toUpperCase().contains(
                  characteristicUuid.toUpperCase().replaceAll('-', ''),
                ),
      )
          .listen(
        (final packet) {
          debugPrint(
            '[BleService] 📨 Data for $characteristicUuid: ${packet.rawData.length} bytes',
          );
          onData(packet.rawData);
        },
        onError: (final error) {
          debugPrint(
            '[BleService] ❌ Subscription error for $characteristicUuid: $error',
          );
          onError?.call(error);
        },
      );

      debugPrint(
        '[BleService] ✅ Subscribed to $characteristicUuid successfully',
      );

      return subscription;
    } on Exception catch (e) {
      debugPrint('[BleService] ❌ Error subscribing to characteristic: $e');
      rethrow;
    }
  }

  /// Limpiar recursos y cerrar streams
  void dispose() {
    _isInitialized = false; // Permitir re-inicialización después del dispose
    _rawBleDeviceController.close();
    _connectionStateController.close();
    _rawBleDataController.close();

    // Cancelar streams de conexión
    for (final subscription in _connectionStreams.values) {
      subscription.cancel();
    }
    _connectionStreams.clear();

    debugPrint('🔵 BleService disposed');
  }

  /// ✅ FASE C: Parsear código de error GATT desde PlatformException
  ///
  /// Ejemplos de mensajes:
  /// - "GATT Error 147" → "147"
  /// - "Error 133" → "133"
  /// - "Connection failed with error code 19" → "19"
  /// - "Unknown error" → null
  static String? _parseGattErrorCode(final String? message) {
    if (message == null) return null;

    // Pattern 1: "GATT Error 147"
    final gattPattern = RegExp(r'GATT Error (\d+)');
    final gattMatch = gattPattern.firstMatch(message);
    if (gattMatch != null) {
      return gattMatch.group(1);
    }

    // Pattern 2: "Error 133"
    final errorPattern = RegExp(r'Error (\d+)');
    final errorMatch = errorPattern.firstMatch(message);
    if (errorMatch != null) {
      return errorMatch.group(1);
    }

    // Pattern 3: "error code 19" (case insensitive)
    final codePattern = RegExp(r'error code (\d+)', caseSensitive: false);
    final codeMatch = codePattern.firstMatch(message);
    if (codeMatch != null) {
      return codeMatch.group(1);
    }

    // Pattern 4: "REMOTE_USER_TERMINATED_CONNECTION" (status 19)
    if (message.contains('REMOTE_USER_TERMINATED_CONNECTION')) {
      return '19';
    }

    // Pattern 5: "GATT_INTERNAL_ERROR" (status 129)
    if (message.contains('GATT_INTERNAL_ERROR')) {
      return '129';
    }

    // Pattern 6: "GATT_ERROR" (status 133)
    if (message.contains('GATT_ERROR')) {
      return '133';
    }

    // No match found
    return null;
  }

  /// 🚨 Detectar si un error GATT indica cache corrupto
  /// Basado en investigación de Stack Overflow sobre Android BLE
  static bool _isGattCacheError(
    final String? errorCode,
    final String? message,
  ) {
    if (errorCode == null && message == null) return false;

    // Códigos de error GATT que indican cache corrupto
    final cacheErrorCodes = ['19', '129', '133'];
    if (errorCode != null && cacheErrorCodes.contains(errorCode)) {
      return true;
    }

    // Mensajes de error que indican cache corrupto
    final cacheErrorMessages = [
      'REMOTE_USER_TERMINATED_CONNECTION',
      'GATT_INTERNAL_ERROR',
      'GATT_ERROR',
      'device is disconnected',
      'service discovery failed',
    ];

    if (message != null) {
      for (final errorMsg in cacheErrorMessages) {
        if (message.toLowerCase().contains(errorMsg.toLowerCase())) {
          return true;
        }
      }
    }

    return false;
  }

  // ============================================================================
  // BLE Characteristic Abstraction Layer (for auth protocols)
  // ============================================================================

  // ❌ DEPRECATED: subscribeToNotifications() eliminado
  // ✅ USE: setNotifiable() instead - it properly sets up onValueReceived listener
  // Razón: subscribeToNotifications() solo hacía setNotifyValue(true) pero NO configuraba
  // el listener de characteristic.onValueReceived, por lo que nunca recibíamos notificaciones.

  /// Unsubscribes from notifications on a specific characteristic.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID
  /// - [characteristicUuid]: Characteristic UUID
  ///
  /// **Returns:**
  /// - `true` if unsubscription succeeded
  /// - `false` if failed

  /// Writes data to a specific characteristic.
  ///
  /// **Purpose:** Abstraction for authentication protocol writes
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID
  /// - [characteristicUuid]: Characteristic UUID
  /// - [data]: Bytes to write
  ///
  /// **Returns:**
  /// - `true` if write succeeded
  /// - `false` if failed
  ///
  /// **Example:**
  /// Request MTU (Maximum Transmission Unit) size
  ///
  /// Larger MTU allows sending bigger packets without fragmentation.
  /// Typical values: 23 (default), 247 (Gadgetbridge), 512 (max Android)
  ///
  /// **Example:**
  /// ```dart
  /// final mtu = await bleService.requestMtu(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   mtu: 247,
  /// );
  /// ```
  Future<int> requestMtu({
    required final String deviceId,
    required final int mtu,
  }) async {
    try {
      final device = _connectedDevices[deviceId];
      if (device == null) {
        debugPrint('❌ Device not connected: $deviceId');
        return 23; // Default MTU
      }

      debugPrint('📡 Requesting MTU $mtu for $deviceId...');
      final negotiatedMtu = await device.requestMtu(mtu);
      debugPrint('✅ MTU negotiated: $negotiatedMtu bytes');

      return negotiatedMtu;
    } on Exception catch (e) {
      debugPrint('❌ MTU request failed: $e');
      return 23; // Return default MTU on failure
    }
  }

  /// Read data from a BLE characteristic (one-shot read)
  ///
  /// Performs a single read operation from a BLE characteristic.
  /// Useful for reading static values like battery level, device info, etc.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID (can be short UUID like 'FE95')
  /// - [characteristicUuid]: Characteristic UUID
  ///
  /// **Returns:**
  /// - List&lt;int&gt; with the read data bytes if successful
  /// - `null` if read failed or device not connected
  ///
  /// **Example:**
  /// ```dart
  /// // Read battery level (BLE Battery Service 0x2A19)
  /// final batteryBytes = await bleService.readCharacteristic(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   serviceUuid: '180F',
  ///   characteristicUuid: '2A19',
  /// );
  /// if (batteryBytes != null) {
  ///   final batteryLevel = batteryBytes[0]; // 0-100%
  /// }
  /// ```
  Future<List<int>?> readCharacteristic({
    required final String deviceId,
    required final String serviceUuid,
    required final String characteristicUuid,
  }) async {
    try {
      final device = _connectedDevices[deviceId];
      if (device == null) {
        debugPrint('❌ Device not connected: $deviceId');
        return null;
      }

      // 🔧 OPTIMIZACIÓN: Usar cache de servicios o descubrir solo si no están en cache
      List<fbp.BluetoothService> services;
      if (_discoveredServices.containsKey(deviceId)) {
        services = _discoveredServices[deviceId]!;
      } else {
        services = await device.discoverServices();
        _discoveredServices[deviceId] = services; // Cache para futuros reads
        debugPrint(
          '🔍 Discovered and cached ${services.length} services for $deviceId',
        );
      }

      // Find service (with UUID normalization)
      final normalizedServiceTarget = _normalizeUuidForComparison(serviceUuid);
      final service = services.firstWhere(
        (final s) =>
            _normalizeUuidForComparison(s.uuid.toString()) ==
            normalizedServiceTarget,
        orElse: () => throw Exception('Service not found: $serviceUuid'),
      );

      // Find characteristic (with UUID normalization)
      final normalizedCharTarget = _normalizeUuidForComparison(
        characteristicUuid,
      );
      final characteristic = service.characteristics.firstWhere(
        (final c) =>
            _normalizeUuidForComparison(c.uuid.toString()) ==
            normalizedCharTarget,
        orElse: () =>
            throw Exception('Characteristic not found: $characteristicUuid'),
      );

      // ✅ Read characteristic value
      final value = await characteristic.read();

      debugPrint(
        '📥 Read ${value.length} bytes from $deviceId / ${characteristicUuid.substring(0, 8)}...',
      );

      return value;
    } on Exception catch (e) {
      debugPrint('❌ Failed to read characteristic: $e');
      return null;
    }
  }

  /// Write data to a BLE characteristic
  ///
  /// **Example:**
  /// ```dart
  /// final written = await bleService.writeCharacteristic(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   serviceUuid: '0000FE95-...',
  ///   characteristicUuid: '00000051-...',
  ///   data: protobufBytes,
  /// );
  /// ```
  Future<bool> writeCharacteristic({
    required final String deviceId,
    required final String serviceUuid,
    required final String characteristicUuid,
    required final List<int> data,
    final bool withoutResponse =
        false, // ✅ NUEVO: soporte para WRITE_NO_RESPONSE
  }) async {
    try {
      final device = _connectedDevices[deviceId];
      if (device == null) {
        debugPrint('❌ Device not connected: $deviceId');
        return false;
      }

      // 🔧 OPTIMIZACIÓN: Usar cache de servicios o descubrir solo si no están en cache
      List<fbp.BluetoothService> services;
      if (_discoveredServices.containsKey(deviceId)) {
        services = _discoveredServices[deviceId]!;
      } else {
        services = await device.discoverServices();
        _discoveredServices[deviceId] = services; // Cache para futuros writes
        debugPrint(
          '🔍 Discovered and cached ${services.length} services for $deviceId',
        );
      }

      // Find service (with UUID normalization)
      final normalizedServiceTarget = _normalizeUuidForComparison(serviceUuid);
      final service = services.firstWhere(
        (final s) =>
            _normalizeUuidForComparison(s.uuid.toString()) ==
            normalizedServiceTarget,
        orElse: () => throw Exception('Service not found: $serviceUuid'),
      );

      // Find characteristic (with UUID normalization)
      final normalizedCharTarget = _normalizeUuidForComparison(
        characteristicUuid,
      );
      final characteristic = service.characteristics.firstWhere(
        (final c) =>
            _normalizeUuidForComparison(c.uuid.toString()) ==
            normalizedCharTarget,
        orElse: () =>
            throw Exception('Characteristic not found: $characteristicUuid'),
      );

      // ✅ ACTUALIZADO: Usar writeWithoutResponse si es necesario
      await characteristic.write(data, withoutResponse: withoutResponse);

      debugPrint(
        '📤 Written ${data.length} bytes to $deviceId / ${characteristicUuid.substring(0, 8)}... (withoutResponse=$withoutResponse)',
      );

      return true;
    } on Exception catch (e) {
      debugPrint('❌ Failed to write characteristic: $e');
      return false;
    }
  }

  /// Waits for a notification from a specific characteristic with timeout.
  ///
  /// **Purpose:** Abstraction for authentication protocol responses
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID
  /// - [characteristicUuid]: Characteristic UUID
  /// - [timeout]: Maximum wait duration
  ///
  /// **Returns:**
  /// - Notification data bytes if received
  /// - `null` if timeout or error
  ///
  /// **Example:**
  /// ```dart
  /// final response = await bleService.waitForNotification(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   serviceUuid: '0000FE95-...',
  ///   characteristicUuid: '00000052-...',
  ///   timeout: Duration(seconds: 5),
  /// );
  /// ```
  Future<List<int>?> waitForNotification({
    required final String deviceId,
    required final String serviceUuid,
    required final String characteristicUuid,
    required final Duration timeout,
  }) async {
    try {
      final device = _connectedDevices[deviceId];
      if (device == null) {
        debugPrint('❌ Device not connected: $deviceId');
        return null;
      }

      final services = await device.discoverServices();

      // Find service (with UUID normalization)
      final normalizedServiceTarget = _normalizeUuidForComparison(serviceUuid);
      final service = services.firstWhere(
        (final s) =>
            _normalizeUuidForComparison(s.uuid.toString()) ==
            normalizedServiceTarget,
        orElse: () => throw Exception('Service not found: $serviceUuid'),
      );

      // Find characteristic (with UUID normalization)
      final normalizedCharTarget = _normalizeUuidForComparison(
        characteristicUuid,
      );
      final characteristic = service.characteristics.firstWhere(
        (final c) =>
            _normalizeUuidForComparison(c.uuid.toString()) ==
            normalizedCharTarget,
        orElse: () =>
            throw Exception('Characteristic not found: $characteristicUuid'),
      );

      // Wait for notification
      final notification = await characteristic.lastValueStream
          .timeout(timeout)
          .firstWhere((final value) => value.isNotEmpty);

      debugPrint(
        '📥 Received ${notification.length} bytes from $deviceId / ${characteristicUuid.substring(0, 8)}...',
      );

      return notification;
    } on TimeoutException {
      debugPrint(
        '⏱️ Timeout waiting for notification from $deviceId / ${characteristicUuid.substring(0, 8)}...',
      );
      return null;
    } on Exception catch (e) {
      debugPrint('❌ Failed to wait for notification: $e');
      return null;
    }
  }

  /// Normalizes a BLE UUID to short format (4 characters) for comparison.
  ///
  /// Examples:
  /// - `0000FE95-0000-1000-8000-00805F9B34FB` → `FE95`
  /// - `fe95` → `FE95`
  /// - `FE95` → `FE95`
  String _normalizeUuidForComparison(final String uuid) {
    final cleaned = uuid.toUpperCase().replaceAll('-', '');

    // Si tiene formato largo (32+ chars), extraer los 4 chars significativos
    if (cleaned.length >= 8) {
      return cleaned.substring(4, 8);
    }

    // Si ya es corto, devolver tal cual
    return cleaned;
  }

  /// Checks if a device has a specific service available.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID to check (accepts short or long format)
  ///
  /// **Returns:**
  /// - `true` if service exists
  /// - `false` if not found or device not connected
  ///
  /// **Note**: Compares UUIDs in normalized short format (e.g., FE95)

  /// Checks if a device has a specific characteristic available.
  ///
  /// **Parameters:**
  /// - [deviceId]: Device MAC address
  /// - [serviceUuid]: Service UUID (accepts short or long format)
  /// - [characteristicUuid]: Characteristic UUID (accepts short or long format)
  ///
  /// **Returns:**
  /// - `true` if characteristic exists
  /// - `false` if not found or device not connected
  ///
  /// **Note**: Compares UUIDs in normalized short format (e.g., FE95)

  /// Establece una conexión temporal al dispositivo para obtener información actualizada
  ///
  /// **Propósito:**
  /// - Conectar temporalmente a un dispositivo para refrescar su información
  /// - Descubrir servicios y características disponibles
  /// - Leer información básica como RSSI
  /// - Preparar el dispositivo para operaciones posteriores
  ///
  /// **Parámetros:**
  /// - [deviceId]: Dirección MAC del dispositivo
  /// - [timeout]: Tiempo máximo para la conexión (default: 15 segundos)
  /// - [requestMtu]: MTU a solicitar (default: 247 bytes)
  ///
  /// **Retorna:**
  /// - [fbp.BluetoothDevice] conectado y listo para usar
  ///
  /// **Throws:**
  /// - [Exception] si no se puede conectar o el dispositivo no existe
  ///
  /// **Uso:**
  /// ```dart
  /// final connectedDevice = await bleService.connectTemporarily(
  ///   deviceId: 'AA:BB:CC:DD:EE:FF',
  ///   timeout: Duration(seconds: 20),
  /// );
  /// // El dispositivo queda conectado y listo para autenticación
  /// ```
  Future<fbp.BluetoothDevice> connectTemporarily({
    required final String deviceId,
    final Duration timeout = const Duration(seconds: 15),
    final int requestMtu = 247,
  }) async {
    debugPrint('🔗 BleService: Connecting temporarily to $deviceId...');

    try {
      // 1. Obtener dispositivo actualizado (evitar cache stale)
      debugPrint('   📡 Getting fresh device instance...');
      final bleDevice = await getBluetoothDeviceAsync(deviceId);

      debugPrint(
        '   ✅ Got device: ${bleDevice.platformName} (${bleDevice.remoteId.str})',
      );

      // 2. Conectar si no está conectado
      if (!bleDevice.isConnected) {
        debugPrint('   📶 Connecting to device...');
        await bleDevice.connect(
          mtu: requestMtu, // MTU optimizado para SPP packets
          timeout: timeout,
          license: fbp.License.free,
        );
        debugPrint('   ✅ Connected successfully');
      } else {
        debugPrint('   ✅ Device already connected');
      }

      // 3. Esperar estabilización de la conexión
      await Future.delayed(const Duration(milliseconds: 500));

      // 4. Descubrir servicios para refrescar estado del dispositivo
      debugPrint('   🔍 Discovering services...');
      final services = await bleDevice.discoverServices();
      debugPrint('   📋 Discovered ${services.length} services');

      // 5. Leer información básica del dispositivo
      try {
        final rssi = await bleDevice.readRssi();
        debugPrint('   📶 Current RSSI: $rssi dBm');
      } on Exception catch (e) {
        debugPrint('   ⚠️ Could not read RSSI: $e');
      }

      // 6. Validar estado de conexión
      if (!bleDevice.isConnected) {
        throw Exception('Device disconnected unexpectedly after setup');
      }

      debugPrint('   ✅ Temporary connection established successfully');
      debugPrint('   📊 Device state: connected=${bleDevice.isConnected}');

      return bleDevice;
    } on Exception catch (e) {
      debugPrint('   ❌ Temporary connection failed: $e');
      throw Exception(
        'Failed to establish temporary connection to $deviceId: $e',
      );
    }
  }

  /// Prepara un dispositivo con ciclo completo: conectar → bond → desconectar
  ///
  /// **Propósito:**
  /// - Establecer pairing/bonding con el dispositivo
  /// - Refrescar información del dispositivo
  /// - Dejarlo listo para reconexión posterior
  ///
  /// **Flujo:**
  /// 1. Conectar temporalmente
  /// 2. Realizar bonding/pairing
  /// 3. Descubrir servicios básicos
  /// 4. Desconectar limpiamente
  /// 5. Retornar dispositivo preparado (desconectado pero bonded)
  ///
  /// **Parámetros:**
  /// - [deviceId]: Dirección MAC del dispositivo
  /// - [timeout]: Tiempo máximo para cada operación
  ///
  /// **Retorna:**
  /// - [fbp.BluetoothDevice] preparado y bonded (desconectado)
  ///
  /// **Throws:**
  /// - [Exception] si alguna etapa del proceso falla
  Future<fbp.BluetoothDevice> prepareDeviceWithBonding({
    required final String deviceId,
    final Duration timeout = const Duration(seconds: 15),
  }) async {
    debugPrint(
      '🔧 BleService: Preparing device $deviceId with bonding cycle...',
    );

    try {
      // 1. Obtener dispositivo fresco
      debugPrint('   📡 Getting fresh device instance...');
      final bleDevice = await getBluetoothDeviceAsync(deviceId);

      // 2. Conectar temporalmente
      debugPrint('   🔗 Establishing temporary connection...');
      if (!bleDevice.isConnected) {
        await bleDevice.connect(
          mtu: 247,
          timeout: timeout,
          license: fbp.License.free,
        );
        debugPrint('   ✅ Connected successfully');
      }

      // 3. Esperar estabilización
      await Future.delayed(const Duration(milliseconds: 500));

      // 4. Realizar bonding/pairing MEJORADO con CompanionDevice
      debugPrint(
        '   🤝 Ensuring device is bonded with CompanionDevice support...',
      );

      // Verificar estado actual de bonding
      final bondState = await bleDevice.bondState.first;
      debugPrint('   Current bond state: $bondState');

      if (bondState == fbp.BluetoothBondState.bonded) {
        debugPrint('   ✅ Device already bonded');
      } else {
        debugPrint('   ⚠️ Device not bonded, initiating bonding process...');

        // Crear bond tradicional primero
        debugPrint('   🔐 Creating Bluetooth bond...');
        await bleDevice.createBond(timeout: 60);
        debugPrint('   ✅ Bonding request completed');

        // Verificar resultado final
        final newBondState = await bleDevice.bondState.first;
        debugPrint('   📊 Final bond state: $newBondState');

        if (newBondState != fbp.BluetoothBondState.bonded) {
          throw Exception('Bonding failed - device not in bonded state');
        }
      }

      debugPrint('   ✅ Device bonding and registration completed');

      // 5. Descubrir servicios básicos para refrescar estado
      debugPrint('   🔍 Discovering services for state refresh...');
      final services = await bleDevice.discoverServices();
      debugPrint('   📋 Discovered ${services.length} services');

      // 6. Leer información básica
      try {
        final rssi = await bleDevice.readRssi();
        debugPrint('   📶 Final RSSI: $rssi dBm');
      } on Exception catch (e) {
        debugPrint('   ⚠️ Could not read final RSSI: $e');
      }

      // 7. DESCONECTAR limpiamente
      debugPrint('   🔌 Disconnecting cleanly...');
      await bleDevice.disconnect();

      // 8. Esperar desconexión completa
      await Future.delayed(const Duration(milliseconds: 1000));

      debugPrint('   ✅ Device preparation completed successfully');
      debugPrint(
        '   📊 Final state: connected=${bleDevice.isConnected}, bonded=true',
      );

      return bleDevice;
    } on Exception catch (e) {
      debugPrint('   ❌ Device preparation failed: $e');
      throw Exception('Failed to prepare device $deviceId: $e');
    }
  }
}
