// This is a generated file - do not edit.
//
// Generated from assets/proto/xiaomi.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use commandDescriptor instead')
const Command$json = {
  '1': 'Command',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 13, '10': 'type'},
    {'1': 'subtype', '3': 2, '4': 1, '5': 13, '10': 'subtype'},
    {'1': 'auth', '3': 3, '4': 1, '5': 11, '6': '.xiaomi.Auth', '10': 'auth'},
    {
      '1': 'system',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.System',
      '10': 'system',
    },
    {
      '1': 'watchface',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Watchface',
      '10': 'watchface',
    },
    {
      '1': 'health',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Health',
      '10': 'health',
    },
    {
      '1': 'calendar',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Calendar',
      '10': 'calendar',
    },
    {
      '1': 'music',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Music',
      '10': 'music',
    },
    {
      '1': 'notification',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Notification',
      '10': 'notification',
    },
    {
      '1': 'weather',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Weather',
      '10': 'weather',
    },
    {
      '1': 'schedule',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Schedule',
      '10': 'schedule',
    },
    {
      '1': 'phonebook',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Phonebook',
      '10': 'phonebook',
    },
    {
      '1': 'dataUpload',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DataUpload',
      '10': 'dataUpload',
    },
    {'1': 'status', '3': 100, '4': 1, '5': 13, '10': 'status'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode(
    'CgdDb21tYW5kEhIKBHR5cGUYASACKA1SBHR5cGUSGAoHc3VidHlwZRgCIAEoDVIHc3VidHlwZR'
    'IgCgRhdXRoGAMgASgLMgwueGlhb21pLkF1dGhSBGF1dGgSJgoGc3lzdGVtGAQgASgLMg4ueGlh'
    'b21pLlN5c3RlbVIGc3lzdGVtEi8KCXdhdGNoZmFjZRgGIAEoCzIRLnhpYW9taS5XYXRjaGZhY2'
    'VSCXdhdGNoZmFjZRImCgZoZWFsdGgYCiABKAsyDi54aWFvbWkuSGVhbHRoUgZoZWFsdGgSLAoI'
    'Y2FsZW5kYXIYDiABKAsyEC54aWFvbWkuQ2FsZW5kYXJSCGNhbGVuZGFyEiMKBW11c2ljGBQgAS'
    'gLMg0ueGlhb21pLk11c2ljUgVtdXNpYxI4Cgxub3RpZmljYXRpb24YCSABKAsyFC54aWFvbWku'
    'Tm90aWZpY2F0aW9uUgxub3RpZmljYXRpb24SKQoHd2VhdGhlchgMIAEoCzIPLnhpYW9taS5XZW'
    'F0aGVyUgd3ZWF0aGVyEiwKCHNjaGVkdWxlGBMgASgLMhAueGlhb21pLlNjaGVkdWxlUghzY2hl'
    'ZHVsZRIvCglwaG9uZWJvb2sYFyABKAsyES54aWFvbWkuUGhvbmVib29rUglwaG9uZWJvb2sSMg'
    'oKZGF0YVVwbG9hZBgYIAEoCzISLnhpYW9taS5EYXRhVXBsb2FkUgpkYXRhVXBsb2FkEhYKBnN0'
    'YXR1cxhkIAEoDVIGc3RhdHVz');

@$core.Deprecated('Use authDescriptor instead')
const Auth$json = {
  '1': 'Auth',
  '2': [
    {'1': 'userId', '3': 7, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'status', '3': 8, '4': 1, '5': 13, '10': 'status'},
    {
      '1': 'phoneNonce',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.PhoneNonce',
      '10': 'phoneNonce',
    },
    {
      '1': 'watchNonce',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WatchNonce',
      '10': 'watchNonce',
    },
    {
      '1': 'authStep3',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AuthStep3',
      '10': 'authStep3',
    },
    {
      '1': 'authStep4',
      '3': 33,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AuthStep4',
      '10': 'authStep4',
    },
  ],
};

/// Descriptor for `Auth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authDescriptor = $convert.base64Decode(
    'CgRBdXRoEhYKBnVzZXJJZBgHIAEoCVIGdXNlcklkEhYKBnN0YXR1cxgIIAEoDVIGc3RhdHVzEj'
    'IKCnBob25lTm9uY2UYHiABKAsyEi54aWFvbWkuUGhvbmVOb25jZVIKcGhvbmVOb25jZRIyCgp3'
    'YXRjaE5vbmNlGB8gASgLMhIueGlhb21pLldhdGNoTm9uY2VSCndhdGNoTm9uY2USLwoJYXV0aF'
    'N0ZXAzGCAgASgLMhEueGlhb21pLkF1dGhTdGVwM1IJYXV0aFN0ZXAzEi8KCWF1dGhTdGVwNBgh'
    'IAEoCzIRLnhpYW9taS5BdXRoU3RlcDRSCWF1dGhTdGVwNA==');

@$core.Deprecated('Use phoneNonceDescriptor instead')
const PhoneNonce$json = {
  '1': 'PhoneNonce',
  '2': [
    {'1': 'nonce', '3': 1, '4': 2, '5': 12, '10': 'nonce'},
  ],
};

/// Descriptor for `PhoneNonce`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneNonceDescriptor =
    $convert.base64Decode('CgpQaG9uZU5vbmNlEhQKBW5vbmNlGAEgAigMUgVub25jZQ==');

@$core.Deprecated('Use watchNonceDescriptor instead')
const WatchNonce$json = {
  '1': 'WatchNonce',
  '2': [
    {'1': 'nonce', '3': 1, '4': 2, '5': 12, '10': 'nonce'},
    {'1': 'hmac', '3': 2, '4': 2, '5': 12, '10': 'hmac'},
  ],
};

/// Descriptor for `WatchNonce`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchNonceDescriptor = $convert.base64Decode(
  'CgpXYXRjaE5vbmNlEhQKBW5vbmNlGAEgAigMUgVub25jZRISCgRobWFjGAIgAigMUgRobWFj',
);

@$core.Deprecated('Use authStep3Descriptor instead')
const AuthStep3$json = {
  '1': 'AuthStep3',
  '2': [
    {'1': 'encryptedNonces', '3': 1, '4': 2, '5': 12, '10': 'encryptedNonces'},
    {
      '1': 'encryptedDeviceInfo',
      '3': 2,
      '4': 2,
      '5': 12,
      '10': 'encryptedDeviceInfo',
    },
  ],
};

/// Descriptor for `AuthStep3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authStep3Descriptor = $convert.base64Decode(
    'CglBdXRoU3RlcDMSKAoPZW5jcnlwdGVkTm9uY2VzGAEgAigMUg9lbmNyeXB0ZWROb25jZXMSMA'
    'oTZW5jcnlwdGVkRGV2aWNlSW5mbxgCIAIoDFITZW5jcnlwdGVkRGV2aWNlSW5mbw==');

@$core.Deprecated('Use authStep4Descriptor instead')
const AuthStep4$json = {
  '1': 'AuthStep4',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 2, '5': 13, '10': 'unknown1'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `AuthStep4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authStep4Descriptor = $convert.base64Decode(
    'CglBdXRoU3RlcDQSGgoIdW5rbm93bjEYASACKA1SCHVua25vd24xEhoKCHVua25vd24yGAIgAS'
    'gNUgh1bmtub3duMg==');

@$core.Deprecated('Use authDeviceInfoDescriptor instead')
const AuthDeviceInfo$json = {
  '1': 'AuthDeviceInfo',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 2, '5': 13, '10': 'unknown1'},
    {'1': 'phoneApiLevel', '3': 2, '4': 2, '5': 2, '10': 'phoneApiLevel'},
    {'1': 'phoneName', '3': 3, '4': 2, '5': 9, '10': 'phoneName'},
    {'1': 'unknown3', '3': 4, '4': 2, '5': 13, '10': 'unknown3'},
    {'1': 'region', '3': 5, '4': 2, '5': 9, '10': 'region'},
  ],
};

/// Descriptor for `AuthDeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authDeviceInfoDescriptor = $convert.base64Decode(
    'Cg5BdXRoRGV2aWNlSW5mbxIaCgh1bmtub3duMRgBIAIoDVIIdW5rbm93bjESJAoNcGhvbmVBcG'
    'lMZXZlbBgCIAIoAlINcGhvbmVBcGlMZXZlbBIcCglwaG9uZU5hbWUYAyACKAlSCXBob25lTmFt'
    'ZRIaCgh1bmtub3duMxgEIAIoDVIIdW5rbm93bjMSFgoGcmVnaW9uGAUgAigJUgZyZWdpb24=');

@$core.Deprecated('Use systemDescriptor instead')
const System$json = {
  '1': 'System',
  '2': [
    {
      '1': 'power',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Power',
      '10': 'power',
    },
    {
      '1': 'deviceInfo',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DeviceInfo',
      '10': 'deviceInfo',
    },
    {
      '1': 'clock',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Clock',
      '10': 'clock',
    },
    {'1': 'findDevice', '3': 5, '4': 1, '5': 13, '10': 'findDevice'},
    {
      '1': 'raiseToWake',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.RaiseToWake',
      '10': 'raiseToWake',
    },
    {
      '1': 'simpleWidgets',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.SimpleWidgets',
      '10': 'simpleWidgets',
    },
    {
      '1': 'displayItems',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DisplayItems',
      '10': 'displayItems',
    },
    {
      '1': 'dndStatus',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DoNotDisturb',
      '10': 'dndStatus',
    },
    {
      '1': 'workoutTypes',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorkoutTypes',
      '10': 'workoutTypes',
    },
    {
      '1': 'firmwareInstallRequest',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.FirmwareInstallRequest',
      '10': 'firmwareInstallRequest',
    },
    {
      '1': 'firmwareInstallResponse',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.FirmwareInstallResponse',
      '10': 'firmwareInstallResponse',
    },
    {
      '1': 'password',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Password',
      '10': 'password',
    },
    {
      '1': 'camera',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Camera',
      '10': 'camera',
    },
    {
      '1': 'language',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Language',
      '10': 'language',
    },
    {
      '1': 'widgetScreens',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WidgetScreens',
      '10': 'widgetScreens',
    },
    {
      '1': 'widgetParts',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WidgetParts',
      '10': 'widgetParts',
    },
    {
      '1': 'miscSettingGet',
      '3': 34,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.MiscSettingGet',
      '10': 'miscSettingGet',
    },
    {
      '1': 'miscSettingSet',
      '3': 35,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.MiscSettingSet',
      '10': 'miscSettingSet',
    },
    {
      '1': 'phoneSilentModeGet',
      '3': 36,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.PhoneSilentModeGet',
      '10': 'phoneSilentModeGet',
    },
    {
      '1': 'phoneSilentModeSet',
      '3': 37,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.PhoneSilentModeSet',
      '10': 'phoneSilentModeSet',
    },
    {
      '1': 'vibrationPatterns',
      '3': 38,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.VibrationPatterns',
      '10': 'vibrationPatterns',
    },
    {
      '1': 'vibrationSetPreset',
      '3': 39,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.VibrationNotificationType',
      '10': 'vibrationSetPreset',
    },
    {
      '1': 'vibrationPatternCreate',
      '3': 40,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.CustomVibrationPattern',
      '10': 'vibrationPatternCreate',
    },
    {
      '1': 'vibrationTestCustom',
      '3': 41,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.VibrationTest',
      '10': 'vibrationTestCustom',
    },
    {
      '1': 'vibrationPatternAck',
      '3': 43,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.VibrationPatternAck',
      '10': 'vibrationPatternAck',
    },
    {
      '1': 'basicDeviceState',
      '3': 48,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.BasicDeviceState',
      '10': 'basicDeviceState',
    },
    {
      '1': 'deviceState',
      '3': 49,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DeviceState',
      '10': 'deviceState',
    },
  ],
};

/// Descriptor for `System`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List systemDescriptor = $convert.base64Decode(
    'CgZTeXN0ZW0SIwoFcG93ZXIYAiABKAsyDS54aWFvbWkuUG93ZXJSBXBvd2VyEjIKCmRldmljZU'
    'luZm8YAyABKAsyEi54aWFvbWkuRGV2aWNlSW5mb1IKZGV2aWNlSW5mbxIjCgVjbG9jaxgEIAEo'
    'CzINLnhpYW9taS5DbG9ja1IFY2xvY2sSHgoKZmluZERldmljZRgFIAEoDVIKZmluZERldmljZR'
    'I1CgtyYWlzZVRvV2FrZRgHIAEoCzITLnhpYW9taS5SYWlzZVRvV2FrZVILcmFpc2VUb1dha2US'
    'OwoNc2ltcGxlV2lkZ2V0cxgJIAEoCzIVLnhpYW9taS5TaW1wbGVXaWRnZXRzUg1zaW1wbGVXaW'
    'RnZXRzEjgKDGRpc3BsYXlJdGVtcxgKIAEoCzIULnhpYW9taS5EaXNwbGF5SXRlbXNSDGRpc3Bs'
    'YXlJdGVtcxIyCglkbmRTdGF0dXMYCyABKAsyFC54aWFvbWkuRG9Ob3REaXN0dXJiUglkbmRTdG'
    'F0dXMSOAoMd29ya291dFR5cGVzGA4gASgLMhQueGlhb21pLldvcmtvdXRUeXBlc1IMd29ya291'
    'dFR5cGVzElYKFmZpcm13YXJlSW5zdGFsbFJlcXVlc3QYECABKAsyHi54aWFvbWkuRmlybXdhcm'
    'VJbnN0YWxsUmVxdWVzdFIWZmlybXdhcmVJbnN0YWxsUmVxdWVzdBJZChdmaXJtd2FyZUluc3Rh'
    'bGxSZXNwb25zZRgRIAEoCzIfLnhpYW9taS5GaXJtd2FyZUluc3RhbGxSZXNwb25zZVIXZmlybX'
    'dhcmVJbnN0YWxsUmVzcG9uc2USLAoIcGFzc3dvcmQYEyABKAsyEC54aWFvbWkuUGFzc3dvcmRS'
    'CHBhc3N3b3JkEiYKBmNhbWVyYRgPIAEoCzIOLnhpYW9taS5DYW1lcmFSBmNhbWVyYRIsCghsYW'
    '5ndWFnZRgUIAEoCzIQLnhpYW9taS5MYW5ndWFnZVIIbGFuZ3VhZ2USOwoNd2lkZ2V0U2NyZWVu'
    'cxgcIAEoCzIVLnhpYW9taS5XaWRnZXRTY3JlZW5zUg13aWRnZXRTY3JlZW5zEjUKC3dpZGdldF'
    'BhcnRzGB0gASgLMhMueGlhb21pLldpZGdldFBhcnRzUgt3aWRnZXRQYXJ0cxI+Cg5taXNjU2V0'
    'dGluZ0dldBgiIAEoCzIWLnhpYW9taS5NaXNjU2V0dGluZ0dldFIObWlzY1NldHRpbmdHZXQSPg'
    'oObWlzY1NldHRpbmdTZXQYIyABKAsyFi54aWFvbWkuTWlzY1NldHRpbmdTZXRSDm1pc2NTZXR0'
    'aW5nU2V0EkoKEnBob25lU2lsZW50TW9kZUdldBgkIAEoCzIaLnhpYW9taS5QaG9uZVNpbGVudE'
    '1vZGVHZXRSEnBob25lU2lsZW50TW9kZUdldBJKChJwaG9uZVNpbGVudE1vZGVTZXQYJSABKAsy'
    'Gi54aWFvbWkuUGhvbmVTaWxlbnRNb2RlU2V0UhJwaG9uZVNpbGVudE1vZGVTZXQSRwoRdmlicm'
    'F0aW9uUGF0dGVybnMYJiABKAsyGS54aWFvbWkuVmlicmF0aW9uUGF0dGVybnNSEXZpYnJhdGlv'
    'blBhdHRlcm5zElEKEnZpYnJhdGlvblNldFByZXNldBgnIAEoCzIhLnhpYW9taS5WaWJyYXRpb2'
    '5Ob3RpZmljYXRpb25UeXBlUhJ2aWJyYXRpb25TZXRQcmVzZXQSVgoWdmlicmF0aW9uUGF0dGVy'
    'bkNyZWF0ZRgoIAEoCzIeLnhpYW9taS5DdXN0b21WaWJyYXRpb25QYXR0ZXJuUhZ2aWJyYXRpb2'
    '5QYXR0ZXJuQ3JlYXRlEkcKE3ZpYnJhdGlvblRlc3RDdXN0b20YKSABKAsyFS54aWFvbWkuVmli'
    'cmF0aW9uVGVzdFITdmlicmF0aW9uVGVzdEN1c3RvbRJNChN2aWJyYXRpb25QYXR0ZXJuQWNrGC'
    'sgASgLMhsueGlhb21pLlZpYnJhdGlvblBhdHRlcm5BY2tSE3ZpYnJhdGlvblBhdHRlcm5BY2sS'
    'RAoQYmFzaWNEZXZpY2VTdGF0ZRgwIAEoCzIYLnhpYW9taS5CYXNpY0RldmljZVN0YXRlUhBiYX'
    'NpY0RldmljZVN0YXRlEjUKC2RldmljZVN0YXRlGDEgASgLMhMueGlhb21pLkRldmljZVN0YXRl'
    'UgtkZXZpY2VTdGF0ZQ==');

