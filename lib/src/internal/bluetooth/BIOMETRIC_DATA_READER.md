# 🎯 BiometricDataReader - Universal Data Access Layer

## 📖 Descripción

**BiometricDataReader** es una abstracción unificada para leer datos biométricos desde **CUALQUIER dispositivo**, independientemente del transport (BLE, BT_CLASSIC, REST API, HealthKit, etc).

## ✨ Features

- ✅ **API universal**: Una sola función `read()` para TODOS los dispositivos
- ✅ **Auto-detection**: Detecta automáticamente device type y transport
- ✅ **Transport-agnostic**: Soporta BLE, SPP, API, HealthKit (extensible)
- ✅ **ParserRegistry integration**: Parseo unificado con parsers reutilizables
- ✅ **Type-safe**: Siempre retorna `BleDataSample` (formato unificado)
- ✅ **Zero config**: Nuevos dispositivos = JSON + Parser, NO código

## 🏗️ Arquitectura

```
User Request
    ↓
BiometricDataReader.read(deviceId, dataType)
    ↓
1. Load Device Implementation (JSON)
   → xiaomi_smart_band_10.json, polar_h10.json, etc.
    ↓
2. Auto-detect Transport
   → BLE characteristic? → _readViaBle()
   → SPP protocol? → _readViaSpp()
   → API protocol? → _readViaApi() (futuro)
    ↓
3. Read Raw Data
   → BLE: subscribe + first notification
   → SPP: sendProtobufCommand()
   → API: HTTP request
    ↓
4. Parse with ParserRegistry
   → ParserRegistry.getParser(parserName)
   → parser(rawData) → BleDataSample
    ↓
Return BleDataSample { value, timestamp, dataType, metadata }
```

## 🚀 Uso

### Setup

```dart
import 'package:dream_incubator/shared/services/bluetooth/biometric_data_reader.dart';

final bleService = BleService();
final sppService = XiaomiSppService(...); // Opcional, solo para Xiaomi Band 9/10

final reader = BiometricDataReader(
  bleService: bleService,
  sppService: sppService, // Opcional
);
```

### Read (one-shot)

```dart
// ✅ Xiaomi Band 10 (SPP protobuf)
final battery = await reader.read('AA:BB:CC:DD:EE:FF', 'battery');
print('Battery: ${battery?.value}%'); // 63%

// ✅ Polar H10 (BLE estándar)
final hr = await reader.read('11:22:33:44:55:66', 'heart_rate');
print('HR: ${hr?.value} BPM'); // 78 BPM

// ✅ Fitbit Sense (BLE propietario) - futuro
final spo2 = await reader.read('22:33:44:55:66:77', 'spo2');
print('SpO2: ${spo2?.value}%'); // 98%
```

### Subscribe (streaming)

```dart
// ✅ Subscribe to heart rate streaming
reader.subscribe('device_id', 'heart_rate').listen((sample) {
  print('HR: ${sample.value} BPM');
  print('Timestamp: ${sample.timestamp}');
  print('Quality: ${sample.metadata?['quality']}');
});

// ✅ Subscribe to movement data
reader.subscribe('device_id', 'movement').listen((sample) {
  print('Movement: ${sample.value}');
  print('Steps: ${sample.metadata?['steps']}');
});
```

## 🔌 Transports Soportados

### 1. BLE (Bluetooth Low Energy)

**Uso**: Dispositivos con BLE characteristics (Polar, Fitbit, Garmin, Xiaomi Band 6/7/8)

**Device Implementation**:
```json
{
  "device_type": "polar_h10",
  "authentication": { "protocol": "none" },
  "services": {
    "heart_rate": {
      "uuid": "180D",
      "characteristics": {
        "measurement": {
          "uuid": "2A37",
          "parser": "generic_heart_rate",
          "data_type": "heart_rate",
          "properties": ["notify"]
        }
      }
    },
    "battery": {
      "uuid": "180F",
      "characteristics": {
        "level": {
          "uuid": "2A19",
          "parser": "generic_battery_level",
          "data_type": "battery",
          "properties": ["read", "notify"]
        }
      }
    }
  }
}
```

**Routing**:
```dart
// Auto-detección:
final charInfo = deviceImpl.getCharacteristicForDataType('heart_rate');
if (charInfo != null) {
  return await _readViaBle(deviceId, charInfo);
}
```

**Read Methods**:
```dart
// One-shot read (e.g., battery level)
final bytes = await bleService.readCharacteristic(
  deviceId: deviceId,
  serviceUuid: '180F',  // Battery Service
  characteristicUuid: '2A19',  // Battery Level
);
// bytes[0] = battery percentage (0-100)

// Subscribe to notifications (e.g., heart rate streaming)
bleService.subscribeToDataType(
  deviceId: deviceId,
  dataType: 'heart_rate',
  onData: (data) { /* ... */ },
);
```

### 2. SPP (Serial Port Profile - BT_CLASSIC)

**Uso**: Xiaomi Mi Band 9/10 (protobuf over BT_CLASSIC)

**Device Implementation**:
```json
{
  "device_type": "xiaomi_smart_band_10",
  "authentication": { "protocol": "xiaomi_spp_v2" },
  "services": {
    "FE95": {
      "characteristics": {
        "command_write": { "uuid": "005F" },
        "command_read": { "uuid": "005E" }
      }
    }
  }
}
```

**Routing**:
```dart
// Auto-detección:
if (deviceImpl.authentication.protocol == 'xiaomi_spp_v2') {
  return await _readViaSpp(deviceId, dataType, deviceImpl);
}
```

**Mapping dataType → SPP command**:
```dart
switch (dataType) {
  case 'battery':
    request = createBatteryRequest();
    parserName = 'xiaomi_spp_battery';
    break;
  // Agregar más aquí...
}
```

