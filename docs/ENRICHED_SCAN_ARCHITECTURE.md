# 🔍 Arquitectura de Escaneo Enriquecido (Enriched Scan)

## Problema Actual

El flujo de escaneo actual **NO ES REALISTA**:

```
┌─────────────────────────────────────────────────────────┐
│ FLUJO ACTUAL (INCOMPLETO)                               │
├─────────────────────────────────────────────────────────┤
│ 1. WearableSensors.scan()                               │
│    ↓                                                    │
│ 2. DeviceConnectionManager.startScanning()             │
│    ├─ Delega a BleService.scanBLE()                     │
│    └─ (Implementación FALTANTE)                         │
│    ↓                                                    │
│ 3. BleService retorna BluetoothDevice bruto:           │
│    ├─ deviceId                                         │
│    ├─ name (a veces vacío)                             │
│    ├─ services: [] (SIEMPRE VACÍO en escaneo)          │
│    ├─ rssi                                             │
│    └─ paired: boolean                                  │
│    ↓                                                    │
│ 4. DeviceAdapter.fromInternal()                        │
│    ├─ Crea WearableDevice(discoveredServices: [])      │
│    ├─ Intenta enriquecer de UUIDs vacíos → FALLA       │
│    └─ Retorna device "desconocido" sin info             │
│    ↓                                                    │
│ RESULTADO: ❌ Dispositivo incompleto (sin servicios)    │
│            ❌ Tipo de dispositivo "unknown"              │
│            ❌ Sin información de batería                │
│            ❌ Sin validación de capabilities             │
└─────────────────────────────────────────────────────────┘

PROBLEMA RAÍZ:
- Escaneo BLE NO incluye lista completa de servicios GATT
- Servicios GATT solo están disponibles DESPUÉS de conectar
- Batería solo disponible durante conexión
- Usuario recibe deviceInfo INCOMPLETA → mala UX
```

## Solución: Enriched Scan Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│ FLUJO CORRECTO (ENRIQUECIDO)                                         │
├──────────────────────────────────────────────────────────────────────┤
│ 1. WearableSensors.scan(duration: 10s)                              │
│    ↓                                                                 │
│ 2. EnrichedDeviceScanner.start()                                    │
│    ├─ Fase 1: BLE Discovery (rastreo pasivo - 5-7s)                │
│    │   └─ Encuentra ~100 dispositivos de otros usuarios              │
│    │   └─ BluetoothDevice bruto (sin servicios)                      │
│    │                                                                 │
│    ├─ Fase 2: Parallel Enrichment (~3s, configurable)              │
│    │   └─ Para CADA dispositivo descubierto:                        │
│    │       ├─ Connect temporal (con timeout 3s)                     │
│    │       ├─ discoverServices() ← GATT services              │
│    │       ├─ readCharacteristic(battery) ← 0x2A19           │
│    │       ├─ readCharacteristic(deviceName) ← 0x2A00        │
│    │       └─ Disconnect                                      │
│    │                                                                 │
│    └─ Resultado: WearableDevice ENRIQUECIDO                         │
│       ├─ deviceId                                                   │
│       ├─ name (completo, no empty)                                  │
│       ├─ discoveredServices: List<GattService> ✅                   │
│       ├─ batteryLevel: int (0-100%)                                 │
│       ├─ deviceTypeId: string (detectado)                           │
│       ├─ rssi                                                       │
│       ├─ paired: boolean                                            │
│       └─ isSavedDevice: boolean                                     │
│    ↓                                                                 │
│ 3. yield WearableDevice ENRIQUECIDO                                 │
│                                                                      │
│ RESULTADO: ✅ Dispositivo COMPLETO con toda la información           │
│           ✅ Tipo de dispositivo DETECTADO                           │
│           ✅ Servicios GATT POBLADOS                                 │
│           ✅ Batería DISPONIBLE                                      │
│           ✅ Ready para usuario seleccionar                          │
└──────────────────────────────────────────────────────────────────────┘
```

## Arquitectura Detallada

### 1. **EnrichedDeviceScanner** (Nueva clase)

```
┌────────────────────────────────────────────┐
│   EnrichedDeviceScanner                    │
│  (Orquestador del scan enriquecido)        │
├────────────────────────────────────────────┤
│ Responsabilidades:                         │
│ - Gestionar fases del scan                │
│ - Paralelizar conexiones                  │
│ - Manejar timeouts                        │
│ - Emitir dispositivos conforme se         │
│   enriquecen (progressive results)        │
├────────────────────────────────────────────┤
│ Métodos Públicos:                         │
│ - start(duration, parallelism)            │
│ - stop()                                  │
│ - Stream<WearableDevice> get resultsStream│
│ - List<WearableDevice> get discoveredSoFar│
├────────────────────────────────────────────┤
│ Métodos Privados:                         │
│ - _discoverPhase()                        │
│ - _enrichmentPhase(devices, parallelism)  │
│ - _enrichDevice(device, timeout)          │
│ - _connectAndDiscover(device)              │
│ - _readBattery(device)                    │
│ - _readDeviceName(device)                 │
│ - _detectDeviceType(services)              │
└────────────────────────────────────────────┘
```

### 2. **Flujo de Enrichment para UN dispositivo**

```
┌─────────────────────────────────────────────────────────┐
│ _enrichDevice(BluetoothDevice) → WearableDevice         │
└─────────────────────────────────────────────────────────┘
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 1. CONNECT CON TIMEOUT (3s)  │
         │    - Connect via BleService  │
         │    - Si timeout → skip       │
         └───────────────────────────────┘
                         │
              ✅ Conectado - Continuar
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 2. DISCOVER SERVICES         │
         │    - Esperar discoverServices│
         │    - Si timeout → skip       │
         │    - Convertir UUID → GATT   │
         │      services                │
         └───────────────────────────────┘
                         │
              ✅ Servicios obtenidos
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 3. READ BATTERY (optional)   │
         │    - UUID 0x2A19             │
         │    - Si fail → null (ok)     │
         │    - Si timeout → skip       │
         └───────────────────────────────┘
                         │
              ✅ Battery leído (o null)
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 4. READ DEVICE NAME (optional)│
         │    - UUID 0x2A00             │
         │    - Si fail → use BLE name  │
         │    - Si timeout → skip       │
         └───────────────────────────────┘
                         │
              ✅ Name obtenido
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 5. DETECT DEVICE TYPE        │
         │    - DeviceTypesLoader       │
         │    - Input: discoveredServices│
         │    - Output: deviceTypeId    │
         └───────────────────────────────┘
                         │
              ✅ Type detectado
                         │
                         ↓
         ┌───────────────────────────────┐
         │ 6. DISCONNECT               │
         │    - Cierra conexión BLE    │
         │    - Libera recursos        │
         └───────────────────────────────┘
                         │
                         ↓
         ┌───────────────────────────────┐
         │ RETURN: WearableDevice       │
         │ ✅ deviceId                  │
         │ ✅ name (completo)           │
         │ ✅ discoveredServices        │
         │ ✅ batteryLevel              │
         │ ✅ deviceTypeId              │
         │ ✅ rssi                      │
         │ ✅ isSavedDevice             │
         └───────────────────────────────┘