@$core.Deprecated('Use powerDescriptor instead')
const Power$json = {
  '1': 'Power',
  '2': [
    {
      '1': 'battery',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Battery',
      '10': 'battery',
    },
  ],
};

/// Descriptor for `Power`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List powerDescriptor = $convert.base64Decode(
  'CgVQb3dlchIpCgdiYXR0ZXJ5GAEgASgLMg8ueGlhb21pLkJhdHRlcnlSB2JhdHRlcnk=',
);

@$core.Deprecated('Use batteryDescriptor instead')
const Battery$json = {
  '1': 'Battery',
  '2': [
    {'1': 'level', '3': 1, '4': 1, '5': 13, '10': 'level'},
    {'1': 'state', '3': 2, '4': 1, '5': 13, '10': 'state'},
    {
      '1': 'lastCharge',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.LastCharge',
      '10': 'lastCharge',
    },
  ],
};

/// Descriptor for `Battery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batteryDescriptor = $convert.base64Decode(
    'CgdCYXR0ZXJ5EhQKBWxldmVsGAEgASgNUgVsZXZlbBIUCgVzdGF0ZRgCIAEoDVIFc3RhdGUSMg'
    'oKbGFzdENoYXJnZRgDIAEoCzISLnhpYW9taS5MYXN0Q2hhcmdlUgpsYXN0Q2hhcmdl');

@$core.Deprecated('Use lastChargeDescriptor instead')
const LastCharge$json = {
  '1': 'LastCharge',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 13, '10': 'state'},
    {
      '1': 'timestampSeconds',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'timestampSeconds',
    },
  ],
};

/// Descriptor for `LastCharge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lastChargeDescriptor = $convert.base64Decode(
    'CgpMYXN0Q2hhcmdlEhQKBXN0YXRlGAEgASgNUgVzdGF0ZRIqChB0aW1lc3RhbXBTZWNvbmRzGA'
    'IgASgNUhB0aW1lc3RhbXBTZWNvbmRz');

@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = {
  '1': 'DeviceInfo',
  '2': [
    {'1': 'serialNumber', '3': 1, '4': 2, '5': 9, '10': 'serialNumber'},
    {'1': 'firmware', '3': 2, '4': 2, '5': 9, '10': 'firmware'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 9, '10': 'unknown3'},
    {'1': 'model', '3': 4, '4': 2, '5': 9, '10': 'model'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VJbmZvEiIKDHNlcmlhbE51bWJlchgBIAIoCVIMc2VyaWFsTnVtYmVyEhoKCGZpcm'
    '13YXJlGAIgAigJUghmaXJtd2FyZRIaCgh1bmtub3duMxgDIAEoCVIIdW5rbm93bjMSFAoFbW9k'
    'ZWwYBCACKAlSBW1vZGVs');

@$core.Deprecated('Use clockDescriptor instead')
const Clock$json = {
  '1': 'Clock',
  '2': [
    {'1': 'date', '3': 1, '4': 2, '5': 11, '6': '.xiaomi.Date', '10': 'date'},
    {'1': 'time', '3': 2, '4': 2, '5': 11, '6': '.xiaomi.Time', '10': 'time'},
    {
      '1': 'timezone',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.xiaomi.TimeZone',
      '10': 'timezone',
    },
    {'1': 'isNot24hour', '3': 4, '4': 1, '5': 8, '10': 'isNot24hour'},
  ],
};

/// Descriptor for `Clock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clockDescriptor = $convert.base64Decode(
    'CgVDbG9jaxIgCgRkYXRlGAEgAigLMgwueGlhb21pLkRhdGVSBGRhdGUSIAoEdGltZRgCIAIoCz'
    'IMLnhpYW9taS5UaW1lUgR0aW1lEiwKCHRpbWV6b25lGAMgAigLMhAueGlhb21pLlRpbWVab25l'
    'Ugh0aW1lem9uZRIgCgtpc05vdDI0aG91chgEIAEoCFILaXNOb3QyNGhvdXI=');

@$core.Deprecated('Use dateDescriptor instead')
const Date$json = {
  '1': 'Date',
  '2': [
    {'1': 'year', '3': 1, '4': 2, '5': 13, '10': 'year'},
    {'1': 'month', '3': 2, '4': 2, '5': 13, '10': 'month'},
    {'1': 'day', '3': 3, '4': 2, '5': 13, '10': 'day'},
  ],
};

/// Descriptor for `Date`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateDescriptor = $convert.base64Decode(
    'CgREYXRlEhIKBHllYXIYASACKA1SBHllYXISFAoFbW9udGgYAiACKA1SBW1vbnRoEhAKA2RheR'
    'gDIAIoDVIDZGF5');

@$core.Deprecated('Use timeDescriptor instead')
const Time$json = {
  '1': 'Time',
  '2': [
    {'1': 'hour', '3': 1, '4': 2, '5': 13, '10': 'hour'},
    {'1': 'minute', '3': 2, '4': 2, '5': 13, '10': 'minute'},
    {'1': 'second', '3': 3, '4': 1, '5': 13, '10': 'second'},
    {'1': 'millisecond', '3': 4, '4': 1, '5': 13, '10': 'millisecond'},
  ],
};

/// Descriptor for `Time`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeDescriptor = $convert.base64Decode(
    'CgRUaW1lEhIKBGhvdXIYASACKA1SBGhvdXISFgoGbWludXRlGAIgAigNUgZtaW51dGUSFgoGc2'
    'Vjb25kGAMgASgNUgZzZWNvbmQSIAoLbWlsbGlzZWNvbmQYBCABKA1SC21pbGxpc2Vjb25k');

@$core.Deprecated('Use timeZoneDescriptor instead')
const TimeZone$json = {
  '1': 'TimeZone',
  '2': [
    {'1': 'zoneOffset', '3': 1, '4': 1, '5': 17, '10': 'zoneOffset'},
    {'1': 'dstOffset', '3': 2, '4': 1, '5': 17, '10': 'dstOffset'},
    {'1': 'name', '3': 3, '4': 2, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `TimeZone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeZoneDescriptor = $convert.base64Decode(
    'CghUaW1lWm9uZRIeCgp6b25lT2Zmc2V0GAEgASgRUgp6b25lT2Zmc2V0EhwKCWRzdE9mZnNldB'
    'gCIAEoEVIJZHN0T2Zmc2V0EhIKBG5hbWUYAyACKAlSBG5hbWU=');

@$core.Deprecated('Use raiseToWakeDescriptor instead')
const RaiseToWake$json = {
  '1': 'RaiseToWake',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 13, '10': 'mode'},
    {
      '1': 'start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'start',
    },
    {
      '1': 'end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'end',
    },
  ],
};

/// Descriptor for `RaiseToWake`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseToWakeDescriptor = $convert.base64Decode(
    'CgtSYWlzZVRvV2FrZRISCgRtb2RlGAEgASgNUgRtb2RlEigKBXN0YXJ0GAIgASgLMhIueGlhb2'
    '1pLkhvdXJNaW51dGVSBXN0YXJ0EiQKA2VuZBgDIAEoCzISLnhpYW9taS5Ib3VyTWludXRlUgNl'
    'bmQ=');

@$core.Deprecated('Use simpleWidgetsDescriptor instead')
const SimpleWidgets$json = {
  '1': 'SimpleWidgets',
  '2': [
    {
      '1': 'simpleWidget',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.SimpleWidget',
      '10': 'simpleWidget',
    },
    {'1': 'unk2', '3': 2, '4': 1, '5': 13, '10': 'unk2'},
    {'1': 'unk3', '3': 3, '4': 1, '5': 13, '10': 'unk3'},
  ],
};

/// Descriptor for `SimpleWidgets`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simpleWidgetsDescriptor = $convert.base64Decode(
    'Cg1TaW1wbGVXaWRnZXRzEjgKDHNpbXBsZVdpZGdldBgBIAMoCzIULnhpYW9taS5TaW1wbGVXaW'
    'RnZXRSDHNpbXBsZVdpZGdldBISCgR1bmsyGAIgASgNUgR1bmsyEhIKBHVuazMYAyABKA1SBHVu'
    'azM=');

@$core.Deprecated('Use simpleWidgetDescriptor instead')
const SimpleWidget$json = {
  '1': 'SimpleWidget',
  '2': [
    {'1': 'unk1', '3': 1, '4': 1, '5': 13, '10': 'unk1'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'unk3', '3': 3, '4': 1, '5': 13, '10': 'unk3'},
  ],
};

/// Descriptor for `SimpleWidget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simpleWidgetDescriptor = $convert.base64Decode(
    'CgxTaW1wbGVXaWRnZXQSEgoEdW5rMRgBIAEoDVIEdW5rMRIYCgdlbmFibGVkGAIgASgIUgdlbm'
    'FibGVkEhIKBHVuazMYAyABKA1SBHVuazM=');

@$core.Deprecated('Use displayItemsDescriptor instead')
const DisplayItems$json = {
  '1': 'DisplayItems',
  '2': [
    {
      '1': 'displayItem',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.DisplayItem',
      '10': 'displayItem',
    },
  ],
};

/// Descriptor for `DisplayItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displayItemsDescriptor = $convert.base64Decode(
    'CgxEaXNwbGF5SXRlbXMSNQoLZGlzcGxheUl0ZW0YASADKAsyEy54aWFvbWkuRGlzcGxheUl0ZW'
    '1SC2Rpc3BsYXlJdGVt');

@$core.Deprecated('Use displayItemDescriptor instead')
const DisplayItem$json = {
  '1': 'DisplayItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
    {'1': 'isSettings', '3': 4, '4': 1, '5': 13, '10': 'isSettings'},
    {'1': 'unknown5', '3': 5, '4': 1, '5': 13, '10': 'unknown5'},
    {'1': 'inMoreSection', '3': 6, '4': 1, '5': 8, '10': 'inMoreSection'},
  ],
};

/// Descriptor for `DisplayItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displayItemDescriptor = $convert.base64Decode(
    'CgtEaXNwbGF5SXRlbRISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAiABKAlSBG5hbWUSGg'
    'oIZGlzYWJsZWQYAyABKAhSCGRpc2FibGVkEh4KCmlzU2V0dGluZ3MYBCABKA1SCmlzU2V0dGlu'
    'Z3MSGgoIdW5rbm93bjUYBSABKA1SCHVua25vd241EiQKDWluTW9yZVNlY3Rpb24YBiABKAhSDW'
    'luTW9yZVNlY3Rpb24=');

@$core.Deprecated('Use cameraDescriptor instead')
const Camera$json = {
  '1': 'Camera',
  '2': [
    {'1': 'enabled', '3': 1, '4': 2, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `Camera`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraDescriptor =
    $convert.base64Decode('CgZDYW1lcmESGAoHZW5hYmxlZBgBIAIoCFIHZW5hYmxlZA==');

@$core.Deprecated('Use languageDescriptor instead')
const Language$json = {
  '1': 'Language',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `Language`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List languageDescriptor =
    $convert.base64Decode('CghMYW5ndWFnZRISCgRjb2RlGAEgASgJUgRjb2Rl');

@$core.Deprecated('Use workoutTypesDescriptor instead')
const WorkoutTypes$json = {
  '1': 'WorkoutTypes',
  '2': [
    {
      '1': 'workoutType',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WorkoutType',
      '10': 'workoutType',
    },
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `WorkoutTypes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutTypesDescriptor = $convert.base64Decode(
    'CgxXb3Jrb3V0VHlwZXMSNQoLd29ya291dFR5cGUYASADKAsyEy54aWFvbWkuV29ya291dFR5cG'
    'VSC3dvcmtvdXRUeXBlEhoKCHVua25vd24yGAIgASgNUgh1bmtub3duMg==');

@$core.Deprecated('Use workoutTypeDescriptor instead')
const WorkoutType$json = {
  '1': 'WorkoutType',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 13, '10': 'type'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `WorkoutType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutTypeDescriptor = $convert.base64Decode(
    'CgtXb3Jrb3V0VHlwZRISCgR0eXBlGAEgASgNUgR0eXBlEhoKCHVua25vd24yGAIgASgNUgh1bm'
    'tub3duMg==');

@$core.Deprecated('Use widgetScreensDescriptor instead')
const WidgetScreens$json = {
  '1': 'WidgetScreens',
  '2': [
    {
      '1': 'widgetScreen',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WidgetScreen',
      '10': 'widgetScreen',
    },
    {'1': 'isFullList', '3': 2, '4': 1, '5': 13, '10': 'isFullList'},
    {
      '1': 'widgetsCapabilities',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WidgetsCapabilities',
      '10': 'widgetsCapabilities',
    },
  ],
};

/// Descriptor for `WidgetScreens`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List widgetScreensDescriptor = $convert.base64Decode(
    'Cg1XaWRnZXRTY3JlZW5zEjgKDHdpZGdldFNjcmVlbhgBIAMoCzIULnhpYW9taS5XaWRnZXRTY3'
    'JlZW5SDHdpZGdldFNjcmVlbhIeCgppc0Z1bGxMaXN0GAIgASgNUgppc0Z1bGxMaXN0Ek0KE3dp'
    'ZGdldHNDYXBhYmlsaXRpZXMYAyABKAsyGy54aWFvbWkuV2lkZ2V0c0NhcGFiaWxpdGllc1ITd2'
    'lkZ2V0c0NhcGFiaWxpdGllcw==');

@$core.Deprecated('Use widgetsCapabilitiesDescriptor instead')
const WidgetsCapabilities$json = {
  '1': 'WidgetsCapabilities',
  '2': [
    {'1': 'minWidgets', '3': 1, '4': 1, '5': 13, '10': 'minWidgets'},
    {'1': 'maxWidgets', '3': 2, '4': 1, '5': 13, '10': 'maxWidgets'},
    {
      '1': 'supportedLayoutStyles',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'supportedLayoutStyles',
    },
  ],
};

/// Descriptor for `WidgetsCapabilities`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List widgetsCapabilitiesDescriptor = $convert.base64Decode(
    'ChNXaWRnZXRzQ2FwYWJpbGl0aWVzEh4KCm1pbldpZGdldHMYASABKA1SCm1pbldpZGdldHMSHg'
    'oKbWF4V2lkZ2V0cxgCIAEoDVIKbWF4V2lkZ2V0cxI0ChVzdXBwb3J0ZWRMYXlvdXRTdHlsZXMY'
    'AyABKA1SFXN1cHBvcnRlZExheW91dFN0eWxlcw==');

@$core.Deprecated('Use widgetScreenDescriptor instead')
const WidgetScreen$json = {
  '1': 'WidgetScreen',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'layout', '3': 2, '4': 1, '5': 13, '10': 'layout'},
    {
      '1': 'widgetPart',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WidgetPart',
      '10': 'widgetPart',
    },
  ],
};

/// Descriptor for `WidgetScreen`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List widgetScreenDescriptor = $convert.base64Decode(
    'CgxXaWRnZXRTY3JlZW4SDgoCaWQYASABKA1SAmlkEhYKBmxheW91dBgCIAEoDVIGbGF5b3V0Ej'
    'IKCndpZGdldFBhcnQYAyADKAsyEi54aWFvbWkuV2lkZ2V0UGFydFIKd2lkZ2V0UGFydA==');

@$core.Deprecated('Use widgetPartsDescriptor instead')
const WidgetParts$json = {
  '1': 'WidgetParts',
  '2': [
    {
      '1': 'widgetPart',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WidgetPart',
      '10': 'widgetPart',
    },
  ],
};

/// Descriptor for `WidgetParts`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List widgetPartsDescriptor = $convert.base64Decode(
    'CgtXaWRnZXRQYXJ0cxIyCgp3aWRnZXRQYXJ0GAEgAygLMhIueGlhb21pLldpZGdldFBhcnRSCn'
    'dpZGdldFBhcnQ=');