### 3. REST API (Futuro)

**Uso**: Fitbit, Garmin cloud sync

**Device Implementation**:
```json
{
  "device_type": "fitbit_sense",
  "authentication": { "protocol": "fitbit_api" }
}
```

**Routing** (futuro):
```dart
if (deviceImpl.authentication.protocol == 'fitbit_api') {
  return await _readViaApi(deviceId, dataType);
}
```

### 4. HealthKit (Futuro)

**Uso**: Apple Watch bridge

**Device Implementation**:
```json
{
  "device_type": "apple_watch",
  "authentication": { "protocol": "healthkit" }
}
```

**Routing** (futuro):
```dart
if (deviceImpl.authentication.protocol == 'healthkit') {
  return await _readViaHealthKit(deviceId, dataType);
}
```

## 📋 Data Types Soportados

| Data Type | Descripción | Ejemplo Devices |
|-----------|-------------|-----------------|
| `battery` | Nivel de batería (0-100%) | Todos |
| `heart_rate` | Frecuencia cardíaca (BPM) | Polar, Fitbit, Xiaomi |
| `spo2` | Saturación de oxígeno (%) | Fitbit, Xiaomi |
| `movement` | Intensidad de movimiento (0-1) | Xiaomi, Garmin |
| `temperature` | Temperatura corporal (°C) | Fitbit, Garmin |
| `steps` | Contador de pasos | Todos |
| `sleep_stage` | Etapa de sueño (REM, light, deep) | Fitbit, Xiaomi |

## 🧩 Extensibilidad

### Agregar Nuevo Dispositivo

**Ejemplo: Fitbit Sense**

#### 1. Crear Device Implementation JSON

`assets/device_implementations/fitbit_sense.json`:
```json
{
  "version": "1.0.0",
  "device_type": "fitbit_sense",
  "display_name": "Fitbit Sense",
  "service_filter": ["ADAB", "FED8"],
  "services": {
    "heart_rate": {
      "uuid": "0000180D-0000-1000-8000-00805F9B34FB",
      "name": "Heart Rate Service",
      "characteristics": {
        "measurement": {
          "uuid": "00002A37-0000-1000-8000-00805F9B34FB",
          "parser": "fitbit_heart_rate",
          "data_type": "heart_rate",
          "properties": ["notify"]
        }
      }
    }
  },
  "data_parsers": {
    "fitbit_heart_rate": {
      "type": "heart_rate",
      "class": "FitbitHeartRateParser",
      "description": "Fitbit proprietary HR format"
    }
  },
  "authentication": {
    "protocol": "none",
    "required": false
  }
}
```

#### 2. Crear Parser

`lib/shared/parsers/fitbit/heart_rate_parser.dart`:
```dart
import 'package:dream_incubator/shared/models/ble_data_sample.dart';
import 'package:dream_incubator/shared/constants/ble_data_types.dart';

class FitbitHeartRateParser {
  static BleDataSample? parse(List<int> bytes) {
    if (bytes.isEmpty) return null;

    try {
      // Fitbit-specific parsing logic
      final hr = bytes[0]; // Simplified example

      return BleDataSample(
        timestamp: DateTime.now(),
        value: hr.toDouble(),
        dataType: BleDataTypes.heartRate,
        metadata: {
          'source': 'fitbit_sense',
          'quality': 'good',
        },
      );
    } catch (e) {
      return null;
    }
  }
}
```

#### 3. Registrar Parser

`lib/shared/parsers/parser_registry.dart`:
```dart
static final Map<String, BleDataSample? Function(List<int>)> _parsers = {
  // ... existing parsers ...
  
  // ===== Fitbit Parsers =====
  'fitbit_heart_rate': FitbitHeartRateParser.parse,
};
```

#### 4. ✅ LISTO!

```dart
// ✅ Funciona automáticamente
final hr = await reader.read('fitbit_device_id', 'heart_rate');
print('Fitbit HR: ${hr?.value} BPM');
```

## 🔍 Debugging

### Logs

```dart
// Enable debug logging
debugPrint = true;

// Example output:
// 🎯 BiometricDataReader.read(AA:BB:CC:DD:EE:FF, battery)
//    📱 Device type: xiaomi_smart_band_10
//    🔐 Auth protocol: xiaomi_spp_v2
//    → Transport: BT_CLASSIC SPP (xiaomi_spp_v2)
//    📤 Sending SPP command: type=2, subtype=1
//    📥 Received response: type=2, subtype=1
//    ✅ Parsed value: 63.0
```

### Cache

```dart
// Clear device implementation cache (útil para tests)
reader.clearCache();
```

## 🧪 Testing

Ver `test/services/biometric_data_reader_test.dart` para:
- Tests de arquitectura
- Ejemplos de uso
- Validación de extensibilidad

```bash
flutter test test/services/biometric_data_reader_test.dart
```

## 📚 Referencias

- **Device Implementations**: `assets/device_implementations/`
- **Parsers**: `lib/shared/parsers/`
- **Parser Registry**: `lib/shared/parsers/parser_registry.dart`
- **Device Loader**: `lib/shared/utils/device_implementation_loader.dart`

## 🎯 Roadmap

- [x] ✅ BLE transport (implemented)
- [x] ✅ BLE one-shot read (`readCharacteristic()` - implemented)
- [x] ✅ SPP transport (Xiaomi Band 9/10 - implemented)
- [ ] ⏳ REST API transport (Fitbit, Garmin)
- [ ] ⏳ HealthKit bridge (Apple Watch)
- [ ] ⏳ WebSocket streaming (cloud sync)

---

**Hecho con 💙 para Dream Incubator**