```

### 3. **Paralelización & Timeouts**

```
┌────────────────────────────────────────────────────────┐
│ Enriquecimiento Paralelo (Ejemplo con 3 dispositivos) │
├────────────────────────────────────────────────────────┤
│                                                        │
│ Device #1  │ Device #2  │ Device #3  │ Device #4     │
│ discover   │ discover   │ discover   │ (esperando)   │
│ ↓          │ ↓          │ ↓          │               │
│ 0.2s       │ 1.1s       │ 0.8s       │               │
│ ↓          │ ↓          │ ↓          │               │
│ battery    │ battery    │ battery    │               │
│ ↓          │ ↓          │ ↓          │               │
│ 0.1s       │ 0.3s       │ 0.2s       │               │
│ ↓          │ ↓          │ ↓          │               │
│ EMIT ✅    │ EMIT ✅    │ EMIT ✅    │               │
│ (0.3s)     │ (1.4s)     │ (1.0s)     │               │
│            │            │            │               │
│ Device #4 → (when Device #1 finishes) ✅ EMIT (0.4s) │
│                                                        │
│ TOTAL TIME: ~1.4s (vs 3 x 1.4s = 4.2s si secuencial)│
│ SPEEDUP: 3x paralelo vs secuencial                    │
└────────────────────────────────────────────────────────┘

CONFIG:
- parallelism: number of concurrent connections
  * Default: 3 (balance entre velocidad y estabilidad BLE)
  * Min: 1 (secuencial)
  * Max: 10 (cuidado: pode sobrecargar BLE stack)
  
- timeoutPerDevice: Duration
  * Default: 3 segundos por dispositivo
  * Includes: connect + discover + read battery/name
  * Si excede → skip enriquecimiento, emitir básico
```

### 4. **Integración con WearableSensors.scan()**

```dart
// ANTES (Current - Incorrecto):
static Stream<WearableDevice> scan({
  Duration duration = const Duration(seconds: 10),
}) async* {
  await _instance!._manager.startScanning(timeout: duration);
  await for (final bleDevice in _instance!._manager.discoveredDevicesStream) {
    yield await DeviceAdapter.fromInternal(bleDevice); // ❌ Sin enriquecer
  }
}