@$core.Deprecated('Use widgetPartDescriptor instead')
const WidgetPart$json = {
  '1': 'WidgetPart',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 13, '10': 'type'},
    {'1': 'function', '3': 2, '4': 1, '5': 13, '10': 'function'},
    {'1': 'id', '3': 3, '4': 1, '5': 13, '10': 'id'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subType', '3': 5, '4': 1, '5': 13, '10': 'subType'},
    {'1': 'appId', '3': 6, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'unknown7', '3': 7, '4': 1, '5': 9, '10': 'unknown7'},
  ],
};

/// Descriptor for `WidgetPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List widgetPartDescriptor = $convert.base64Decode(
    'CgpXaWRnZXRQYXJ0EhIKBHR5cGUYASABKA1SBHR5cGUSGgoIZnVuY3Rpb24YAiABKA1SCGZ1bm'
    'N0aW9uEg4KAmlkGAMgASgNUgJpZBIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSGAoHc3ViVHlwZRgF'
    'IAEoDVIHc3ViVHlwZRIUCgVhcHBJZBgGIAEoCVIFYXBwSWQSGgoIdW5rbm93bjcYByABKAlSCH'
    'Vua25vd243');

@$core.Deprecated('Use doNotDisturbDescriptor instead')
const DoNotDisturb$json = {
  '1': 'DoNotDisturb',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
  ],
};

/// Descriptor for `DoNotDisturb`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doNotDisturbDescriptor = $convert
    .base64Decode('CgxEb05vdERpc3R1cmISFgoGc3RhdHVzGAEgASgNUgZzdGF0dXM=');

@$core.Deprecated('Use miscSettingGetDescriptor instead')
const MiscSettingGet$json = {
  '1': 'MiscSettingGet',
  '2': [
    {'1': 'setting', '3': 1, '4': 1, '5': 13, '10': 'setting'},
  ],
};

/// Descriptor for `MiscSettingGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List miscSettingGetDescriptor = $convert
    .base64Decode('Cg5NaXNjU2V0dGluZ0dldBIYCgdzZXR0aW5nGAEgASgNUgdzZXR0aW5n');

@$core.Deprecated('Use miscSettingSetDescriptor instead')
const MiscSettingSet$json = {
  '1': 'MiscSettingSet',
  '2': [
    {
      '1': 'miscNotificationSettings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.MiscNotificationSettings',
      '10': 'miscNotificationSettings',
    },
    {
      '1': 'dndSync',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DndSync',
      '10': 'dndSync',
    },
    {
      '1': 'wearingMode',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WearingMode',
      '10': 'wearingMode',
    },
  ],
};

/// Descriptor for `MiscSettingSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List miscSettingSetDescriptor = $convert.base64Decode(
    'Cg5NaXNjU2V0dGluZ1NldBJcChhtaXNjTm90aWZpY2F0aW9uU2V0dGluZ3MYASABKAsyIC54aW'
    'FvbWkuTWlzY05vdGlmaWNhdGlvblNldHRpbmdzUhhtaXNjTm90aWZpY2F0aW9uU2V0dGluZ3MS'
    'KQoHZG5kU3luYxgCIAEoCzIPLnhpYW9taS5EbmRTeW5jUgdkbmRTeW5jEjUKC3dlYXJpbmdNb2'
    'RlGAMgASgLMhMueGlhb21pLldlYXJpbmdNb2RlUgt3ZWFyaW5nTW9kZQ==');

@$core.Deprecated('Use miscNotificationSettingsDescriptor instead')
const MiscNotificationSettings$json = {
  '1': 'MiscNotificationSettings',
  '2': [
    {'1': 'wakeScreen', '3': 1, '4': 1, '5': 13, '10': 'wakeScreen'},
    {
      '1': 'onlyWhenPhoneLocked',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'onlyWhenPhoneLocked',
    },
    {'1': 'onlyWhenWorn', '3': 3, '4': 1, '5': 13, '10': 'onlyWhenWorn'},
  ],
};

/// Descriptor for `MiscNotificationSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List miscNotificationSettingsDescriptor = $convert.base64Decode(
    'ChhNaXNjTm90aWZpY2F0aW9uU2V0dGluZ3MSHgoKd2FrZVNjcmVlbhgBIAEoDVIKd2FrZVNjcm'
    'VlbhIwChNvbmx5V2hlblBob25lTG9ja2VkGAIgASgNUhNvbmx5V2hlblBob25lTG9ja2VkEiIK'
    'DG9ubHlXaGVuV29ybhgDIAEoDVIMb25seVdoZW5Xb3Ju');

@$core.Deprecated('Use dndSyncDescriptor instead')
const DndSync$json = {
  '1': 'DndSync',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 13, '10': 'enabled'},
  ],
};

/// Descriptor for `DndSync`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dndSyncDescriptor =
    $convert.base64Decode('CgdEbmRTeW5jEhgKB2VuYWJsZWQYASABKA1SB2VuYWJsZWQ=');

@$core.Deprecated('Use wearingModeDescriptor instead')
const WearingMode$json = {
  '1': 'WearingMode',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 13, '10': 'mode'},
  ],
};

/// Descriptor for `WearingMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wearingModeDescriptor =
    $convert.base64Decode('CgtXZWFyaW5nTW9kZRISCgRtb2RlGAEgASgNUgRtb2Rl');

@$core.Deprecated('Use firmwareInstallRequestDescriptor instead')
const FirmwareInstallRequest$json = {
  '1': 'FirmwareInstallRequest',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'md5', '3': 4, '4': 1, '5': 9, '10': 'md5'},
  ],
};

/// Descriptor for `FirmwareInstallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List firmwareInstallRequestDescriptor = $convert.base64Decode(
    'ChZGaXJtd2FyZUluc3RhbGxSZXF1ZXN0EhoKCHVua25vd24xGAEgASgNUgh1bmtub3duMRIaCg'
    'h1bmtub3duMhgCIAEoDVIIdW5rbm93bjISGAoHdmVyc2lvbhgDIAEoCVIHdmVyc2lvbhIQCgNt'
    'ZDUYBCABKAlSA21kNQ==');

@$core.Deprecated('Use firmwareInstallResponseDescriptor instead')
const FirmwareInstallResponse$json = {
  '1': 'FirmwareInstallResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
  ],
};

/// Descriptor for `FirmwareInstallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List firmwareInstallResponseDescriptor =
    $convert.base64Decode(
  'ChdGaXJtd2FyZUluc3RhbGxSZXNwb25zZRIWCgZzdGF0dXMYASABKA1SBnN0YXR1cw==',
);

@$core.Deprecated('Use passwordDescriptor instead')
const Password$json = {
  '1': 'Password',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 13, '10': 'state'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
  ],
};

/// Descriptor for `Password`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passwordDescriptor = $convert.base64Decode(
    'CghQYXNzd29yZBIUCgVzdGF0ZRgBIAEoDVIFc3RhdGUSGgoIcGFzc3dvcmQYAiABKAlSCHBhc3'
    'N3b3JkEhoKCHVua25vd24zGAMgASgNUgh1bmtub3duMw==');

@$core.Deprecated('Use phoneSilentModeGetDescriptor instead')
const PhoneSilentModeGet$json = {
  '1': 'PhoneSilentModeGet',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
  ],
};

/// Descriptor for `PhoneSilentModeGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneSilentModeGetDescriptor =
    $convert.base64Decode(
  'ChJQaG9uZVNpbGVudE1vZGVHZXQSGgoIdW5rbm93bjEYASABKA1SCHVua25vd24x',
);

@$core.Deprecated('Use phoneSilentModeSetDescriptor instead')
const PhoneSilentModeSet$json = {
  '1': 'PhoneSilentModeSet',
  '2': [
    {
      '1': 'phoneSilentMode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.PhoneSilentMode',
      '10': 'phoneSilentMode',
    },
  ],
};

/// Descriptor for `PhoneSilentModeSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneSilentModeSetDescriptor = $convert.base64Decode(
    'ChJQaG9uZVNpbGVudE1vZGVTZXQSQQoPcGhvbmVTaWxlbnRNb2RlGAEgASgLMhcueGlhb21pLl'
    'Bob25lU2lsZW50TW9kZVIPcGhvbmVTaWxlbnRNb2Rl');

@$core.Deprecated('Use phoneSilentModeDescriptor instead')
const PhoneSilentMode$json = {
  '1': 'PhoneSilentMode',
  '2': [
    {'1': 'silent', '3': 1, '4': 1, '5': 8, '10': 'silent'},
  ],
};

/// Descriptor for `PhoneSilentMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneSilentModeDescriptor = $convert
    .base64Decode('Cg9QaG9uZVNpbGVudE1vZGUSFgoGc2lsZW50GAEgASgIUgZzaWxlbnQ=');

@$core.Deprecated('Use vibrationPatternsDescriptor instead')
const VibrationPatterns$json = {
  '1': 'VibrationPatterns',
  '2': [
    {
      '1': 'notificationType',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.VibrationNotificationType',
      '10': 'notificationType',
    },
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
    {
      '1': 'customVibrationPattern',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.CustomVibrationPattern',
      '10': 'customVibrationPattern',
    },
  ],
};

/// Descriptor for `VibrationPatterns`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vibrationPatternsDescriptor = $convert.base64Decode(
    'ChFWaWJyYXRpb25QYXR0ZXJucxJNChBub3RpZmljYXRpb25UeXBlGAEgAygLMiEueGlhb21pLl'
    'ZpYnJhdGlvbk5vdGlmaWNhdGlvblR5cGVSEG5vdGlmaWNhdGlvblR5cGUSGgoIdW5rbm93bjIY'
    'AiABKA1SCHVua25vd24yElYKFmN1c3RvbVZpYnJhdGlvblBhdHRlcm4YAyADKAsyHi54aWFvbW'
    'kuQ3VzdG9tVmlicmF0aW9uUGF0dGVyblIWY3VzdG9tVmlicmF0aW9uUGF0dGVybg==');

@$core.Deprecated('Use customVibrationPatternDescriptor instead')
const CustomVibrationPattern$json = {
  '1': 'CustomVibrationPattern',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'vibration',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Vibration',
      '10': 'vibration',
    },
    {'1': 'unknown4', '3': 4, '4': 1, '5': 13, '10': 'unknown4'},
  ],
};

/// Descriptor for `CustomVibrationPattern`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List customVibrationPatternDescriptor = $convert.base64Decode(
    'ChZDdXN0b21WaWJyYXRpb25QYXR0ZXJuEg4KAmlkGAEgASgNUgJpZBISCgRuYW1lGAIgASgJUg'
    'RuYW1lEi8KCXZpYnJhdGlvbhgDIAMoCzIRLnhpYW9taS5WaWJyYXRpb25SCXZpYnJhdGlvbhIa'
    'Cgh1bmtub3duNBgEIAEoDVIIdW5rbm93bjQ=');

@$core.Deprecated('Use vibrationNotificationTypeDescriptor instead')
const VibrationNotificationType$json = {
  '1': 'VibrationNotificationType',
  '2': [
    {
      '1': 'notificationType',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'notificationType',
    },
    {'1': 'preset', '3': 2, '4': 1, '5': 13, '10': 'preset'},
  ],
};

/// Descriptor for `VibrationNotificationType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vibrationNotificationTypeDescriptor =
    $convert.base64Decode(
        'ChlWaWJyYXRpb25Ob3RpZmljYXRpb25UeXBlEioKEG5vdGlmaWNhdGlvblR5cGUYASABKA1SEG'
        '5vdGlmaWNhdGlvblR5cGUSFgoGcHJlc2V0GAIgASgNUgZwcmVzZXQ=');

@$core.Deprecated('Use vibrationTestDescriptor instead')
const VibrationTest$json = {
  '1': 'VibrationTest',
  '2': [
    {
      '1': 'vibration',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Vibration',
      '10': 'vibration',
    },
  ],
};

/// Descriptor for `VibrationTest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vibrationTestDescriptor = $convert.base64Decode(
    'Cg1WaWJyYXRpb25UZXN0Ei8KCXZpYnJhdGlvbhgBIAMoCzIRLnhpYW9taS5WaWJyYXRpb25SCX'
    'ZpYnJhdGlvbg==');

@$core.Deprecated('Use vibrationPatternAckDescriptor instead')
const VibrationPatternAck$json = {
  '1': 'VibrationPatternAck',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
  ],
};

/// Descriptor for `VibrationPatternAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vibrationPatternAckDescriptor =
    $convert.base64Decode(
  'ChNWaWJyYXRpb25QYXR0ZXJuQWNrEhYKBnN0YXR1cxgBIAEoDVIGc3RhdHVz',
);

@$core.Deprecated('Use vibrationDescriptor instead')
const Vibration$json = {
  '1': 'Vibration',
  '2': [
    {'1': 'vibrate', '3': 1, '4': 1, '5': 13, '10': 'vibrate'},
    {'1': 'ms', '3': 2, '4': 1, '5': 13, '10': 'ms'},
  ],
};

/// Descriptor for `Vibration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vibrationDescriptor = $convert.base64Decode(
  'CglWaWJyYXRpb24SGAoHdmlicmF0ZRgBIAEoDVIHdmlicmF0ZRIOCgJtcxgCIAEoDVICbXM=',
);

@$core.Deprecated('Use deviceActivityStateDescriptor instead')
const DeviceActivityState$json = {
  '1': 'DeviceActivityState',
  '2': [
    {'1': 'activityType', '3': 1, '4': 1, '5': 13, '10': 'activityType'},
    {
      '1': 'currentActivityState',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'currentActivityState',
    },
  ],
};

/// Descriptor for `DeviceActivityState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceActivityStateDescriptor = $convert.base64Decode(
    'ChNEZXZpY2VBY3Rpdml0eVN0YXRlEiIKDGFjdGl2aXR5VHlwZRgBIAEoDVIMYWN0aXZpdHlUeX'
    'BlEjIKFGN1cnJlbnRBY3Rpdml0eVN0YXRlGAIgASgNUhRjdXJyZW50QWN0aXZpdHlTdGF0ZQ==');

