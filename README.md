# 📦 Wearable Sensors

Bluetooth LE & Classic wearable device integration package for Flutter.

## Features

- 🔍 Device discovery and scanning
- 🔗 Connection management (BLE & BT Classic)
- 📊 Real-time biometric data streaming
- 🔐 Vendor-specific authentication
- 🏭 Multi-vendor support (starting with Xiaomi)

## Supported Devices

- Xiaomi Smart Band 10 (initial support)
- More devices coming soon!

## Installation

```yaml
dependencies:
  wearable_sensors:
    git:
      url: https://github.com/albertooishii/wearable_sensors.git
```

## Quick Start

```dart
import 'package:wearable_sensors/wearable_sensors.dart';

// Initialize
await WearableSensors.initialize();

// Scan for devices
final devices = await WearableSensors.scan();

// Connect
await WearableSensors.connect(deviceId);

// Read sensor data
final reading = await WearableSensors.read(deviceId, SensorType.heartRate);
print('Heart Rate: ${reading.value} bpm');
```

## Status

🚧 **Work in Progress** - Currently extracting from Dream Incubator project

## License

Mozilla Public License 2.0 (MPL-2.0)