// DESPUÉS (Corrected - Enriched):
static Stream<WearableDevice> scan({
  Duration duration = const Duration(seconds: 10),
  int parallelism = 3,
  Duration? enrichmentTimeout,
}) async* {
  _ensureInitialized();
  
  try {
    // Crear scanner enriquecido
    final scanner = EnrichedDeviceScanner(
      bleService: _instance!._manager.bleService,
      timeout: duration,
      parallelism: parallelism,
      enrichmentTimeout: enrichmentTimeout ?? const Duration(seconds: 3),
    );
    
    // Iniciar scanning
    await scanner.start();
    
    // Emitir resultados conforme se enriquecen (progressive)
    await for (final enrichedDevice in scanner.resultsStream) {
      yield enrichedDevice; // ✅ WearableDevice COMPLETO
    }
  } catch (e, stackTrace) {
    throw ConnectionException(
      'Enriched scan failed: $e',
      code: 'SCAN_FAILED',
      cause: e,
      stackTrace: stackTrace,
    );
  }
}
```

### 5. **Manejo de Timeouts & Errores**

```
┌─────────────────────────────────────────────────────┐
│ Timeout Hierarchy                                   │
├─────────────────────────────────────────────────────┤
│ Total Scan Duration: 10s (user specified)          │
│ ├─ Discovery Phase: ~5-7s (pasivo, no timeout)    │
│ └─ Enrichment Phase: Remaining time                │
│    └─ Per-Device Timeout: 3s (or user specified)  │
│                                                     │
│ Example: scan(duration: 10s, enrichmentTimeout: 3s)│
│ - 0-7s: Discovery phase (devices found continuously)
│ - 7-10s: Enrich up to 3 devices in parallel       │
│   * Each device gets 3s timeout                    │
│   * If exceeds 3s → skip rest, emit basic info    │
│   * If total time exceeds 10s → emit what we have │
└─────────────────────────────────────────────────────┘

FAILURE HANDLING:
1. Connect fails (device offline)
   → Emit basic device (no services, no battery)
   
2. Discover services fails (BLE issue)
   → Emit with empty services list
   
3. Battery read fails (unsupported char)
   → Emit with battery = null (ok)
   
4. Device type detection fails
   → Emit with deviceTypeId = "unknown"
   
5. Per-device timeout exceeded
   → Emit whatever we have so far (graceful degradation)
   
6. Total scan time exceeded
   → Stop scanner, emit collected devices
```

## Cambios de Código Requeridos

### Archivos a Crear:
1. **`lib/src/internal/bluetooth/enriched_device_scanner.dart`** (NEW)
   - Clase `EnrichedDeviceScanner`
   - Lógica de scan + enrichment paralelo
   - ~500-600 líneas

### Archivos a Modificar:
1. **`lib/src/api/wearable_sensors.dart`**
   - Método `scan()`: usar EnrichedDeviceScanner
   - Método `discoveredDevices()`: considerar si cambiar o dejar como stream raw

2. **`lib/src/internal/bluetooth/ble_service.dart`**
   - Agregar método `connectAndDiscoverServices(deviceId)` (reutilizable)
   - Agregar método `readCharacteristic(deviceId, uuid)` (público para EnrichedDeviceScanner)

3. **`lib/src/internal/bluetooth/device_connection_manager.dart`**
   - Agregar método `startScanning()` (faltante actualmente)
   - Agregar getter para `discoveredDevicesStream`

### Archivos SIN cambios:
- `DeviceAdapter.fromInternal()`: seguirá igual (solo convertidor)
- `WearableDevice`: modelo de dato (sin cambios)
- `GattService` y `GattServicesCatalog`: ya listos

## Beneficios de Enriched Scan

```
┌──────────────────────────────────────────────┐
│ VENTAJAS                                     │
├──────────────────────────────────────────────┤
│ ✅ UX: Usuario ve info COMPLETA en scan      │
│ ✅ Device Type: Detectado automáticamente    │
│ ✅ Services: Disponibles ANTES de conectar   │
│ ✅ Battery: Visible en lista de scan         │
│ ✅ Performance: Parallelización 3x faster    │
│ ✅ Robustness: Timeouts y fallbacks          │
│ ✅ Progressive: Resultados conforme se       │
│    enriquecen (mejor UX para scanning largo) │
│ ✅ Testeable: Lógica separada en clase       │
│    dedicada (EnrichedDeviceScanner)         │
└──────────────────────────────────────────────┘
```

## Configuración Recomendada

```dart
// Para escaneo rápido (UI responsive)
WearableSensors.scan(
  duration: const Duration(seconds: 5),
  parallelism: 5,  // Más agresivo
  enrichmentTimeout: const Duration(seconds: 1),  // Rápido
)

// Para escaneo completo (máxima cobertura)
WearableSensors.scan(
  duration: const Duration(seconds: 30),
  parallelism: 3,  // Estable
  enrichmentTimeout: const Duration(seconds: 5),  // Tolerante
)

// Para background scan (eficiencia batería)
WearableSensors.scan(
  duration: const Duration(seconds: 60),
  parallelism: 1,  // Secuencial - bajo consumo
  enrichmentTimeout: const Duration(seconds: 10),  // Muy tolerante
)
```

## Orden de Implementación

1. ✅ Crear `EnrichedDeviceScanner` (clase nueva)
2. Agregar métodos en `BleService` (connect + discover, read characteristic)
3. Agregar método `startScanning()` en `DeviceConnectionManager`
4. Actualizar `WearableSensors.scan()` para usar `EnrichedDeviceScanner`
5. Pruebas E2E: scan → connect → verificar servicios + battery
6. Documentación y ejemplos

---

**Próximo paso**: ¿Continuamos con la implementación de `EnrichedDeviceScanner`?