@$core.Deprecated('Use basicDeviceStateDescriptor instead')
const BasicDeviceState$json = {
  '1': 'BasicDeviceState',
  '2': [
    {'1': 'isCharging', '3': 1, '4': 2, '5': 8, '10': 'isCharging'},
    {'1': 'batteryLevel', '3': 2, '4': 1, '5': 13, '10': 'batteryLevel'},
    {'1': 'isWorn', '3': 3, '4': 2, '5': 8, '10': 'isWorn'},
    {'1': 'isUserAsleep', '3': 4, '4': 2, '5': 8, '10': 'isUserAsleep'},
    {
      '1': 'activityState',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DeviceActivityState',
      '10': 'activityState',
    },
  ],
};

/// Descriptor for `BasicDeviceState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List basicDeviceStateDescriptor = $convert.base64Decode(
    'ChBCYXNpY0RldmljZVN0YXRlEh4KCmlzQ2hhcmdpbmcYASACKAhSCmlzQ2hhcmdpbmcSIgoMYm'
    'F0dGVyeUxldmVsGAIgASgNUgxiYXR0ZXJ5TGV2ZWwSFgoGaXNXb3JuGAMgAigIUgZpc1dvcm4S'
    'IgoMaXNVc2VyQXNsZWVwGAQgAigIUgxpc1VzZXJBc2xlZXASQQoNYWN0aXZpdHlTdGF0ZRgFIA'
    'EoCzIbLnhpYW9taS5EZXZpY2VBY3Rpdml0eVN0YXRlUg1hY3Rpdml0eVN0YXRl');

@$core.Deprecated('Use deviceStateDescriptor instead')
const DeviceState$json = {
  '1': 'DeviceState',
  '2': [
    {'1': 'chargingState', '3': 1, '4': 1, '5': 13, '10': 'chargingState'},
    {'1': 'wearingState', '3': 2, '4': 1, '5': 13, '10': 'wearingState'},
    {'1': 'sleepState', '3': 3, '4': 1, '5': 13, '10': 'sleepState'},
    {'1': 'warningState', '3': 4, '4': 1, '5': 13, '10': 'warningState'},
    {
      '1': 'activityState',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DeviceActivityState',
      '10': 'activityState',
    },
  ],
};

/// Descriptor for `DeviceState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceStateDescriptor = $convert.base64Decode(
    'CgtEZXZpY2VTdGF0ZRIkCg1jaGFyZ2luZ1N0YXRlGAEgASgNUg1jaGFyZ2luZ1N0YXRlEiIKDH'
    'dlYXJpbmdTdGF0ZRgCIAEoDVIMd2VhcmluZ1N0YXRlEh4KCnNsZWVwU3RhdGUYAyABKA1SCnNs'
    'ZWVwU3RhdGUSIgoMd2FybmluZ1N0YXRlGAQgASgNUgx3YXJuaW5nU3RhdGUSQQoNYWN0aXZpdH'
    'lTdGF0ZRgFIAEoCzIbLnhpYW9taS5EZXZpY2VBY3Rpdml0eVN0YXRlUg1hY3Rpdml0eVN0YXRl');

@$core.Deprecated('Use watchfaceDescriptor instead')
const Watchface$json = {
  '1': 'Watchface',
  '2': [
    {
      '1': 'watchfaceList',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WatchfaceList',
      '10': 'watchfaceList',
    },
    {'1': 'watchfaceId', '3': 2, '4': 1, '5': 9, '10': 'watchfaceId'},
    {'1': 'ack', '3': 4, '4': 1, '5': 13, '10': 'ack'},
    {'1': 'installStatus', '3': 5, '4': 1, '5': 13, '10': 'installStatus'},
    {
      '1': 'watchfaceInstallStart',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WatchfaceInstallStart',
      '10': 'watchfaceInstallStart',
    },
    {
      '1': 'watchfaceInstallFinish',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WatchfaceInstallFinish',
      '10': 'watchfaceInstallFinish',
    },
  ],
};

/// Descriptor for `Watchface`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchfaceDescriptor = $convert.base64Decode(
    'CglXYXRjaGZhY2USOwoNd2F0Y2hmYWNlTGlzdBgBIAEoCzIVLnhpYW9taS5XYXRjaGZhY2VMaX'
    'N0Ug13YXRjaGZhY2VMaXN0EiAKC3dhdGNoZmFjZUlkGAIgASgJUgt3YXRjaGZhY2VJZBIQCgNh'
    'Y2sYBCABKA1SA2FjaxIkCg1pbnN0YWxsU3RhdHVzGAUgASgNUg1pbnN0YWxsU3RhdHVzElMKFX'
    'dhdGNoZmFjZUluc3RhbGxTdGFydBgGIAEoCzIdLnhpYW9taS5XYXRjaGZhY2VJbnN0YWxsU3Rh'
    'cnRSFXdhdGNoZmFjZUluc3RhbGxTdGFydBJWChZ3YXRjaGZhY2VJbnN0YWxsRmluaXNoGAcgAS'
    'gLMh4ueGlhb21pLldhdGNoZmFjZUluc3RhbGxGaW5pc2hSFndhdGNoZmFjZUluc3RhbGxGaW5p'
    'c2g=');

@$core.Deprecated('Use watchfaceListDescriptor instead')
const WatchfaceList$json = {
  '1': 'WatchfaceList',
  '2': [
    {
      '1': 'watchface',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WatchfaceInfo',
      '10': 'watchface',
    },
  ],
};

/// Descriptor for `WatchfaceList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchfaceListDescriptor = $convert.base64Decode(
    'Cg1XYXRjaGZhY2VMaXN0EjMKCXdhdGNoZmFjZRgBIAMoCzIVLnhpYW9taS5XYXRjaGZhY2VJbm'
    'ZvUgl3YXRjaGZhY2U=');

@$core.Deprecated('Use watchfaceInfoDescriptor instead')
const WatchfaceInfo$json = {
  '1': 'WatchfaceInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'active', '3': 3, '4': 1, '5': 8, '10': 'active'},
    {'1': 'canDelete', '3': 4, '4': 1, '5': 8, '10': 'canDelete'},
    {'1': 'unknown5', '3': 5, '4': 1, '5': 13, '10': 'unknown5'},
    {'1': 'unknown6', '3': 6, '4': 1, '5': 13, '10': 'unknown6'},
    {'1': 'unknown11', '3': 11, '4': 1, '5': 13, '10': 'unknown11'},
  ],
};

/// Descriptor for `WatchfaceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchfaceInfoDescriptor = $convert.base64Decode(
    'Cg1XYXRjaGZhY2VJbmZvEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhYKBm'
    'FjdGl2ZRgDIAEoCFIGYWN0aXZlEhwKCWNhbkRlbGV0ZRgEIAEoCFIJY2FuRGVsZXRlEhoKCHVu'
    'a25vd241GAUgASgNUgh1bmtub3duNRIaCgh1bmtub3duNhgGIAEoDVIIdW5rbm93bjYSHAoJdW'
    '5rbm93bjExGAsgASgNUgl1bmtub3duMTE=');

@$core.Deprecated('Use watchfaceInstallStartDescriptor instead')
const WatchfaceInstallStart$json = {
  '1': 'WatchfaceInstallStart',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'size', '3': 2, '4': 1, '5': 13, '10': 'size'},
  ],
};

/// Descriptor for `WatchfaceInstallStart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchfaceInstallStartDescriptor = $convert.base64Decode(
    'ChVXYXRjaGZhY2VJbnN0YWxsU3RhcnQSDgoCaWQYASABKAlSAmlkEhIKBHNpemUYAiABKA1SBH'
    'NpemU=');

@$core.Deprecated('Use watchfaceInstallFinishDescriptor instead')
const WatchfaceInstallFinish$json = {
  '1': 'WatchfaceInstallFinish',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
    {'1': 'unknown4', '3': 4, '4': 1, '5': 13, '10': 'unknown4'},
  ],
};

/// Descriptor for `WatchfaceInstallFinish`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchfaceInstallFinishDescriptor = $convert.base64Decode(
    'ChZXYXRjaGZhY2VJbnN0YWxsRmluaXNoEg4KAmlkGAEgASgJUgJpZBIaCgh1bmtub3duMhgCIA'
    'EoDVIIdW5rbm93bjISGgoIdW5rbm93bjMYAyABKA1SCHVua25vd24zEhoKCHVua25vd240GAQg'
    'ASgNUgh1bmtub3duNA==');

@$core.Deprecated('Use healthDescriptor instead')
const Health$json = {
  '1': 'Health',
  '2': [
    {
      '1': 'userInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.UserInfo',
      '10': 'userInfo',
    },
    {
      '1': 'activityRequestFileIds',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'activityRequestFileIds',
    },
    {
      '1': 'activitySyncAckFileIds',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'activitySyncAckFileIds',
    },
    {
      '1': 'activitySyncRequestToday',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ActivitySyncRequestToday',
      '10': 'activitySyncRequestToday',
    },
    {'1': 'spo2', '3': 7, '4': 1, '5': 11, '6': '.xiaomi.SpO2', '10': 'spo2'},
    {
      '1': 'heartRate',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HeartRate',
      '10': 'heartRate',
    },
    {
      '1': 'standingReminder',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.StandingReminder',
      '10': 'standingReminder',
    },
    {
      '1': 'stress',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Stress',
      '10': 'stress',
    },
    {
      '1': 'goalNotification',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.GoalNotification',
      '10': 'goalNotification',
    },
    {
      '1': 'vitalityScore',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.VitalityScore',
      '10': 'vitalityScore',
    },
    {
      '1': 'workoutStatusWatch',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorkoutStatusWatch',
      '10': 'workoutStatusWatch',
    },
    {
      '1': 'workoutOpenWatch',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorkoutOpenWatch',
      '10': 'workoutOpenWatch',
    },
    {
      '1': 'workoutOpenReply',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorkoutOpenReply',
      '10': 'workoutOpenReply',
    },
    {
      '1': 'goalsConfig',
      '3': 38,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.GoalsConfig',
      '10': 'goalsConfig',
    },
    {
      '1': 'workoutLocation',
      '3': 40,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorkoutLocation',
      '10': 'workoutLocation',
    },
    {
      '1': 'realTimeStats',
      '3': 39,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.RealTimeStats',
      '10': 'realTimeStats',
    },
  ],
};

/// Descriptor for `Health`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthDescriptor = $convert.base64Decode(
    'CgZIZWFsdGgSLAoIdXNlckluZm8YASABKAsyEC54aWFvbWkuVXNlckluZm9SCHVzZXJJbmZvEj'
    'YKFmFjdGl2aXR5UmVxdWVzdEZpbGVJZHMYAiABKAxSFmFjdGl2aXR5UmVxdWVzdEZpbGVJZHMS'
    'NgoWYWN0aXZpdHlTeW5jQWNrRmlsZUlkcxgDIAEoDFIWYWN0aXZpdHlTeW5jQWNrRmlsZUlkcx'
    'JcChhhY3Rpdml0eVN5bmNSZXF1ZXN0VG9kYXkYBSABKAsyIC54aWFvbWkuQWN0aXZpdHlTeW5j'
    'UmVxdWVzdFRvZGF5UhhhY3Rpdml0eVN5bmNSZXF1ZXN0VG9kYXkSIAoEc3BvMhgHIAEoCzIMLn'
    'hpYW9taS5TcE8yUgRzcG8yEi8KCWhlYXJ0UmF0ZRgIIAEoCzIRLnhpYW9taS5IZWFydFJhdGVS'
    'CWhlYXJ0UmF0ZRJEChBzdGFuZGluZ1JlbWluZGVyGAkgASgLMhgueGlhb21pLlN0YW5kaW5nUm'
    'VtaW5kZXJSEHN0YW5kaW5nUmVtaW5kZXISJgoGc3RyZXNzGAogASgLMg4ueGlhb21pLlN0cmVz'
    'c1IGc3RyZXNzEkQKEGdvYWxOb3RpZmljYXRpb24YDSABKAsyGC54aWFvbWkuR29hbE5vdGlmaW'
    'NhdGlvblIQZ29hbE5vdGlmaWNhdGlvbhI7Cg12aXRhbGl0eVNjb3JlGA4gASgLMhUueGlhb21p'
    'LlZpdGFsaXR5U2NvcmVSDXZpdGFsaXR5U2NvcmUSSgoSd29ya291dFN0YXR1c1dhdGNoGBQgAS'
    'gLMhoueGlhb21pLldvcmtvdXRTdGF0dXNXYXRjaFISd29ya291dFN0YXR1c1dhdGNoEkQKEHdv'
    'cmtvdXRPcGVuV2F0Y2gYGSABKAsyGC54aWFvbWkuV29ya291dE9wZW5XYXRjaFIQd29ya291dE'
    '9wZW5XYXRjaBJEChB3b3Jrb3V0T3BlblJlcGx5GBogASgLMhgueGlhb21pLldvcmtvdXRPcGVu'
    'UmVwbHlSEHdvcmtvdXRPcGVuUmVwbHkSNQoLZ29hbHNDb25maWcYJiABKAsyEy54aWFvbWkuR2'
    '9hbHNDb25maWdSC2dvYWxzQ29uZmlnEkEKD3dvcmtvdXRMb2NhdGlvbhgoIAEoCzIXLnhpYW9t'
    'aS5Xb3Jrb3V0TG9jYXRpb25SD3dvcmtvdXRMb2NhdGlvbhI7Cg1yZWFsVGltZVN0YXRzGCcgAS'
    'gLMhUueGlhb21pLlJlYWxUaW1lU3RhdHNSDXJlYWxUaW1lU3RhdHM=');

@$core.Deprecated('Use userInfoDescriptor instead')
const UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'height', '3': 1, '4': 1, '5': 13, '10': 'height'},
    {'1': 'weight', '3': 2, '4': 1, '5': 2, '10': 'weight'},
    {'1': 'birthday', '3': 3, '4': 1, '5': 13, '10': 'birthday'},
    {'1': 'gender', '3': 4, '4': 1, '5': 13, '10': 'gender'},
    {'1': 'maxHeartRate', '3': 5, '4': 1, '5': 13, '10': 'maxHeartRate'},
    {'1': 'goalCalories', '3': 6, '4': 1, '5': 13, '10': 'goalCalories'},
    {'1': 'goalSteps', '3': 7, '4': 1, '5': 13, '10': 'goalSteps'},
    {'1': 'goalStanding', '3': 9, '4': 1, '5': 13, '10': 'goalStanding'},
    {'1': 'goalMoving', '3': 11, '4': 1, '5': 13, '10': 'goalMoving'},
  ],
};

/// Descriptor for `UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoDescriptor = $convert.base64Decode(
    'CghVc2VySW5mbxIWCgZoZWlnaHQYASABKA1SBmhlaWdodBIWCgZ3ZWlnaHQYAiABKAJSBndlaW'
    'dodBIaCghiaXJ0aGRheRgDIAEoDVIIYmlydGhkYXkSFgoGZ2VuZGVyGAQgASgNUgZnZW5kZXIS'
    'IgoMbWF4SGVhcnRSYXRlGAUgASgNUgxtYXhIZWFydFJhdGUSIgoMZ29hbENhbG9yaWVzGAYgAS'
    'gNUgxnb2FsQ2Fsb3JpZXMSHAoJZ29hbFN0ZXBzGAcgASgNUglnb2FsU3RlcHMSIgoMZ29hbFN0'
    'YW5kaW5nGAkgASgNUgxnb2FsU3RhbmRpbmcSHgoKZ29hbE1vdmluZxgLIAEoDVIKZ29hbE1vdm'
    'luZw==');

@$core.Deprecated('Use activitySyncRequestTodayDescriptor instead')
const ActivitySyncRequestToday$json = {
  '1': 'ActivitySyncRequestToday',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
  ],
};

/// Descriptor for `ActivitySyncRequestToday`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activitySyncRequestTodayDescriptor =
    $convert.base64Decode(
  'ChhBY3Rpdml0eVN5bmNSZXF1ZXN0VG9kYXkSGgoIdW5rbm93bjEYASABKA1SCHVua25vd24x',
);

