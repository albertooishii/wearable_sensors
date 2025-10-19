# Plan de Limpieza: Simplificar Flujo de Dispositivos

## 📊 VISIÓN GENERAL DEL FLUJO (Actual + Propuesto)

### Flujo 1: Carga de Bonded Devices (en initialize)
```
WearableSensors.initialize()
  ↓
DeviceConnectionManager.initialize()
  ↓
_loadBondedDevices()
  ├─ Get bonded devices from system (BLE)
  ├─ Para cada device:
  │  ├─ DeviceAdapter.fromInternal(isSavedDevice=true)
  │  ├─ Enriquece con GATT services
  │  └─ Agrega a _deviceStates[deviceId]
  ↓
Emit: _deviceStatesController.add(_deviceStates)
  ↓
UI recibe: deviceStream(filter: bonded) → emite en "My Devices"
```

### Flujo 2: Escaneo de Dispositivos (discovered)
```
WearableSensors.scan(duration: 15s)
  ↓
DeviceConnectionManager.startScanning()
  ↓
BleService.startScanning() busca BLE devices
  ↓
Para cada BLE device encontrado:
  ├─ discoveredDevicesStream asyncMap:
  │  ├─ DeviceAdapter.fromInternal(isSavedDevice=false)
  │  ├─ Enriquece con GATT services
  │  └─ Agrega a _deviceStates[deviceId]
  ├─ Emit: _deviceStatesController.add(_deviceStates)
  ↓
UI recibe: deviceStream(filter: nearby, enrich=true) 
  → Filtra solo si discoveredServices.isNotEmpty
  → emite en "Scanned Devices"
```

### Flujo 3: Conexión + Actualización de Estado
```
WearableSensors.connect(deviceId)
  ↓
DeviceConnectionManager.connectDevice()
  ├─ Crea orchestrator (vendor-specific)
  ├─ Conecta y autentica
  ├─ Suscribe a streams: connection, battery, biometric, error
  ↓
Cuando cambia estado:
  ├─ orchestrator.connectionStateStream → _updateDeviceState()
  ├─ orchestrator.batteryStream → _updateDeviceState()
  ├─ orchestrator.biometricDataStream → _updateDeviceState()
  ↓
_updateDeviceState() compara old vs new
  ├─ Si no hay cambios: skip
  ├─ Si hay cambios: Emit _deviceStatesController
  ↓
UI recibe: deviceStream(...) → actualiza en tiempo real
```

---

## 🗑️ CÓDIGO A ELIMINAR (en device_connection_manager.dart)

### 1. **connectionStatesStream** (nunca se usa)
- **Línea 106-111**: `Stream<Map<String, ConnectionState>> get connectionStatesStream`
- **Por qué**: Creado pero no consumido en API pública. Solo emitir a `_deviceStatesController`

### 2. **discoveredDeviceStorage** (inyectado pero sin usar)
- **Línea 80-81**: `DiscoveredDeviceStorage? _discoveredDeviceStorage;`
- **Línea 100-103**: `set discoveredDeviceStorage(...)`
- **Línea 386-393**: Intento de usar (comentado/muerto)
- **Por qué**: Código muerto que no se usa

### 3. **autoReconnectSavedDevices()** (no es core)
- **Línea 908-921**: Método completo
- **Línea 927-937**: `_getSavedDeviceIds()` (solo usado por autoReconnect)
- **Por qué**: No se usa en dream_incubator. No es responsabilidad de manager.

### 4. **requestBatteryUpdate()** (no es core)
- **Línea 1013-1053**: Método completo
- **Por qué**: No se usa en dream_incubator. Battery viene del orchestrator stream.

### 5. **Comentarios excesivos**
- Remover "MOMENTO 1", "MOMENTO 2", referencias a métodos inexistentes
- Mantener solo: descripción de QUÉ hace, no HOW

---

## 📝 CÓDIGO A SIMPLIFICAR

### 1. **_loadBondedDevices()** (simplificar logs)
```dart
// ANTES: 50+ líneas con logs extensos
// DESPUÉS: 
// - Log de inicio: "Loading bonded devices..."
// - Log de error/éxito: cantidad cargada
// - Remover logs de cada device individual
```

### 2. **discoveredDevicesStream** (limpiar asyncMap)
```dart
// ANTES: Código comentado, referencias muertas
// DESPUÉS: 
// - Solo: DeviceAdapter.fromInternal() + emit
// - Remover try/catch innecesarios
```

