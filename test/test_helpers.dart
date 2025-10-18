import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';

/// Mock para rootBundle que carga desde el JSON file del package
class MockAssetBundle extends Mock implements AssetBundle {
  static const Map<String, String> _assetCache = {
    'assets/data/device_types.json': '''
[
    {
        "id": "xiaomi_mi_band",
        "name": "Xiaomi Smart Band",
        "icon": "watch",
        "color": "orange",
        "category": "fitness_tracker",
        "vendor": "xiaomi",
        "description": "Xiaomi Smart Band with heart rate and sleep tracking",
        "detection": {
            "required_services": ["180D"],
            "optional_services": ["180A", "180F"]
        }
    },
    {
        "id": "fitbit_charge",
        "name": "Fitbit Charge 5",
        "icon": "watch",
        "color": "black",
        "category": "fitness_tracker",
        "vendor": "fitbit",
        "description": "Fitbit Charge 5 with advanced health features",
        "detection": {
            "required_services": ["180D", "180A"],
            "optional_services": ["180F"]
        }
    },
    {
        "id": "garmin_vivoactive",
        "name": "Garmin Vivoactive",
        "icon": "watch",
        "color": "blue",
        "category": "sports_watch",
        "vendor": "garmin",
        "description": "Garmin Vivoactive sports watch",
        "detection": {
            "required_services": ["180D"],
            "optional_services": ["180A", "180F", "180B"]
        }
    },
    {
        "id": "apple_watch",
        "name": "Apple Watch Series 8",
        "icon": "watch",
        "color": "silver",
        "category": "smartwatch",
        "vendor": "apple",
        "description": "Apple Watch with HealthKit integration",
        "detection": {
            "required_services": ["180D", "180F"],
            "optional_services": ["180A", "180B"]
        }
    },
    {
        "id": "heart_rate_monitor",
        "name": "Generic Heart Rate Monitor",
        "icon": "heart",
        "color": "red",
        "category": "health_sensor",
        "vendor": "generic",
        "description": "Generic Bluetooth Heart Rate Monitor",
        "detection": {
            "required_services": ["180D"],
            "optional_services": []
        }
    },
    {
        "id": "unknown",
        "name": "Unknown Device",
        "icon": "device_unknown",
        "color": "grey",
        "category": "generic",
        "vendor": "generic",
        "description": "Unidentified Bluetooth device",
        "detection": {
            "required_services": [],
            "optional_services": []
        }
    },
    {
        "id": "xiaomi_mi_band_8",
        "name": "Xiaomi Mi Band 8",
        "icon": "watch",
        "color": "orange",
        "category": "fitness_tracker",
        "vendor": "xiaomi",
        "description": "Xiaomi Mi Band 8 with advanced biometric tracking",
        "detection": {
            "required_services": ["180D", "FEE0"],
            "optional_services": ["180A", "180F"]
        }
    }
]
''',
  };

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (_assetCache.containsKey(key)) {
      return _assetCache[key]!;
    }
    throw Exception('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError('Use loadString instead');
  }
}