@$core.Deprecated('Use spO2Descriptor instead')
const SpO2$json = {
  '1': 'SpO2',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
    {'1': 'allDayTracking', '3': 2, '4': 1, '5': 8, '10': 'allDayTracking'},
    {
      '1': 'alarmLow',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Spo2AlarmLow',
      '10': 'alarmLow',
    },
  ],
};

/// Descriptor for `SpO2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spO2Descriptor = $convert.base64Decode(
    'CgRTcE8yEhoKCHVua25vd24xGAEgASgNUgh1bmtub3duMRImCg5hbGxEYXlUcmFja2luZxgCIA'
    'EoCFIOYWxsRGF5VHJhY2tpbmcSMAoIYWxhcm1Mb3cYBCABKAsyFC54aWFvbWkuU3BvMkFsYXJt'
    'TG93UghhbGFybUxvdw==');

@$core.Deprecated('Use spo2AlarmLowDescriptor instead')
const Spo2AlarmLow$json = {
  '1': 'Spo2AlarmLow',
  '2': [
    {'1': 'alarmLowEnabled', '3': 1, '4': 1, '5': 8, '10': 'alarmLowEnabled'},
    {
      '1': 'alarmLowThreshold',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'alarmLowThreshold',
    },
  ],
};

/// Descriptor for `Spo2AlarmLow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spo2AlarmLowDescriptor = $convert.base64Decode(
    'CgxTcG8yQWxhcm1Mb3cSKAoPYWxhcm1Mb3dFbmFibGVkGAEgASgIUg9hbGFybUxvd0VuYWJsZW'
    'QSLAoRYWxhcm1Mb3dUaHJlc2hvbGQYAiABKA1SEWFsYXJtTG93VGhyZXNob2xk');

@$core.Deprecated('Use heartRateDescriptor instead')
const HeartRate$json = {
  '1': 'HeartRate',
  '2': [
    {'1': 'disabled', '3': 1, '4': 1, '5': 8, '10': 'disabled'},
    {'1': 'interval', '3': 2, '4': 1, '5': 13, '10': 'interval'},
    {'1': 'alarmHighEnabled', '3': 3, '4': 1, '5': 8, '10': 'alarmHighEnabled'},
    {
      '1': 'alarmHighThreshold',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'alarmHighThreshold',
    },
    {
      '1': 'advancedMonitoring',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AdvancedMonitoring',
      '10': 'advancedMonitoring',
    },
    {'1': 'unknown7', '3': 7, '4': 1, '5': 13, '10': 'unknown7'},
    {
      '1': 'heartRateAlarmLow',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HeartRateAlarmLow',
      '10': 'heartRateAlarmLow',
    },
    {'1': 'breathingScore', '3': 9, '4': 1, '5': 13, '10': 'breathingScore'},
  ],
};

/// Descriptor for `HeartRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartRateDescriptor = $convert.base64Decode(
    'CglIZWFydFJhdGUSGgoIZGlzYWJsZWQYASABKAhSCGRpc2FibGVkEhoKCGludGVydmFsGAIgAS'
    'gNUghpbnRlcnZhbBIqChBhbGFybUhpZ2hFbmFibGVkGAMgASgIUhBhbGFybUhpZ2hFbmFibGVk'
    'Ei4KEmFsYXJtSGlnaFRocmVzaG9sZBgEIAEoDVISYWxhcm1IaWdoVGhyZXNob2xkEkoKEmFkdm'
    'FuY2VkTW9uaXRvcmluZxgFIAEoCzIaLnhpYW9taS5BZHZhbmNlZE1vbml0b3JpbmdSEmFkdmFu'
    'Y2VkTW9uaXRvcmluZxIaCgh1bmtub3duNxgHIAEoDVIIdW5rbm93bjcSRwoRaGVhcnRSYXRlQW'
    'xhcm1Mb3cYCCABKAsyGS54aWFvbWkuSGVhcnRSYXRlQWxhcm1Mb3dSEWhlYXJ0UmF0ZUFsYXJt'
    'TG93EiYKDmJyZWF0aGluZ1Njb3JlGAkgASgNUg5icmVhdGhpbmdTY29yZQ==');

@$core.Deprecated('Use advancedMonitoringDescriptor instead')
const AdvancedMonitoring$json = {
  '1': 'AdvancedMonitoring',
  '2': [
    {'1': 'enabled', '3': 1, '4': 2, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `AdvancedMonitoring`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advancedMonitoringDescriptor =
    $convert.base64Decode(
  'ChJBZHZhbmNlZE1vbml0b3JpbmcSGAoHZW5hYmxlZBgBIAIoCFIHZW5hYmxlZA==',
);

@$core.Deprecated('Use heartRateAlarmLowDescriptor instead')
const HeartRateAlarmLow$json = {
  '1': 'HeartRateAlarmLow',
  '2': [
    {'1': 'alarmLowEnabled', '3': 1, '4': 1, '5': 8, '10': 'alarmLowEnabled'},
    {
      '1': 'alarmLowThreshold',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'alarmLowThreshold',
    },
  ],
};

/// Descriptor for `HeartRateAlarmLow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartRateAlarmLowDescriptor = $convert.base64Decode(
    'ChFIZWFydFJhdGVBbGFybUxvdxIoCg9hbGFybUxvd0VuYWJsZWQYASABKAhSD2FsYXJtTG93RW'
    '5hYmxlZBIsChFhbGFybUxvd1RocmVzaG9sZBgCIAEoDVIRYWxhcm1Mb3dUaHJlc2hvbGQ=');

@$core.Deprecated('Use standingReminderDescriptor instead')
const StandingReminder$json = {
  '1': 'StandingReminder',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'start',
    },
    {
      '1': 'end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'end',
    },
    {'1': 'dnd', '3': 4, '4': 1, '5': 8, '10': 'dnd'},
    {
      '1': 'dndStart',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'dndStart',
    },
    {
      '1': 'dndEnd',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'dndEnd',
    },
  ],
};

/// Descriptor for `StandingReminder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List standingReminderDescriptor = $convert.base64Decode(
    'ChBTdGFuZGluZ1JlbWluZGVyEhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQSKAoFc3RhcnQYAi'
    'ABKAsyEi54aWFvbWkuSG91ck1pbnV0ZVIFc3RhcnQSJAoDZW5kGAMgASgLMhIueGlhb21pLkhv'
    'dXJNaW51dGVSA2VuZBIQCgNkbmQYBCABKAhSA2RuZBIuCghkbmRTdGFydBgGIAEoCzISLnhpYW'
    '9taS5Ib3VyTWludXRlUghkbmRTdGFydBIqCgZkbmRFbmQYByABKAsyEi54aWFvbWkuSG91ck1p'
    'bnV0ZVIGZG5kRW5k');

@$core.Deprecated('Use stressDescriptor instead')
const Stress$json = {
  '1': 'Stress',
  '2': [
    {'1': 'allDayTracking', '3': 1, '4': 1, '5': 8, '10': 'allDayTracking'},
    {
      '1': 'relaxReminder',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.RelaxReminder',
      '10': 'relaxReminder',
    },
  ],
};

/// Descriptor for `Stress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stressDescriptor = $convert.base64Decode(
    'CgZTdHJlc3MSJgoOYWxsRGF5VHJhY2tpbmcYASABKAhSDmFsbERheVRyYWNraW5nEjsKDXJlbG'
    'F4UmVtaW5kZXIYAiABKAsyFS54aWFvbWkuUmVsYXhSZW1pbmRlclINcmVsYXhSZW1pbmRlcg==');

@$core.Deprecated('Use goalNotificationDescriptor instead')
const GoalNotification$json = {
  '1': 'GoalNotification',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `GoalNotification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalNotificationDescriptor = $convert.base64Decode(
    'ChBHb2FsTm90aWZpY2F0aW9uEhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQSGgoIdW5rbm93bj'
    'IYAiABKA1SCHVua25vd24y');

@$core.Deprecated('Use relaxReminderDescriptor instead')
const RelaxReminder$json = {
  '1': 'RelaxReminder',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `RelaxReminder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relaxReminderDescriptor = $convert.base64Decode(
    'Cg1SZWxheFJlbWluZGVyEhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQSGgoIdW5rbm93bjIYAi'
    'ABKA1SCHVua25vd24y');

@$core.Deprecated('Use vitalityScoreDescriptor instead')
const VitalityScore$json = {
  '1': 'VitalityScore',
  '2': [
    {'1': 'sevenDay', '3': 1, '4': 1, '5': 8, '10': 'sevenDay'},
    {'1': 'dailyProgress', '3': 2, '4': 1, '5': 8, '10': 'dailyProgress'},
  ],
};

/// Descriptor for `VitalityScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vitalityScoreDescriptor = $convert.base64Decode(
    'Cg1WaXRhbGl0eVNjb3JlEhoKCHNldmVuRGF5GAEgASgIUghzZXZlbkRheRIkCg1kYWlseVByb2'
    'dyZXNzGAIgASgIUg1kYWlseVByb2dyZXNz');

@$core.Deprecated('Use workoutStatusWatchDescriptor instead')
const WorkoutStatusWatch$json = {
  '1': 'WorkoutStatusWatch',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 13, '10': 'timestamp'},
    {'1': 'sport', '3': 3, '4': 1, '5': 13, '10': 'sport'},
    {'1': 'status', '3': 4, '4': 1, '5': 13, '10': 'status'},
    {'1': 'activityFileIds', '3': 5, '4': 1, '5': 12, '10': 'activityFileIds'},
    {'1': 'unknown6', '3': 6, '4': 1, '5': 13, '10': 'unknown6'},
    {'1': 'unknown10', '3': 10, '4': 1, '5': 13, '10': 'unknown10'},
  ],
};

/// Descriptor for `WorkoutStatusWatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutStatusWatchDescriptor = $convert.base64Decode(
    'ChJXb3Jrb3V0U3RhdHVzV2F0Y2gSHAoJdGltZXN0YW1wGAEgASgNUgl0aW1lc3RhbXASFAoFc3'
    'BvcnQYAyABKA1SBXNwb3J0EhYKBnN0YXR1cxgEIAEoDVIGc3RhdHVzEigKD2FjdGl2aXR5Rmls'
    'ZUlkcxgFIAEoDFIPYWN0aXZpdHlGaWxlSWRzEhoKCHVua25vd242GAYgASgNUgh1bmtub3duNh'
    'IcCgl1bmtub3duMTAYCiABKA1SCXVua25vd24xMA==');

@$core.Deprecated('Use workoutOpenWatchDescriptor instead')
const WorkoutOpenWatch$json = {
  '1': 'WorkoutOpenWatch',
  '2': [
    {'1': 'sport', '3': 1, '4': 1, '5': 13, '10': 'sport'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
  ],
};

/// Descriptor for `WorkoutOpenWatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutOpenWatchDescriptor = $convert.base64Decode(
    'ChBXb3Jrb3V0T3BlbldhdGNoEhQKBXNwb3J0GAEgASgNUgVzcG9ydBIaCgh1bmtub3duMhgCIA'
    'EoDVIIdW5rbm93bjI=');

@$core.Deprecated('Use workoutOpenReplyDescriptor instead')
const WorkoutOpenReply$json = {
  '1': 'WorkoutOpenReply',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
  ],
};

/// Descriptor for `WorkoutOpenReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutOpenReplyDescriptor = $convert.base64Decode(
    'ChBXb3Jrb3V0T3BlblJlcGx5EhoKCHVua25vd24xGAEgASgNUgh1bmtub3duMRIaCgh1bmtub3'
    'duMhgCIAEoDVIIdW5rbm93bjISGgoIdW5rbm93bjMYAyABKA1SCHVua25vd24z');

@$core.Deprecated('Use goalsConfigDescriptor instead')
const GoalsConfig$json = {
  '1': 'GoalsConfig',
  '2': [
    {
      '1': 'currentGoals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Goal',
      '10': 'currentGoals',
    },
    {
      '1': 'supportedGoals',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Goal',
      '10': 'supportedGoals',
    },
  ],
};

/// Descriptor for `GoalsConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalsConfigDescriptor = $convert.base64Decode(
    'CgtHb2Fsc0NvbmZpZxIwCgxjdXJyZW50R29hbHMYASADKAsyDC54aWFvbWkuR29hbFIMY3Vycm'
    'VudEdvYWxzEjQKDnN1cHBvcnRlZEdvYWxzGAIgAygLMgwueGlhb21pLkdvYWxSDnN1cHBvcnRl'
    'ZEdvYWxz');

@$core.Deprecated('Use goalDescriptor instead')
const Goal$json = {
  '1': 'Goal',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
  ],
};

/// Descriptor for `Goal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalDescriptor =
    $convert.base64Decode('CgRHb2FsEg4KAmlkGAEgASgNUgJpZA==');

@$core.Deprecated('Use workoutLocationDescriptor instead')
const WorkoutLocation$json = {
  '1': 'WorkoutLocation',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 13, '10': 'timestamp'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'altitude', '3': 5, '4': 1, '5': 1, '10': 'altitude'},
    {'1': 'speed', '3': 6, '4': 1, '5': 2, '10': 'speed'},
    {'1': 'bearing', '3': 7, '4': 1, '5': 2, '10': 'bearing'},
    {
      '1': 'horizontalAccuracy',
      '3': 8,
      '4': 1,
      '5': 2,
      '10': 'horizontalAccuracy',
    },
    {'1': 'verticalAccuracy', '3': 9, '4': 1, '5': 2, '10': 'verticalAccuracy'},
  ],
};

/// Descriptor for `WorkoutLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workoutLocationDescriptor = $convert.base64Decode(
    'Cg9Xb3Jrb3V0TG9jYXRpb24SGgoIdW5rbm93bjEYASABKA1SCHVua25vd24xEhwKCXRpbWVzdG'
    'FtcBgCIAEoDVIJdGltZXN0YW1wEhwKCWxvbmdpdHVkZRgDIAEoAVIJbG9uZ2l0dWRlEhoKCGxh'
    'dGl0dWRlGAQgASgBUghsYXRpdHVkZRIaCghhbHRpdHVkZRgFIAEoAVIIYWx0aXR1ZGUSFAoFc3'
    'BlZWQYBiABKAJSBXNwZWVkEhgKB2JlYXJpbmcYByABKAJSB2JlYXJpbmcSLgoSaG9yaXpvbnRh'
    'bEFjY3VyYWN5GAggASgCUhJob3Jpem9udGFsQWNjdXJhY3kSKgoQdmVydGljYWxBY2N1cmFjeR'
    'gJIAEoAlIQdmVydGljYWxBY2N1cmFjeQ==');

@$core.Deprecated('Use realTimeStatsDescriptor instead')
const RealTimeStats$json = {
  '1': 'RealTimeStats',
  '2': [
    {'1': 'steps', '3': 1, '4': 1, '5': 13, '10': 'steps'},
    {'1': 'calories', '3': 2, '4': 1, '5': 13, '10': 'calories'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
    {'1': 'heartRate', '3': 4, '4': 1, '5': 13, '10': 'heartRate'},
    {'1': 'unknown5', '3': 5, '4': 1, '5': 13, '10': 'unknown5'},
    {'1': 'standingHours', '3': 6, '4': 1, '5': 13, '10': 'standingHours'},
  ],
};

/// Descriptor for `RealTimeStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List realTimeStatsDescriptor = $convert.base64Decode(
    'Cg1SZWFsVGltZVN0YXRzEhQKBXN0ZXBzGAEgASgNUgVzdGVwcxIaCghjYWxvcmllcxgCIAEoDV'
    'IIY2Fsb3JpZXMSGgoIdW5rbm93bjMYAyABKA1SCHVua25vd24zEhwKCWhlYXJ0UmF0ZRgEIAEo'
    'DVIJaGVhcnRSYXRlEhoKCHVua25vd241GAUgASgNUgh1bmtub3duNRIkCg1zdGFuZGluZ0hvdX'
    'JzGAYgASgNUg1zdGFuZGluZ0hvdXJz');