### 3. **connectDevice()** (remover lógica de "momentos")
```dart
// ANTES: 400+ líneas con referencias a "Moment 1", "Moment 2"
// DESPUÉS:
// - Paso 1: Detectar vendor
// - Paso 2: Crear orchestrator
// - Paso 3: Conectar
// - Paso 4: Suscribir a streams
// - Eso es todo
```

### 4. **Documentación de classe**
```dart
// ANTES: Documentación larga con ejemplos desactualizados
// DESPUÉS:
// - Descripción clara de responsabilidades
// - Ejemplos de uso básico
```

---

## ✅ CÓDIGO A MANTENER (Sin cambios)

### En device_connection_manager.dart:
- `initialize()` - Carga bonded devices
- `startScanning()` / `stopScanning()` - Controla BLE scan
- `discoveredDevicesStream` getter - Enriquece y emite
- `connectDevice()` / `disconnectDevice()` - Conecta/desconecta
- `deviceStatesStream` - Emite cambios (broadcast)
- `deviceStates` getter - Acceso síncrono
- `_updateDeviceState()` - Actualiza y emite
- `_detectVendor()` - Detecta vendor
- `_createOrchestrator()` - Factory
- Stream subscriptions cleanup

### En wearable_sensors.dart:
- `scan()` - Inicia escaneo
- `deviceStream()` con filtros y parámetros (keepUnnamed, enrich)
- Toda la documentación de API

---

## 🎯 RESULTADOS ESPERADOS DESPUÉS DE LIMPIEZA

| Aspecto | Antes | Después |
|---------|-------|---------|
| Líneas en device_connection_manager | ~1080 | ~700 (-35%) |
| Métodos públicos innecesarios | 3 (autoReconnect, requestBattery, etc) | 0 |
| Campos sin usar | 1 (discoveredDeviceStorage) | 0 |
| Streams sin usar | 1 (connectionStatesStream) | 0 |
| Flujo claro para: bonded devices | ⚠️ Confuso | ✅ Cristalino |
| Flujo claro para: discovered devices | ⚠️ Confuso | ✅ Cristalino |
| Flujo claro para: actualización de estado | ⚠️ Confuso | ✅ Cristalino |

---

## 🔍 VALIDACIÓN POST-LIMPIEZA

Después de completar, verificar:

### Compilación:
```bash
cd wearable_sensors && flutter analyze
cd dream_incubator && flutter analyze
```
Esperado: ✅ Zero errors

### Funcionalidad:
1. ✅ **Bonded Devices**: Aparecen en "My Devices" después de initialize
2. ✅ **Discovered Devices**: Aparecen en "Scanned Devices" después de scan
3. ✅ **Unknown Device**: Se filtra si `skipUnnamed=true` (default)
4. ✅ **Dispositivos sin nombre**: Se muestran si `isPairedToSystem=true` (bonded)
5. ✅ **Enriquecimiento**: Devices solo emiten cuando `discoveredServices.isNotEmpty` si `enrich=true`
6. ✅ **Connect/Disconnect**: Actualiza connectionState en tiempo real

---

## ⚠️ ORDEN DE LIMPIEZA

**IMPORTANTE**: Hacer en este orden para no romper nada:

1. **Paso 1**: Remover `autoReconnectSavedDevices()` + `_getSavedDeviceIds()`
2. **Paso 2**: Remover `requestBatteryUpdate()`
3. **Paso 3**: Remover `discoveredDeviceStorage` (setter + field)
4. **Paso 4**: Remover `connectionStatesStream`
5. **Paso 5**: Simplificar `_loadBondedDevices()` - logs
6. **Paso 6**: Simplificar `connectDevice()` - remover "momentos"
7. **Paso 7**: Simplificar `discoveredDevicesStream` - limpiar asyncMap
8. **Paso 8**: Compilar y validar
9. **Paso 9**: Test en device

---

## 📌 NOTAS IMPORTANTES

- **No tocar**: BiometricDataReader, VendorOrchestrator, DeviceAdapter
- **No tocar**: wearable_sensors.dart API (ya limpia)
- **Objetivo**: Hacer manager transparente - solo coordina flujos
- **Test**: Correr app en device/emulator después de cada paso
