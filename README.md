# 📱 Wearable Sensors para Flutter

> Universal Dart/Flutter package para conectar con dispositivos wearables Bluetooth (smartwatches, fitness trackers, health monitors) usando una sola API.

[![pub package](https://img.shields.io/pub/v/wearable_sensors.svg)](https://pub.dev/packages/wearable_sensors)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://www.mozilla.org/MPL/2.0/)

## ✨ Características principales

- 🔍 **Device Discovery**: Escanea y detecta dispositivos Bluetooth LE y Classic
- 🔗 **Connection Management**: Gestión robusta de conexiones con reconexión automática
- 📊 **Real-time Streaming**: Stream de datos biométricos (HRV, movimiento, batería, etc.)
- 🔐 **Vendor Authentication**: Autenticación segura con protocolos específicos del fabricante
- 🏭 **Multi-Vendor Support**: Xiaomi, Apple, Fitbit, y arquitectura extensible
- 🛡️ **Type-Safe API**: API completamente tipada en Dart, sin casteos dinámicos
- 📱 **Cross-Platform**: Android e iOS (iOS vía HealthKit)

## �� Dispositivos soportados

### Actualmente implementados
- **Xiaomi Mi Band** (6, 7, 8, 10) - Soporte completo con protocolo SPP V2
- **Generic BLE Devices** - HR, batería, conteo de pasos

### Planeados
- Apple Watch & AirPods
- Fitbit
- Samsung Galaxy Watch
- Garmin
- OURA

## 🚀 Instalación rápida

```yaml
dependencies:
  wearable_sensors:
    git:
      url: https://github.com/albertooishii/wearable_sensors.git
      ref: main
```

O cuando esté publicado en pub.dev:

```yaml
dependencies:
  wearable_sensors: ^0.1.0
```

## 🧪 Uso esencial

```dart
import 'package:wearable_sensors/wearable_sensors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WearableSensors.initialize();

  // Escanear dispositivos
  final devices = await WearableSensors.scan(
    timeout: Duration(seconds: 10),
  );

  // Conectar
  await WearableSensors.connect(
    deviceId: devices.first.id,
  );

  // Leer datos
  final reading = await WearableSensors.read(
    deviceId: devices.first.id,
    sensorType: SensorType.heartRate,
  );
  print('Heart Rate: ${reading.value} bpm');

  // Stream datos en tiempo real
  WearableSensors.stream(deviceId: devices.first.id)
    .listen((reading) {
      print('${reading.sensorType}: ${reading.value}');
    });

  runApp(const MyApp());
}
```

## ⚙️ Configuración

### Permisos Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

### Permisos iOS (Info.plist)
```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Necesitamos acceso a Bluetooth para conectar con tu dispositivo wearable</string>
<key>NSBluetoothCentralUsageDescription</key>
<string>Necesitamos acceso a Bluetooth para detectar y conectar con dispositivos</string>
```

## 📘 API Principal

| Método | Descripción | Retorno |
|--------|-------------|---------|
| `initialize()` | Inicializa el sistema y permisos | `Future<void>` |
| `scan({Duration? timeout})` | Escanea dispositivos disponibles | `Future<List<WearableDevice>>` |
| `connect(String deviceId)` | Conecta con un dispositivo | `Future<void>` |
| `disconnect(String deviceId)` | Desconecta | `Future<void>` |
| `read(String deviceId, SensorType type)` | Lee valor único | `Future<SensorReading>` |
| `stream(String deviceId)` | Stream de datos en tiempo real | `Stream<SensorReading>` |
| `getCapabilities(String deviceId)` | Obtiene sensores soportados | `Future<DeviceCapabilities>` |

## 🏗️ Arquitectura

```
wearable_sensors/
├── lib/src/
│   ├── api/                    # Public API (exportado)
│   │   ├── wearable_sensors.dart
│   │   ├── models/
│   │   ├── enums/
│   │   └── exceptions/
│   └── internal/               # Implementación (NO exportado)
│       ├── bluetooth/
│       ├── vendors/
│       ├── parsers/
│       └── utils/
├── assets/
└── test/
```

## 🧪 Testing

```bash
flutter test
flutter test test/device_types_loader_test.dart
```

## 🧑‍�� Desarrollo

```bash
git clone https://github.com/albertooishii/wearable_sensors.git
cd wearable_sensors
flutter pub get
flutter test
flutter analyze
```

## 🐛 Problemas conocidos

- iOS aún requiere integración HealthKit
- Algunos dispositivos no anuncian todos los servicios (manejado)
- SPP V2 limitado a Xiaomi (por ahora)

## 📬 Contacto

- 🐙 **GitHub**: [@albertooishii](https://github.com/albertooishii)
- 💼 **LinkedIn**: [Perfil Profesional](https://linkedin.com/in/albertooishii)
- 📧 **Email**: albertooishii@gmail.com

## 📄 Licencia

Distribuido bajo la [Mozilla Public License 2.0](https://www.mozilla.org/MPL/2.0/).