@$core.Deprecated('Use calendarDescriptor instead')
const Calendar$json = {
  '1': 'Calendar',
  '2': [
    {
      '1': 'calendarSync',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.CalendarSync',
      '10': 'calendarSync',
    },
  ],
};

/// Descriptor for `Calendar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calendarDescriptor = $convert.base64Decode(
    'CghDYWxlbmRhchI4CgxjYWxlbmRhclN5bmMYAiABKAsyFC54aWFvbWkuQ2FsZW5kYXJTeW5jUg'
    'xjYWxlbmRhclN5bmM=');

@$core.Deprecated('Use calendarSyncDescriptor instead')
const CalendarSync$json = {
  '1': 'CalendarSync',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.CalendarEvent',
      '10': 'event',
    },
    {'1': 'disabled', '3': 2, '4': 1, '5': 8, '10': 'disabled'},
  ],
};

/// Descriptor for `CalendarSync`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calendarSyncDescriptor = $convert.base64Decode(
    'CgxDYWxlbmRhclN5bmMSKwoFZXZlbnQYASADKAsyFS54aWFvbWkuQ2FsZW5kYXJFdmVudFIFZX'
    'ZlbnQSGgoIZGlzYWJsZWQYAiABKAhSCGRpc2FibGVk');

@$core.Deprecated('Use calendarEventDescriptor instead')
const CalendarEvent$json = {
  '1': 'CalendarEvent',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    {'1': 'start', '3': 4, '4': 1, '5': 13, '10': 'start'},
    {'1': 'end', '3': 5, '4': 1, '5': 13, '10': 'end'},
    {'1': 'allDay', '3': 6, '4': 1, '5': 8, '10': 'allDay'},
    {
      '1': 'notifyMinutesBefore',
      '3': 7,
      '4': 1,
      '5': 13,
      '10': 'notifyMinutesBefore',
    },
  ],
};

/// Descriptor for `CalendarEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calendarEventDescriptor = $convert.base64Decode(
    'Cg1DYWxlbmRhckV2ZW50EhQKBXRpdGxlGAEgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgCIA'
    'EoCVILZGVzY3JpcHRpb24SGgoIbG9jYXRpb24YAyABKAlSCGxvY2F0aW9uEhQKBXN0YXJ0GAQg'
    'ASgNUgVzdGFydBIQCgNlbmQYBSABKA1SA2VuZBIWCgZhbGxEYXkYBiABKAhSBmFsbERheRIwCh'
    'Nub3RpZnlNaW51dGVzQmVmb3JlGAcgASgNUhNub3RpZnlNaW51dGVzQmVmb3Jl');

@$core.Deprecated('Use musicDescriptor instead')
const Music$json = {
  '1': 'Music',
  '2': [
    {
      '1': 'musicInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.MusicInfo',
      '10': 'musicInfo',
    },
    {
      '1': 'mediaKey',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.MediaKey',
      '10': 'mediaKey',
    },
  ],
};

/// Descriptor for `Music`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicDescriptor = $convert.base64Decode(
    'CgVNdXNpYxIvCgltdXNpY0luZm8YASABKAsyES54aWFvbWkuTXVzaWNJbmZvUgltdXNpY0luZm'
    '8SLAoIbWVkaWFLZXkYAiABKAsyEC54aWFvbWkuTWVkaWFLZXlSCG1lZGlhS2V5');

@$core.Deprecated('Use musicInfoDescriptor instead')
const MusicInfo$json = {
  '1': 'MusicInfo',
  '2': [
    {'1': 'state', '3': 1, '4': 2, '5': 13, '10': 'state'},
    {'1': 'volume', '3': 2, '4': 1, '5': 13, '10': 'volume'},
    {'1': 'track', '3': 4, '4': 1, '5': 9, '10': 'track'},
    {'1': 'artist', '3': 5, '4': 1, '5': 9, '10': 'artist'},
    {'1': 'position', '3': 6, '4': 1, '5': 13, '10': 'position'},
    {'1': 'duration', '3': 7, '4': 1, '5': 13, '10': 'duration'},
  ],
};

/// Descriptor for `MusicInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicInfoDescriptor = $convert.base64Decode(
    'CglNdXNpY0luZm8SFAoFc3RhdGUYASACKA1SBXN0YXRlEhYKBnZvbHVtZRgCIAEoDVIGdm9sdW'
    '1lEhQKBXRyYWNrGAQgASgJUgV0cmFjaxIWCgZhcnRpc3QYBSABKAlSBmFydGlzdBIaCghwb3Np'
    'dGlvbhgGIAEoDVIIcG9zaXRpb24SGgoIZHVyYXRpb24YByABKA1SCGR1cmF0aW9u');

@$core.Deprecated('Use mediaKeyDescriptor instead')
const MediaKey$json = {
  '1': 'MediaKey',
  '2': [
    {'1': 'key', '3': 1, '4': 2, '5': 13, '10': 'key'},
    {'1': 'volume', '3': 2, '4': 1, '5': 13, '10': 'volume'},
  ],
};

/// Descriptor for `MediaKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKeyDescriptor = $convert.base64Decode(
  'CghNZWRpYUtleRIQCgNrZXkYASACKA1SA2tleRIWCgZ2b2x1bWUYAiABKA1SBnZvbHVtZQ==',
);

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {
      '1': 'openOnPhone',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationId',
      '10': 'openOnPhone',
    },
    {
      '1': 'notification2',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Notification2',
      '10': 'notification2',
    },
    {
      '1': 'notificationDismiss',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationDismiss',
      '10': 'notificationDismiss',
    },
    {
      '1': 'screenOnOnNotifications',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'screenOnOnNotifications',
    },
    {'1': 'unknown8', '3': 8, '4': 1, '5': 13, '10': 'unknown8'},
    {
      '1': 'cannedMessages',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.CannedMessages',
      '10': 'cannedMessages',
    },
    {
      '1': 'notificationReply',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationReply',
      '10': 'notificationReply',
    },
    {
      '1': 'notificationReplyStatus',
      '3': 13,
      '4': 1,
      '5': 13,
      '10': 'notificationReplyStatus',
    },
    {
      '1': 'notificationIconReply',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationIconPackage',
      '10': 'notificationIconReply',
    },
    {
      '1': 'notificationIconRequest',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationIconRequest',
      '10': 'notificationIconRequest',
    },
    {
      '1': 'notificationIconQuery',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.NotificationIconPackage',
      '10': 'notificationIconQuery',
    },
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SOAoLb3Blbk9uUGhvbmUYAiABKAsyFi54aWFvbWkuTm90aWZpY2F0aW'
    '9uSWRSC29wZW5PblBob25lEjsKDW5vdGlmaWNhdGlvbjIYAyABKAsyFS54aWFvbWkuTm90aWZp'
    'Y2F0aW9uMlINbm90aWZpY2F0aW9uMhJNChNub3RpZmljYXRpb25EaXNtaXNzGAQgASgLMhsueG'
    'lhb21pLk5vdGlmaWNhdGlvbkRpc21pc3NSE25vdGlmaWNhdGlvbkRpc21pc3MSOAoXc2NyZWVu'
    'T25Pbk5vdGlmaWNhdGlvbnMYByABKAhSF3NjcmVlbk9uT25Ob3RpZmljYXRpb25zEhoKCHVua2'
    '5vd244GAggASgNUgh1bmtub3duOBI+Cg5jYW5uZWRNZXNzYWdlcxgJIAEoCzIWLnhpYW9taS5D'
    'YW5uZWRNZXNzYWdlc1IOY2FubmVkTWVzc2FnZXMSRwoRbm90aWZpY2F0aW9uUmVwbHkYDCABKA'
    'syGS54aWFvbWkuTm90aWZpY2F0aW9uUmVwbHlSEW5vdGlmaWNhdGlvblJlcGx5EjgKF25vdGlm'
    'aWNhdGlvblJlcGx5U3RhdHVzGA0gASgNUhdub3RpZmljYXRpb25SZXBseVN0YXR1cxJVChVub3'
    'RpZmljYXRpb25JY29uUmVwbHkYDiABKAsyHy54aWFvbWkuTm90aWZpY2F0aW9uSWNvblBhY2th'
    'Z2VSFW5vdGlmaWNhdGlvbkljb25SZXBseRJZChdub3RpZmljYXRpb25JY29uUmVxdWVzdBgPIA'
    'EoCzIfLnhpYW9taS5Ob3RpZmljYXRpb25JY29uUmVxdWVzdFIXbm90aWZpY2F0aW9uSWNvblJl'
    'cXVlc3QSVQoVbm90aWZpY2F0aW9uSWNvblF1ZXJ5GBAgASgLMh8ueGlhb21pLk5vdGlmaWNhdG'
    'lvbkljb25QYWNrYWdlUhVub3RpZmljYXRpb25JY29uUXVlcnk=');

@$core.Deprecated('Use notification2Descriptor instead')
const Notification2$json = {
  '1': 'Notification2',
  '2': [
    {
      '1': 'notification3',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Notification3',
      '10': 'notification3',
    },
  ],
};

/// Descriptor for `Notification2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notification2Descriptor = $convert.base64Decode(
    'Cg1Ob3RpZmljYXRpb24yEjsKDW5vdGlmaWNhdGlvbjMYASABKAsyFS54aWFvbWkuTm90aWZpY2'
    'F0aW9uM1INbm90aWZpY2F0aW9uMw==');

@$core.Deprecated('Use notification3Descriptor instead')
const Notification3$json = {
  '1': 'Notification3',
  '2': [
    {'1': 'package', '3': 1, '4': 1, '5': 9, '10': 'package'},
    {'1': 'appName', '3': 2, '4': 1, '5': 9, '10': 'appName'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'unknown4', '3': 4, '4': 1, '5': 9, '10': 'unknown4'},
    {'1': 'body', '3': 5, '4': 1, '5': 9, '10': 'body'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 9, '10': 'timestamp'},
    {'1': 'id', '3': 7, '4': 1, '5': 13, '10': 'id'},
    {'1': 'isCall', '3': 8, '4': 1, '5': 8, '10': 'isCall'},
    {'1': 'repliesAllowed', '3': 11, '4': 1, '5': 8, '10': 'repliesAllowed'},
    {'1': 'key', '3': 12, '4': 1, '5': 9, '10': 'key'},
    {'1': 'openOnPhone', '3': 13, '4': 1, '5': 8, '10': 'openOnPhone'},
  ],
};

/// Descriptor for `Notification3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notification3Descriptor = $convert.base64Decode(
    'Cg1Ob3RpZmljYXRpb24zEhgKB3BhY2thZ2UYASABKAlSB3BhY2thZ2USGAoHYXBwTmFtZRgCIA'
    'EoCVIHYXBwTmFtZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGgoIdW5rbm93bjQYBCABKAlSCHVu'
    'a25vd240EhIKBGJvZHkYBSABKAlSBGJvZHkSHAoJdGltZXN0YW1wGAYgASgJUgl0aW1lc3RhbX'
    'ASDgoCaWQYByABKA1SAmlkEhYKBmlzQ2FsbBgIIAEoCFIGaXNDYWxsEiYKDnJlcGxpZXNBbGxv'
    'd2VkGAsgASgIUg5yZXBsaWVzQWxsb3dlZBIQCgNrZXkYDCABKAlSA2tleRIgCgtvcGVuT25QaG'
    '9uZRgNIAEoCFILb3Blbk9uUGhvbmU=');

@$core.Deprecated('Use notificationDismissDescriptor instead')
const NotificationDismiss$json = {
  '1': 'NotificationDismiss',
  '2': [
    {
      '1': 'notificationId',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.NotificationId',
      '10': 'notificationId',
    },
  ],
};

/// Descriptor for `NotificationDismiss`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDismissDescriptor = $convert.base64Decode(
    'ChNOb3RpZmljYXRpb25EaXNtaXNzEj4KDm5vdGlmaWNhdGlvbklkGAEgAygLMhYueGlhb21pLk'
    '5vdGlmaWNhdGlvbklkUg5ub3RpZmljYXRpb25JZA==');

@$core.Deprecated('Use notificationIdDescriptor instead')
const NotificationId$json = {
  '1': 'NotificationId',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'package', '3': 2, '4': 1, '5': 9, '10': 'package'},
    {'1': 'key', '3': 4, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `NotificationId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationIdDescriptor = $convert.base64Decode(
    'Cg5Ob3RpZmljYXRpb25JZBIOCgJpZBgBIAEoDVICaWQSGAoHcGFja2FnZRgCIAEoCVIHcGFja2'
    'FnZRIQCgNrZXkYBCABKAlSA2tleQ==');

@$core.Deprecated('Use cannedMessagesDescriptor instead')
const CannedMessages$json = {
  '1': 'CannedMessages',
  '2': [
    {'1': 'minReplies', '3': 1, '4': 1, '5': 13, '10': 'minReplies'},
    {'1': 'reply', '3': 2, '4': 3, '5': 9, '10': 'reply'},
    {'1': 'maxReplies', '3': 3, '4': 1, '5': 13, '10': 'maxReplies'},
  ],
};

/// Descriptor for `CannedMessages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cannedMessagesDescriptor = $convert.base64Decode(
    'Cg5DYW5uZWRNZXNzYWdlcxIeCgptaW5SZXBsaWVzGAEgASgNUgptaW5SZXBsaWVzEhQKBXJlcG'
    'x5GAIgAygJUgVyZXBseRIeCgptYXhSZXBsaWVzGAMgASgNUgptYXhSZXBsaWVz');

@$core.Deprecated('Use notificationIconRequestDescriptor instead')
const NotificationIconRequest$json = {
  '1': 'NotificationIconRequest',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
    {'1': 'pixelFormat', '3': 2, '4': 1, '5': 13, '10': 'pixelFormat'},
    {'1': 'size', '3': 3, '4': 1, '5': 13, '10': 'size'},
  ],
};

/// Descriptor for `NotificationIconRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationIconRequestDescriptor =
    $convert.base64Decode(
        'ChdOb3RpZmljYXRpb25JY29uUmVxdWVzdBIWCgZzdGF0dXMYASABKA1SBnN0YXR1cxIgCgtwaX'
        'hlbEZvcm1hdBgCIAEoDVILcGl4ZWxGb3JtYXQSEgoEc2l6ZRgDIAEoDVIEc2l6ZQ==');

@$core.Deprecated('Use notificationReplyDescriptor instead')
const NotificationReply$json = {
  '1': 'NotificationReply',
  '2': [
    {'1': 'unknown1', '3': 1, '4': 1, '5': 13, '10': 'unknown1'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
    {'1': 'number', '3': 4, '4': 1, '5': 9, '10': 'number'},
  ],
};

/// Descriptor for `NotificationReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationReplyDescriptor = $convert.base64Decode(
    'ChFOb3RpZmljYXRpb25SZXBseRIaCgh1bmtub3duMRgBIAEoDVIIdW5rbm93bjESGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZRIaCgh1bmtub3duMxgDIAEoDVIIdW5rbm93bjMSFgoGbnVtYmVy'
    'GAQgASgJUgZudW1iZXI=');

@$core.Deprecated('Use notificationIconPackageDescriptor instead')
const NotificationIconPackage$json = {
  '1': 'NotificationIconPackage',
  '2': [
    {'1': 'package', '3': 1, '4': 1, '5': 9, '10': 'package'},
  ],
};

/// Descriptor for `NotificationIconPackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationIconPackageDescriptor =
    $convert.base64Decode(
  'ChdOb3RpZmljYXRpb25JY29uUGFja2FnZRIYCgdwYWNrYWdlGAEgASgJUgdwYWNrYWdl',
);

@$core.Deprecated('Use weatherDescriptor instead')
const Weather$json = {
  '1': 'Weather',
  '2': [
    {
      '1': 'current',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherCurrent',
      '10': 'current',
    },
    {
      '1': 'forecast',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherForecast',
      '10': 'forecast',
    },
    {
      '1': 'locations',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherLocations',
      '10': 'locations',
    },
    {
      '1': 'location',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherLocation',
      '10': 'location',
    },
    {
      '1': 'prefs',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherPrefs',
      '10': 'prefs',
    },
  ],
};

/// Descriptor for `Weather`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherDescriptor = $convert.base64Decode(
    'CgdXZWF0aGVyEjAKB2N1cnJlbnQYASABKAsyFi54aWFvbWkuV2VhdGhlckN1cnJlbnRSB2N1cn'
    'JlbnQSMwoIZm9yZWNhc3QYAiABKAsyFy54aWFvbWkuV2VhdGhlckZvcmVjYXN0Ughmb3JlY2Fz'
    'dBI2Cglsb2NhdGlvbnMYBCABKAsyGC54aWFvbWkuV2VhdGhlckxvY2F0aW9uc1IJbG9jYXRpb2'
    '5zEjMKCGxvY2F0aW9uGAUgASgLMhcueGlhb21pLldlYXRoZXJMb2NhdGlvblIIbG9jYXRpb24S'
    'KgoFcHJlZnMYBiABKAsyFC54aWFvbWkuV2VhdGhlclByZWZzUgVwcmVmcw==');

@$core.Deprecated('Use weatherCurrentDescriptor instead')
const WeatherCurrent$json = {
  '1': 'WeatherCurrent',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherMetadata',
      '10': 'metadata',
    },
    {
      '1': 'weatherCondition',
      '3': 2,
      '4': 2,
      '5': 13,
      '10': 'weatherCondition',
    },
    {
      '1': 'temperature',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'temperature',
    },
    {
      '1': 'humidity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'humidity',
    },
    {
      '1': 'wind',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'wind',
    },
    {
      '1': 'uv',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'uv',
    },
    {
      '1': 'aqi',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'aqi',
    },
    {
      '1': 'warning',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherWarnings',
      '10': 'warning',
    },
    {'1': 'pressure', '3': 9, '4': 1, '5': 2, '10': 'pressure'},
  ],
};

/// Descriptor for `WeatherCurrent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherCurrentDescriptor = $convert.base64Decode(
    'Cg5XZWF0aGVyQ3VycmVudBIzCghtZXRhZGF0YRgBIAEoCzIXLnhpYW9taS5XZWF0aGVyTWV0YW'
    'RhdGFSCG1ldGFkYXRhEioKEHdlYXRoZXJDb25kaXRpb24YAiACKA1SEHdlYXRoZXJDb25kaXRp'
    'b24SOgoLdGVtcGVyYXR1cmUYAyABKAsyGC54aWFvbWkuV2VhdGhlclVuaXRWYWx1ZVILdGVtcG'
    'VyYXR1cmUSNAoIaHVtaWRpdHkYBCABKAsyGC54aWFvbWkuV2VhdGhlclVuaXRWYWx1ZVIIaHVt'
    'aWRpdHkSLAoEd2luZBgFIAEoCzIYLnhpYW9taS5XZWF0aGVyVW5pdFZhbHVlUgR3aW5kEigKAn'
    'V2GAYgASgLMhgueGlhb21pLldlYXRoZXJVbml0VmFsdWVSAnV2EioKA2FxaRgHIAEoCzIYLnhp'
    'YW9taS5XZWF0aGVyVW5pdFZhbHVlUgNhcWkSMQoHd2FybmluZxgIIAEoCzIXLnhpYW9taS5XZW'
    'F0aGVyV2FybmluZ3NSB3dhcm5pbmcSGgoIcHJlc3N1cmUYCSABKAJSCHByZXNzdXJl');

@$core.Deprecated('Use weatherMetadataDescriptor instead')
const WeatherMetadata$json = {
  '1': 'WeatherMetadata',
  '2': [
    {
      '1': 'publicationTimestamp',
      '3': 1,
      '4': 2,
      '5': 9,
      '10': 'publicationTimestamp',
    },
    {'1': 'cityName', '3': 2, '4': 2, '5': 9, '10': 'cityName'},
    {'1': 'locationName', '3': 3, '4': 2, '5': 9, '10': 'locationName'},
    {'1': 'locationKey', '3': 4, '4': 1, '5': 9, '10': 'locationKey'},
    {
      '1': 'isCurrentLocation',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'isCurrentLocation',
    },
  ],
};

/// Descriptor for `WeatherMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherMetadataDescriptor = $convert.base64Decode(
    'Cg9XZWF0aGVyTWV0YWRhdGESMgoUcHVibGljYXRpb25UaW1lc3RhbXAYASACKAlSFHB1YmxpY2'
    'F0aW9uVGltZXN0YW1wEhoKCGNpdHlOYW1lGAIgAigJUghjaXR5TmFtZRIiCgxsb2NhdGlvbk5h'
    'bWUYAyACKAlSDGxvY2F0aW9uTmFtZRIgCgtsb2NhdGlvbktleRgEIAEoCVILbG9jYXRpb25LZX'
    'kSLAoRaXNDdXJyZW50TG9jYXRpb24YBSABKAhSEWlzQ3VycmVudExvY2F0aW9u');

@$core.Deprecated('Use weatherUnitValueDescriptor instead')
const WeatherUnitValue$json = {
  '1': 'WeatherUnitValue',
  '2': [
    {'1': 'unit', '3': 1, '4': 2, '5': 9, '10': 'unit'},
    {'1': 'value', '3': 2, '4': 2, '5': 17, '10': 'value'},
  ],
};

/// Descriptor for `WeatherUnitValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherUnitValueDescriptor = $convert.base64Decode(
    'ChBXZWF0aGVyVW5pdFZhbHVlEhIKBHVuaXQYASACKAlSBHVuaXQSFAoFdmFsdWUYAiACKBFSBX'
    'ZhbHVl');

@$core.Deprecated('Use weatherWarningsDescriptor instead')
const WeatherWarnings$json = {
  '1': 'WeatherWarnings',
  '2': [
    {
      '1': 'warning',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WeatherWarning',
      '10': 'warning',
    },
  ],
};

/// Descriptor for `WeatherWarnings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherWarningsDescriptor = $convert.base64Decode(
    'Cg9XZWF0aGVyV2FybmluZ3MSMAoHd2FybmluZxgBIAMoCzIWLnhpYW9taS5XZWF0aGVyV2Fybm'
    'luZ1IHd2FybmluZw==');

@$core.Deprecated('Use weatherWarningDescriptor instead')
const WeatherWarning$json = {
  '1': 'WeatherWarning',
  '2': [
    {'1': 'type', '3': 1, '4': 2, '5': 9, '10': 'type'},
    {'1': 'level', '3': 2, '4': 2, '5': 9, '10': 'level'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'id', '3': 5, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `WeatherWarning`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherWarningDescriptor = $convert.base64Decode(
    'Cg5XZWF0aGVyV2FybmluZxISCgR0eXBlGAEgAigJUgR0eXBlEhQKBWxldmVsGAIgAigJUgVsZX'
    'ZlbBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0'
    'aW9uEg4KAmlkGAUgASgJUgJpZA==');

@$core.Deprecated('Use weatherLocationsDescriptor instead')
const WeatherLocations$json = {
  '1': 'WeatherLocations',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.WeatherLocation',
      '10': 'location',
    },
  ],
};

/// Descriptor for `WeatherLocations`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherLocationsDescriptor = $convert.base64Decode(
    'ChBXZWF0aGVyTG9jYXRpb25zEjMKCGxvY2F0aW9uGAEgAygLMhcueGlhb21pLldlYXRoZXJMb2'
    'NhdGlvblIIbG9jYXRpb24=');

@$core.Deprecated('Use weatherForecastDescriptor instead')
const WeatherForecast$json = {
  '1': 'WeatherForecast',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 2,
      '5': 11,
      '6': '.xiaomi.WeatherMetadata',
      '10': 'metadata',
    },
    {
      '1': 'entries',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.xiaomi.ForecastEntries',
      '10': 'entries',
    },
  ],
};

/// Descriptor for `WeatherForecast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherForecastDescriptor = $convert.base64Decode(
    'Cg9XZWF0aGVyRm9yZWNhc3QSMwoIbWV0YWRhdGEYASACKAsyFy54aWFvbWkuV2VhdGhlck1ldG'
    'FkYXRhUghtZXRhZGF0YRIxCgdlbnRyaWVzGAIgAigLMhcueGlhb21pLkZvcmVjYXN0RW50cmll'
    'c1IHZW50cmllcw==');

@$core.Deprecated('Use forecastEntriesDescriptor instead')
const ForecastEntries$json = {
  '1': 'ForecastEntries',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.ForecastEntry',
      '10': 'entry',
    },
  ],
};

/// Descriptor for `ForecastEntries`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forecastEntriesDescriptor = $convert.base64Decode(
    'Cg9Gb3JlY2FzdEVudHJpZXMSKwoFZW50cnkYASADKAsyFS54aWFvbWkuRm9yZWNhc3RFbnRyeV'
    'IFZW50cnk=');

@$core.Deprecated('Use forecastEntryDescriptor instead')
const ForecastEntry$json = {
  '1': 'ForecastEntry',
  '2': [
    {
      '1': 'aqi',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'aqi',
    },
    {
      '1': 'conditionRange',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherRange',
      '10': 'conditionRange',
    },
    {
      '1': 'temperatureRange',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherRange',
      '10': 'temperatureRange',
    },
    {
      '1': 'temperatureSymbol',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'temperatureSymbol',
    },
    {
      '1': 'sunriseSunset',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherSunriseSunset',
      '10': 'sunriseSunset',
    },
    {
      '1': 'wind',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WeatherUnitValue',
      '10': 'wind',
    },
  ],
};

/// Descriptor for `ForecastEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forecastEntryDescriptor = $convert.base64Decode(
    'Cg1Gb3JlY2FzdEVudHJ5EioKA2FxaRgBIAEoCzIYLnhpYW9taS5XZWF0aGVyVW5pdFZhbHVlUg'
    'NhcWkSPAoOY29uZGl0aW9uUmFuZ2UYAiABKAsyFC54aWFvbWkuV2VhdGhlclJhbmdlUg5jb25k'
    'aXRpb25SYW5nZRJAChB0ZW1wZXJhdHVyZVJhbmdlGAMgASgLMhQueGlhb21pLldlYXRoZXJSYW'
    '5nZVIQdGVtcGVyYXR1cmVSYW5nZRIsChF0ZW1wZXJhdHVyZVN5bWJvbBgEIAEoCVIRdGVtcGVy'
    'YXR1cmVTeW1ib2wSQgoNc3VucmlzZVN1bnNldBgFIAEoCzIcLnhpYW9taS5XZWF0aGVyU3Vucm'
    'lzZVN1bnNldFINc3VucmlzZVN1bnNldBIsCgR3aW5kGAYgASgLMhgueGlhb21pLldlYXRoZXJV'
    'bml0VmFsdWVSBHdpbmQ=');

@$core.Deprecated('Use weatherRangeDescriptor instead')
const WeatherRange$json = {
  '1': 'WeatherRange',
  '2': [
    {'1': 'from', '3': 1, '4': 2, '5': 17, '10': 'from'},
    {'1': 'to', '3': 2, '4': 2, '5': 17, '10': 'to'},
  ],
};

/// Descriptor for `WeatherRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherRangeDescriptor = $convert.base64Decode(
  'CgxXZWF0aGVyUmFuZ2USEgoEZnJvbRgBIAIoEVIEZnJvbRIOCgJ0bxgCIAIoEVICdG8=',
);

@$core.Deprecated('Use weatherSunriseSunsetDescriptor instead')
const WeatherSunriseSunset$json = {
  '1': 'WeatherSunriseSunset',
  '2': [
    {'1': 'sunrise', '3': 1, '4': 2, '5': 9, '10': 'sunrise'},
    {'1': 'sunset', '3': 2, '4': 2, '5': 9, '10': 'sunset'},
  ],
};

/// Descriptor for `WeatherSunriseSunset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherSunriseSunsetDescriptor = $convert.base64Decode(
    'ChRXZWF0aGVyU3VucmlzZVN1bnNldBIYCgdzdW5yaXNlGAEgAigJUgdzdW5yaXNlEhYKBnN1bn'
    'NldBgCIAIoCVIGc3Vuc2V0');

@$core.Deprecated('Use weatherLocationDescriptor instead')
const WeatherLocation$json = {
  '1': 'WeatherLocation',
  '2': [
    {'1': 'code', '3': 1, '4': 2, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `WeatherLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherLocationDescriptor = $convert.base64Decode(
    'Cg9XZWF0aGVyTG9jYXRpb24SEgoEY29kZRgBIAIoCVIEY29kZRISCgRuYW1lGAIgASgJUgRuYW'
    '1l');

@$core.Deprecated('Use weatherPrefsDescriptor instead')
const WeatherPrefs$json = {
  '1': 'WeatherPrefs',
  '2': [
    {
      '1': 'temperatureScale',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'temperatureScale',
    },
    {
      '1': 'weatherWarningsEnabled',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'weatherWarningsEnabled',
    },
  ],
};

/// Descriptor for `WeatherPrefs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherPrefsDescriptor = $convert.base64Decode(
    'CgxXZWF0aGVyUHJlZnMSKgoQdGVtcGVyYXR1cmVTY2FsZRgBIAEoDVIQdGVtcGVyYXR1cmVTY2'
    'FsZRI2ChZ3ZWF0aGVyV2FybmluZ3NFbmFibGVkGAIgASgNUhZ3ZWF0aGVyV2FybmluZ3NFbmFi'
    'bGVk');

@$core.Deprecated('Use scheduleDescriptor instead')
const Schedule$json = {
  '1': 'Schedule',
  '2': [
    {
      '1': 'alarms',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Alarms',
      '10': 'alarms',
    },
    {
      '1': 'createAlarm',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AlarmDetails',
      '10': 'createAlarm',
    },
    {
      '1': 'editAlarm',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Alarm',
      '10': 'editAlarm',
    },
    {'1': 'ackId', '3': 4, '4': 1, '5': 13, '10': 'ackId'},
    {
      '1': 'deleteAlarm',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AlarmDelete',
      '10': 'deleteAlarm',
    },
    {
      '1': 'sleepMode',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.SleepMode',
      '10': 'sleepMode',
    },
    {
      '1': 'reminders',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Reminders',
      '10': 'reminders',
    },
    {
      '1': 'worldClocks',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.WorldClocks',
      '10': 'worldClocks',
    },
    {
      '1': 'worldClockStatus',
      '3': 13,
      '4': 1,
      '5': 13,
      '10': 'worldClockStatus',
    },
    {
      '1': 'createReminder',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ReminderDetails',
      '10': 'createReminder',
    },
    {
      '1': 'editReminder',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.Reminder',
      '10': 'editReminder',
    },
    {
      '1': 'deleteReminder',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ReminderDelete',
      '10': 'deleteReminder',
    },
  ],
};

/// Descriptor for `Schedule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleDescriptor = $convert.base64Decode(
    'CghTY2hlZHVsZRImCgZhbGFybXMYASABKAsyDi54aWFvbWkuQWxhcm1zUgZhbGFybXMSNgoLY3'
    'JlYXRlQWxhcm0YAiABKAsyFC54aWFvbWkuQWxhcm1EZXRhaWxzUgtjcmVhdGVBbGFybRIrCgll'
    'ZGl0QWxhcm0YAyABKAsyDS54aWFvbWkuQWxhcm1SCWVkaXRBbGFybRIUCgVhY2tJZBgEIAEoDV'
    'IFYWNrSWQSNQoLZGVsZXRlQWxhcm0YBSABKAsyEy54aWFvbWkuQWxhcm1EZWxldGVSC2RlbGV0'
    'ZUFsYXJtEi8KCXNsZWVwTW9kZRgJIAEoCzIRLnhpYW9taS5TbGVlcE1vZGVSCXNsZWVwTW9kZR'
    'IvCglyZW1pbmRlcnMYCiABKAsyES54aWFvbWkuUmVtaW5kZXJzUglyZW1pbmRlcnMSNQoLd29y'
    'bGRDbG9ja3MYCyABKAsyEy54aWFvbWkuV29ybGRDbG9ja3NSC3dvcmxkQ2xvY2tzEioKEHdvcm'
    'xkQ2xvY2tTdGF0dXMYDSABKA1SEHdvcmxkQ2xvY2tTdGF0dXMSPwoOY3JlYXRlUmVtaW5kZXIY'
    'DiABKAsyFy54aWFvbWkuUmVtaW5kZXJEZXRhaWxzUg5jcmVhdGVSZW1pbmRlchI0CgxlZGl0Um'
    'VtaW5kZXIYDyABKAsyEC54aWFvbWkuUmVtaW5kZXJSDGVkaXRSZW1pbmRlchI+Cg5kZWxldGVS'
    'ZW1pbmRlchgRIAEoCzIWLnhpYW9taS5SZW1pbmRlckRlbGV0ZVIOZGVsZXRlUmVtaW5kZXI=');

@$core.Deprecated('Use alarmsDescriptor instead')
const Alarms$json = {
  '1': 'Alarms',
  '2': [
    {'1': 'maxAlarms', '3': 2, '4': 1, '5': 13, '10': 'maxAlarms'},
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
    {'1': 'unknown4', '3': 4, '4': 1, '5': 13, '10': 'unknown4'},
    {
      '1': 'alarm',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Alarm',
      '10': 'alarm',
    },
  ],
};

/// Descriptor for `Alarms`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmsDescriptor = $convert.base64Decode(
    'CgZBbGFybXMSHAoJbWF4QWxhcm1zGAIgASgNUgltYXhBbGFybXMSGgoIdW5rbm93bjMYAyABKA'
    '1SCHVua25vd24zEhoKCHVua25vd240GAQgASgNUgh1bmtub3duNBIjCgVhbGFybRgBIAMoCzIN'
    'LnhpYW9taS5BbGFybVIFYWxhcm0=');

@$core.Deprecated('Use alarmDescriptor instead')
const Alarm$json = {
  '1': 'Alarm',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {
      '1': 'alarmDetails',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.AlarmDetails',
      '10': 'alarmDetails',
    },
  ],
};

/// Descriptor for `Alarm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmDescriptor = $convert.base64Decode(
    'CgVBbGFybRIOCgJpZBgBIAEoDVICaWQSOAoMYWxhcm1EZXRhaWxzGAIgASgLMhQueGlhb21pLk'
    'FsYXJtRGV0YWlsc1IMYWxhcm1EZXRhaWxz');

@$core.Deprecated('Use alarmDetailsDescriptor instead')
const AlarmDetails$json = {
  '1': 'AlarmDetails',
  '2': [
    {
      '1': 'time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'time',
    },
    {'1': 'repeatMode', '3': 3, '4': 1, '5': 13, '10': 'repeatMode'},
    {'1': 'repeatFlags', '3': 4, '4': 1, '5': 13, '10': 'repeatFlags'},
    {'1': 'enabled', '3': 5, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'smart', '3': 7, '4': 1, '5': 13, '10': 'smart'},
  ],
};

/// Descriptor for `AlarmDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmDetailsDescriptor = $convert.base64Decode(
    'CgxBbGFybURldGFpbHMSJgoEdGltZRgCIAEoCzISLnhpYW9taS5Ib3VyTWludXRlUgR0aW1lEh'
    '4KCnJlcGVhdE1vZGUYAyABKA1SCnJlcGVhdE1vZGUSIAoLcmVwZWF0RmxhZ3MYBCABKA1SC3Jl'
    'cGVhdEZsYWdzEhgKB2VuYWJsZWQYBSABKAhSB2VuYWJsZWQSFAoFc21hcnQYByABKA1SBXNtYX'
    'J0');

@$core.Deprecated('Use alarmDeleteDescriptor instead')
const AlarmDelete$json = {
  '1': 'AlarmDelete',
  '2': [
    {'1': 'id', '3': 1, '4': 3, '5': 13, '10': 'id'},
  ],
};

/// Descriptor for `AlarmDelete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmDeleteDescriptor =
    $convert.base64Decode('CgtBbGFybURlbGV0ZRIOCgJpZBgBIAMoDVICaWQ=');

@$core.Deprecated('Use sleepModeDescriptor instead')
const SleepMode$json = {
  '1': 'SleepMode',
  '2': [
    {'1': 'enabled', '3': 1, '4': 2, '5': 8, '10': 'enabled'},
    {
      '1': 'schedule',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.SleepModeSchedule',
      '10': 'schedule',
    },
  ],
};

/// Descriptor for `SleepMode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sleepModeDescriptor = $convert.base64Decode(
    'CglTbGVlcE1vZGUSGAoHZW5hYmxlZBgBIAIoCFIHZW5hYmxlZBI1CghzY2hlZHVsZRgCIAEoCz'
    'IZLnhpYW9taS5TbGVlcE1vZGVTY2hlZHVsZVIIc2NoZWR1bGU=');

@$core.Deprecated('Use sleepModeScheduleDescriptor instead')
const SleepModeSchedule$json = {
  '1': 'SleepModeSchedule',
  '2': [
    {
      '1': 'start',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'start',
    },
    {
      '1': 'end',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.HourMinute',
      '10': 'end',
    },
    {'1': 'unknown3', '3': 3, '4': 1, '5': 13, '10': 'unknown3'},
  ],
};

/// Descriptor for `SleepModeSchedule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sleepModeScheduleDescriptor = $convert.base64Decode(
    'ChFTbGVlcE1vZGVTY2hlZHVsZRIoCgVzdGFydBgBIAEoCzISLnhpYW9taS5Ib3VyTWludXRlUg'
    'VzdGFydBIkCgNlbmQYAiABKAsyEi54aWFvbWkuSG91ck1pbnV0ZVIDZW5kEhoKCHVua25vd24z'
    'GAMgASgNUgh1bmtub3duMw==');

@$core.Deprecated('Use remindersDescriptor instead')
const Reminders$json = {
  '1': 'Reminders',
  '2': [
    {
      '1': 'reminder',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.Reminder',
      '10': 'reminder',
    },
    {'1': 'maxReminders', '3': 2, '4': 1, '5': 13, '10': 'maxReminders'},
  ],
};

/// Descriptor for `Reminders`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remindersDescriptor = $convert.base64Decode(
    'CglSZW1pbmRlcnMSLAoIcmVtaW5kZXIYASADKAsyEC54aWFvbWkuUmVtaW5kZXJSCHJlbWluZG'
    'VyEiIKDG1heFJlbWluZGVycxgCIAEoDVIMbWF4UmVtaW5kZXJz');

@$core.Deprecated('Use reminderDescriptor instead')
const Reminder$json = {
  '1': 'Reminder',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {
      '1': 'reminderDetails',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ReminderDetails',
      '10': 'reminderDetails',
    },
  ],
};

/// Descriptor for `Reminder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reminderDescriptor = $convert.base64Decode(
    'CghSZW1pbmRlchIOCgJpZBgBIAEoDVICaWQSQQoPcmVtaW5kZXJEZXRhaWxzGAIgASgLMhcueG'
    'lhb21pLlJlbWluZGVyRGV0YWlsc1IPcmVtaW5kZXJEZXRhaWxz');

@$core.Deprecated('Use reminderDetailsDescriptor instead')
const ReminderDetails$json = {
  '1': 'ReminderDetails',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 11, '6': '.xiaomi.Date', '10': 'date'},
    {'1': 'time', '3': 2, '4': 1, '5': 11, '6': '.xiaomi.Time', '10': 'time'},
    {'1': 'repeatMode', '3': 3, '4': 1, '5': 13, '10': 'repeatMode'},
    {'1': 'repeatFlags', '3': 4, '4': 1, '5': 13, '10': 'repeatFlags'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `ReminderDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reminderDetailsDescriptor = $convert.base64Decode(
    'Cg9SZW1pbmRlckRldGFpbHMSIAoEZGF0ZRgBIAEoCzIMLnhpYW9taS5EYXRlUgRkYXRlEiAKBH'
    'RpbWUYAiABKAsyDC54aWFvbWkuVGltZVIEdGltZRIeCgpyZXBlYXRNb2RlGAMgASgNUgpyZXBl'
    'YXRNb2RlEiAKC3JlcGVhdEZsYWdzGAQgASgNUgtyZXBlYXRGbGFncxIUCgV0aXRsZRgFIAEoCV'
    'IFdGl0bGU=');

@$core.Deprecated('Use reminderDeleteDescriptor instead')
const ReminderDelete$json = {
  '1': 'ReminderDelete',
  '2': [
    {'1': 'id', '3': 1, '4': 3, '5': 13, '10': 'id'},
  ],
};

/// Descriptor for `ReminderDelete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reminderDeleteDescriptor =
    $convert.base64Decode('Cg5SZW1pbmRlckRlbGV0ZRIOCgJpZBgBIAMoDVICaWQ=');

@$core.Deprecated('Use worldClocksDescriptor instead')
const WorldClocks$json = {
  '1': 'WorldClocks',
  '2': [
    {'1': 'worldClock', '3': 1, '4': 3, '5': 9, '10': 'worldClock'},
  ],
};

/// Descriptor for `WorldClocks`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List worldClocksDescriptor = $convert.base64Decode(
  'CgtXb3JsZENsb2NrcxIeCgp3b3JsZENsb2NrGAEgAygJUgp3b3JsZENsb2Nr',
);

@$core.Deprecated('Use hourMinuteDescriptor instead')
const HourMinute$json = {
  '1': 'HourMinute',
  '2': [
    {'1': 'hour', '3': 1, '4': 2, '5': 13, '10': 'hour'},
    {'1': 'minute', '3': 2, '4': 2, '5': 13, '10': 'minute'},
  ],
};

/// Descriptor for `HourMinute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hourMinuteDescriptor = $convert.base64Decode(
    'CgpIb3VyTWludXRlEhIKBGhvdXIYASACKA1SBGhvdXISFgoGbWludXRlGAIgAigNUgZtaW51dG'
    'U=');

@$core.Deprecated('Use dataUploadDescriptor instead')
const DataUpload$json = {
  '1': 'DataUpload',
  '2': [
    {
      '1': 'dataUploadRequest',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DataUploadRequest',
      '10': 'dataUploadRequest',
    },
    {
      '1': 'dataUploadAck',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.DataUploadAck',
      '10': 'dataUploadAck',
    },
  ],
};

/// Descriptor for `DataUpload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataUploadDescriptor = $convert.base64Decode(
    'CgpEYXRhVXBsb2FkEkcKEWRhdGFVcGxvYWRSZXF1ZXN0GAEgASgLMhkueGlhb21pLkRhdGFVcG'
    'xvYWRSZXF1ZXN0UhFkYXRhVXBsb2FkUmVxdWVzdBI7Cg1kYXRhVXBsb2FkQWNrGAIgASgLMhUu'
    'eGlhb21pLkRhdGFVcGxvYWRBY2tSDWRhdGFVcGxvYWRBY2s=');

@$core.Deprecated('Use dataUploadRequestDescriptor instead')
const DataUploadRequest$json = {
  '1': 'DataUploadRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 13, '10': 'type'},
    {'1': 'md5sum', '3': 2, '4': 1, '5': 12, '10': 'md5sum'},
    {'1': 'size', '3': 3, '4': 1, '5': 13, '10': 'size'},
  ],
};

/// Descriptor for `DataUploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataUploadRequestDescriptor = $convert.base64Decode(
    'ChFEYXRhVXBsb2FkUmVxdWVzdBISCgR0eXBlGAEgASgNUgR0eXBlEhYKBm1kNXN1bRgCIAEoDF'
    'IGbWQ1c3VtEhIKBHNpemUYAyABKA1SBHNpemU=');

@$core.Deprecated('Use dataUploadAckDescriptor instead')
const DataUploadAck$json = {
  '1': 'DataUploadAck',
  '2': [
    {'1': 'md5sum', '3': 1, '4': 1, '5': 12, '10': 'md5sum'},
    {'1': 'unknown2', '3': 2, '4': 1, '5': 13, '10': 'unknown2'},
    {'1': 'resumePosition', '3': 4, '4': 1, '5': 13, '10': 'resumePosition'},
    {'1': 'chunkSize', '3': 5, '4': 1, '5': 13, '10': 'chunkSize'},
  ],
};

/// Descriptor for `DataUploadAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataUploadAckDescriptor = $convert.base64Decode(
    'Cg1EYXRhVXBsb2FkQWNrEhYKBm1kNXN1bRgBIAEoDFIGbWQ1c3VtEhoKCHVua25vd24yGAIgAS'
    'gNUgh1bmtub3duMhImCg5yZXN1bWVQb3NpdGlvbhgEIAEoDVIOcmVzdW1lUG9zaXRpb24SHAoJ'
    'Y2h1bmtTaXplGAUgASgNUgljaHVua1NpemU=');

@$core.Deprecated('Use contactInfoDescriptor instead')
const ContactInfo$json = {
  '1': 'ContactInfo',
  '2': [
    {'1': 'displayName', '3': 1, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'phoneNumber', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `ContactInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactInfoDescriptor = $convert.base64Decode(
    'CgtDb250YWN0SW5mbxIgCgtkaXNwbGF5TmFtZRgBIAEoCVILZGlzcGxheU5hbWUSIAoLcGhvbm'
    'VOdW1iZXIYAiABKAlSC3Bob25lTnVtYmVy');

@$core.Deprecated('Use contactListDescriptor instead')
const ContactList$json = {
  '1': 'ContactList',
  '2': [
    {
      '1': 'contactInfo',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xiaomi.ContactInfo',
      '10': 'contactInfo',
    },
  ],
};

/// Descriptor for `ContactList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactListDescriptor = $convert.base64Decode(
    'CgtDb250YWN0TGlzdBI1Cgtjb250YWN0SW5mbxgBIAMoCzITLnhpYW9taS5Db250YWN0SW5mb1'
    'ILY29udGFjdEluZm8=');

@$core.Deprecated('Use phonebookDescriptor instead')
const Phonebook$json = {
  '1': 'Phonebook',
  '2': [
    {
      '1': 'requestedPhoneNumber',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'requestedPhoneNumber',
    },
    {
      '1': 'contactInfo',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ContactInfo',
      '10': 'contactInfo',
    },
    {
      '1': 'contactList',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.xiaomi.ContactList',
      '10': 'contactList',
    },
  ],
};

/// Descriptor for `Phonebook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phonebookDescriptor = $convert.base64Decode(
    'CglQaG9uZWJvb2sSMgoUcmVxdWVzdGVkUGhvbmVOdW1iZXIYAiABKAlSFHJlcXVlc3RlZFBob2'
    '5lTnVtYmVyEjUKC2NvbnRhY3RJbmZvGAMgASgLMhMueGlhb21pLkNvbnRhY3RJbmZvUgtjb250'
    'YWN0SW5mbxI1Cgtjb250YWN0TGlzdBgEIAEoCzITLnhpYW9taS5Db250YWN0TGlzdFILY29udG'
    'FjdExpc3Q=');
