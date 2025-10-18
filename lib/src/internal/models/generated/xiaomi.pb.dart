// This is a generated file - do not edit.
//
// Generated from assets/proto/xiaomi.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Command extends $pb.GeneratedMessage {
  factory Command({
    $core.int? type,
    $core.int? subtype,
    Auth? auth,
    System? system,
    Watchface? watchface,
    Notification? notification,
    Health? health,
    Weather? weather,
    Calendar? calendar,
    Schedule? schedule,
    Music? music,
    Phonebook? phonebook,
    DataUpload? dataUpload,
    $core.int? status,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (subtype != null) result.subtype = subtype;
    if (auth != null) result.auth = auth;
    if (system != null) result.system = system;
    if (watchface != null) result.watchface = watchface;
    if (notification != null) result.notification = notification;
    if (health != null) result.health = health;
    if (weather != null) result.weather = weather;
    if (calendar != null) result.calendar = calendar;
    if (schedule != null) result.schedule = schedule;
    if (music != null) result.music = music;
    if (phonebook != null) result.phonebook = phonebook;
    if (dataUpload != null) result.dataUpload = dataUpload;
    if (status != null) result.status = status;
    return result;
  }

  Command._();

  factory Command.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Command.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Command',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'subtype', fieldType: $pb.PbFieldType.OU3)
    ..aOM<Auth>(3, _omitFieldNames ? '' : 'auth', subBuilder: Auth.create)
    ..aOM<System>(4, _omitFieldNames ? '' : 'system', subBuilder: System.create)
    ..aOM<Watchface>(
      6,
      _omitFieldNames ? '' : 'watchface',
      subBuilder: Watchface.create,
    )
    ..aOM<Notification>(
      9,
      _omitFieldNames ? '' : 'notification',
      subBuilder: Notification.create,
    )
    ..aOM<Health>(
      10,
      _omitFieldNames ? '' : 'health',
      subBuilder: Health.create,
    )
    ..aOM<Weather>(
      12,
      _omitFieldNames ? '' : 'weather',
      subBuilder: Weather.create,
    )
    ..aOM<Calendar>(
      14,
      _omitFieldNames ? '' : 'calendar',
      subBuilder: Calendar.create,
    )
    ..aOM<Schedule>(
      19,
      _omitFieldNames ? '' : 'schedule',
      subBuilder: Schedule.create,
    )
    ..aOM<Music>(20, _omitFieldNames ? '' : 'music', subBuilder: Music.create)
    ..aOM<Phonebook>(
      23,
      _omitFieldNames ? '' : 'phonebook',
      subBuilder: Phonebook.create,
    )
    ..aOM<DataUpload>(
      24,
      _omitFieldNames ? '' : 'dataUpload',
      protoName: 'dataUpload',
      subBuilder: DataUpload.create,
    )
    ..aI(100, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Command clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Command copyWith(void Function(Command) updates) =>
      super.copyWith((message) => updates(message as Command)) as Command;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  @$core.override
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get subtype => $_getIZ(1);
  @$pb.TagNumber(2)
  set subtype($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtype() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtype() => $_clearField(2);

  @$pb.TagNumber(3)
  Auth get auth => $_getN(2);
  @$pb.TagNumber(3)
  set auth(Auth value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuth() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuth() => $_clearField(3);
  @$pb.TagNumber(3)
  Auth ensureAuth() => $_ensure(2);

  @$pb.TagNumber(4)
  System get system => $_getN(3);
  @$pb.TagNumber(4)
  set system(System value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystem() => $_clearField(4);
  @$pb.TagNumber(4)
  System ensureSystem() => $_ensure(3);

  @$pb.TagNumber(6)
  Watchface get watchface => $_getN(4);
  @$pb.TagNumber(6)
  set watchface(Watchface value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWatchface() => $_has(4);
  @$pb.TagNumber(6)
  void clearWatchface() => $_clearField(6);
  @$pb.TagNumber(6)
  Watchface ensureWatchface() => $_ensure(4);

  @$pb.TagNumber(9)
  Notification get notification => $_getN(5);
  @$pb.TagNumber(9)
  set notification(Notification value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasNotification() => $_has(5);
  @$pb.TagNumber(9)
  void clearNotification() => $_clearField(9);
  @$pb.TagNumber(9)
  Notification ensureNotification() => $_ensure(5);

  /// 8, 10 get
  @$pb.TagNumber(10)
  Health get health => $_getN(6);
  @$pb.TagNumber(10)
  set health(Health value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasHealth() => $_has(6);
  @$pb.TagNumber(10)
  void clearHealth() => $_clearField(10);
  @$pb.TagNumber(10)
  Health ensureHealth() => $_ensure(6);

  @$pb.TagNumber(12)
  Weather get weather => $_getN(7);
  @$pb.TagNumber(12)
  set weather(Weather value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasWeather() => $_has(7);
  @$pb.TagNumber(12)
  void clearWeather() => $_clearField(12);
  @$pb.TagNumber(12)
  Weather ensureWeather() => $_ensure(7);

  @$pb.TagNumber(14)
  Calendar get calendar => $_getN(8);
  @$pb.TagNumber(14)
  set calendar(Calendar value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCalendar() => $_has(8);
  @$pb.TagNumber(14)
  void clearCalendar() => $_clearField(14);
  @$pb.TagNumber(14)
  Calendar ensureCalendar() => $_ensure(8);

  @$pb.TagNumber(19)
  Schedule get schedule => $_getN(9);
  @$pb.TagNumber(19)
  set schedule(Schedule value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSchedule() => $_has(9);
  @$pb.TagNumber(19)
  void clearSchedule() => $_clearField(19);
  @$pb.TagNumber(19)
  Schedule ensureSchedule() => $_ensure(9);

  @$pb.TagNumber(20)
  Music get music => $_getN(10);
  @$pb.TagNumber(20)
  set music(Music value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasMusic() => $_has(10);
  @$pb.TagNumber(20)
  void clearMusic() => $_clearField(20);
  @$pb.TagNumber(20)
  Music ensureMusic() => $_ensure(10);

  /// command type 21
  @$pb.TagNumber(23)
  Phonebook get phonebook => $_getN(11);
  @$pb.TagNumber(23)
  set phonebook(Phonebook value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasPhonebook() => $_has(11);
  @$pb.TagNumber(23)
  void clearPhonebook() => $_clearField(23);
  @$pb.TagNumber(23)
  Phonebook ensurePhonebook() => $_ensure(11);

  /// type 22
  @$pb.TagNumber(24)
  DataUpload get dataUpload => $_getN(12);
  @$pb.TagNumber(24)
  set dataUpload(DataUpload value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasDataUpload() => $_has(12);
  @$pb.TagNumber(24)
  void clearDataUpload() => $_clearField(24);
  @$pb.TagNumber(24)
  DataUpload ensureDataUpload() => $_ensure(12);

  @$pb.TagNumber(100)
  $core.int get status => $_getIZ(13);
  @$pb.TagNumber(100)
  set status($core.int value) => $_setUnsignedInt32(13, value);
  @$pb.TagNumber(100)
  $core.bool hasStatus() => $_has(13);
  @$pb.TagNumber(100)
  void clearStatus() => $_clearField(100);
}

class Auth extends $pb.GeneratedMessage {
  factory Auth({
    $core.String? userId,
    $core.int? status,
    PhoneNonce? phoneNonce,
    WatchNonce? watchNonce,
    AuthStep3? authStep3,
    AuthStep4? authStep4,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (status != null) result.status = status;
    if (phoneNonce != null) result.phoneNonce = phoneNonce;
    if (watchNonce != null) result.watchNonce = watchNonce;
    if (authStep3 != null) result.authStep3 = authStep3;
    if (authStep4 != null) result.authStep4 = authStep4;
    return result;
  }

  Auth._();

  factory Auth.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Auth.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Auth',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(7, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aI(8, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..aOM<PhoneNonce>(
      30,
      _omitFieldNames ? '' : 'phoneNonce',
      protoName: 'phoneNonce',
      subBuilder: PhoneNonce.create,
    )
    ..aOM<WatchNonce>(
      31,
      _omitFieldNames ? '' : 'watchNonce',
      protoName: 'watchNonce',
      subBuilder: WatchNonce.create,
    )
    ..aOM<AuthStep3>(
      32,
      _omitFieldNames ? '' : 'authStep3',
      protoName: 'authStep3',
      subBuilder: AuthStep3.create,
    )
    ..aOM<AuthStep4>(
      33,
      _omitFieldNames ? '' : 'authStep4',
      protoName: 'authStep4',
      subBuilder: AuthStep4.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Auth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Auth copyWith(void Function(Auth) updates) =>
      super.copyWith((message) => updates(message as Auth)) as Auth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Auth create() => Auth._();
  @$core.override
  Auth createEmptyInstance() => create();
  static $pb.PbList<Auth> createRepeated() => $pb.PbList<Auth>();
  @$core.pragma('dart2js:noInline')
  static Auth getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Auth>(create);
  static Auth? _defaultInstance;

  @$pb.TagNumber(7)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(7)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(7)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(7)
  void clearUserId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(8)
  set status($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  /// 1, 26
  @$pb.TagNumber(30)
  PhoneNonce get phoneNonce => $_getN(2);
  @$pb.TagNumber(30)
  set phoneNonce(PhoneNonce value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasPhoneNonce() => $_has(2);
  @$pb.TagNumber(30)
  void clearPhoneNonce() => $_clearField(30);
  @$pb.TagNumber(30)
  PhoneNonce ensurePhoneNonce() => $_ensure(2);

  @$pb.TagNumber(31)
  WatchNonce get watchNonce => $_getN(3);
  @$pb.TagNumber(31)
  set watchNonce(WatchNonce value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasWatchNonce() => $_has(3);
  @$pb.TagNumber(31)
  void clearWatchNonce() => $_clearField(31);
  @$pb.TagNumber(31)
  WatchNonce ensureWatchNonce() => $_ensure(3);

  /// 1, 27
  @$pb.TagNumber(32)
  AuthStep3 get authStep3 => $_getN(4);
  @$pb.TagNumber(32)
  set authStep3(AuthStep3 value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasAuthStep3() => $_has(4);
  @$pb.TagNumber(32)
  void clearAuthStep3() => $_clearField(32);
  @$pb.TagNumber(32)
  AuthStep3 ensureAuthStep3() => $_ensure(4);

  @$pb.TagNumber(33)
  AuthStep4 get authStep4 => $_getN(5);
  @$pb.TagNumber(33)
  set authStep4(AuthStep4 value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasAuthStep4() => $_has(5);
  @$pb.TagNumber(33)
  void clearAuthStep4() => $_clearField(33);
  @$pb.TagNumber(33)
  AuthStep4 ensureAuthStep4() => $_ensure(5);
}

class PhoneNonce extends $pb.GeneratedMessage {
  factory PhoneNonce({
    $core.List<$core.int>? nonce,
  }) {
    final result = create();
    if (nonce != null) result.nonce = nonce;
    return result;
  }

  PhoneNonce._();

  factory PhoneNonce.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneNonce.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'PhoneNonce',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..a<$core.List<$core.int>>(
      1,
      _omitFieldNames ? '' : 'nonce',
      $pb.PbFieldType.QY,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNonce clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNonce copyWith(void Function(PhoneNonce) updates) =>
      super.copyWith((message) => updates(message as PhoneNonce)) as PhoneNonce;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneNonce create() => PhoneNonce._();
  @$core.override
  PhoneNonce createEmptyInstance() => create();
  static $pb.PbList<PhoneNonce> createRepeated() => $pb.PbList<PhoneNonce>();
  @$core.pragma('dart2js:noInline')
  static PhoneNonce getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneNonce>(create);
  static PhoneNonce? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nonce => $_getN(0);
  @$pb.TagNumber(1)
  set nonce($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNonce() => $_has(0);
  @$pb.TagNumber(1)
  void clearNonce() => $_clearField(1);
}

class WatchNonce extends $pb.GeneratedMessage {
  factory WatchNonce({
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? hmac,
  }) {
    final result = create();
    if (nonce != null) result.nonce = nonce;
    if (hmac != null) result.hmac = hmac;
    return result;
  }

  WatchNonce._();

  factory WatchNonce.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchNonce.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WatchNonce',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..a<$core.List<$core.int>>(
      1,
      _omitFieldNames ? '' : 'nonce',
      $pb.PbFieldType.QY,
    )
    ..a<$core.List<$core.int>>(
      2,
      _omitFieldNames ? '' : 'hmac',
      $pb.PbFieldType.QY,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchNonce clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchNonce copyWith(void Function(WatchNonce) updates) =>
      super.copyWith((message) => updates(message as WatchNonce)) as WatchNonce;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchNonce create() => WatchNonce._();
  @$core.override
  WatchNonce createEmptyInstance() => create();
  static $pb.PbList<WatchNonce> createRepeated() => $pb.PbList<WatchNonce>();
  @$core.pragma('dart2js:noInline')
  static WatchNonce getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchNonce>(create);
  static WatchNonce? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get nonce => $_getN(0);
  @$pb.TagNumber(1)
  set nonce($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNonce() => $_has(0);
  @$pb.TagNumber(1)
  void clearNonce() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get hmac => $_getN(1);
  @$pb.TagNumber(2)
  set hmac($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHmac() => $_has(1);
  @$pb.TagNumber(2)
  void clearHmac() => $_clearField(2);
}

class AuthStep3 extends $pb.GeneratedMessage {
  factory AuthStep3({
    $core.List<$core.int>? encryptedNonces,
    $core.List<$core.int>? encryptedDeviceInfo,
  }) {
    final result = create();
    if (encryptedNonces != null) result.encryptedNonces = encryptedNonces;
    if (encryptedDeviceInfo != null)
      result.encryptedDeviceInfo = encryptedDeviceInfo;
    return result;
  }

  AuthStep3._();

  factory AuthStep3.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthStep3.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AuthStep3',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..a<$core.List<$core.int>>(
      1,
      _omitFieldNames ? '' : 'encryptedNonces',
      $pb.PbFieldType.QY,
      protoName: 'encryptedNonces',
    )
    ..a<$core.List<$core.int>>(
      2,
      _omitFieldNames ? '' : 'encryptedDeviceInfo',
      $pb.PbFieldType.QY,
      protoName: 'encryptedDeviceInfo',
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthStep3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthStep3 copyWith(void Function(AuthStep3) updates) =>
      super.copyWith((message) => updates(message as AuthStep3)) as AuthStep3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthStep3 create() => AuthStep3._();
  @$core.override
  AuthStep3 createEmptyInstance() => create();
  static $pb.PbList<AuthStep3> createRepeated() => $pb.PbList<AuthStep3>();
  @$core.pragma('dart2js:noInline')
  static AuthStep3 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthStep3>(create);
  static AuthStep3? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get encryptedNonces => $_getN(0);
  @$pb.TagNumber(1)
  set encryptedNonces($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncryptedNonces() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncryptedNonces() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get encryptedDeviceInfo => $_getN(1);
  @$pb.TagNumber(2)
  set encryptedDeviceInfo($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncryptedDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptedDeviceInfo() => $_clearField(2);
}

class AuthStep4 extends $pb.GeneratedMessage {
  factory AuthStep4({
    $core.int? unknown1,
    $core.int? unknown2,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  AuthStep4._();

  factory AuthStep4.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthStep4.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AuthStep4',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthStep4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthStep4 copyWith(void Function(AuthStep4) updates) =>
      super.copyWith((message) => updates(message as AuthStep4)) as AuthStep4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthStep4 create() => AuthStep4._();
  @$core.override
  AuthStep4 createEmptyInstance() => create();
  static $pb.PbList<AuthStep4> createRepeated() => $pb.PbList<AuthStep4>();
  @$core.pragma('dart2js:noInline')
  static AuthStep4 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthStep4>(create);
  static AuthStep4? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class AuthDeviceInfo extends $pb.GeneratedMessage {
  factory AuthDeviceInfo({
    $core.int? unknown1,
    $core.double? phoneApiLevel,
    $core.String? phoneName,
    $core.int? unknown3,
    $core.String? region,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (phoneApiLevel != null) result.phoneApiLevel = phoneApiLevel;
    if (phoneName != null) result.phoneName = phoneName;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (region != null) result.region = region;
    return result;
  }

  AuthDeviceInfo._();

  factory AuthDeviceInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthDeviceInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AuthDeviceInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.QU3)
    ..aD(
      2,
      _omitFieldNames ? '' : 'phoneApiLevel',
      protoName: 'phoneApiLevel',
      fieldType: $pb.PbFieldType.QF,
    )
    ..aQS(3, _omitFieldNames ? '' : 'phoneName', protoName: 'phoneName')
    ..aI(4, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.QU3)
    ..aQS(5, _omitFieldNames ? '' : 'region');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthDeviceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthDeviceInfo copyWith(void Function(AuthDeviceInfo) updates) =>
      super.copyWith((message) => updates(message as AuthDeviceInfo))
          as AuthDeviceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthDeviceInfo create() => AuthDeviceInfo._();
  @$core.override
  AuthDeviceInfo createEmptyInstance() => create();
  static $pb.PbList<AuthDeviceInfo> createRepeated() =>
      $pb.PbList<AuthDeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static AuthDeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthDeviceInfo>(create);
  static AuthDeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get phoneApiLevel => $_getN(1);
  @$pb.TagNumber(2)
  set phoneApiLevel($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneApiLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneApiLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get phoneName => $_getSZ(2);
  @$pb.TagNumber(3)
  set phoneName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhoneName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhoneName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unknown3 => $_getIZ(3);
  @$pb.TagNumber(4)
  set unknown3($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown3() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get region => $_getSZ(4);
  @$pb.TagNumber(5)
  set region($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRegion() => $_has(4);
  @$pb.TagNumber(5)
  void clearRegion() => $_clearField(5);
}

class System extends $pb.GeneratedMessage {
  factory System({
    Power? power,
    DeviceInfo? deviceInfo,
    Clock? clock,
    $core.int? findDevice,
    RaiseToWake? raiseToWake,
    SimpleWidgets? simpleWidgets,
    DisplayItems? displayItems,
    DoNotDisturb? dndStatus,
    WorkoutTypes? workoutTypes,
    Camera? camera,
    FirmwareInstallRequest? firmwareInstallRequest,
    FirmwareInstallResponse? firmwareInstallResponse,
    Password? password,
    Language? language,
    WidgetScreens? widgetScreens,
    WidgetParts? widgetParts,
    MiscSettingGet? miscSettingGet,
    MiscSettingSet? miscSettingSet,
    PhoneSilentModeGet? phoneSilentModeGet,
    PhoneSilentModeSet? phoneSilentModeSet,
    VibrationPatterns? vibrationPatterns,
    VibrationNotificationType? vibrationSetPreset,
    CustomVibrationPattern? vibrationPatternCreate,
    VibrationTest? vibrationTestCustom,
    VibrationPatternAck? vibrationPatternAck,
    BasicDeviceState? basicDeviceState,
    DeviceState? deviceState,
  }) {
    final result = create();
    if (power != null) result.power = power;
    if (deviceInfo != null) result.deviceInfo = deviceInfo;
    if (clock != null) result.clock = clock;
    if (findDevice != null) result.findDevice = findDevice;
    if (raiseToWake != null) result.raiseToWake = raiseToWake;
    if (simpleWidgets != null) result.simpleWidgets = simpleWidgets;
    if (displayItems != null) result.displayItems = displayItems;
    if (dndStatus != null) result.dndStatus = dndStatus;
    if (workoutTypes != null) result.workoutTypes = workoutTypes;
    if (camera != null) result.camera = camera;
    if (firmwareInstallRequest != null)
      result.firmwareInstallRequest = firmwareInstallRequest;
    if (firmwareInstallResponse != null)
      result.firmwareInstallResponse = firmwareInstallResponse;
    if (password != null) result.password = password;
    if (language != null) result.language = language;
    if (widgetScreens != null) result.widgetScreens = widgetScreens;
    if (widgetParts != null) result.widgetParts = widgetParts;
    if (miscSettingGet != null) result.miscSettingGet = miscSettingGet;
    if (miscSettingSet != null) result.miscSettingSet = miscSettingSet;
    if (phoneSilentModeGet != null)
      result.phoneSilentModeGet = phoneSilentModeGet;
    if (phoneSilentModeSet != null)
      result.phoneSilentModeSet = phoneSilentModeSet;
    if (vibrationPatterns != null) result.vibrationPatterns = vibrationPatterns;
    if (vibrationSetPreset != null)
      result.vibrationSetPreset = vibrationSetPreset;
    if (vibrationPatternCreate != null)
      result.vibrationPatternCreate = vibrationPatternCreate;
    if (vibrationTestCustom != null)
      result.vibrationTestCustom = vibrationTestCustom;
    if (vibrationPatternAck != null)
      result.vibrationPatternAck = vibrationPatternAck;
    if (basicDeviceState != null) result.basicDeviceState = basicDeviceState;
    if (deviceState != null) result.deviceState = deviceState;
    return result;
  }

  System._();

  factory System.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory System.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'System',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<Power>(2, _omitFieldNames ? '' : 'power', subBuilder: Power.create)
    ..aOM<DeviceInfo>(
      3,
      _omitFieldNames ? '' : 'deviceInfo',
      protoName: 'deviceInfo',
      subBuilder: DeviceInfo.create,
    )
    ..aOM<Clock>(4, _omitFieldNames ? '' : 'clock', subBuilder: Clock.create)
    ..aI(
      5,
      _omitFieldNames ? '' : 'findDevice',
      protoName: 'findDevice',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<RaiseToWake>(
      7,
      _omitFieldNames ? '' : 'raiseToWake',
      protoName: 'raiseToWake',
      subBuilder: RaiseToWake.create,
    )
    ..aOM<SimpleWidgets>(
      9,
      _omitFieldNames ? '' : 'simpleWidgets',
      protoName: 'simpleWidgets',
      subBuilder: SimpleWidgets.create,
    )
    ..aOM<DisplayItems>(
      10,
      _omitFieldNames ? '' : 'displayItems',
      protoName: 'displayItems',
      subBuilder: DisplayItems.create,
    )
    ..aOM<DoNotDisturb>(
      11,
      _omitFieldNames ? '' : 'dndStatus',
      protoName: 'dndStatus',
      subBuilder: DoNotDisturb.create,
    )
    ..aOM<WorkoutTypes>(
      14,
      _omitFieldNames ? '' : 'workoutTypes',
      protoName: 'workoutTypes',
      subBuilder: WorkoutTypes.create,
    )
    ..aOM<Camera>(
      15,
      _omitFieldNames ? '' : 'camera',
      subBuilder: Camera.create,
    )
    ..aOM<FirmwareInstallRequest>(
      16,
      _omitFieldNames ? '' : 'firmwareInstallRequest',
      protoName: 'firmwareInstallRequest',
      subBuilder: FirmwareInstallRequest.create,
    )
    ..aOM<FirmwareInstallResponse>(
      17,
      _omitFieldNames ? '' : 'firmwareInstallResponse',
      protoName: 'firmwareInstallResponse',
      subBuilder: FirmwareInstallResponse.create,
    )
    ..aOM<Password>(
      19,
      _omitFieldNames ? '' : 'password',
      subBuilder: Password.create,
    )
    ..aOM<Language>(
      20,
      _omitFieldNames ? '' : 'language',
      subBuilder: Language.create,
    )
    ..aOM<WidgetScreens>(
      28,
      _omitFieldNames ? '' : 'widgetScreens',
      protoName: 'widgetScreens',
      subBuilder: WidgetScreens.create,
    )
    ..aOM<WidgetParts>(
      29,
      _omitFieldNames ? '' : 'widgetParts',
      protoName: 'widgetParts',
      subBuilder: WidgetParts.create,
    )
    ..aOM<MiscSettingGet>(
      34,
      _omitFieldNames ? '' : 'miscSettingGet',
      protoName: 'miscSettingGet',
      subBuilder: MiscSettingGet.create,
    )
    ..aOM<MiscSettingSet>(
      35,
      _omitFieldNames ? '' : 'miscSettingSet',
      protoName: 'miscSettingSet',
      subBuilder: MiscSettingSet.create,
    )
    ..aOM<PhoneSilentModeGet>(
      36,
      _omitFieldNames ? '' : 'phoneSilentModeGet',
      protoName: 'phoneSilentModeGet',
      subBuilder: PhoneSilentModeGet.create,
    )
    ..aOM<PhoneSilentModeSet>(
      37,
      _omitFieldNames ? '' : 'phoneSilentModeSet',
      protoName: 'phoneSilentModeSet',
      subBuilder: PhoneSilentModeSet.create,
    )
    ..aOM<VibrationPatterns>(
      38,
      _omitFieldNames ? '' : 'vibrationPatterns',
      protoName: 'vibrationPatterns',
      subBuilder: VibrationPatterns.create,
    )
    ..aOM<VibrationNotificationType>(
      39,
      _omitFieldNames ? '' : 'vibrationSetPreset',
      protoName: 'vibrationSetPreset',
      subBuilder: VibrationNotificationType.create,
    )
    ..aOM<CustomVibrationPattern>(
      40,
      _omitFieldNames ? '' : 'vibrationPatternCreate',
      protoName: 'vibrationPatternCreate',
      subBuilder: CustomVibrationPattern.create,
    )
    ..aOM<VibrationTest>(
      41,
      _omitFieldNames ? '' : 'vibrationTestCustom',
      protoName: 'vibrationTestCustom',
      subBuilder: VibrationTest.create,
    )
    ..aOM<VibrationPatternAck>(
      43,
      _omitFieldNames ? '' : 'vibrationPatternAck',
      protoName: 'vibrationPatternAck',
      subBuilder: VibrationPatternAck.create,
    )
    ..aOM<BasicDeviceState>(
      48,
      _omitFieldNames ? '' : 'basicDeviceState',
      protoName: 'basicDeviceState',
      subBuilder: BasicDeviceState.create,
    )
    ..aOM<DeviceState>(
      49,
      _omitFieldNames ? '' : 'deviceState',
      protoName: 'deviceState',
      subBuilder: DeviceState.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  System clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  System copyWith(void Function(System) updates) =>
      super.copyWith((message) => updates(message as System)) as System;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static System create() => System._();
  @$core.override
  System createEmptyInstance() => create();
  static $pb.PbList<System> createRepeated() => $pb.PbList<System>();
  @$core.pragma('dart2js:noInline')
  static System getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<System>(create);
  static System? _defaultInstance;

  /// 2, 1
  @$pb.TagNumber(2)
  Power get power => $_getN(0);
  @$pb.TagNumber(2)
  set power(Power value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPower() => $_has(0);
  @$pb.TagNumber(2)
  void clearPower() => $_clearField(2);
  @$pb.TagNumber(2)
  Power ensurePower() => $_ensure(0);

  /// 2, 2
  @$pb.TagNumber(3)
  DeviceInfo get deviceInfo => $_getN(1);
  @$pb.TagNumber(3)
  set deviceInfo(DeviceInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(3)
  void clearDeviceInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  DeviceInfo ensureDeviceInfo() => $_ensure(1);

  /// 2, 3
  @$pb.TagNumber(4)
  Clock get clock => $_getN(2);
  @$pb.TagNumber(4)
  set clock(Clock value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClock() => $_has(2);
  @$pb.TagNumber(4)
  void clearClock() => $_clearField(4);
  @$pb.TagNumber(4)
  Clock ensureClock() => $_ensure(2);

  /// 2, 18
  @$pb.TagNumber(5)
  $core.int get findDevice => $_getIZ(3);
  @$pb.TagNumber(5)
  set findDevice($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasFindDevice() => $_has(3);
  @$pb.TagNumber(5)
  void clearFindDevice() => $_clearField(5);

  /// 2, 24 get | 2, 25 set
  @$pb.TagNumber(7)
  RaiseToWake get raiseToWake => $_getN(4);
  @$pb.TagNumber(7)
  set raiseToWake(RaiseToWake value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRaiseToWake() => $_has(4);
  @$pb.TagNumber(7)
  void clearRaiseToWake() => $_clearField(7);
  @$pb.TagNumber(7)
  RaiseToWake ensureRaiseToWake() => $_ensure(4);

  /// 2, 28 get | 2, 27 set
  @$pb.TagNumber(9)
  SimpleWidgets get simpleWidgets => $_getN(5);
  @$pb.TagNumber(9)
  set simpleWidgets(SimpleWidgets value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSimpleWidgets() => $_has(5);
  @$pb.TagNumber(9)
  void clearSimpleWidgets() => $_clearField(9);
  @$pb.TagNumber(9)
  SimpleWidgets ensureSimpleWidgets() => $_ensure(5);

  /// 2, 29 get | 2, 39 set
  @$pb.TagNumber(10)
  DisplayItems get displayItems => $_getN(6);
  @$pb.TagNumber(10)
  set displayItems(DisplayItems value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDisplayItems() => $_has(6);
  @$pb.TagNumber(10)
  void clearDisplayItems() => $_clearField(10);
  @$pb.TagNumber(10)
  DisplayItems ensureDisplayItems() => $_ensure(6);

  /// 2, 34
  @$pb.TagNumber(11)
  DoNotDisturb get dndStatus => $_getN(7);
  @$pb.TagNumber(11)
  set dndStatus(DoNotDisturb value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDndStatus() => $_has(7);
  @$pb.TagNumber(11)
  void clearDndStatus() => $_clearField(11);
  @$pb.TagNumber(11)
  DoNotDisturb ensureDndStatus() => $_ensure(7);

  /// 2, 39
  @$pb.TagNumber(14)
  WorkoutTypes get workoutTypes => $_getN(8);
  @$pb.TagNumber(14)
  set workoutTypes(WorkoutTypes value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasWorkoutTypes() => $_has(8);
  @$pb.TagNumber(14)
  void clearWorkoutTypes() => $_clearField(14);
  @$pb.TagNumber(14)
  WorkoutTypes ensureWorkoutTypes() => $_ensure(8);

  /// 2, 7 get | 2, 8 set
  @$pb.TagNumber(15)
  Camera get camera => $_getN(9);
  @$pb.TagNumber(15)
  set camera(Camera value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCamera() => $_has(9);
  @$pb.TagNumber(15)
  void clearCamera() => $_clearField(15);
  @$pb.TagNumber(15)
  Camera ensureCamera() => $_ensure(9);

  /// 2, 5
  @$pb.TagNumber(16)
  FirmwareInstallRequest get firmwareInstallRequest => $_getN(10);
  @$pb.TagNumber(16)
  set firmwareInstallRequest(FirmwareInstallRequest value) =>
      $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasFirmwareInstallRequest() => $_has(10);
  @$pb.TagNumber(16)
  void clearFirmwareInstallRequest() => $_clearField(16);
  @$pb.TagNumber(16)
  FirmwareInstallRequest ensureFirmwareInstallRequest() => $_ensure(10);

  @$pb.TagNumber(17)
  FirmwareInstallResponse get firmwareInstallResponse => $_getN(11);
  @$pb.TagNumber(17)
  set firmwareInstallResponse(FirmwareInstallResponse value) =>
      $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasFirmwareInstallResponse() => $_has(11);
  @$pb.TagNumber(17)
  void clearFirmwareInstallResponse() => $_clearField(17);
  @$pb.TagNumber(17)
  FirmwareInstallResponse ensureFirmwareInstallResponse() => $_ensure(11);

  /// 2, 9 get | 2, 21 set
  @$pb.TagNumber(19)
  Password get password => $_getN(12);
  @$pb.TagNumber(19)
  set password(Password value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasPassword() => $_has(12);
  @$pb.TagNumber(19)
  void clearPassword() => $_clearField(19);
  @$pb.TagNumber(19)
  Password ensurePassword() => $_ensure(12);

  /// 2, 6
  @$pb.TagNumber(20)
  Language get language => $_getN(13);
  @$pb.TagNumber(20)
  set language(Language value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLanguage() => $_has(13);
  @$pb.TagNumber(20)
  void clearLanguage() => $_clearField(20);
  @$pb.TagNumber(20)
  Language ensureLanguage() => $_ensure(13);

  /// 2, 51 get | 2, 52 create
  @$pb.TagNumber(28)
  WidgetScreens get widgetScreens => $_getN(14);
  @$pb.TagNumber(28)
  set widgetScreens(WidgetScreens value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasWidgetScreens() => $_has(14);
  @$pb.TagNumber(28)
  void clearWidgetScreens() => $_clearField(28);
  @$pb.TagNumber(28)
  WidgetScreens ensureWidgetScreens() => $_ensure(14);

  /// 2, 53
  @$pb.TagNumber(29)
  WidgetParts get widgetParts => $_getN(15);
  @$pb.TagNumber(29)
  set widgetParts(WidgetParts value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasWidgetParts() => $_has(15);
  @$pb.TagNumber(29)
  void clearWidgetParts() => $_clearField(29);
  @$pb.TagNumber(29)
  WidgetParts ensureWidgetParts() => $_ensure(15);

  /// 2, 14
  @$pb.TagNumber(34)
  MiscSettingGet get miscSettingGet => $_getN(16);
  @$pb.TagNumber(34)
  set miscSettingGet(MiscSettingGet value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasMiscSettingGet() => $_has(16);
  @$pb.TagNumber(34)
  void clearMiscSettingGet() => $_clearField(34);
  @$pb.TagNumber(34)
  MiscSettingGet ensureMiscSettingGet() => $_ensure(16);

  /// 2, 15
  @$pb.TagNumber(35)
  MiscSettingSet get miscSettingSet => $_getN(17);
  @$pb.TagNumber(35)
  set miscSettingSet(MiscSettingSet value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasMiscSettingSet() => $_has(17);
  @$pb.TagNumber(35)
  void clearMiscSettingSet() => $_clearField(35);
  @$pb.TagNumber(35)
  MiscSettingSet ensureMiscSettingSet() => $_ensure(17);

  /// 2, 43
  @$pb.TagNumber(36)
  PhoneSilentModeGet get phoneSilentModeGet => $_getN(18);
  @$pb.TagNumber(36)
  set phoneSilentModeGet(PhoneSilentModeGet value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasPhoneSilentModeGet() => $_has(18);
  @$pb.TagNumber(36)
  void clearPhoneSilentModeGet() => $_clearField(36);
  @$pb.TagNumber(36)
  PhoneSilentModeGet ensurePhoneSilentModeGet() => $_ensure(18);

  /// 2, 44 returning to watch, 2, 45 setting from watch
  @$pb.TagNumber(37)
  PhoneSilentModeSet get phoneSilentModeSet => $_getN(19);
  @$pb.TagNumber(37)
  set phoneSilentModeSet(PhoneSilentModeSet value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasPhoneSilentModeSet() => $_has(19);
  @$pb.TagNumber(37)
  void clearPhoneSilentModeSet() => $_clearField(37);
  @$pb.TagNumber(37)
  PhoneSilentModeSet ensurePhoneSilentModeSet() => $_ensure(19);

  /// 2, 46
  @$pb.TagNumber(38)
  VibrationPatterns get vibrationPatterns => $_getN(20);
  @$pb.TagNumber(38)
  set vibrationPatterns(VibrationPatterns value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasVibrationPatterns() => $_has(20);
  @$pb.TagNumber(38)
  void clearVibrationPatterns() => $_clearField(38);
  @$pb.TagNumber(38)
  VibrationPatterns ensureVibrationPatterns() => $_ensure(20);

  /// 2, 47
  @$pb.TagNumber(39)
  VibrationNotificationType get vibrationSetPreset => $_getN(21);
  @$pb.TagNumber(39)
  set vibrationSetPreset(VibrationNotificationType value) =>
      $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasVibrationSetPreset() => $_has(21);
  @$pb.TagNumber(39)
  void clearVibrationSetPreset() => $_clearField(39);
  @$pb.TagNumber(39)
  VibrationNotificationType ensureVibrationSetPreset() => $_ensure(21);

  /// 2, 58
  @$pb.TagNumber(40)
  CustomVibrationPattern get vibrationPatternCreate => $_getN(22);
  @$pb.TagNumber(40)
  set vibrationPatternCreate(CustomVibrationPattern value) =>
      $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasVibrationPatternCreate() => $_has(22);
  @$pb.TagNumber(40)
  void clearVibrationPatternCreate() => $_clearField(40);
  @$pb.TagNumber(40)
  CustomVibrationPattern ensureVibrationPatternCreate() => $_ensure(22);

  /// 2, 59
  @$pb.TagNumber(41)
  VibrationTest get vibrationTestCustom => $_getN(23);
  @$pb.TagNumber(41)
  set vibrationTestCustom(VibrationTest value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasVibrationTestCustom() => $_has(23);
  @$pb.TagNumber(41)
  void clearVibrationTestCustom() => $_clearField(41);
  @$pb.TagNumber(41)
  VibrationTest ensureVibrationTestCustom() => $_ensure(23);

  /// 2, 47
  @$pb.TagNumber(43)
  VibrationPatternAck get vibrationPatternAck => $_getN(24);
  @$pb.TagNumber(43)
  set vibrationPatternAck(VibrationPatternAck value) => $_setField(43, value);
  @$pb.TagNumber(43)
  $core.bool hasVibrationPatternAck() => $_has(24);
  @$pb.TagNumber(43)
  void clearVibrationPatternAck() => $_clearField(43);
  @$pb.TagNumber(43)
  VibrationPatternAck ensureVibrationPatternAck() => $_ensure(24);

  /// 2, 78
  @$pb.TagNumber(48)
  BasicDeviceState get basicDeviceState => $_getN(25);
  @$pb.TagNumber(48)
  set basicDeviceState(BasicDeviceState value) => $_setField(48, value);
  @$pb.TagNumber(48)
  $core.bool hasBasicDeviceState() => $_has(25);
  @$pb.TagNumber(48)
  void clearBasicDeviceState() => $_clearField(48);
  @$pb.TagNumber(48)
  BasicDeviceState ensureBasicDeviceState() => $_ensure(25);

  /// 2, 79
  @$pb.TagNumber(49)
  DeviceState get deviceState => $_getN(26);
  @$pb.TagNumber(49)
  set deviceState(DeviceState value) => $_setField(49, value);
  @$pb.TagNumber(49)
  $core.bool hasDeviceState() => $_has(26);
  @$pb.TagNumber(49)
  void clearDeviceState() => $_clearField(49);
  @$pb.TagNumber(49)
  DeviceState ensureDeviceState() => $_ensure(26);
}

class Power extends $pb.GeneratedMessage {
  factory Power({
    Battery? battery,
  }) {
    final result = create();
    if (battery != null) result.battery = battery;
    return result;
  }

  Power._();

  factory Power.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Power.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Power',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<Battery>(
      1,
      _omitFieldNames ? '' : 'battery',
      subBuilder: Battery.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Power clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Power copyWith(void Function(Power) updates) =>
      super.copyWith((message) => updates(message as Power)) as Power;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Power create() => Power._();
  @$core.override
  Power createEmptyInstance() => create();
  static $pb.PbList<Power> createRepeated() => $pb.PbList<Power>();
  @$core.pragma('dart2js:noInline')
  static Power getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Power>(create);
  static Power? _defaultInstance;

  @$pb.TagNumber(1)
  Battery get battery => $_getN(0);
  @$pb.TagNumber(1)
  set battery(Battery value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBattery() => $_has(0);
  @$pb.TagNumber(1)
  void clearBattery() => $_clearField(1);
  @$pb.TagNumber(1)
  Battery ensureBattery() => $_ensure(0);
}

class Battery extends $pb.GeneratedMessage {
  factory Battery({
    $core.int? level,
    $core.int? state,
    LastCharge? lastCharge,
  }) {
    final result = create();
    if (level != null) result.level = level;
    if (state != null) result.state = state;
    if (lastCharge != null) result.lastCharge = lastCharge;
    return result;
  }

  Battery._();

  factory Battery.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Battery.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Battery',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'level', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'state', fieldType: $pb.PbFieldType.OU3)
    ..aOM<LastCharge>(
      3,
      _omitFieldNames ? '' : 'lastCharge',
      protoName: 'lastCharge',
      subBuilder: LastCharge.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Battery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Battery copyWith(void Function(Battery) updates) =>
      super.copyWith((message) => updates(message as Battery)) as Battery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Battery create() => Battery._();
  @$core.override
  Battery createEmptyInstance() => create();
  static $pb.PbList<Battery> createRepeated() => $pb.PbList<Battery>();
  @$core.pragma('dart2js:noInline')
  static Battery getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Battery>(create);
  static Battery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get level => $_getIZ(0);
  @$pb.TagNumber(1)
  set level($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get state => $_getIZ(1);
  @$pb.TagNumber(2)
  set state($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  LastCharge get lastCharge => $_getN(2);
  @$pb.TagNumber(3)
  set lastCharge(LastCharge value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLastCharge() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastCharge() => $_clearField(3);
  @$pb.TagNumber(3)
  LastCharge ensureLastCharge() => $_ensure(2);
}

class LastCharge extends $pb.GeneratedMessage {
  factory LastCharge({
    $core.int? state,
    $core.int? timestampSeconds,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (timestampSeconds != null) result.timestampSeconds = timestampSeconds;
    return result;
  }

  LastCharge._();

  factory LastCharge.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory LastCharge.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'LastCharge',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'state', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      2,
      _omitFieldNames ? '' : 'timestampSeconds',
      protoName: 'timestampSeconds',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LastCharge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LastCharge copyWith(void Function(LastCharge) updates) =>
      super.copyWith((message) => updates(message as LastCharge)) as LastCharge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LastCharge create() => LastCharge._();
  @$core.override
  LastCharge createEmptyInstance() => create();
  static $pb.PbList<LastCharge> createRepeated() => $pb.PbList<LastCharge>();
  @$core.pragma('dart2js:noInline')
  static LastCharge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LastCharge>(create);
  static LastCharge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get state => $_getIZ(0);
  @$pb.TagNumber(1)
  set state($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get timestampSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set timestampSeconds($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestampSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestampSeconds() => $_clearField(2);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? serialNumber,
    $core.String? firmware,
    $core.String? unknown3,
    $core.String? model,
  }) {
    final result = create();
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (firmware != null) result.firmware = firmware;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (model != null) result.model = model;
    return result;
  }

  DeviceInfo._();

  factory DeviceInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DeviceInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(1, _omitFieldNames ? '' : 'serialNumber', protoName: 'serialNumber')
    ..aQS(2, _omitFieldNames ? '' : 'firmware')
    ..aOS(3, _omitFieldNames ? '' : 'unknown3')
    ..aQS(4, _omitFieldNames ? '' : 'model');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  @$core.override
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serialNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set serialNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSerialNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearSerialNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get firmware => $_getSZ(1);
  @$pb.TagNumber(2)
  set firmware($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirmware() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirmware() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unknown3 => $_getSZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get model => $_getSZ(3);
  @$pb.TagNumber(4)
  set model($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearModel() => $_clearField(4);
}

class Clock extends $pb.GeneratedMessage {
  factory Clock({
    Date? date,
    Time? time,
    TimeZone? timezone,
    $core.bool? isNot24hour,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (time != null) result.time = time;
    if (timezone != null) result.timezone = timezone;
    if (isNot24hour != null) result.isNot24hour = isNot24hour;
    return result;
  }

  Clock._();

  factory Clock.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Clock.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Clock',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQM<Date>(1, _omitFieldNames ? '' : 'date', subBuilder: Date.create)
    ..aQM<Time>(2, _omitFieldNames ? '' : 'time', subBuilder: Time.create)
    ..aQM<TimeZone>(
      3,
      _omitFieldNames ? '' : 'timezone',
      subBuilder: TimeZone.create,
    )
    ..aOB(4, _omitFieldNames ? '' : 'isNot24hour', protoName: 'isNot24hour');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clock clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Clock copyWith(void Function(Clock) updates) =>
      super.copyWith((message) => updates(message as Clock)) as Clock;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Clock create() => Clock._();
  @$core.override
  Clock createEmptyInstance() => create();
  static $pb.PbList<Clock> createRepeated() => $pb.PbList<Clock>();
  @$core.pragma('dart2js:noInline')
  static Clock getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Clock>(create);
  static Clock? _defaultInstance;

  @$pb.TagNumber(1)
  Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date(Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  Time get time => $_getN(1);
  @$pb.TagNumber(2)
  set time(Time value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => $_clearField(2);
  @$pb.TagNumber(2)
  Time ensureTime() => $_ensure(1);

  @$pb.TagNumber(3)
  TimeZone get timezone => $_getN(2);
  @$pb.TagNumber(3)
  set timezone(TimeZone value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTimezone() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimezone() => $_clearField(3);
  @$pb.TagNumber(3)
  TimeZone ensureTimezone() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isNot24hour => $_getBF(3);
  @$pb.TagNumber(4)
  set isNot24hour($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsNot24hour() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsNot24hour() => $_clearField(4);
}

class Date extends $pb.GeneratedMessage {
  factory Date({
    $core.int? year,
    $core.int? month,
    $core.int? day,
  }) {
    final result = create();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    if (day != null) result.day = day;
    return result;
  }

  Date._();

  factory Date.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Date.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Date',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'year', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'month', fieldType: $pb.PbFieldType.QU3)
    ..aI(3, _omitFieldNames ? '' : 'day', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Date clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Date copyWith(void Function(Date) updates) =>
      super.copyWith((message) => updates(message as Date)) as Date;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Date create() => Date._();
  @$core.override
  Date createEmptyInstance() => create();
  static $pb.PbList<Date> createRepeated() => $pb.PbList<Date>();
  @$core.pragma('dart2js:noInline')
  static Date getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Date>(create);
  static Date? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get day => $_getIZ(2);
  @$pb.TagNumber(3)
  set day($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDay() => $_clearField(3);
}

class Time extends $pb.GeneratedMessage {
  factory Time({
    $core.int? hour,
    $core.int? minute,
    $core.int? second,
    $core.int? millisecond,
  }) {
    final result = create();
    if (hour != null) result.hour = hour;
    if (minute != null) result.minute = minute;
    if (second != null) result.second = second;
    if (millisecond != null) result.millisecond = millisecond;
    return result;
  }

  Time._();

  factory Time.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Time.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Time',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'hour', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'minute', fieldType: $pb.PbFieldType.QU3)
    ..aI(3, _omitFieldNames ? '' : 'second', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      4,
      _omitFieldNames ? '' : 'millisecond',
      fieldType: $pb.PbFieldType.OU3,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Time clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Time copyWith(void Function(Time) updates) =>
      super.copyWith((message) => updates(message as Time)) as Time;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Time create() => Time._();
  @$core.override
  Time createEmptyInstance() => create();
  static $pb.PbList<Time> createRepeated() => $pb.PbList<Time>();
  @$core.pragma('dart2js:noInline')
  static Time getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Time>(create);
  static Time? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hour => $_getIZ(0);
  @$pb.TagNumber(1)
  set hour($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHour() => $_has(0);
  @$pb.TagNumber(1)
  void clearHour() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minute => $_getIZ(1);
  @$pb.TagNumber(2)
  set minute($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinute() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinute() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get second => $_getIZ(2);
  @$pb.TagNumber(3)
  set second($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSecond() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecond() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get millisecond => $_getIZ(3);
  @$pb.TagNumber(4)
  set millisecond($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMillisecond() => $_has(3);
  @$pb.TagNumber(4)
  void clearMillisecond() => $_clearField(4);
}

class TimeZone extends $pb.GeneratedMessage {
  factory TimeZone({
    $core.int? zoneOffset,
    $core.int? dstOffset,
    $core.String? name,
  }) {
    final result = create();
    if (zoneOffset != null) result.zoneOffset = zoneOffset;
    if (dstOffset != null) result.dstOffset = dstOffset;
    if (name != null) result.name = name;
    return result;
  }

  TimeZone._();

  factory TimeZone.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory TimeZone.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'TimeZone',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'zoneOffset',
      protoName: 'zoneOffset',
      fieldType: $pb.PbFieldType.OS3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'dstOffset',
      protoName: 'dstOffset',
      fieldType: $pb.PbFieldType.OS3,
    )
    ..aQS(3, _omitFieldNames ? '' : 'name');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeZone clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeZone copyWith(void Function(TimeZone) updates) =>
      super.copyWith((message) => updates(message as TimeZone)) as TimeZone;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeZone create() => TimeZone._();
  @$core.override
  TimeZone createEmptyInstance() => create();
  static $pb.PbList<TimeZone> createRepeated() => $pb.PbList<TimeZone>();
  @$core.pragma('dart2js:noInline')
  static TimeZone getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeZone>(create);
  static TimeZone? _defaultInstance;

  /// offsets are in blocks of 15 min
  @$pb.TagNumber(1)
  $core.int get zoneOffset => $_getIZ(0);
  @$pb.TagNumber(1)
  set zoneOffset($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasZoneOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get dstOffset => $_getIZ(1);
  @$pb.TagNumber(2)
  set dstOffset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDstOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearDstOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

class RaiseToWake extends $pb.GeneratedMessage {
  factory RaiseToWake({
    $core.int? mode,
    HourMinute? start,
    HourMinute? end,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    return result;
  }

  RaiseToWake._();

  factory RaiseToWake.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseToWake.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'RaiseToWake',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..aOM<HourMinute>(
      2,
      _omitFieldNames ? '' : 'start',
      subBuilder: HourMinute.create,
    )
    ..aOM<HourMinute>(
      3,
      _omitFieldNames ? '' : 'end',
      subBuilder: HourMinute.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseToWake clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseToWake copyWith(void Function(RaiseToWake) updates) =>
      super.copyWith((message) => updates(message as RaiseToWake))
          as RaiseToWake;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseToWake create() => RaiseToWake._();
  @$core.override
  RaiseToWake createEmptyInstance() => create();
  static $pb.PbList<RaiseToWake> createRepeated() => $pb.PbList<RaiseToWake>();
  @$core.pragma('dart2js:noInline')
  static RaiseToWake getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseToWake>(create);
  static RaiseToWake? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get mode => $_getIZ(0);
  @$pb.TagNumber(1)
  set mode($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  HourMinute get start => $_getN(1);
  @$pb.TagNumber(2)
  set start(HourMinute value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearStart() => $_clearField(2);
  @$pb.TagNumber(2)
  HourMinute ensureStart() => $_ensure(1);

  @$pb.TagNumber(3)
  HourMinute get end => $_getN(2);
  @$pb.TagNumber(3)
  set end(HourMinute value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  HourMinute ensureEnd() => $_ensure(2);
}

class SimpleWidgets extends $pb.GeneratedMessage {
  factory SimpleWidgets({
    $core.Iterable<SimpleWidget>? simpleWidget,
    $core.int? unk2,
    $core.int? unk3,
  }) {
    final result = create();
    if (simpleWidget != null) result.simpleWidget.addAll(simpleWidget);
    if (unk2 != null) result.unk2 = unk2;
    if (unk3 != null) result.unk3 = unk3;
    return result;
  }

  SimpleWidgets._();

  factory SimpleWidgets.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory SimpleWidgets.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'SimpleWidgets',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<SimpleWidget>(
      1,
      _omitFieldNames ? '' : 'simpleWidget',
      protoName: 'simpleWidget',
      subBuilder: SimpleWidget.create,
    )
    ..aI(2, _omitFieldNames ? '' : 'unk2', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'unk3', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleWidgets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleWidgets copyWith(void Function(SimpleWidgets) updates) =>
      super.copyWith((message) => updates(message as SimpleWidgets))
          as SimpleWidgets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SimpleWidgets create() => SimpleWidgets._();
  @$core.override
  SimpleWidgets createEmptyInstance() => create();
  static $pb.PbList<SimpleWidgets> createRepeated() =>
      $pb.PbList<SimpleWidgets>();
  @$core.pragma('dart2js:noInline')
  static SimpleWidgets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SimpleWidgets>(create);
  static SimpleWidgets? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SimpleWidget> get simpleWidget => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get unk2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unk2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnk2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnk2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unk3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unk3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnk3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnk3() => $_clearField(3);
}

class SimpleWidget extends $pb.GeneratedMessage {
  factory SimpleWidget({
    $core.int? unk1,
    $core.bool? enabled,
    $core.int? unk3,
  }) {
    final result = create();
    if (unk1 != null) result.unk1 = unk1;
    if (enabled != null) result.enabled = enabled;
    if (unk3 != null) result.unk3 = unk3;
    return result;
  }

  SimpleWidget._();

  factory SimpleWidget.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory SimpleWidget.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'SimpleWidget',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unk1', fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aI(3, _omitFieldNames ? '' : 'unk3', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleWidget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleWidget copyWith(void Function(SimpleWidget) updates) =>
      super.copyWith((message) => updates(message as SimpleWidget))
          as SimpleWidget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SimpleWidget create() => SimpleWidget._();
  @$core.override
  SimpleWidget createEmptyInstance() => create();
  static $pb.PbList<SimpleWidget> createRepeated() =>
      $pb.PbList<SimpleWidget>();
  @$core.pragma('dart2js:noInline')
  static SimpleWidget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SimpleWidget>(create);
  static SimpleWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unk1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unk1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnk1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnk1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unk3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unk3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnk3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnk3() => $_clearField(3);
}

class DisplayItems extends $pb.GeneratedMessage {
  factory DisplayItems({
    $core.Iterable<DisplayItem>? displayItem,
  }) {
    final result = create();
    if (displayItem != null) result.displayItem.addAll(displayItem);
    return result;
  }

  DisplayItems._();

  factory DisplayItems.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisplayItems.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DisplayItems',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<DisplayItem>(
      1,
      _omitFieldNames ? '' : 'displayItem',
      protoName: 'displayItem',
      subBuilder: DisplayItem.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayItems clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayItems copyWith(void Function(DisplayItems) updates) =>
      super.copyWith((message) => updates(message as DisplayItems))
          as DisplayItems;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisplayItems create() => DisplayItems._();
  @$core.override
  DisplayItems createEmptyInstance() => create();
  static $pb.PbList<DisplayItems> createRepeated() =>
      $pb.PbList<DisplayItems>();
  @$core.pragma('dart2js:noInline')
  static DisplayItems getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisplayItems>(create);
  static DisplayItems? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DisplayItem> get displayItem => $_getList(0);
}

class DisplayItem extends $pb.GeneratedMessage {
  factory DisplayItem({
    $core.String? code,
    $core.String? name,
    $core.bool? disabled,
    $core.int? isSettings,
    $core.int? unknown5,
    $core.bool? inMoreSection,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (disabled != null) result.disabled = disabled;
    if (isSettings != null) result.isSettings = isSettings;
    if (unknown5 != null) result.unknown5 = unknown5;
    if (inMoreSection != null) result.inMoreSection = inMoreSection;
    return result;
  }

  DisplayItem._();

  factory DisplayItem.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisplayItem.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DisplayItem',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'disabled')
    ..aI(
      4,
      _omitFieldNames ? '' : 'isSettings',
      protoName: 'isSettings',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(5, _omitFieldNames ? '' : 'unknown5', fieldType: $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'inMoreSection', protoName: 'inMoreSection')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplayItem copyWith(void Function(DisplayItem) updates) =>
      super.copyWith((message) => updates(message as DisplayItem))
          as DisplayItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisplayItem create() => DisplayItem._();
  @$core.override
  DisplayItem createEmptyInstance() => create();
  static $pb.PbList<DisplayItem> createRepeated() => $pb.PbList<DisplayItem>();
  @$core.pragma('dart2js:noInline')
  static DisplayItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisplayItem>(create);
  static DisplayItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isSettings => $_getIZ(3);
  @$pb.TagNumber(4)
  set isSettings($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsSettings() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsSettings() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unknown5 => $_getIZ(4);
  @$pb.TagNumber(5)
  set unknown5($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnknown5() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnknown5() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get inMoreSection => $_getBF(5);
  @$pb.TagNumber(6)
  set inMoreSection($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInMoreSection() => $_has(5);
  @$pb.TagNumber(6)
  void clearInMoreSection() => $_clearField(6);
}

class Camera extends $pb.GeneratedMessage {
  factory Camera({
    $core.bool? enabled,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  Camera._();

  factory Camera.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Camera.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Camera',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..a<$core.bool>(1, _omitFieldNames ? '' : 'enabled', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Camera clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Camera copyWith(void Function(Camera) updates) =>
      super.copyWith((message) => updates(message as Camera)) as Camera;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Camera create() => Camera._();
  @$core.override
  Camera createEmptyInstance() => create();
  static $pb.PbList<Camera> createRepeated() => $pb.PbList<Camera>();
  @$core.pragma('dart2js:noInline')
  static Camera getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Camera>(create);
  static Camera? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);
}

class Language extends $pb.GeneratedMessage {
  factory Language({
    $core.String? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  Language._();

  factory Language.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Language.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Language',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Language clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Language copyWith(void Function(Language) updates) =>
      super.copyWith((message) => updates(message as Language)) as Language;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Language create() => Language._();
  @$core.override
  Language createEmptyInstance() => create();
  static $pb.PbList<Language> createRepeated() => $pb.PbList<Language>();
  @$core.pragma('dart2js:noInline')
  static Language getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Language>(create);
  static Language? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class WorkoutTypes extends $pb.GeneratedMessage {
  factory WorkoutTypes({
    $core.Iterable<WorkoutType>? workoutType,
    $core.int? unknown2,
  }) {
    final result = create();
    if (workoutType != null) result.workoutType.addAll(workoutType);
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  WorkoutTypes._();

  factory WorkoutTypes.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutTypes.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutTypes',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<WorkoutType>(
      1,
      _omitFieldNames ? '' : 'workoutType',
      protoName: 'workoutType',
      subBuilder: WorkoutType.create,
    )
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutTypes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutTypes copyWith(void Function(WorkoutTypes) updates) =>
      super.copyWith((message) => updates(message as WorkoutTypes))
          as WorkoutTypes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutTypes create() => WorkoutTypes._();
  @$core.override
  WorkoutTypes createEmptyInstance() => create();
  static $pb.PbList<WorkoutTypes> createRepeated() =>
      $pb.PbList<WorkoutTypes>();
  @$core.pragma('dart2js:noInline')
  static WorkoutTypes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutTypes>(create);
  static WorkoutTypes? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkoutType> get workoutType => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class WorkoutType extends $pb.GeneratedMessage {
  factory WorkoutType({
    $core.int? type,
    $core.int? unknown2,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  WorkoutType._();

  factory WorkoutType.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutType.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutType',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutType clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutType copyWith(void Function(WorkoutType) updates) =>
      super.copyWith((message) => updates(message as WorkoutType))
          as WorkoutType;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutType create() => WorkoutType._();
  @$core.override
  WorkoutType createEmptyInstance() => create();
  static $pb.PbList<WorkoutType> createRepeated() => $pb.PbList<WorkoutType>();
  @$core.pragma('dart2js:noInline')
  static WorkoutType getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutType>(create);
  static WorkoutType? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class WidgetScreens extends $pb.GeneratedMessage {
  factory WidgetScreens({
    $core.Iterable<WidgetScreen>? widgetScreen,
    $core.int? isFullList,
    WidgetsCapabilities? widgetsCapabilities,
  }) {
    final result = create();
    if (widgetScreen != null) result.widgetScreen.addAll(widgetScreen);
    if (isFullList != null) result.isFullList = isFullList;
    if (widgetsCapabilities != null)
      result.widgetsCapabilities = widgetsCapabilities;
    return result;
  }

  WidgetScreens._();

  factory WidgetScreens.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WidgetScreens.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WidgetScreens',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<WidgetScreen>(
      1,
      _omitFieldNames ? '' : 'widgetScreen',
      protoName: 'widgetScreen',
      subBuilder: WidgetScreen.create,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'isFullList',
      protoName: 'isFullList',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<WidgetsCapabilities>(
      3,
      _omitFieldNames ? '' : 'widgetsCapabilities',
      protoName: 'widgetsCapabilities',
      subBuilder: WidgetsCapabilities.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetScreens clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetScreens copyWith(void Function(WidgetScreens) updates) =>
      super.copyWith((message) => updates(message as WidgetScreens))
          as WidgetScreens;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WidgetScreens create() => WidgetScreens._();
  @$core.override
  WidgetScreens createEmptyInstance() => create();
  static $pb.PbList<WidgetScreens> createRepeated() =>
      $pb.PbList<WidgetScreens>();
  @$core.pragma('dart2js:noInline')
  static WidgetScreens getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WidgetScreens>(create);
  static WidgetScreens? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WidgetScreen> get widgetScreen => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get isFullList => $_getIZ(1);
  @$pb.TagNumber(2)
  set isFullList($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFullList() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFullList() => $_clearField(2);

  @$pb.TagNumber(3)
  WidgetsCapabilities get widgetsCapabilities => $_getN(2);
  @$pb.TagNumber(3)
  set widgetsCapabilities(WidgetsCapabilities value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWidgetsCapabilities() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidgetsCapabilities() => $_clearField(3);
  @$pb.TagNumber(3)
  WidgetsCapabilities ensureWidgetsCapabilities() => $_ensure(2);
}

class WidgetsCapabilities extends $pb.GeneratedMessage {
  factory WidgetsCapabilities({
    $core.int? minWidgets,
    $core.int? maxWidgets,
    $core.int? supportedLayoutStyles,
  }) {
    final result = create();
    if (minWidgets != null) result.minWidgets = minWidgets;
    if (maxWidgets != null) result.maxWidgets = maxWidgets;
    if (supportedLayoutStyles != null)
      result.supportedLayoutStyles = supportedLayoutStyles;
    return result;
  }

  WidgetsCapabilities._();

  factory WidgetsCapabilities.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WidgetsCapabilities.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WidgetsCapabilities',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'minWidgets',
      protoName: 'minWidgets',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'maxWidgets',
      protoName: 'maxWidgets',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      3,
      _omitFieldNames ? '' : 'supportedLayoutStyles',
      protoName: 'supportedLayoutStyles',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetsCapabilities clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetsCapabilities copyWith(void Function(WidgetsCapabilities) updates) =>
      super.copyWith((message) => updates(message as WidgetsCapabilities))
          as WidgetsCapabilities;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WidgetsCapabilities create() => WidgetsCapabilities._();
  @$core.override
  WidgetsCapabilities createEmptyInstance() => create();
  static $pb.PbList<WidgetsCapabilities> createRepeated() =>
      $pb.PbList<WidgetsCapabilities>();
  @$core.pragma('dart2js:noInline')
  static WidgetsCapabilities getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WidgetsCapabilities>(create);
  static WidgetsCapabilities? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minWidgets => $_getIZ(0);
  @$pb.TagNumber(1)
  set minWidgets($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinWidgets() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinWidgets() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxWidgets => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxWidgets($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxWidgets() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxWidgets() => $_clearField(2);

  /// bitmap:
  /// - 0b0000_0011_0000_0000 (768) on bands
  /// - 0b0000_0000_0000_0111 (7) on some square/round devices (Watch S1 Active)
  /// - 0b0000_0000_1000_0111 (135) on some square/round devices (Redmi Watch 4)
  /// - 0b0111_1100_0000_0000 (31744) on portrait devices (Band 8 Pro)
  @$pb.TagNumber(3)
  $core.int get supportedLayoutStyles => $_getIZ(2);
  @$pb.TagNumber(3)
  set supportedLayoutStyles($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSupportedLayoutStyles() => $_has(2);
  @$pb.TagNumber(3)
  void clearSupportedLayoutStyles() => $_clearField(3);
}

class WidgetScreen extends $pb.GeneratedMessage {
  factory WidgetScreen({
    $core.int? id,
    $core.int? layout,
    $core.Iterable<WidgetPart>? widgetPart,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (layout != null) result.layout = layout;
    if (widgetPart != null) result.widgetPart.addAll(widgetPart);
    return result;
  }

  WidgetScreen._();

  factory WidgetScreen.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WidgetScreen.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WidgetScreen',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'layout', fieldType: $pb.PbFieldType.OU3)
    ..pPM<WidgetPart>(
      3,
      _omitFieldNames ? '' : 'widgetPart',
      protoName: 'widgetPart',
      subBuilder: WidgetPart.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetScreen clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetScreen copyWith(void Function(WidgetScreen) updates) =>
      super.copyWith((message) => updates(message as WidgetScreen))
          as WidgetScreen;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WidgetScreen create() => WidgetScreen._();
  @$core.override
  WidgetScreen createEmptyInstance() => create();
  static $pb.PbList<WidgetScreen> createRepeated() =>
      $pb.PbList<WidgetScreen>();
  @$core.pragma('dart2js:noInline')
  static WidgetScreen getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WidgetScreen>(create);
  static WidgetScreen? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get layout => $_getIZ(1);
  @$pb.TagNumber(2)
  set layout($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLayout() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayout() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<WidgetPart> get widgetPart => $_getList(2);
}

class WidgetParts extends $pb.GeneratedMessage {
  factory WidgetParts({
    $core.Iterable<WidgetPart>? widgetPart,
  }) {
    final result = create();
    if (widgetPart != null) result.widgetPart.addAll(widgetPart);
    return result;
  }

  WidgetParts._();

  factory WidgetParts.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WidgetParts.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WidgetParts',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<WidgetPart>(
      1,
      _omitFieldNames ? '' : 'widgetPart',
      protoName: 'widgetPart',
      subBuilder: WidgetPart.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetParts clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetParts copyWith(void Function(WidgetParts) updates) =>
      super.copyWith((message) => updates(message as WidgetParts))
          as WidgetParts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WidgetParts create() => WidgetParts._();
  @$core.override
  WidgetParts createEmptyInstance() => create();
  static $pb.PbList<WidgetParts> createRepeated() => $pb.PbList<WidgetParts>();
  @$core.pragma('dart2js:noInline')
  static WidgetParts getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WidgetParts>(create);
  static WidgetParts? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WidgetPart> get widgetPart => $_getList(0);
}

class WidgetPart extends $pb.GeneratedMessage {
  factory WidgetPart({
    $core.int? type,
    $core.int? function,
    $core.int? id,
    $core.String? title,
    $core.int? subType,
    $core.String? appId,
    $core.String? unknown7,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (function != null) result.function = function;
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (subType != null) result.subType = subType;
    if (appId != null) result.appId = appId;
    if (unknown7 != null) result.unknown7 = unknown7;
    return result;
  }

  WidgetPart._();

  factory WidgetPart.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WidgetPart.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WidgetPart',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'function', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aI(
      5,
      _omitFieldNames ? '' : 'subType',
      protoName: 'subType',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOS(6, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..aOS(7, _omitFieldNames ? '' : 'unknown7')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WidgetPart copyWith(void Function(WidgetPart) updates) =>
      super.copyWith((message) => updates(message as WidgetPart)) as WidgetPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WidgetPart create() => WidgetPart._();
  @$core.override
  WidgetPart createEmptyInstance() => create();
  static $pb.PbList<WidgetPart> createRepeated() => $pb.PbList<WidgetPart>();
  @$core.pragma('dart2js:noInline')
  static WidgetPart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WidgetPart>(create);
  static WidgetPart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get function => $_getIZ(1);
  @$pb.TagNumber(2)
  set function($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFunction() => $_has(1);
  @$pb.TagNumber(2)
  void clearFunction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get id => $_getIZ(2);
  @$pb.TagNumber(3)
  set id($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get subType => $_getIZ(4);
  @$pb.TagNumber(5)
  set subType($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubType() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appId => $_getSZ(5);
  @$pb.TagNumber(6)
  set appId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get unknown7 => $_getSZ(6);
  @$pb.TagNumber(7)
  set unknown7($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnknown7() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnknown7() => $_clearField(7);
}

class DoNotDisturb extends $pb.GeneratedMessage {
  factory DoNotDisturb({
    $core.int? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  DoNotDisturb._();

  factory DoNotDisturb.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoNotDisturb.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DoNotDisturb',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoNotDisturb clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoNotDisturb copyWith(void Function(DoNotDisturb) updates) =>
      super.copyWith((message) => updates(message as DoNotDisturb))
          as DoNotDisturb;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoNotDisturb create() => DoNotDisturb._();
  @$core.override
  DoNotDisturb createEmptyInstance() => create();
  static $pb.PbList<DoNotDisturb> createRepeated() =>
      $pb.PbList<DoNotDisturb>();
  @$core.pragma('dart2js:noInline')
  static DoNotDisturb getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoNotDisturb>(create);
  static DoNotDisturb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class MiscSettingGet extends $pb.GeneratedMessage {
  factory MiscSettingGet({
    $core.int? setting,
  }) {
    final result = create();
    if (setting != null) result.setting = setting;
    return result;
  }

  MiscSettingGet._();

  factory MiscSettingGet.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory MiscSettingGet.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'MiscSettingGet',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'setting', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscSettingGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscSettingGet copyWith(void Function(MiscSettingGet) updates) =>
      super.copyWith((message) => updates(message as MiscSettingGet))
          as MiscSettingGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MiscSettingGet create() => MiscSettingGet._();
  @$core.override
  MiscSettingGet createEmptyInstance() => create();
  static $pb.PbList<MiscSettingGet> createRepeated() =>
      $pb.PbList<MiscSettingGet>();
  @$core.pragma('dart2js:noInline')
  static MiscSettingGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MiscSettingGet>(create);
  static MiscSettingGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get setting => $_getIZ(0);
  @$pb.TagNumber(1)
  set setting($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetting() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetting() => $_clearField(1);
}

class MiscSettingSet extends $pb.GeneratedMessage {
  factory MiscSettingSet({
    MiscNotificationSettings? miscNotificationSettings,
    DndSync? dndSync,
    WearingMode? wearingMode,
  }) {
    final result = create();
    if (miscNotificationSettings != null)
      result.miscNotificationSettings = miscNotificationSettings;
    if (dndSync != null) result.dndSync = dndSync;
    if (wearingMode != null) result.wearingMode = wearingMode;
    return result;
  }

  MiscSettingSet._();

  factory MiscSettingSet.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory MiscSettingSet.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'MiscSettingSet',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<MiscNotificationSettings>(
      1,
      _omitFieldNames ? '' : 'miscNotificationSettings',
      protoName: 'miscNotificationSettings',
      subBuilder: MiscNotificationSettings.create,
    )
    ..aOM<DndSync>(
      2,
      _omitFieldNames ? '' : 'dndSync',
      protoName: 'dndSync',
      subBuilder: DndSync.create,
    )
    ..aOM<WearingMode>(
      3,
      _omitFieldNames ? '' : 'wearingMode',
      protoName: 'wearingMode',
      subBuilder: WearingMode.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscSettingSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscSettingSet copyWith(void Function(MiscSettingSet) updates) =>
      super.copyWith((message) => updates(message as MiscSettingSet))
          as MiscSettingSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MiscSettingSet create() => MiscSettingSet._();
  @$core.override
  MiscSettingSet createEmptyInstance() => create();
  static $pb.PbList<MiscSettingSet> createRepeated() =>
      $pb.PbList<MiscSettingSet>();
  @$core.pragma('dart2js:noInline')
  static MiscSettingSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MiscSettingSet>(create);
  static MiscSettingSet? _defaultInstance;

  @$pb.TagNumber(1)
  MiscNotificationSettings get miscNotificationSettings => $_getN(0);
  @$pb.TagNumber(1)
  set miscNotificationSettings(MiscNotificationSettings value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMiscNotificationSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearMiscNotificationSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  MiscNotificationSettings ensureMiscNotificationSettings() => $_ensure(0);

  @$pb.TagNumber(2)
  DndSync get dndSync => $_getN(1);
  @$pb.TagNumber(2)
  set dndSync(DndSync value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDndSync() => $_has(1);
  @$pb.TagNumber(2)
  void clearDndSync() => $_clearField(2);
  @$pb.TagNumber(2)
  DndSync ensureDndSync() => $_ensure(1);

  @$pb.TagNumber(3)
  WearingMode get wearingMode => $_getN(2);
  @$pb.TagNumber(3)
  set wearingMode(WearingMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWearingMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearWearingMode() => $_clearField(3);
  @$pb.TagNumber(3)
  WearingMode ensureWearingMode() => $_ensure(2);
}

class MiscNotificationSettings extends $pb.GeneratedMessage {
  factory MiscNotificationSettings({
    $core.int? wakeScreen,
    $core.int? onlyWhenPhoneLocked,
    $core.int? onlyWhenWorn,
  }) {
    final result = create();
    if (wakeScreen != null) result.wakeScreen = wakeScreen;
    if (onlyWhenPhoneLocked != null)
      result.onlyWhenPhoneLocked = onlyWhenPhoneLocked;
    if (onlyWhenWorn != null) result.onlyWhenWorn = onlyWhenWorn;
    return result;
  }

  MiscNotificationSettings._();

  factory MiscNotificationSettings.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory MiscNotificationSettings.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'MiscNotificationSettings',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'wakeScreen',
      protoName: 'wakeScreen',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'onlyWhenPhoneLocked',
      protoName: 'onlyWhenPhoneLocked',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      3,
      _omitFieldNames ? '' : 'onlyWhenWorn',
      protoName: 'onlyWhenWorn',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscNotificationSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiscNotificationSettings copyWith(
    void Function(MiscNotificationSettings) updates,
  ) =>
      super.copyWith((message) => updates(message as MiscNotificationSettings))
          as MiscNotificationSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MiscNotificationSettings create() => MiscNotificationSettings._();
  @$core.override
  MiscNotificationSettings createEmptyInstance() => create();
  static $pb.PbList<MiscNotificationSettings> createRepeated() =>
      $pb.PbList<MiscNotificationSettings>();
  @$core.pragma('dart2js:noInline')
  static MiscNotificationSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MiscNotificationSettings>(create);
  static MiscNotificationSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get wakeScreen => $_getIZ(0);
  @$pb.TagNumber(1)
  set wakeScreen($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWakeScreen() => $_has(0);
  @$pb.TagNumber(1)
  void clearWakeScreen() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get onlyWhenPhoneLocked => $_getIZ(1);
  @$pb.TagNumber(2)
  set onlyWhenPhoneLocked($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnlyWhenPhoneLocked() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnlyWhenPhoneLocked() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get onlyWhenWorn => $_getIZ(2);
  @$pb.TagNumber(3)
  set onlyWhenWorn($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOnlyWhenWorn() => $_has(2);
  @$pb.TagNumber(3)
  void clearOnlyWhenWorn() => $_clearField(3);
}

class DndSync extends $pb.GeneratedMessage {
  factory DndSync({
    $core.int? enabled,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  DndSync._();

  factory DndSync.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DndSync.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DndSync',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'enabled', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DndSync clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DndSync copyWith(void Function(DndSync) updates) =>
      super.copyWith((message) => updates(message as DndSync)) as DndSync;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DndSync create() => DndSync._();
  @$core.override
  DndSync createEmptyInstance() => create();
  static $pb.PbList<DndSync> createRepeated() => $pb.PbList<DndSync>();
  @$core.pragma('dart2js:noInline')
  static DndSync getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DndSync>(create);
  static DndSync? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get enabled => $_getIZ(0);
  @$pb.TagNumber(1)
  set enabled($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);
}

class WearingMode extends $pb.GeneratedMessage {
  factory WearingMode({
    $core.int? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  WearingMode._();

  factory WearingMode.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WearingMode.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WearingMode',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WearingMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WearingMode copyWith(void Function(WearingMode) updates) =>
      super.copyWith((message) => updates(message as WearingMode))
          as WearingMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WearingMode create() => WearingMode._();
  @$core.override
  WearingMode createEmptyInstance() => create();
  static $pb.PbList<WearingMode> createRepeated() => $pb.PbList<WearingMode>();
  @$core.pragma('dart2js:noInline')
  static WearingMode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WearingMode>(create);
  static WearingMode? _defaultInstance;

  /// 0 Band Mode (wristband)
  /// 1 Pebble Mode (show buckle)
  /// 2 Necklace mode (neck strap)
  @$pb.TagNumber(1)
  $core.int get mode => $_getIZ(0);
  @$pb.TagNumber(1)
  set mode($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

class FirmwareInstallRequest extends $pb.GeneratedMessage {
  factory FirmwareInstallRequest({
    $core.int? unknown1,
    $core.int? unknown2,
    $core.String? version,
    $core.String? md5,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (unknown2 != null) result.unknown2 = unknown2;
    if (version != null) result.version = version;
    if (md5 != null) result.md5 = md5;
    return result;
  }

  FirmwareInstallRequest._();

  factory FirmwareInstallRequest.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory FirmwareInstallRequest.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'FirmwareInstallRequest',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aOS(4, _omitFieldNames ? '' : 'md5')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirmwareInstallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirmwareInstallRequest copyWith(
    void Function(FirmwareInstallRequest) updates,
  ) =>
      super.copyWith((message) => updates(message as FirmwareInstallRequest))
          as FirmwareInstallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FirmwareInstallRequest create() => FirmwareInstallRequest._();
  @$core.override
  FirmwareInstallRequest createEmptyInstance() => create();
  static $pb.PbList<FirmwareInstallRequest> createRepeated() =>
      $pb.PbList<FirmwareInstallRequest>();
  @$core.pragma('dart2js:noInline')
  static FirmwareInstallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FirmwareInstallRequest>(create);
  static FirmwareInstallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get md5 => $_getSZ(3);
  @$pb.TagNumber(4)
  set md5($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMd5() => $_has(3);
  @$pb.TagNumber(4)
  void clearMd5() => $_clearField(4);
}

class FirmwareInstallResponse extends $pb.GeneratedMessage {
  factory FirmwareInstallResponse({
    $core.int? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  FirmwareInstallResponse._();

  factory FirmwareInstallResponse.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory FirmwareInstallResponse.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'FirmwareInstallResponse',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirmwareInstallResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirmwareInstallResponse copyWith(
    void Function(FirmwareInstallResponse) updates,
  ) =>
      super.copyWith((message) => updates(message as FirmwareInstallResponse))
          as FirmwareInstallResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FirmwareInstallResponse create() => FirmwareInstallResponse._();
  @$core.override
  FirmwareInstallResponse createEmptyInstance() => create();
  static $pb.PbList<FirmwareInstallResponse> createRepeated() =>
      $pb.PbList<FirmwareInstallResponse>();
  @$core.pragma('dart2js:noInline')
  static FirmwareInstallResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FirmwareInstallResponse>(create);
  static FirmwareInstallResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class Password extends $pb.GeneratedMessage {
  factory Password({
    $core.int? state,
    $core.String? password,
    $core.int? unknown3,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (password != null) result.password = password;
    if (unknown3 != null) result.unknown3 = unknown3;
    return result;
  }

  Password._();

  factory Password.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Password.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Password',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'state', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Password clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Password copyWith(void Function(Password) updates) =>
      super.copyWith((message) => updates(message as Password)) as Password;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Password create() => Password._();
  @$core.override
  Password createEmptyInstance() => create();
  static $pb.PbList<Password> createRepeated() => $pb.PbList<Password>();
  @$core.pragma('dart2js:noInline')
  static Password getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Password>(create);
  static Password? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get state => $_getIZ(0);
  @$pb.TagNumber(1)
  set state($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);
}

class PhoneSilentModeGet extends $pb.GeneratedMessage {
  factory PhoneSilentModeGet({
    $core.int? unknown1,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    return result;
  }

  PhoneSilentModeGet._();

  factory PhoneSilentModeGet.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneSilentModeGet.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'PhoneSilentModeGet',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentModeGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentModeGet copyWith(void Function(PhoneSilentModeGet) updates) =>
      super.copyWith((message) => updates(message as PhoneSilentModeGet))
          as PhoneSilentModeGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneSilentModeGet create() => PhoneSilentModeGet._();
  @$core.override
  PhoneSilentModeGet createEmptyInstance() => create();
  static $pb.PbList<PhoneSilentModeGet> createRepeated() =>
      $pb.PbList<PhoneSilentModeGet>();
  @$core.pragma('dart2js:noInline')
  static PhoneSilentModeGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneSilentModeGet>(create);
  static PhoneSilentModeGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);
}

class PhoneSilentModeSet extends $pb.GeneratedMessage {
  factory PhoneSilentModeSet({
    PhoneSilentMode? phoneSilentMode,
  }) {
    final result = create();
    if (phoneSilentMode != null) result.phoneSilentMode = phoneSilentMode;
    return result;
  }

  PhoneSilentModeSet._();

  factory PhoneSilentModeSet.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneSilentModeSet.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'PhoneSilentModeSet',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<PhoneSilentMode>(
      1,
      _omitFieldNames ? '' : 'phoneSilentMode',
      protoName: 'phoneSilentMode',
      subBuilder: PhoneSilentMode.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentModeSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentModeSet copyWith(void Function(PhoneSilentModeSet) updates) =>
      super.copyWith((message) => updates(message as PhoneSilentModeSet))
          as PhoneSilentModeSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneSilentModeSet create() => PhoneSilentModeSet._();
  @$core.override
  PhoneSilentModeSet createEmptyInstance() => create();
  static $pb.PbList<PhoneSilentModeSet> createRepeated() =>
      $pb.PbList<PhoneSilentModeSet>();
  @$core.pragma('dart2js:noInline')
  static PhoneSilentModeSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneSilentModeSet>(create);
  static PhoneSilentModeSet? _defaultInstance;

  @$pb.TagNumber(1)
  PhoneSilentMode get phoneSilentMode => $_getN(0);
  @$pb.TagNumber(1)
  set phoneSilentMode(PhoneSilentMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneSilentMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneSilentMode() => $_clearField(1);
  @$pb.TagNumber(1)
  PhoneSilentMode ensurePhoneSilentMode() => $_ensure(0);
}

class PhoneSilentMode extends $pb.GeneratedMessage {
  factory PhoneSilentMode({
    $core.bool? silent,
  }) {
    final result = create();
    if (silent != null) result.silent = silent;
    return result;
  }

  PhoneSilentMode._();

  factory PhoneSilentMode.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneSilentMode.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'PhoneSilentMode',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'silent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneSilentMode copyWith(void Function(PhoneSilentMode) updates) =>
      super.copyWith((message) => updates(message as PhoneSilentMode))
          as PhoneSilentMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneSilentMode create() => PhoneSilentMode._();
  @$core.override
  PhoneSilentMode createEmptyInstance() => create();
  static $pb.PbList<PhoneSilentMode> createRepeated() =>
      $pb.PbList<PhoneSilentMode>();
  @$core.pragma('dart2js:noInline')
  static PhoneSilentMode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneSilentMode>(create);
  static PhoneSilentMode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get silent => $_getBF(0);
  @$pb.TagNumber(1)
  set silent($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSilent() => $_has(0);
  @$pb.TagNumber(1)
  void clearSilent() => $_clearField(1);
}

class VibrationPatterns extends $pb.GeneratedMessage {
  factory VibrationPatterns({
    $core.Iterable<VibrationNotificationType>? notificationType,
    $core.int? unknown2,
    $core.Iterable<CustomVibrationPattern>? customVibrationPattern,
  }) {
    final result = create();
    if (notificationType != null)
      result.notificationType.addAll(notificationType);
    if (unknown2 != null) result.unknown2 = unknown2;
    if (customVibrationPattern != null)
      result.customVibrationPattern.addAll(customVibrationPattern);
    return result;
  }

  VibrationPatterns._();

  factory VibrationPatterns.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory VibrationPatterns.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'VibrationPatterns',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<VibrationNotificationType>(
      1,
      _omitFieldNames ? '' : 'notificationType',
      protoName: 'notificationType',
      subBuilder: VibrationNotificationType.create,
    )
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..pPM<CustomVibrationPattern>(
      3,
      _omitFieldNames ? '' : 'customVibrationPattern',
      protoName: 'customVibrationPattern',
      subBuilder: CustomVibrationPattern.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationPatterns clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationPatterns copyWith(void Function(VibrationPatterns) updates) =>
      super.copyWith((message) => updates(message as VibrationPatterns))
          as VibrationPatterns;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VibrationPatterns create() => VibrationPatterns._();
  @$core.override
  VibrationPatterns createEmptyInstance() => create();
  static $pb.PbList<VibrationPatterns> createRepeated() =>
      $pb.PbList<VibrationPatterns>();
  @$core.pragma('dart2js:noInline')
  static VibrationPatterns getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VibrationPatterns>(create);
  static VibrationPatterns? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VibrationNotificationType> get notificationType => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CustomVibrationPattern> get customVibrationPattern => $_getList(2);
}

class CustomVibrationPattern extends $pb.GeneratedMessage {
  factory CustomVibrationPattern({
    $core.int? id,
    $core.String? name,
    $core.Iterable<Vibration>? vibration,
    $core.int? unknown4,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (vibration != null) result.vibration.addAll(vibration);
    if (unknown4 != null) result.unknown4 = unknown4;
    return result;
  }

  CustomVibrationPattern._();

  factory CustomVibrationPattern.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory CustomVibrationPattern.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'CustomVibrationPattern',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPM<Vibration>(
      3,
      _omitFieldNames ? '' : 'vibration',
      subBuilder: Vibration.create,
    )
    ..aI(4, _omitFieldNames ? '' : 'unknown4', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomVibrationPattern clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomVibrationPattern copyWith(
    void Function(CustomVibrationPattern) updates,
  ) =>
      super.copyWith((message) => updates(message as CustomVibrationPattern))
          as CustomVibrationPattern;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CustomVibrationPattern create() => CustomVibrationPattern._();
  @$core.override
  CustomVibrationPattern createEmptyInstance() => create();
  static $pb.PbList<CustomVibrationPattern> createRepeated() =>
      $pb.PbList<CustomVibrationPattern>();
  @$core.pragma('dart2js:noInline')
  static CustomVibrationPattern getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CustomVibrationPattern>(create);
  static CustomVibrationPattern? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Vibration> get vibration => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get unknown4 => $_getIZ(3);
  @$pb.TagNumber(4)
  set unknown4($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown4() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown4() => $_clearField(4);
}

class VibrationNotificationType extends $pb.GeneratedMessage {
  factory VibrationNotificationType({
    $core.int? notificationType,
    $core.int? preset,
  }) {
    final result = create();
    if (notificationType != null) result.notificationType = notificationType;
    if (preset != null) result.preset = preset;
    return result;
  }

  VibrationNotificationType._();

  factory VibrationNotificationType.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory VibrationNotificationType.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'VibrationNotificationType',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'notificationType',
      protoName: 'notificationType',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(2, _omitFieldNames ? '' : 'preset', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationNotificationType clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationNotificationType copyWith(
    void Function(VibrationNotificationType) updates,
  ) =>
      super.copyWith((message) => updates(message as VibrationNotificationType))
          as VibrationNotificationType;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VibrationNotificationType create() => VibrationNotificationType._();
  @$core.override
  VibrationNotificationType createEmptyInstance() => create();
  static $pb.PbList<VibrationNotificationType> createRepeated() =>
      $pb.PbList<VibrationNotificationType>();
  @$core.pragma('dart2js:noInline')
  static VibrationNotificationType getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VibrationNotificationType>(create);
  static VibrationNotificationType? _defaultInstance;

  /// 1 incoming calls
  /// 2 events // TODO confirm which one is events, which one is schedule
  /// 3 alarms
  /// 4 notifications
  /// 5 standing reminder
  /// 6 sms
  /// 7 goal
  /// 8 events // TODO confirm which one is events, which one is schedule
  @$pb.TagNumber(1)
  $core.int get notificationType => $_getIZ(0);
  @$pb.TagNumber(1)
  set notificationType($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationType() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get preset => $_getIZ(1);
  @$pb.TagNumber(2)
  set preset($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreset() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreset() => $_clearField(2);
}

class VibrationTest extends $pb.GeneratedMessage {
  factory VibrationTest({
    $core.Iterable<Vibration>? vibration,
  }) {
    final result = create();
    if (vibration != null) result.vibration.addAll(vibration);
    return result;
  }

  VibrationTest._();

  factory VibrationTest.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory VibrationTest.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'VibrationTest',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<Vibration>(
      1,
      _omitFieldNames ? '' : 'vibration',
      subBuilder: Vibration.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationTest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationTest copyWith(void Function(VibrationTest) updates) =>
      super.copyWith((message) => updates(message as VibrationTest))
          as VibrationTest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VibrationTest create() => VibrationTest._();
  @$core.override
  VibrationTest createEmptyInstance() => create();
  static $pb.PbList<VibrationTest> createRepeated() =>
      $pb.PbList<VibrationTest>();
  @$core.pragma('dart2js:noInline')
  static VibrationTest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VibrationTest>(create);
  static VibrationTest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Vibration> get vibration => $_getList(0);
}

class VibrationPatternAck extends $pb.GeneratedMessage {
  factory VibrationPatternAck({
    $core.int? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  VibrationPatternAck._();

  factory VibrationPatternAck.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory VibrationPatternAck.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'VibrationPatternAck',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationPatternAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VibrationPatternAck copyWith(void Function(VibrationPatternAck) updates) =>
      super.copyWith((message) => updates(message as VibrationPatternAck))
          as VibrationPatternAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VibrationPatternAck create() => VibrationPatternAck._();
  @$core.override
  VibrationPatternAck createEmptyInstance() => create();
  static $pb.PbList<VibrationPatternAck> createRepeated() =>
      $pb.PbList<VibrationPatternAck>();
  @$core.pragma('dart2js:noInline')
  static VibrationPatternAck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VibrationPatternAck>(create);
  static VibrationPatternAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class Vibration extends $pb.GeneratedMessage {
  factory Vibration({
    $core.int? vibrate,
    $core.int? ms,
  }) {
    final result = create();
    if (vibrate != null) result.vibrate = vibrate;
    if (ms != null) result.ms = ms;
    return result;
  }

  Vibration._();

  factory Vibration.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vibration.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Vibration',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'vibrate', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'ms', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vibration clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vibration copyWith(void Function(Vibration) updates) =>
      super.copyWith((message) => updates(message as Vibration)) as Vibration;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vibration create() => Vibration._();
  @$core.override
  Vibration createEmptyInstance() => create();
  static $pb.PbList<Vibration> createRepeated() => $pb.PbList<Vibration>();
  @$core.pragma('dart2js:noInline')
  static Vibration getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vibration>(create);
  static Vibration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get vibrate => $_getIZ(0);
  @$pb.TagNumber(1)
  set vibrate($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVibrate() => $_has(0);
  @$pb.TagNumber(1)
  void clearVibrate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get ms => $_getIZ(1);
  @$pb.TagNumber(2)
  set ms($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearMs() => $_clearField(2);
}

class DeviceActivityState extends $pb.GeneratedMessage {
  factory DeviceActivityState({
    $core.int? activityType,
    $core.int? currentActivityState,
  }) {
    final result = create();
    if (activityType != null) result.activityType = activityType;
    if (currentActivityState != null)
      result.currentActivityState = currentActivityState;
    return result;
  }

  DeviceActivityState._();

  factory DeviceActivityState.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceActivityState.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DeviceActivityState',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'activityType',
      protoName: 'activityType',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'currentActivityState',
      protoName: 'currentActivityState',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceActivityState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceActivityState copyWith(void Function(DeviceActivityState) updates) =>
      super.copyWith((message) => updates(message as DeviceActivityState))
          as DeviceActivityState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceActivityState create() => DeviceActivityState._();
  @$core.override
  DeviceActivityState createEmptyInstance() => create();
  static $pb.PbList<DeviceActivityState> createRepeated() =>
      $pb.PbList<DeviceActivityState>();
  @$core.pragma('dart2js:noInline')
  static DeviceActivityState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceActivityState>(create);
  static DeviceActivityState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get activityType => $_getIZ(0);
  @$pb.TagNumber(1)
  set activityType($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActivityType() => $_has(0);
  @$pb.TagNumber(1)
  void clearActivityType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get currentActivityState => $_getIZ(1);
  @$pb.TagNumber(2)
  set currentActivityState($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentActivityState() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentActivityState() => $_clearField(2);
}

class BasicDeviceState extends $pb.GeneratedMessage {
  factory BasicDeviceState({
    $core.bool? isCharging,
    $core.int? batteryLevel,
    $core.bool? isWorn,
    $core.bool? isUserAsleep,
    DeviceActivityState? activityState,
  }) {
    final result = create();
    if (isCharging != null) result.isCharging = isCharging;
    if (batteryLevel != null) result.batteryLevel = batteryLevel;
    if (isWorn != null) result.isWorn = isWorn;
    if (isUserAsleep != null) result.isUserAsleep = isUserAsleep;
    if (activityState != null) result.activityState = activityState;
    return result;
  }

  BasicDeviceState._();

  factory BasicDeviceState.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory BasicDeviceState.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'BasicDeviceState',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..a<$core.bool>(
      1,
      _omitFieldNames ? '' : 'isCharging',
      $pb.PbFieldType.QB,
      protoName: 'isCharging',
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'batteryLevel',
      protoName: 'batteryLevel',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..a<$core.bool>(
      3,
      _omitFieldNames ? '' : 'isWorn',
      $pb.PbFieldType.QB,
      protoName: 'isWorn',
    )
    ..a<$core.bool>(
      4,
      _omitFieldNames ? '' : 'isUserAsleep',
      $pb.PbFieldType.QB,
      protoName: 'isUserAsleep',
    )
    ..aOM<DeviceActivityState>(
      5,
      _omitFieldNames ? '' : 'activityState',
      protoName: 'activityState',
      subBuilder: DeviceActivityState.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicDeviceState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicDeviceState copyWith(void Function(BasicDeviceState) updates) =>
      super.copyWith((message) => updates(message as BasicDeviceState))
          as BasicDeviceState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BasicDeviceState create() => BasicDeviceState._();
  @$core.override
  BasicDeviceState createEmptyInstance() => create();
  static $pb.PbList<BasicDeviceState> createRepeated() =>
      $pb.PbList<BasicDeviceState>();
  @$core.pragma('dart2js:noInline')
  static BasicDeviceState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BasicDeviceState>(create);
  static BasicDeviceState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isCharging => $_getBF(0);
  @$pb.TagNumber(1)
  set isCharging($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsCharging() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsCharging() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get batteryLevel => $_getIZ(1);
  @$pb.TagNumber(2)
  set batteryLevel($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBatteryLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatteryLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isWorn => $_getBF(2);
  @$pb.TagNumber(3)
  set isWorn($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsWorn() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsWorn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isUserAsleep => $_getBF(3);
  @$pb.TagNumber(4)
  set isUserAsleep($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsUserAsleep() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsUserAsleep() => $_clearField(4);

  @$pb.TagNumber(5)
  DeviceActivityState get activityState => $_getN(4);
  @$pb.TagNumber(5)
  set activityState(DeviceActivityState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasActivityState() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivityState() => $_clearField(5);
  @$pb.TagNumber(5)
  DeviceActivityState ensureActivityState() => $_ensure(4);
}

class DeviceState extends $pb.GeneratedMessage {
  factory DeviceState({
    $core.int? chargingState,
    $core.int? wearingState,
    $core.int? sleepState,
    $core.int? warningState,
    DeviceActivityState? activityState,
  }) {
    final result = create();
    if (chargingState != null) result.chargingState = chargingState;
    if (wearingState != null) result.wearingState = wearingState;
    if (sleepState != null) result.sleepState = sleepState;
    if (warningState != null) result.warningState = warningState;
    if (activityState != null) result.activityState = activityState;
    return result;
  }

  DeviceState._();

  factory DeviceState.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceState.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DeviceState',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'chargingState',
      protoName: 'chargingState',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'wearingState',
      protoName: 'wearingState',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      3,
      _omitFieldNames ? '' : 'sleepState',
      protoName: 'sleepState',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      4,
      _omitFieldNames ? '' : 'warningState',
      protoName: 'warningState',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<DeviceActivityState>(
      5,
      _omitFieldNames ? '' : 'activityState',
      protoName: 'activityState',
      subBuilder: DeviceActivityState.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceState copyWith(void Function(DeviceState) updates) =>
      super.copyWith((message) => updates(message as DeviceState))
          as DeviceState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceState create() => DeviceState._();
  @$core.override
  DeviceState createEmptyInstance() => create();
  static $pb.PbList<DeviceState> createRepeated() => $pb.PbList<DeviceState>();
  @$core.pragma('dart2js:noInline')
  static DeviceState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceState>(create);
  static DeviceState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get chargingState => $_getIZ(0);
  @$pb.TagNumber(1)
  set chargingState($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChargingState() => $_has(0);
  @$pb.TagNumber(1)
  void clearChargingState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get wearingState => $_getIZ(1);
  @$pb.TagNumber(2)
  set wearingState($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWearingState() => $_has(1);
  @$pb.TagNumber(2)
  void clearWearingState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sleepState => $_getIZ(2);
  @$pb.TagNumber(3)
  set sleepState($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSleepState() => $_has(2);
  @$pb.TagNumber(3)
  void clearSleepState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get warningState => $_getIZ(3);
  @$pb.TagNumber(4)
  set warningState($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWarningState() => $_has(3);
  @$pb.TagNumber(4)
  void clearWarningState() => $_clearField(4);

  @$pb.TagNumber(5)
  DeviceActivityState get activityState => $_getN(4);
  @$pb.TagNumber(5)
  set activityState(DeviceActivityState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasActivityState() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivityState() => $_clearField(5);
  @$pb.TagNumber(5)
  DeviceActivityState ensureActivityState() => $_ensure(4);
}

class Watchface extends $pb.GeneratedMessage {
  factory Watchface({
    WatchfaceList? watchfaceList,
    $core.String? watchfaceId,
    $core.int? ack,
    $core.int? installStatus,
    WatchfaceInstallStart? watchfaceInstallStart,
    WatchfaceInstallFinish? watchfaceInstallFinish,
  }) {
    final result = create();
    if (watchfaceList != null) result.watchfaceList = watchfaceList;
    if (watchfaceId != null) result.watchfaceId = watchfaceId;
    if (ack != null) result.ack = ack;
    if (installStatus != null) result.installStatus = installStatus;
    if (watchfaceInstallStart != null)
      result.watchfaceInstallStart = watchfaceInstallStart;
    if (watchfaceInstallFinish != null)
      result.watchfaceInstallFinish = watchfaceInstallFinish;
    return result;
  }

  Watchface._();

  factory Watchface.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Watchface.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Watchface',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<WatchfaceList>(
      1,
      _omitFieldNames ? '' : 'watchfaceList',
      protoName: 'watchfaceList',
      subBuilder: WatchfaceList.create,
    )
    ..aOS(2, _omitFieldNames ? '' : 'watchfaceId', protoName: 'watchfaceId')
    ..aI(4, _omitFieldNames ? '' : 'ack', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      5,
      _omitFieldNames ? '' : 'installStatus',
      protoName: 'installStatus',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<WatchfaceInstallStart>(
      6,
      _omitFieldNames ? '' : 'watchfaceInstallStart',
      protoName: 'watchfaceInstallStart',
      subBuilder: WatchfaceInstallStart.create,
    )
    ..aOM<WatchfaceInstallFinish>(
      7,
      _omitFieldNames ? '' : 'watchfaceInstallFinish',
      protoName: 'watchfaceInstallFinish',
      subBuilder: WatchfaceInstallFinish.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Watchface clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Watchface copyWith(void Function(Watchface) updates) =>
      super.copyWith((message) => updates(message as Watchface)) as Watchface;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Watchface create() => Watchface._();
  @$core.override
  Watchface createEmptyInstance() => create();
  static $pb.PbList<Watchface> createRepeated() => $pb.PbList<Watchface>();
  @$core.pragma('dart2js:noInline')
  static Watchface getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Watchface>(create);
  static Watchface? _defaultInstance;

  @$pb.TagNumber(1)
  WatchfaceList get watchfaceList => $_getN(0);
  @$pb.TagNumber(1)
  set watchfaceList(WatchfaceList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWatchfaceList() => $_has(0);
  @$pb.TagNumber(1)
  void clearWatchfaceList() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchfaceList ensureWatchfaceList() => $_ensure(0);

  /// 4, 2 delete | 4, 1 set
  @$pb.TagNumber(2)
  $core.String get watchfaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set watchfaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWatchfaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWatchfaceId() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.int get ack => $_getIZ(2);
  @$pb.TagNumber(4)
  set ack($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(4)
  $core.bool hasAck() => $_has(2);
  @$pb.TagNumber(4)
  void clearAck() => $_clearField(4);

  /// 4, 4
  @$pb.TagNumber(5)
  $core.int get installStatus => $_getIZ(3);
  @$pb.TagNumber(5)
  set installStatus($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasInstallStatus() => $_has(3);
  @$pb.TagNumber(5)
  void clearInstallStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  WatchfaceInstallStart get watchfaceInstallStart => $_getN(4);
  @$pb.TagNumber(6)
  set watchfaceInstallStart(WatchfaceInstallStart value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWatchfaceInstallStart() => $_has(4);
  @$pb.TagNumber(6)
  void clearWatchfaceInstallStart() => $_clearField(6);
  @$pb.TagNumber(6)
  WatchfaceInstallStart ensureWatchfaceInstallStart() => $_ensure(4);

  @$pb.TagNumber(7)
  WatchfaceInstallFinish get watchfaceInstallFinish => $_getN(5);
  @$pb.TagNumber(7)
  set watchfaceInstallFinish(WatchfaceInstallFinish value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWatchfaceInstallFinish() => $_has(5);
  @$pb.TagNumber(7)
  void clearWatchfaceInstallFinish() => $_clearField(7);
  @$pb.TagNumber(7)
  WatchfaceInstallFinish ensureWatchfaceInstallFinish() => $_ensure(5);
}

class WatchfaceList extends $pb.GeneratedMessage {
  factory WatchfaceList({
    $core.Iterable<WatchfaceInfo>? watchface,
  }) {
    final result = create();
    if (watchface != null) result.watchface.addAll(watchface);
    return result;
  }

  WatchfaceList._();

  factory WatchfaceList.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchfaceList.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WatchfaceList',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<WatchfaceInfo>(
      1,
      _omitFieldNames ? '' : 'watchface',
      subBuilder: WatchfaceInfo.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceList copyWith(void Function(WatchfaceList) updates) =>
      super.copyWith((message) => updates(message as WatchfaceList))
          as WatchfaceList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchfaceList create() => WatchfaceList._();
  @$core.override
  WatchfaceList createEmptyInstance() => create();
  static $pb.PbList<WatchfaceList> createRepeated() =>
      $pb.PbList<WatchfaceList>();
  @$core.pragma('dart2js:noInline')
  static WatchfaceList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchfaceList>(create);
  static WatchfaceList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WatchfaceInfo> get watchface => $_getList(0);
}

class WatchfaceInfo extends $pb.GeneratedMessage {
  factory WatchfaceInfo({
    $core.String? id,
    $core.String? name,
    $core.bool? active,
    $core.bool? canDelete,
    $core.int? unknown5,
    $core.int? unknown6,
    $core.int? unknown11,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (active != null) result.active = active;
    if (canDelete != null) result.canDelete = canDelete;
    if (unknown5 != null) result.unknown5 = unknown5;
    if (unknown6 != null) result.unknown6 = unknown6;
    if (unknown11 != null) result.unknown11 = unknown11;
    return result;
  }

  WatchfaceInfo._();

  factory WatchfaceInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchfaceInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WatchfaceInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'active')
    ..aOB(4, _omitFieldNames ? '' : 'canDelete', protoName: 'canDelete')
    ..aI(5, _omitFieldNames ? '' : 'unknown5', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'unknown6', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'unknown11', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInfo copyWith(void Function(WatchfaceInfo) updates) =>
      super.copyWith((message) => updates(message as WatchfaceInfo))
          as WatchfaceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchfaceInfo create() => WatchfaceInfo._();
  @$core.override
  WatchfaceInfo createEmptyInstance() => create();
  static $pb.PbList<WatchfaceInfo> createRepeated() =>
      $pb.PbList<WatchfaceInfo>();
  @$core.pragma('dart2js:noInline')
  static WatchfaceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchfaceInfo>(create);
  static WatchfaceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get active => $_getBF(2);
  @$pb.TagNumber(3)
  set active($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearActive() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get canDelete => $_getBF(3);
  @$pb.TagNumber(4)
  set canDelete($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanDelete() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unknown5 => $_getIZ(4);
  @$pb.TagNumber(5)
  set unknown5($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnknown5() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnknown5() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get unknown6 => $_getIZ(5);
  @$pb.TagNumber(6)
  set unknown6($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnknown6() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnknown6() => $_clearField(6);

  @$pb.TagNumber(11)
  $core.int get unknown11 => $_getIZ(6);
  @$pb.TagNumber(11)
  set unknown11($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(11)
  $core.bool hasUnknown11() => $_has(6);
  @$pb.TagNumber(11)
  void clearUnknown11() => $_clearField(11);
}

class WatchfaceInstallStart extends $pb.GeneratedMessage {
  factory WatchfaceInstallStart({
    $core.String? id,
    $core.int? size,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (size != null) result.size = size;
    return result;
  }

  WatchfaceInstallStart._();

  factory WatchfaceInstallStart.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchfaceInstallStart.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WatchfaceInstallStart',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'size', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInstallStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInstallStart copyWith(
    void Function(WatchfaceInstallStart) updates,
  ) =>
      super.copyWith((message) => updates(message as WatchfaceInstallStart))
          as WatchfaceInstallStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchfaceInstallStart create() => WatchfaceInstallStart._();
  @$core.override
  WatchfaceInstallStart createEmptyInstance() => create();
  static $pb.PbList<WatchfaceInstallStart> createRepeated() =>
      $pb.PbList<WatchfaceInstallStart>();
  @$core.pragma('dart2js:noInline')
  static WatchfaceInstallStart getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchfaceInstallStart>(create);
  static WatchfaceInstallStart? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get size => $_getIZ(1);
  @$pb.TagNumber(2)
  set size($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);
}

class WatchfaceInstallFinish extends $pb.GeneratedMessage {
  factory WatchfaceInstallFinish({
    $core.String? id,
    $core.int? unknown2,
    $core.int? unknown3,
    $core.int? unknown4,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (unknown2 != null) result.unknown2 = unknown2;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (unknown4 != null) result.unknown4 = unknown4;
    return result;
  }

  WatchfaceInstallFinish._();

  factory WatchfaceInstallFinish.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchfaceInstallFinish.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WatchfaceInstallFinish',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'unknown4', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInstallFinish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchfaceInstallFinish copyWith(
    void Function(WatchfaceInstallFinish) updates,
  ) =>
      super.copyWith((message) => updates(message as WatchfaceInstallFinish))
          as WatchfaceInstallFinish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchfaceInstallFinish create() => WatchfaceInstallFinish._();
  @$core.override
  WatchfaceInstallFinish createEmptyInstance() => create();
  static $pb.PbList<WatchfaceInstallFinish> createRepeated() =>
      $pb.PbList<WatchfaceInstallFinish>();
  @$core.pragma('dart2js:noInline')
  static WatchfaceInstallFinish getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchfaceInstallFinish>(create);
  static WatchfaceInstallFinish? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unknown4 => $_getIZ(3);
  @$pb.TagNumber(4)
  set unknown4($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown4() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown4() => $_clearField(4);
}

class Health extends $pb.GeneratedMessage {
  factory Health({
    UserInfo? userInfo,
    $core.List<$core.int>? activityRequestFileIds,
    $core.List<$core.int>? activitySyncAckFileIds,
    ActivitySyncRequestToday? activitySyncRequestToday,
    SpO2? spo2,
    HeartRate? heartRate,
    StandingReminder? standingReminder,
    Stress? stress,
    GoalNotification? goalNotification,
    VitalityScore? vitalityScore,
    WorkoutStatusWatch? workoutStatusWatch,
    WorkoutOpenWatch? workoutOpenWatch,
    WorkoutOpenReply? workoutOpenReply,
    GoalsConfig? goalsConfig,
    RealTimeStats? realTimeStats,
    WorkoutLocation? workoutLocation,
  }) {
    final result = create();
    if (userInfo != null) result.userInfo = userInfo;
    if (activityRequestFileIds != null)
      result.activityRequestFileIds = activityRequestFileIds;
    if (activitySyncAckFileIds != null)
      result.activitySyncAckFileIds = activitySyncAckFileIds;
    if (activitySyncRequestToday != null)
      result.activitySyncRequestToday = activitySyncRequestToday;
    if (spo2 != null) result.spo2 = spo2;
    if (heartRate != null) result.heartRate = heartRate;
    if (standingReminder != null) result.standingReminder = standingReminder;
    if (stress != null) result.stress = stress;
    if (goalNotification != null) result.goalNotification = goalNotification;
    if (vitalityScore != null) result.vitalityScore = vitalityScore;
    if (workoutStatusWatch != null)
      result.workoutStatusWatch = workoutStatusWatch;
    if (workoutOpenWatch != null) result.workoutOpenWatch = workoutOpenWatch;
    if (workoutOpenReply != null) result.workoutOpenReply = workoutOpenReply;
    if (goalsConfig != null) result.goalsConfig = goalsConfig;
    if (realTimeStats != null) result.realTimeStats = realTimeStats;
    if (workoutLocation != null) result.workoutLocation = workoutLocation;
    return result;
  }

  Health._();

  factory Health.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Health.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Health',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<UserInfo>(
      1,
      _omitFieldNames ? '' : 'userInfo',
      protoName: 'userInfo',
      subBuilder: UserInfo.create,
    )
    ..a<$core.List<$core.int>>(
      2,
      _omitFieldNames ? '' : 'activityRequestFileIds',
      $pb.PbFieldType.OY,
      protoName: 'activityRequestFileIds',
    )
    ..a<$core.List<$core.int>>(
      3,
      _omitFieldNames ? '' : 'activitySyncAckFileIds',
      $pb.PbFieldType.OY,
      protoName: 'activitySyncAckFileIds',
    )
    ..aOM<ActivitySyncRequestToday>(
      5,
      _omitFieldNames ? '' : 'activitySyncRequestToday',
      protoName: 'activitySyncRequestToday',
      subBuilder: ActivitySyncRequestToday.create,
    )
    ..aOM<SpO2>(7, _omitFieldNames ? '' : 'spo2', subBuilder: SpO2.create)
    ..aOM<HeartRate>(
      8,
      _omitFieldNames ? '' : 'heartRate',
      protoName: 'heartRate',
      subBuilder: HeartRate.create,
    )
    ..aOM<StandingReminder>(
      9,
      _omitFieldNames ? '' : 'standingReminder',
      protoName: 'standingReminder',
      subBuilder: StandingReminder.create,
    )
    ..aOM<Stress>(
      10,
      _omitFieldNames ? '' : 'stress',
      subBuilder: Stress.create,
    )
    ..aOM<GoalNotification>(
      13,
      _omitFieldNames ? '' : 'goalNotification',
      protoName: 'goalNotification',
      subBuilder: GoalNotification.create,
    )
    ..aOM<VitalityScore>(
      14,
      _omitFieldNames ? '' : 'vitalityScore',
      protoName: 'vitalityScore',
      subBuilder: VitalityScore.create,
    )
    ..aOM<WorkoutStatusWatch>(
      20,
      _omitFieldNames ? '' : 'workoutStatusWatch',
      protoName: 'workoutStatusWatch',
      subBuilder: WorkoutStatusWatch.create,
    )
    ..aOM<WorkoutOpenWatch>(
      25,
      _omitFieldNames ? '' : 'workoutOpenWatch',
      protoName: 'workoutOpenWatch',
      subBuilder: WorkoutOpenWatch.create,
    )
    ..aOM<WorkoutOpenReply>(
      26,
      _omitFieldNames ? '' : 'workoutOpenReply',
      protoName: 'workoutOpenReply',
      subBuilder: WorkoutOpenReply.create,
    )
    ..aOM<GoalsConfig>(
      38,
      _omitFieldNames ? '' : 'goalsConfig',
      protoName: 'goalsConfig',
      subBuilder: GoalsConfig.create,
    )
    ..aOM<RealTimeStats>(
      39,
      _omitFieldNames ? '' : 'realTimeStats',
      protoName: 'realTimeStats',
      subBuilder: RealTimeStats.create,
    )
    ..aOM<WorkoutLocation>(
      40,
      _omitFieldNames ? '' : 'workoutLocation',
      protoName: 'workoutLocation',
      subBuilder: WorkoutLocation.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Health clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Health copyWith(void Function(Health) updates) =>
      super.copyWith((message) => updates(message as Health)) as Health;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Health create() => Health._();
  @$core.override
  Health createEmptyInstance() => create();
  static $pb.PbList<Health> createRepeated() => $pb.PbList<Health>();
  @$core.pragma('dart2js:noInline')
  static Health getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Health>(create);
  static Health? _defaultInstance;

  @$pb.TagNumber(1)
  UserInfo get userInfo => $_getN(0);
  @$pb.TagNumber(1)
  set userInfo(UserInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUserInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  UserInfo ensureUserInfo() => $_ensure(0);

  /// 8, 2 get today | 8, 3 get past
  @$pb.TagNumber(2)
  $core.List<$core.int> get activityRequestFileIds => $_getN(1);
  @$pb.TagNumber(2)
  set activityRequestFileIds($core.List<$core.int> value) =>
      $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActivityRequestFileIds() => $_has(1);
  @$pb.TagNumber(2)
  void clearActivityRequestFileIds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get activitySyncAckFileIds => $_getN(2);
  @$pb.TagNumber(3)
  set activitySyncAckFileIds($core.List<$core.int> value) =>
      $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActivitySyncAckFileIds() => $_has(2);
  @$pb.TagNumber(3)
  void clearActivitySyncAckFileIds() => $_clearField(3);

  @$pb.TagNumber(5)
  ActivitySyncRequestToday get activitySyncRequestToday => $_getN(3);
  @$pb.TagNumber(5)
  set activitySyncRequestToday(ActivitySyncRequestToday value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasActivitySyncRequestToday() => $_has(3);
  @$pb.TagNumber(5)
  void clearActivitySyncRequestToday() => $_clearField(5);
  @$pb.TagNumber(5)
  ActivitySyncRequestToday ensureActivitySyncRequestToday() => $_ensure(3);

  @$pb.TagNumber(7)
  SpO2 get spo2 => $_getN(4);
  @$pb.TagNumber(7)
  set spo2(SpO2 value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSpo2() => $_has(4);
  @$pb.TagNumber(7)
  void clearSpo2() => $_clearField(7);
  @$pb.TagNumber(7)
  SpO2 ensureSpo2() => $_ensure(4);

  @$pb.TagNumber(8)
  HeartRate get heartRate => $_getN(5);
  @$pb.TagNumber(8)
  set heartRate(HeartRate value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasHeartRate() => $_has(5);
  @$pb.TagNumber(8)
  void clearHeartRate() => $_clearField(8);
  @$pb.TagNumber(8)
  HeartRate ensureHeartRate() => $_ensure(5);

  /// 8, 12 get | 8, 13 set
  @$pb.TagNumber(9)
  StandingReminder get standingReminder => $_getN(6);
  @$pb.TagNumber(9)
  set standingReminder(StandingReminder value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStandingReminder() => $_has(6);
  @$pb.TagNumber(9)
  void clearStandingReminder() => $_clearField(9);
  @$pb.TagNumber(9)
  StandingReminder ensureStandingReminder() => $_ensure(6);

  @$pb.TagNumber(10)
  Stress get stress => $_getN(7);
  @$pb.TagNumber(10)
  set stress(Stress value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStress() => $_has(7);
  @$pb.TagNumber(10)
  void clearStress() => $_clearField(10);
  @$pb.TagNumber(10)
  Stress ensureStress() => $_ensure(7);

  @$pb.TagNumber(13)
  GoalNotification get goalNotification => $_getN(8);
  @$pb.TagNumber(13)
  set goalNotification(GoalNotification value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGoalNotification() => $_has(8);
  @$pb.TagNumber(13)
  void clearGoalNotification() => $_clearField(13);
  @$pb.TagNumber(13)
  GoalNotification ensureGoalNotification() => $_ensure(8);

  /// 8, 35 get | 8, 36 set
  @$pb.TagNumber(14)
  VitalityScore get vitalityScore => $_getN(9);
  @$pb.TagNumber(14)
  set vitalityScore(VitalityScore value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasVitalityScore() => $_has(9);
  @$pb.TagNumber(14)
  void clearVitalityScore() => $_clearField(14);
  @$pb.TagNumber(14)
  VitalityScore ensureVitalityScore() => $_ensure(9);

  /// 8, 26
  @$pb.TagNumber(20)
  WorkoutStatusWatch get workoutStatusWatch => $_getN(10);
  @$pb.TagNumber(20)
  set workoutStatusWatch(WorkoutStatusWatch value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasWorkoutStatusWatch() => $_has(10);
  @$pb.TagNumber(20)
  void clearWorkoutStatusWatch() => $_clearField(20);
  @$pb.TagNumber(20)
  WorkoutStatusWatch ensureWorkoutStatusWatch() => $_ensure(10);

  /// 8, 30
  @$pb.TagNumber(25)
  WorkoutOpenWatch get workoutOpenWatch => $_getN(11);
  @$pb.TagNumber(25)
  set workoutOpenWatch(WorkoutOpenWatch value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasWorkoutOpenWatch() => $_has(11);
  @$pb.TagNumber(25)
  void clearWorkoutOpenWatch() => $_clearField(25);
  @$pb.TagNumber(25)
  WorkoutOpenWatch ensureWorkoutOpenWatch() => $_ensure(11);

  @$pb.TagNumber(26)
  WorkoutOpenReply get workoutOpenReply => $_getN(12);
  @$pb.TagNumber(26)
  set workoutOpenReply(WorkoutOpenReply value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasWorkoutOpenReply() => $_has(12);
  @$pb.TagNumber(26)
  void clearWorkoutOpenReply() => $_clearField(26);
  @$pb.TagNumber(26)
  WorkoutOpenReply ensureWorkoutOpenReply() => $_ensure(12);

  /// 7, 43
  @$pb.TagNumber(38)
  GoalsConfig get goalsConfig => $_getN(13);
  @$pb.TagNumber(38)
  set goalsConfig(GoalsConfig value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasGoalsConfig() => $_has(13);
  @$pb.TagNumber(38)
  void clearGoalsConfig() => $_clearField(38);
  @$pb.TagNumber(38)
  GoalsConfig ensureGoalsConfig() => $_ensure(13);

  /// 8,45 enable | 8, 46 disable | 8, 47 periodic
  @$pb.TagNumber(39)
  RealTimeStats get realTimeStats => $_getN(14);
  @$pb.TagNumber(39)
  set realTimeStats(RealTimeStats value) => $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasRealTimeStats() => $_has(14);
  @$pb.TagNumber(39)
  void clearRealTimeStats() => $_clearField(39);
  @$pb.TagNumber(39)
  RealTimeStats ensureRealTimeStats() => $_ensure(14);

  /// 7, 48
  @$pb.TagNumber(40)
  WorkoutLocation get workoutLocation => $_getN(15);
  @$pb.TagNumber(40)
  set workoutLocation(WorkoutLocation value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasWorkoutLocation() => $_has(15);
  @$pb.TagNumber(40)
  void clearWorkoutLocation() => $_clearField(40);
  @$pb.TagNumber(40)
  WorkoutLocation ensureWorkoutLocation() => $_ensure(15);
}

class UserInfo extends $pb.GeneratedMessage {
  factory UserInfo({
    $core.int? height,
    $core.double? weight,
    $core.int? birthday,
    $core.int? gender,
    $core.int? maxHeartRate,
    $core.int? goalCalories,
    $core.int? goalSteps,
    $core.int? goalStanding,
    $core.int? goalMoving,
  }) {
    final result = create();
    if (height != null) result.height = height;
    if (weight != null) result.weight = weight;
    if (birthday != null) result.birthday = birthday;
    if (gender != null) result.gender = gender;
    if (maxHeartRate != null) result.maxHeartRate = maxHeartRate;
    if (goalCalories != null) result.goalCalories = goalCalories;
    if (goalSteps != null) result.goalSteps = goalSteps;
    if (goalStanding != null) result.goalStanding = goalStanding;
    if (goalMoving != null) result.goalMoving = goalMoving;
    return result;
  }

  UserInfo._();

  factory UserInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'UserInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aD(2, _omitFieldNames ? '' : 'weight', fieldType: $pb.PbFieldType.OF)
    ..aI(3, _omitFieldNames ? '' : 'birthday', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'gender', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      5,
      _omitFieldNames ? '' : 'maxHeartRate',
      protoName: 'maxHeartRate',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      6,
      _omitFieldNames ? '' : 'goalCalories',
      protoName: 'goalCalories',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      7,
      _omitFieldNames ? '' : 'goalSteps',
      protoName: 'goalSteps',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      9,
      _omitFieldNames ? '' : 'goalStanding',
      protoName: 'goalStanding',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      11,
      _omitFieldNames ? '' : 'goalMoving',
      protoName: 'goalMoving',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo copyWith(void Function(UserInfo) updates) =>
      super.copyWith((message) => updates(message as UserInfo)) as UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfo create() => UserInfo._();
  @$core.override
  UserInfo createEmptyInstance() => create();
  static $pb.PbList<UserInfo> createRepeated() => $pb.PbList<UserInfo>();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfo>(create);
  static UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get height => $_getIZ(0);
  @$pb.TagNumber(1)
  set height($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get weight => $_getN(1);
  @$pb.TagNumber(2)
  set weight($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get birthday => $_getIZ(2);
  @$pb.TagNumber(3)
  set birthday($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBirthday() => $_has(2);
  @$pb.TagNumber(3)
  void clearBirthday() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get gender => $_getIZ(3);
  @$pb.TagNumber(4)
  set gender($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGender() => $_has(3);
  @$pb.TagNumber(4)
  void clearGender() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxHeartRate => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxHeartRate($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxHeartRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxHeartRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get goalCalories => $_getIZ(5);
  @$pb.TagNumber(6)
  set goalCalories($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGoalCalories() => $_has(5);
  @$pb.TagNumber(6)
  void clearGoalCalories() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get goalSteps => $_getIZ(6);
  @$pb.TagNumber(7)
  set goalSteps($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGoalSteps() => $_has(6);
  @$pb.TagNumber(7)
  void clearGoalSteps() => $_clearField(7);

  @$pb.TagNumber(9)
  $core.int get goalStanding => $_getIZ(7);
  @$pb.TagNumber(9)
  set goalStanding($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(9)
  $core.bool hasGoalStanding() => $_has(7);
  @$pb.TagNumber(9)
  void clearGoalStanding() => $_clearField(9);

  @$pb.TagNumber(11)
  $core.int get goalMoving => $_getIZ(8);
  @$pb.TagNumber(11)
  set goalMoving($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(11)
  $core.bool hasGoalMoving() => $_has(8);
  @$pb.TagNumber(11)
  void clearGoalMoving() => $_clearField(11);
}

class ActivitySyncRequestToday extends $pb.GeneratedMessage {
  factory ActivitySyncRequestToday({
    $core.int? unknown1,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    return result;
  }

  ActivitySyncRequestToday._();

  factory ActivitySyncRequestToday.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActivitySyncRequestToday.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ActivitySyncRequestToday',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivitySyncRequestToday clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivitySyncRequestToday copyWith(
    void Function(ActivitySyncRequestToday) updates,
  ) =>
      super.copyWith((message) => updates(message as ActivitySyncRequestToday))
          as ActivitySyncRequestToday;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActivitySyncRequestToday create() => ActivitySyncRequestToday._();
  @$core.override
  ActivitySyncRequestToday createEmptyInstance() => create();
  static $pb.PbList<ActivitySyncRequestToday> createRepeated() =>
      $pb.PbList<ActivitySyncRequestToday>();
  @$core.pragma('dart2js:noInline')
  static ActivitySyncRequestToday getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivitySyncRequestToday>(create);
  static ActivitySyncRequestToday? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);
}

class SpO2 extends $pb.GeneratedMessage {
  factory SpO2({
    $core.int? unknown1,
    $core.bool? allDayTracking,
    Spo2AlarmLow? alarmLow,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (allDayTracking != null) result.allDayTracking = allDayTracking;
    if (alarmLow != null) result.alarmLow = alarmLow;
    return result;
  }

  SpO2._();

  factory SpO2.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpO2.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'SpO2',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..aOB(
      2,
      _omitFieldNames ? '' : 'allDayTracking',
      protoName: 'allDayTracking',
    )
    ..aOM<Spo2AlarmLow>(
      4,
      _omitFieldNames ? '' : 'alarmLow',
      protoName: 'alarmLow',
      subBuilder: Spo2AlarmLow.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpO2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpO2 copyWith(void Function(SpO2) updates) =>
      super.copyWith((message) => updates(message as SpO2)) as SpO2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpO2 create() => SpO2._();
  @$core.override
  SpO2 createEmptyInstance() => create();
  static $pb.PbList<SpO2> createRepeated() => $pb.PbList<SpO2>();
  @$core.pragma('dart2js:noInline')
  static SpO2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpO2>(create);
  static SpO2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get allDayTracking => $_getBF(1);
  @$pb.TagNumber(2)
  set allDayTracking($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllDayTracking() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllDayTracking() => $_clearField(2);

  @$pb.TagNumber(4)
  Spo2AlarmLow get alarmLow => $_getN(2);
  @$pb.TagNumber(4)
  set alarmLow(Spo2AlarmLow value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAlarmLow() => $_has(2);
  @$pb.TagNumber(4)
  void clearAlarmLow() => $_clearField(4);
  @$pb.TagNumber(4)
  Spo2AlarmLow ensureAlarmLow() => $_ensure(2);
}

class Spo2AlarmLow extends $pb.GeneratedMessage {
  factory Spo2AlarmLow({
    $core.bool? alarmLowEnabled,
    $core.int? alarmLowThreshold,
  }) {
    final result = create();
    if (alarmLowEnabled != null) result.alarmLowEnabled = alarmLowEnabled;
    if (alarmLowThreshold != null) result.alarmLowThreshold = alarmLowThreshold;
    return result;
  }

  Spo2AlarmLow._();

  factory Spo2AlarmLow.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Spo2AlarmLow.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Spo2AlarmLow',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(
      1,
      _omitFieldNames ? '' : 'alarmLowEnabled',
      protoName: 'alarmLowEnabled',
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'alarmLowThreshold',
      protoName: 'alarmLowThreshold',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Spo2AlarmLow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Spo2AlarmLow copyWith(void Function(Spo2AlarmLow) updates) =>
      super.copyWith((message) => updates(message as Spo2AlarmLow))
          as Spo2AlarmLow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Spo2AlarmLow create() => Spo2AlarmLow._();
  @$core.override
  Spo2AlarmLow createEmptyInstance() => create();
  static $pb.PbList<Spo2AlarmLow> createRepeated() =>
      $pb.PbList<Spo2AlarmLow>();
  @$core.pragma('dart2js:noInline')
  static Spo2AlarmLow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Spo2AlarmLow>(create);
  static Spo2AlarmLow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get alarmLowEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set alarmLowEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmLowEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmLowEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get alarmLowThreshold => $_getIZ(1);
  @$pb.TagNumber(2)
  set alarmLowThreshold($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlarmLowThreshold() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlarmLowThreshold() => $_clearField(2);
}

class HeartRate extends $pb.GeneratedMessage {
  factory HeartRate({
    $core.bool? disabled,
    $core.int? interval,
    $core.bool? alarmHighEnabled,
    $core.int? alarmHighThreshold,
    AdvancedMonitoring? advancedMonitoring,
    $core.int? unknown7,
    HeartRateAlarmLow? heartRateAlarmLow,
    $core.int? breathingScore,
  }) {
    final result = create();
    if (disabled != null) result.disabled = disabled;
    if (interval != null) result.interval = interval;
    if (alarmHighEnabled != null) result.alarmHighEnabled = alarmHighEnabled;
    if (alarmHighThreshold != null)
      result.alarmHighThreshold = alarmHighThreshold;
    if (advancedMonitoring != null)
      result.advancedMonitoring = advancedMonitoring;
    if (unknown7 != null) result.unknown7 = unknown7;
    if (heartRateAlarmLow != null) result.heartRateAlarmLow = heartRateAlarmLow;
    if (breathingScore != null) result.breathingScore = breathingScore;
    return result;
  }

  HeartRate._();

  factory HeartRate.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartRate.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'HeartRate',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'disabled')
    ..aI(2, _omitFieldNames ? '' : 'interval', fieldType: $pb.PbFieldType.OU3)
    ..aOB(
      3,
      _omitFieldNames ? '' : 'alarmHighEnabled',
      protoName: 'alarmHighEnabled',
    )
    ..aI(
      4,
      _omitFieldNames ? '' : 'alarmHighThreshold',
      protoName: 'alarmHighThreshold',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<AdvancedMonitoring>(
      5,
      _omitFieldNames ? '' : 'advancedMonitoring',
      protoName: 'advancedMonitoring',
      subBuilder: AdvancedMonitoring.create,
    )
    ..aI(7, _omitFieldNames ? '' : 'unknown7', fieldType: $pb.PbFieldType.OU3)
    ..aOM<HeartRateAlarmLow>(
      8,
      _omitFieldNames ? '' : 'heartRateAlarmLow',
      protoName: 'heartRateAlarmLow',
      subBuilder: HeartRateAlarmLow.create,
    )
    ..aI(
      9,
      _omitFieldNames ? '' : 'breathingScore',
      protoName: 'breathingScore',
      fieldType: $pb.PbFieldType.OU3,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartRate copyWith(void Function(HeartRate) updates) =>
      super.copyWith((message) => updates(message as HeartRate)) as HeartRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartRate create() => HeartRate._();
  @$core.override
  HeartRate createEmptyInstance() => create();
  static $pb.PbList<HeartRate> createRepeated() => $pb.PbList<HeartRate>();
  @$core.pragma('dart2js:noInline')
  static HeartRate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HeartRate>(create);
  static HeartRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get disabled => $_getBF(0);
  @$pb.TagNumber(1)
  set disabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get interval => $_getIZ(1);
  @$pb.TagNumber(2)
  set interval($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInterval() => $_has(1);
  @$pb.TagNumber(2)
  void clearInterval() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get alarmHighEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set alarmHighEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAlarmHighEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlarmHighEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get alarmHighThreshold => $_getIZ(3);
  @$pb.TagNumber(4)
  set alarmHighThreshold($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAlarmHighThreshold() => $_has(3);
  @$pb.TagNumber(4)
  void clearAlarmHighThreshold() => $_clearField(4);

  @$pb.TagNumber(5)
  AdvancedMonitoring get advancedMonitoring => $_getN(4);
  @$pb.TagNumber(5)
  set advancedMonitoring(AdvancedMonitoring value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAdvancedMonitoring() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdvancedMonitoring() => $_clearField(5);
  @$pb.TagNumber(5)
  AdvancedMonitoring ensureAdvancedMonitoring() => $_ensure(4);

  @$pb.TagNumber(7)
  $core.int get unknown7 => $_getIZ(5);
  @$pb.TagNumber(7)
  set unknown7($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasUnknown7() => $_has(5);
  @$pb.TagNumber(7)
  void clearUnknown7() => $_clearField(7);

  @$pb.TagNumber(8)
  HeartRateAlarmLow get heartRateAlarmLow => $_getN(6);
  @$pb.TagNumber(8)
  set heartRateAlarmLow(HeartRateAlarmLow value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasHeartRateAlarmLow() => $_has(6);
  @$pb.TagNumber(8)
  void clearHeartRateAlarmLow() => $_clearField(8);
  @$pb.TagNumber(8)
  HeartRateAlarmLow ensureHeartRateAlarmLow() => $_ensure(6);

  @$pb.TagNumber(9)
  $core.int get breathingScore => $_getIZ(7);
  @$pb.TagNumber(9)
  set breathingScore($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(9)
  $core.bool hasBreathingScore() => $_has(7);
  @$pb.TagNumber(9)
  void clearBreathingScore() => $_clearField(9);
}

class AdvancedMonitoring extends $pb.GeneratedMessage {
  factory AdvancedMonitoring({
    $core.bool? enabled,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  AdvancedMonitoring._();

  factory AdvancedMonitoring.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvancedMonitoring.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AdvancedMonitoring',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..a<$core.bool>(1, _omitFieldNames ? '' : 'enabled', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancedMonitoring clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancedMonitoring copyWith(void Function(AdvancedMonitoring) updates) =>
      super.copyWith((message) => updates(message as AdvancedMonitoring))
          as AdvancedMonitoring;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvancedMonitoring create() => AdvancedMonitoring._();
  @$core.override
  AdvancedMonitoring createEmptyInstance() => create();
  static $pb.PbList<AdvancedMonitoring> createRepeated() =>
      $pb.PbList<AdvancedMonitoring>();
  @$core.pragma('dart2js:noInline')
  static AdvancedMonitoring getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvancedMonitoring>(create);
  static AdvancedMonitoring? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);
}

class HeartRateAlarmLow extends $pb.GeneratedMessage {
  factory HeartRateAlarmLow({
    $core.bool? alarmLowEnabled,
    $core.int? alarmLowThreshold,
  }) {
    final result = create();
    if (alarmLowEnabled != null) result.alarmLowEnabled = alarmLowEnabled;
    if (alarmLowThreshold != null) result.alarmLowThreshold = alarmLowThreshold;
    return result;
  }

  HeartRateAlarmLow._();

  factory HeartRateAlarmLow.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartRateAlarmLow.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'HeartRateAlarmLow',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(
      1,
      _omitFieldNames ? '' : 'alarmLowEnabled',
      protoName: 'alarmLowEnabled',
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'alarmLowThreshold',
      protoName: 'alarmLowThreshold',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartRateAlarmLow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartRateAlarmLow copyWith(void Function(HeartRateAlarmLow) updates) =>
      super.copyWith((message) => updates(message as HeartRateAlarmLow))
          as HeartRateAlarmLow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartRateAlarmLow create() => HeartRateAlarmLow._();
  @$core.override
  HeartRateAlarmLow createEmptyInstance() => create();
  static $pb.PbList<HeartRateAlarmLow> createRepeated() =>
      $pb.PbList<HeartRateAlarmLow>();
  @$core.pragma('dart2js:noInline')
  static HeartRateAlarmLow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartRateAlarmLow>(create);
  static HeartRateAlarmLow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get alarmLowEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set alarmLowEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmLowEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmLowEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get alarmLowThreshold => $_getIZ(1);
  @$pb.TagNumber(2)
  set alarmLowThreshold($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlarmLowThreshold() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlarmLowThreshold() => $_clearField(2);
}

class StandingReminder extends $pb.GeneratedMessage {
  factory StandingReminder({
    $core.bool? enabled,
    HourMinute? start,
    HourMinute? end,
    $core.bool? dnd,
    HourMinute? dndStart,
    HourMinute? dndEnd,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (dnd != null) result.dnd = dnd;
    if (dndStart != null) result.dndStart = dndStart;
    if (dndEnd != null) result.dndEnd = dndEnd;
    return result;
  }

  StandingReminder._();

  factory StandingReminder.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory StandingReminder.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'StandingReminder',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOM<HourMinute>(
      2,
      _omitFieldNames ? '' : 'start',
      subBuilder: HourMinute.create,
    )
    ..aOM<HourMinute>(
      3,
      _omitFieldNames ? '' : 'end',
      subBuilder: HourMinute.create,
    )
    ..aOB(4, _omitFieldNames ? '' : 'dnd')
    ..aOM<HourMinute>(
      6,
      _omitFieldNames ? '' : 'dndStart',
      protoName: 'dndStart',
      subBuilder: HourMinute.create,
    )
    ..aOM<HourMinute>(
      7,
      _omitFieldNames ? '' : 'dndEnd',
      protoName: 'dndEnd',
      subBuilder: HourMinute.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandingReminder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StandingReminder copyWith(void Function(StandingReminder) updates) =>
      super.copyWith((message) => updates(message as StandingReminder))
          as StandingReminder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StandingReminder create() => StandingReminder._();
  @$core.override
  StandingReminder createEmptyInstance() => create();
  static $pb.PbList<StandingReminder> createRepeated() =>
      $pb.PbList<StandingReminder>();
  @$core.pragma('dart2js:noInline')
  static StandingReminder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StandingReminder>(create);
  static StandingReminder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  HourMinute get start => $_getN(1);
  @$pb.TagNumber(2)
  set start(HourMinute value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearStart() => $_clearField(2);
  @$pb.TagNumber(2)
  HourMinute ensureStart() => $_ensure(1);

  @$pb.TagNumber(3)
  HourMinute get end => $_getN(2);
  @$pb.TagNumber(3)
  set end(HourMinute value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  HourMinute ensureEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get dnd => $_getBF(3);
  @$pb.TagNumber(4)
  set dnd($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearDnd() => $_clearField(4);

  @$pb.TagNumber(6)
  HourMinute get dndStart => $_getN(4);
  @$pb.TagNumber(6)
  set dndStart(HourMinute value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDndStart() => $_has(4);
  @$pb.TagNumber(6)
  void clearDndStart() => $_clearField(6);
  @$pb.TagNumber(6)
  HourMinute ensureDndStart() => $_ensure(4);

  @$pb.TagNumber(7)
  HourMinute get dndEnd => $_getN(5);
  @$pb.TagNumber(7)
  set dndEnd(HourMinute value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDndEnd() => $_has(5);
  @$pb.TagNumber(7)
  void clearDndEnd() => $_clearField(7);
  @$pb.TagNumber(7)
  HourMinute ensureDndEnd() => $_ensure(5);
}

class Stress extends $pb.GeneratedMessage {
  factory Stress({
    $core.bool? allDayTracking,
    RelaxReminder? relaxReminder,
  }) {
    final result = create();
    if (allDayTracking != null) result.allDayTracking = allDayTracking;
    if (relaxReminder != null) result.relaxReminder = relaxReminder;
    return result;
  }

  Stress._();

  factory Stress.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stress.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Stress',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(
      1,
      _omitFieldNames ? '' : 'allDayTracking',
      protoName: 'allDayTracking',
    )
    ..aOM<RelaxReminder>(
      2,
      _omitFieldNames ? '' : 'relaxReminder',
      protoName: 'relaxReminder',
      subBuilder: RelaxReminder.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stress copyWith(void Function(Stress) updates) =>
      super.copyWith((message) => updates(message as Stress)) as Stress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stress create() => Stress._();
  @$core.override
  Stress createEmptyInstance() => create();
  static $pb.PbList<Stress> createRepeated() => $pb.PbList<Stress>();
  @$core.pragma('dart2js:noInline')
  static Stress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stress>(create);
  static Stress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allDayTracking => $_getBF(0);
  @$pb.TagNumber(1)
  set allDayTracking($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllDayTracking() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllDayTracking() => $_clearField(1);

  @$pb.TagNumber(2)
  RelaxReminder get relaxReminder => $_getN(1);
  @$pb.TagNumber(2)
  set relaxReminder(RelaxReminder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRelaxReminder() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelaxReminder() => $_clearField(2);
  @$pb.TagNumber(2)
  RelaxReminder ensureRelaxReminder() => $_ensure(1);
}

class GoalNotification extends $pb.GeneratedMessage {
  factory GoalNotification({
    $core.bool? enabled,
    $core.int? unknown2,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  GoalNotification._();

  factory GoalNotification.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoalNotification.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'GoalNotification',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalNotification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalNotification copyWith(void Function(GoalNotification) updates) =>
      super.copyWith((message) => updates(message as GoalNotification))
          as GoalNotification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoalNotification create() => GoalNotification._();
  @$core.override
  GoalNotification createEmptyInstance() => create();
  static $pb.PbList<GoalNotification> createRepeated() =>
      $pb.PbList<GoalNotification>();
  @$core.pragma('dart2js:noInline')
  static GoalNotification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoalNotification>(create);
  static GoalNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class RelaxReminder extends $pb.GeneratedMessage {
  factory RelaxReminder({
    $core.bool? enabled,
    $core.int? unknown2,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  RelaxReminder._();

  factory RelaxReminder.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory RelaxReminder.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'RelaxReminder',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelaxReminder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelaxReminder copyWith(void Function(RelaxReminder) updates) =>
      super.copyWith((message) => updates(message as RelaxReminder))
          as RelaxReminder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelaxReminder create() => RelaxReminder._();
  @$core.override
  RelaxReminder createEmptyInstance() => create();
  static $pb.PbList<RelaxReminder> createRepeated() =>
      $pb.PbList<RelaxReminder>();
  @$core.pragma('dart2js:noInline')
  static RelaxReminder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelaxReminder>(create);
  static RelaxReminder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class VitalityScore extends $pb.GeneratedMessage {
  factory VitalityScore({
    $core.bool? sevenDay,
    $core.bool? dailyProgress,
  }) {
    final result = create();
    if (sevenDay != null) result.sevenDay = sevenDay;
    if (dailyProgress != null) result.dailyProgress = dailyProgress;
    return result;
  }

  VitalityScore._();

  factory VitalityScore.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory VitalityScore.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'VitalityScore',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOB(1, _omitFieldNames ? '' : 'sevenDay', protoName: 'sevenDay')
    ..aOB(2, _omitFieldNames ? '' : 'dailyProgress', protoName: 'dailyProgress')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VitalityScore clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VitalityScore copyWith(void Function(VitalityScore) updates) =>
      super.copyWith((message) => updates(message as VitalityScore))
          as VitalityScore;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VitalityScore create() => VitalityScore._();
  @$core.override
  VitalityScore createEmptyInstance() => create();
  static $pb.PbList<VitalityScore> createRepeated() =>
      $pb.PbList<VitalityScore>();
  @$core.pragma('dart2js:noInline')
  static VitalityScore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VitalityScore>(create);
  static VitalityScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get sevenDay => $_getBF(0);
  @$pb.TagNumber(1)
  set sevenDay($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSevenDay() => $_has(0);
  @$pb.TagNumber(1)
  void clearSevenDay() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get dailyProgress => $_getBF(1);
  @$pb.TagNumber(2)
  set dailyProgress($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDailyProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearDailyProgress() => $_clearField(2);
}

class WorkoutStatusWatch extends $pb.GeneratedMessage {
  factory WorkoutStatusWatch({
    $core.int? timestamp,
    $core.int? sport,
    $core.int? status,
    $core.List<$core.int>? activityFileIds,
    $core.int? unknown6,
    $core.int? unknown10,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    if (sport != null) result.sport = sport;
    if (status != null) result.status = status;
    if (activityFileIds != null) result.activityFileIds = activityFileIds;
    if (unknown6 != null) result.unknown6 = unknown6;
    if (unknown10 != null) result.unknown10 = unknown10;
    return result;
  }

  WorkoutStatusWatch._();

  factory WorkoutStatusWatch.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutStatusWatch.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutStatusWatch',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'timestamp', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'sport', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
      5,
      _omitFieldNames ? '' : 'activityFileIds',
      $pb.PbFieldType.OY,
      protoName: 'activityFileIds',
    )
    ..aI(6, _omitFieldNames ? '' : 'unknown6', fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'unknown10', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutStatusWatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutStatusWatch copyWith(void Function(WorkoutStatusWatch) updates) =>
      super.copyWith((message) => updates(message as WorkoutStatusWatch))
          as WorkoutStatusWatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutStatusWatch create() => WorkoutStatusWatch._();
  @$core.override
  WorkoutStatusWatch createEmptyInstance() => create();
  static $pb.PbList<WorkoutStatusWatch> createRepeated() =>
      $pb.PbList<WorkoutStatusWatch>();
  @$core.pragma('dart2js:noInline')
  static WorkoutStatusWatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutStatusWatch>(create);
  static WorkoutStatusWatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get timestamp => $_getIZ(0);
  @$pb.TagNumber(1)
  set timestamp($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);

  @$pb.TagNumber(3)
  $core.int get sport => $_getIZ(1);
  @$pb.TagNumber(3)
  set sport($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(3)
  $core.bool hasSport() => $_has(1);
  @$pb.TagNumber(3)
  void clearSport() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(4)
  set status($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get activityFileIds => $_getN(3);
  @$pb.TagNumber(5)
  set activityFileIds($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(5)
  $core.bool hasActivityFileIds() => $_has(3);
  @$pb.TagNumber(5)
  void clearActivityFileIds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get unknown6 => $_getIZ(4);
  @$pb.TagNumber(6)
  set unknown6($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(6)
  $core.bool hasUnknown6() => $_has(4);
  @$pb.TagNumber(6)
  void clearUnknown6() => $_clearField(6);

  @$pb.TagNumber(10)
  $core.int get unknown10 => $_getIZ(5);
  @$pb.TagNumber(10)
  set unknown10($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(10)
  $core.bool hasUnknown10() => $_has(5);
  @$pb.TagNumber(10)
  void clearUnknown10() => $_clearField(10);
}

class WorkoutOpenWatch extends $pb.GeneratedMessage {
  factory WorkoutOpenWatch({
    $core.int? sport,
    $core.int? unknown2,
  }) {
    final result = create();
    if (sport != null) result.sport = sport;
    if (unknown2 != null) result.unknown2 = unknown2;
    return result;
  }

  WorkoutOpenWatch._();

  factory WorkoutOpenWatch.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutOpenWatch.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutOpenWatch',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'sport', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutOpenWatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutOpenWatch copyWith(void Function(WorkoutOpenWatch) updates) =>
      super.copyWith((message) => updates(message as WorkoutOpenWatch))
          as WorkoutOpenWatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutOpenWatch create() => WorkoutOpenWatch._();
  @$core.override
  WorkoutOpenWatch createEmptyInstance() => create();
  static $pb.PbList<WorkoutOpenWatch> createRepeated() =>
      $pb.PbList<WorkoutOpenWatch>();
  @$core.pragma('dart2js:noInline')
  static WorkoutOpenWatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutOpenWatch>(create);
  static WorkoutOpenWatch? _defaultInstance;

  /// This is only called when gps is needed?
  /// 1 outdoor running, 2 walking, 3 hiking, 4 trekking, 5 trail run, 6 outdoor cycling
  @$pb.TagNumber(1)
  $core.int get sport => $_getIZ(0);
  @$pb.TagNumber(1)
  set sport($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSport() => $_has(0);
  @$pb.TagNumber(1)
  void clearSport() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);
}

class WorkoutOpenReply extends $pb.GeneratedMessage {
  factory WorkoutOpenReply({
    $core.int? unknown1,
    $core.int? unknown2,
    $core.int? unknown3,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (unknown2 != null) result.unknown2 = unknown2;
    if (unknown3 != null) result.unknown3 = unknown3;
    return result;
  }

  WorkoutOpenReply._();

  factory WorkoutOpenReply.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutOpenReply.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutOpenReply',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutOpenReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutOpenReply copyWith(void Function(WorkoutOpenReply) updates) =>
      super.copyWith((message) => updates(message as WorkoutOpenReply))
          as WorkoutOpenReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutOpenReply create() => WorkoutOpenReply._();
  @$core.override
  WorkoutOpenReply createEmptyInstance() => create();
  static $pb.PbList<WorkoutOpenReply> createRepeated() =>
      $pb.PbList<WorkoutOpenReply>();
  @$core.pragma('dart2js:noInline')
  static WorkoutOpenReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutOpenReply>(create);
  static WorkoutOpenReply? _defaultInstance;

  /// 3 2 10 when no gps permissions at all
  /// 5 2 10 when no all time gps permission
  /// ...
  /// 0 * * when phone gps is working fine
  /// 0 2 10
  /// 0 2 2
  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);
}

class GoalsConfig extends $pb.GeneratedMessage {
  factory GoalsConfig({
    $core.Iterable<Goal>? currentGoals,
    $core.Iterable<Goal>? supportedGoals,
  }) {
    final result = create();
    if (currentGoals != null) result.currentGoals.addAll(currentGoals);
    if (supportedGoals != null) result.supportedGoals.addAll(supportedGoals);
    return result;
  }

  GoalsConfig._();

  factory GoalsConfig.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoalsConfig.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'GoalsConfig',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<Goal>(
      1,
      _omitFieldNames ? '' : 'currentGoals',
      protoName: 'currentGoals',
      subBuilder: Goal.create,
    )
    ..pPM<Goal>(
      2,
      _omitFieldNames ? '' : 'supportedGoals',
      protoName: 'supportedGoals',
      subBuilder: Goal.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalsConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoalsConfig copyWith(void Function(GoalsConfig) updates) =>
      super.copyWith((message) => updates(message as GoalsConfig))
          as GoalsConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoalsConfig create() => GoalsConfig._();
  @$core.override
  GoalsConfig createEmptyInstance() => create();
  static $pb.PbList<GoalsConfig> createRepeated() => $pb.PbList<GoalsConfig>();
  @$core.pragma('dart2js:noInline')
  static GoalsConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoalsConfig>(create);
  static GoalsConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Goal> get currentGoals => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Goal> get supportedGoals => $_getList(1);
}

class Goal extends $pb.GeneratedMessage {
  factory Goal({
    $core.int? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  Goal._();

  factory Goal.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Goal.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Goal',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Goal copyWith(void Function(Goal) updates) =>
      super.copyWith((message) => updates(message as Goal)) as Goal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Goal create() => Goal._();
  @$core.override
  Goal createEmptyInstance() => create();
  static $pb.PbList<Goal> createRepeated() => $pb.PbList<Goal>();
  @$core.pragma('dart2js:noInline')
  static Goal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Goal>(create);
  static Goal? _defaultInstance;

  /// 1 steps?
  /// 2 calories?
  /// 3 moving time
  /// 4 standing time
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class WorkoutLocation extends $pb.GeneratedMessage {
  factory WorkoutLocation({
    $core.int? unknown1,
    $core.int? timestamp,
    $core.double? longitude,
    $core.double? latitude,
    $core.double? altitude,
    $core.double? speed,
    $core.double? bearing,
    $core.double? horizontalAccuracy,
    $core.double? verticalAccuracy,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (timestamp != null) result.timestamp = timestamp;
    if (longitude != null) result.longitude = longitude;
    if (latitude != null) result.latitude = latitude;
    if (altitude != null) result.altitude = altitude;
    if (speed != null) result.speed = speed;
    if (bearing != null) result.bearing = bearing;
    if (horizontalAccuracy != null)
      result.horizontalAccuracy = horizontalAccuracy;
    if (verticalAccuracy != null) result.verticalAccuracy = verticalAccuracy;
    return result;
  }

  WorkoutLocation._();

  factory WorkoutLocation.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkoutLocation.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorkoutLocation',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'timestamp', fieldType: $pb.PbFieldType.OU3)
    ..aD(3, _omitFieldNames ? '' : 'longitude')
    ..aD(4, _omitFieldNames ? '' : 'latitude')
    ..aD(5, _omitFieldNames ? '' : 'altitude')
    ..aD(6, _omitFieldNames ? '' : 'speed', fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'bearing', fieldType: $pb.PbFieldType.OF)
    ..aD(
      8,
      _omitFieldNames ? '' : 'horizontalAccuracy',
      protoName: 'horizontalAccuracy',
      fieldType: $pb.PbFieldType.OF,
    )
    ..aD(
      9,
      _omitFieldNames ? '' : 'verticalAccuracy',
      protoName: 'verticalAccuracy',
      fieldType: $pb.PbFieldType.OF,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutLocation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkoutLocation copyWith(void Function(WorkoutLocation) updates) =>
      super.copyWith((message) => updates(message as WorkoutLocation))
          as WorkoutLocation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkoutLocation create() => WorkoutLocation._();
  @$core.override
  WorkoutLocation createEmptyInstance() => create();
  static $pb.PbList<WorkoutLocation> createRepeated() =>
      $pb.PbList<WorkoutLocation>();
  @$core.pragma('dart2js:noInline')
  static WorkoutLocation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkoutLocation>(create);
  static WorkoutLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get timestamp => $_getIZ(1);
  @$pb.TagNumber(2)
  set timestamp($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get altitude => $_getN(4);
  @$pb.TagNumber(5)
  set altitude($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAltitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearAltitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get speed => $_getN(5);
  @$pb.TagNumber(6)
  set speed($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSpeed() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpeed() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get bearing => $_getN(6);
  @$pb.TagNumber(7)
  set bearing($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBearing() => $_has(6);
  @$pb.TagNumber(7)
  void clearBearing() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get horizontalAccuracy => $_getN(7);
  @$pb.TagNumber(8)
  set horizontalAccuracy($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHorizontalAccuracy() => $_has(7);
  @$pb.TagNumber(8)
  void clearHorizontalAccuracy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get verticalAccuracy => $_getN(8);
  @$pb.TagNumber(9)
  set verticalAccuracy($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVerticalAccuracy() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerticalAccuracy() => $_clearField(9);
}

class RealTimeStats extends $pb.GeneratedMessage {
  factory RealTimeStats({
    $core.int? steps,
    $core.int? calories,
    $core.int? unknown3,
    $core.int? heartRate,
    $core.int? unknown5,
    $core.int? standingHours,
  }) {
    final result = create();
    if (steps != null) result.steps = steps;
    if (calories != null) result.calories = calories;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (heartRate != null) result.heartRate = heartRate;
    if (unknown5 != null) result.unknown5 = unknown5;
    if (standingHours != null) result.standingHours = standingHours;
    return result;
  }

  RealTimeStats._();

  factory RealTimeStats.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory RealTimeStats.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'RealTimeStats',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'steps', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'calories', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      4,
      _omitFieldNames ? '' : 'heartRate',
      protoName: 'heartRate',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(5, _omitFieldNames ? '' : 'unknown5', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      6,
      _omitFieldNames ? '' : 'standingHours',
      protoName: 'standingHours',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RealTimeStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RealTimeStats copyWith(void Function(RealTimeStats) updates) =>
      super.copyWith((message) => updates(message as RealTimeStats))
          as RealTimeStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RealTimeStats create() => RealTimeStats._();
  @$core.override
  RealTimeStats createEmptyInstance() => create();
  static $pb.PbList<RealTimeStats> createRepeated() =>
      $pb.PbList<RealTimeStats>();
  @$core.pragma('dart2js:noInline')
  static RealTimeStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RealTimeStats>(create);
  static RealTimeStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get steps => $_getIZ(0);
  @$pb.TagNumber(1)
  set steps($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSteps() => $_has(0);
  @$pb.TagNumber(1)
  void clearSteps() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get calories => $_getIZ(1);
  @$pb.TagNumber(2)
  set calories($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCalories() => $_has(1);
  @$pb.TagNumber(2)
  void clearCalories() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get heartRate => $_getIZ(3);
  @$pb.TagNumber(4)
  set heartRate($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeartRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeartRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unknown5 => $_getIZ(4);
  @$pb.TagNumber(5)
  set unknown5($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnknown5() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnknown5() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get standingHours => $_getIZ(5);
  @$pb.TagNumber(6)
  set standingHours($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStandingHours() => $_has(5);
  @$pb.TagNumber(6)
  void clearStandingHours() => $_clearField(6);
}

class Calendar extends $pb.GeneratedMessage {
  factory Calendar({
    CalendarSync? calendarSync,
  }) {
    final result = create();
    if (calendarSync != null) result.calendarSync = calendarSync;
    return result;
  }

  Calendar._();

  factory Calendar.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Calendar.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Calendar',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<CalendarSync>(
      2,
      _omitFieldNames ? '' : 'calendarSync',
      protoName: 'calendarSync',
      subBuilder: CalendarSync.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Calendar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Calendar copyWith(void Function(Calendar) updates) =>
      super.copyWith((message) => updates(message as Calendar)) as Calendar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Calendar create() => Calendar._();
  @$core.override
  Calendar createEmptyInstance() => create();
  static $pb.PbList<Calendar> createRepeated() => $pb.PbList<Calendar>();
  @$core.pragma('dart2js:noInline')
  static Calendar getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Calendar>(create);
  static Calendar? _defaultInstance;

  @$pb.TagNumber(2)
  CalendarSync get calendarSync => $_getN(0);
  @$pb.TagNumber(2)
  set calendarSync(CalendarSync value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCalendarSync() => $_has(0);
  @$pb.TagNumber(2)
  void clearCalendarSync() => $_clearField(2);
  @$pb.TagNumber(2)
  CalendarSync ensureCalendarSync() => $_ensure(0);
}

class CalendarSync extends $pb.GeneratedMessage {
  factory CalendarSync({
    $core.Iterable<CalendarEvent>? event,
    $core.bool? disabled,
  }) {
    final result = create();
    if (event != null) result.event.addAll(event);
    if (disabled != null) result.disabled = disabled;
    return result;
  }

  CalendarSync._();

  factory CalendarSync.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalendarSync.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'CalendarSync',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<CalendarEvent>(
      1,
      _omitFieldNames ? '' : 'event',
      subBuilder: CalendarEvent.create,
    )
    ..aOB(2, _omitFieldNames ? '' : 'disabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarSync clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarSync copyWith(void Function(CalendarSync) updates) =>
      super.copyWith((message) => updates(message as CalendarSync))
          as CalendarSync;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalendarSync create() => CalendarSync._();
  @$core.override
  CalendarSync createEmptyInstance() => create();
  static $pb.PbList<CalendarSync> createRepeated() =>
      $pb.PbList<CalendarSync>();
  @$core.pragma('dart2js:noInline')
  static CalendarSync getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalendarSync>(create);
  static CalendarSync? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CalendarEvent> get event => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get disabled => $_getBF(1);
  @$pb.TagNumber(2)
  set disabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisabled() => $_clearField(2);
}

class CalendarEvent extends $pb.GeneratedMessage {
  factory CalendarEvent({
    $core.String? title,
    $core.String? description,
    $core.String? location,
    $core.int? start,
    $core.int? end,
    $core.bool? allDay,
    $core.int? notifyMinutesBefore,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (location != null) result.location = location;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (allDay != null) result.allDay = allDay;
    if (notifyMinutesBefore != null)
      result.notifyMinutesBefore = notifyMinutesBefore;
    return result;
  }

  CalendarEvent._();

  factory CalendarEvent.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalendarEvent.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'CalendarEvent',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'location')
    ..aI(4, _omitFieldNames ? '' : 'start', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'end', fieldType: $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'allDay', protoName: 'allDay')
    ..aI(
      7,
      _omitFieldNames ? '' : 'notifyMinutesBefore',
      protoName: 'notifyMinutesBefore',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarEvent copyWith(void Function(CalendarEvent) updates) =>
      super.copyWith((message) => updates(message as CalendarEvent))
          as CalendarEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalendarEvent create() => CalendarEvent._();
  @$core.override
  CalendarEvent createEmptyInstance() => create();
  static $pb.PbList<CalendarEvent> createRepeated() =>
      $pb.PbList<CalendarEvent>();
  @$core.pragma('dart2js:noInline')
  static CalendarEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalendarEvent>(create);
  static CalendarEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get location => $_getSZ(2);
  @$pb.TagNumber(3)
  set location($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get start => $_getIZ(3);
  @$pb.TagNumber(4)
  set start($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get end => $_getIZ(4);
  @$pb.TagNumber(5)
  set end($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get allDay => $_getBF(5);
  @$pb.TagNumber(6)
  set allDay($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllDay() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllDay() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get notifyMinutesBefore => $_getIZ(6);
  @$pb.TagNumber(7)
  set notifyMinutesBefore($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotifyMinutesBefore() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotifyMinutesBefore() => $_clearField(7);
}

class Music extends $pb.GeneratedMessage {
  factory Music({
    MusicInfo? musicInfo,
    MediaKey? mediaKey,
  }) {
    final result = create();
    if (musicInfo != null) result.musicInfo = musicInfo;
    if (mediaKey != null) result.mediaKey = mediaKey;
    return result;
  }

  Music._();

  factory Music.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Music.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Music',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<MusicInfo>(
      1,
      _omitFieldNames ? '' : 'musicInfo',
      protoName: 'musicInfo',
      subBuilder: MusicInfo.create,
    )
    ..aOM<MediaKey>(
      2,
      _omitFieldNames ? '' : 'mediaKey',
      protoName: 'mediaKey',
      subBuilder: MediaKey.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Music clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Music copyWith(void Function(Music) updates) =>
      super.copyWith((message) => updates(message as Music)) as Music;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Music create() => Music._();
  @$core.override
  Music createEmptyInstance() => create();
  static $pb.PbList<Music> createRepeated() => $pb.PbList<Music>();
  @$core.pragma('dart2js:noInline')
  static Music getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Music>(create);
  static Music? _defaultInstance;

  /// 18, 1
  @$pb.TagNumber(1)
  MusicInfo get musicInfo => $_getN(0);
  @$pb.TagNumber(1)
  set musicInfo(MusicInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMusicInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearMusicInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  MusicInfo ensureMusicInfo() => $_ensure(0);

  /// 18, 2
  @$pb.TagNumber(2)
  MediaKey get mediaKey => $_getN(1);
  @$pb.TagNumber(2)
  set mediaKey(MediaKey value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaKey() => $_clearField(2);
  @$pb.TagNumber(2)
  MediaKey ensureMediaKey() => $_ensure(1);
}

class MusicInfo extends $pb.GeneratedMessage {
  factory MusicInfo({
    $core.int? state,
    $core.int? volume,
    $core.String? track,
    $core.String? artist,
    $core.int? position,
    $core.int? duration,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (volume != null) result.volume = volume;
    if (track != null) result.track = track;
    if (artist != null) result.artist = artist;
    if (position != null) result.position = position;
    if (duration != null) result.duration = duration;
    return result;
  }

  MusicInfo._();

  factory MusicInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory MusicInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'MusicInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'state', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'volume', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'track')
    ..aOS(5, _omitFieldNames ? '' : 'artist')
    ..aI(6, _omitFieldNames ? '' : 'position', fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'duration', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicInfo copyWith(void Function(MusicInfo) updates) =>
      super.copyWith((message) => updates(message as MusicInfo)) as MusicInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MusicInfo create() => MusicInfo._();
  @$core.override
  MusicInfo createEmptyInstance() => create();
  static $pb.PbList<MusicInfo> createRepeated() => $pb.PbList<MusicInfo>();
  @$core.pragma('dart2js:noInline')
  static MusicInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MusicInfo>(create);
  static MusicInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get state => $_getIZ(0);
  @$pb.TagNumber(1)
  set state($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get volume => $_getIZ(1);
  @$pb.TagNumber(2)
  set volume($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVolume() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolume() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.String get track => $_getSZ(2);
  @$pb.TagNumber(4)
  set track($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasTrack() => $_has(2);
  @$pb.TagNumber(4)
  void clearTrack() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get artist => $_getSZ(3);
  @$pb.TagNumber(5)
  set artist($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasArtist() => $_has(3);
  @$pb.TagNumber(5)
  void clearArtist() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get position => $_getIZ(4);
  @$pb.TagNumber(6)
  set position($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(6)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(6)
  void clearPosition() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get duration => $_getIZ(5);
  @$pb.TagNumber(7)
  set duration($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasDuration() => $_has(5);
  @$pb.TagNumber(7)
  void clearDuration() => $_clearField(7);
}

class MediaKey extends $pb.GeneratedMessage {
  factory MediaKey({
    $core.int? key,
    $core.int? volume,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (volume != null) result.volume = volume;
    return result;
  }

  MediaKey._();

  factory MediaKey.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaKey.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'MediaKey',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'key', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'volume', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKey copyWith(void Function(MediaKey) updates) =>
      super.copyWith((message) => updates(message as MediaKey)) as MediaKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaKey create() => MediaKey._();
  @$core.override
  MediaKey createEmptyInstance() => create();
  static $pb.PbList<MediaKey> createRepeated() => $pb.PbList<MediaKey>();
  @$core.pragma('dart2js:noInline')
  static MediaKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MediaKey>(create);
  static MediaKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get key => $_getIZ(0);
  @$pb.TagNumber(1)
  set key($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get volume => $_getIZ(1);
  @$pb.TagNumber(2)
  set volume($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVolume() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolume() => $_clearField(2);
}

class Notification extends $pb.GeneratedMessage {
  factory Notification({
    NotificationId? openOnPhone,
    Notification2? notification2,
    NotificationDismiss? notificationDismiss,
    $core.bool? screenOnOnNotifications,
    $core.int? unknown8,
    CannedMessages? cannedMessages,
    NotificationReply? notificationReply,
    $core.int? notificationReplyStatus,
    NotificationIconPackage? notificationIconReply,
    NotificationIconRequest? notificationIconRequest,
    NotificationIconPackage? notificationIconQuery,
  }) {
    final result = create();
    if (openOnPhone != null) result.openOnPhone = openOnPhone;
    if (notification2 != null) result.notification2 = notification2;
    if (notificationDismiss != null)
      result.notificationDismiss = notificationDismiss;
    if (screenOnOnNotifications != null)
      result.screenOnOnNotifications = screenOnOnNotifications;
    if (unknown8 != null) result.unknown8 = unknown8;
    if (cannedMessages != null) result.cannedMessages = cannedMessages;
    if (notificationReply != null) result.notificationReply = notificationReply;
    if (notificationReplyStatus != null)
      result.notificationReplyStatus = notificationReplyStatus;
    if (notificationIconReply != null)
      result.notificationIconReply = notificationIconReply;
    if (notificationIconRequest != null)
      result.notificationIconRequest = notificationIconRequest;
    if (notificationIconQuery != null)
      result.notificationIconQuery = notificationIconQuery;
    return result;
  }

  Notification._();

  factory Notification.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Notification',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<NotificationId>(
      2,
      _omitFieldNames ? '' : 'openOnPhone',
      protoName: 'openOnPhone',
      subBuilder: NotificationId.create,
    )
    ..aOM<Notification2>(
      3,
      _omitFieldNames ? '' : 'notification2',
      subBuilder: Notification2.create,
    )
    ..aOM<NotificationDismiss>(
      4,
      _omitFieldNames ? '' : 'notificationDismiss',
      protoName: 'notificationDismiss',
      subBuilder: NotificationDismiss.create,
    )
    ..aOB(
      7,
      _omitFieldNames ? '' : 'screenOnOnNotifications',
      protoName: 'screenOnOnNotifications',
    )
    ..aI(8, _omitFieldNames ? '' : 'unknown8', fieldType: $pb.PbFieldType.OU3)
    ..aOM<CannedMessages>(
      9,
      _omitFieldNames ? '' : 'cannedMessages',
      protoName: 'cannedMessages',
      subBuilder: CannedMessages.create,
    )
    ..aOM<NotificationReply>(
      12,
      _omitFieldNames ? '' : 'notificationReply',
      protoName: 'notificationReply',
      subBuilder: NotificationReply.create,
    )
    ..aI(
      13,
      _omitFieldNames ? '' : 'notificationReplyStatus',
      protoName: 'notificationReplyStatus',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<NotificationIconPackage>(
      14,
      _omitFieldNames ? '' : 'notificationIconReply',
      protoName: 'notificationIconReply',
      subBuilder: NotificationIconPackage.create,
    )
    ..aOM<NotificationIconRequest>(
      15,
      _omitFieldNames ? '' : 'notificationIconRequest',
      protoName: 'notificationIconRequest',
      subBuilder: NotificationIconRequest.create,
    )
    ..aOM<NotificationIconPackage>(
      16,
      _omitFieldNames ? '' : 'notificationIconQuery',
      protoName: 'notificationIconQuery',
      subBuilder: NotificationIconPackage.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification copyWith(void Function(Notification) updates) =>
      super.copyWith((message) => updates(message as Notification))
          as Notification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification create() => Notification._();
  @$core.override
  Notification createEmptyInstance() => create();
  static $pb.PbList<Notification> createRepeated() =>
      $pb.PbList<Notification>();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification>(create);
  static Notification? _defaultInstance;

  /// 7, 8
  @$pb.TagNumber(2)
  NotificationId get openOnPhone => $_getN(0);
  @$pb.TagNumber(2)
  set openOnPhone(NotificationId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenOnPhone() => $_has(0);
  @$pb.TagNumber(2)
  void clearOpenOnPhone() => $_clearField(2);
  @$pb.TagNumber(2)
  NotificationId ensureOpenOnPhone() => $_ensure(0);

  @$pb.TagNumber(3)
  Notification2 get notification2 => $_getN(1);
  @$pb.TagNumber(3)
  set notification2(Notification2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotification2() => $_has(1);
  @$pb.TagNumber(3)
  void clearNotification2() => $_clearField(3);
  @$pb.TagNumber(3)
  Notification2 ensureNotification2() => $_ensure(1);

  @$pb.TagNumber(4)
  NotificationDismiss get notificationDismiss => $_getN(2);
  @$pb.TagNumber(4)
  set notificationDismiss(NotificationDismiss value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNotificationDismiss() => $_has(2);
  @$pb.TagNumber(4)
  void clearNotificationDismiss() => $_clearField(4);
  @$pb.TagNumber(4)
  NotificationDismiss ensureNotificationDismiss() => $_ensure(2);

  @$pb.TagNumber(7)
  $core.bool get screenOnOnNotifications => $_getBF(3);
  @$pb.TagNumber(7)
  set screenOnOnNotifications($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(7)
  $core.bool hasScreenOnOnNotifications() => $_has(3);
  @$pb.TagNumber(7)
  void clearScreenOnOnNotifications() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get unknown8 => $_getIZ(4);
  @$pb.TagNumber(8)
  set unknown8($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(8)
  $core.bool hasUnknown8() => $_has(4);
  @$pb.TagNumber(8)
  void clearUnknown8() => $_clearField(8);

  /// 7, 9 get | 7, 12 set
  @$pb.TagNumber(9)
  CannedMessages get cannedMessages => $_getN(5);
  @$pb.TagNumber(9)
  set cannedMessages(CannedMessages value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCannedMessages() => $_has(5);
  @$pb.TagNumber(9)
  void clearCannedMessages() => $_clearField(9);
  @$pb.TagNumber(9)
  CannedMessages ensureCannedMessages() => $_ensure(5);

  /// 7, 13
  @$pb.TagNumber(12)
  NotificationReply get notificationReply => $_getN(6);
  @$pb.TagNumber(12)
  set notificationReply(NotificationReply value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasNotificationReply() => $_has(6);
  @$pb.TagNumber(12)
  void clearNotificationReply() => $_clearField(12);
  @$pb.TagNumber(12)
  NotificationReply ensureNotificationReply() => $_ensure(6);

  /// 7, 14
  @$pb.TagNumber(13)
  $core.int get notificationReplyStatus => $_getIZ(7);
  @$pb.TagNumber(13)
  set notificationReplyStatus($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(13)
  $core.bool hasNotificationReplyStatus() => $_has(7);
  @$pb.TagNumber(13)
  void clearNotificationReplyStatus() => $_clearField(13);

  /// 7, 15
  @$pb.TagNumber(14)
  NotificationIconPackage get notificationIconReply => $_getN(8);
  @$pb.TagNumber(14)
  set notificationIconReply(NotificationIconPackage value) =>
      $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasNotificationIconReply() => $_has(8);
  @$pb.TagNumber(14)
  void clearNotificationIconReply() => $_clearField(14);
  @$pb.TagNumber(14)
  NotificationIconPackage ensureNotificationIconReply() => $_ensure(8);

  /// 7, 15
  @$pb.TagNumber(15)
  NotificationIconRequest get notificationIconRequest => $_getN(9);
  @$pb.TagNumber(15)
  set notificationIconRequest(NotificationIconRequest value) =>
      $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasNotificationIconRequest() => $_has(9);
  @$pb.TagNumber(15)
  void clearNotificationIconRequest() => $_clearField(15);
  @$pb.TagNumber(15)
  NotificationIconRequest ensureNotificationIconRequest() => $_ensure(9);

  /// 7, 16
  @$pb.TagNumber(16)
  NotificationIconPackage get notificationIconQuery => $_getN(10);
  @$pb.TagNumber(16)
  set notificationIconQuery(NotificationIconPackage value) =>
      $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasNotificationIconQuery() => $_has(10);
  @$pb.TagNumber(16)
  void clearNotificationIconQuery() => $_clearField(16);
  @$pb.TagNumber(16)
  NotificationIconPackage ensureNotificationIconQuery() => $_ensure(10);
}

class Notification2 extends $pb.GeneratedMessage {
  factory Notification2({
    Notification3? notification3,
  }) {
    final result = create();
    if (notification3 != null) result.notification3 = notification3;
    return result;
  }

  Notification2._();

  factory Notification2.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification2.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Notification2',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<Notification3>(
      1,
      _omitFieldNames ? '' : 'notification3',
      subBuilder: Notification3.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification2 copyWith(void Function(Notification2) updates) =>
      super.copyWith((message) => updates(message as Notification2))
          as Notification2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification2 create() => Notification2._();
  @$core.override
  Notification2 createEmptyInstance() => create();
  static $pb.PbList<Notification2> createRepeated() =>
      $pb.PbList<Notification2>();
  @$core.pragma('dart2js:noInline')
  static Notification2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification2>(create);
  static Notification2? _defaultInstance;

  @$pb.TagNumber(1)
  Notification3 get notification3 => $_getN(0);
  @$pb.TagNumber(1)
  set notification3(Notification3 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotification3() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotification3() => $_clearField(1);
  @$pb.TagNumber(1)
  Notification3 ensureNotification3() => $_ensure(0);
}

class Notification3 extends $pb.GeneratedMessage {
  factory Notification3({
    $core.String? package,
    $core.String? appName,
    $core.String? title,
    $core.String? unknown4,
    $core.String? body,
    $core.String? timestamp,
    $core.int? id,
    $core.bool? isCall,
    $core.bool? repliesAllowed,
    $core.String? key,
    $core.bool? openOnPhone,
  }) {
    final result = create();
    if (package != null) result.package = package;
    if (appName != null) result.appName = appName;
    if (title != null) result.title = title;
    if (unknown4 != null) result.unknown4 = unknown4;
    if (body != null) result.body = body;
    if (timestamp != null) result.timestamp = timestamp;
    if (id != null) result.id = id;
    if (isCall != null) result.isCall = isCall;
    if (repliesAllowed != null) result.repliesAllowed = repliesAllowed;
    if (key != null) result.key = key;
    if (openOnPhone != null) result.openOnPhone = openOnPhone;
    return result;
  }

  Notification3._();

  factory Notification3.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification3.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Notification3',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'package')
    ..aOS(2, _omitFieldNames ? '' : 'appName', protoName: 'appName')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'unknown4')
    ..aOS(5, _omitFieldNames ? '' : 'body')
    ..aOS(6, _omitFieldNames ? '' : 'timestamp')
    ..aI(7, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'isCall', protoName: 'isCall')
    ..aOB(
      11,
      _omitFieldNames ? '' : 'repliesAllowed',
      protoName: 'repliesAllowed',
    )
    ..aOS(12, _omitFieldNames ? '' : 'key')
    ..aOB(13, _omitFieldNames ? '' : 'openOnPhone', protoName: 'openOnPhone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification3 copyWith(void Function(Notification3) updates) =>
      super.copyWith((message) => updates(message as Notification3))
          as Notification3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification3 create() => Notification3._();
  @$core.override
  Notification3 createEmptyInstance() => create();
  static $pb.PbList<Notification3> createRepeated() =>
      $pb.PbList<Notification3>();
  @$core.pragma('dart2js:noInline')
  static Notification3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification3>(create);
  static Notification3? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get package => $_getSZ(0);
  @$pb.TagNumber(1)
  set package($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get appName => $_getSZ(1);
  @$pb.TagNumber(2)
  set appName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppName() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unknown4 => $_getSZ(3);
  @$pb.TagNumber(4)
  set unknown4($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown4() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown4() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get body => $_getSZ(4);
  @$pb.TagNumber(5)
  set body($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBody() => $_has(4);
  @$pb.TagNumber(5)
  void clearBody() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get timestamp => $_getSZ(5);
  @$pb.TagNumber(6)
  set timestamp($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get id => $_getIZ(6);
  @$pb.TagNumber(7)
  set id($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasId() => $_has(6);
  @$pb.TagNumber(7)
  void clearId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isCall => $_getBF(7);
  @$pb.TagNumber(8)
  set isCall($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsCall() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsCall() => $_clearField(8);

  @$pb.TagNumber(11)
  $core.bool get repliesAllowed => $_getBF(8);
  @$pb.TagNumber(11)
  set repliesAllowed($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(11)
  $core.bool hasRepliesAllowed() => $_has(8);
  @$pb.TagNumber(11)
  void clearRepliesAllowed() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get key => $_getSZ(9);
  @$pb.TagNumber(12)
  set key($core.String value) => $_setString(9, value);
  @$pb.TagNumber(12)
  $core.bool hasKey() => $_has(9);
  @$pb.TagNumber(12)
  void clearKey() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get openOnPhone => $_getBF(10);
  @$pb.TagNumber(13)
  set openOnPhone($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(13)
  $core.bool hasOpenOnPhone() => $_has(10);
  @$pb.TagNumber(13)
  void clearOpenOnPhone() => $_clearField(13);
}

class NotificationDismiss extends $pb.GeneratedMessage {
  factory NotificationDismiss({
    $core.Iterable<NotificationId>? notificationId,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId.addAll(notificationId);
    return result;
  }

  NotificationDismiss._();

  factory NotificationDismiss.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationDismiss.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'NotificationDismiss',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<NotificationId>(
      1,
      _omitFieldNames ? '' : 'notificationId',
      protoName: 'notificationId',
      subBuilder: NotificationId.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationDismiss clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationDismiss copyWith(void Function(NotificationDismiss) updates) =>
      super.copyWith((message) => updates(message as NotificationDismiss))
          as NotificationDismiss;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationDismiss create() => NotificationDismiss._();
  @$core.override
  NotificationDismiss createEmptyInstance() => create();
  static $pb.PbList<NotificationDismiss> createRepeated() =>
      $pb.PbList<NotificationDismiss>();
  @$core.pragma('dart2js:noInline')
  static NotificationDismiss getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationDismiss>(create);
  static NotificationDismiss? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NotificationId> get notificationId => $_getList(0);
}

class NotificationId extends $pb.GeneratedMessage {
  factory NotificationId({
    $core.int? id,
    $core.String? package,
    $core.String? key,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (package != null) result.package = package;
    if (key != null) result.key = key;
    return result;
  }

  NotificationId._();

  factory NotificationId.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationId.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'NotificationId',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'package')
    ..aOS(4, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationId copyWith(void Function(NotificationId) updates) =>
      super.copyWith((message) => updates(message as NotificationId))
          as NotificationId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationId create() => NotificationId._();
  @$core.override
  NotificationId createEmptyInstance() => create();
  static $pb.PbList<NotificationId> createRepeated() =>
      $pb.PbList<NotificationId>();
  @$core.pragma('dart2js:noInline')
  static NotificationId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationId>(create);
  static NotificationId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get package => $_getSZ(1);
  @$pb.TagNumber(2)
  set package($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackage() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.String get key => $_getSZ(2);
  @$pb.TagNumber(4)
  set key($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasKey() => $_has(2);
  @$pb.TagNumber(4)
  void clearKey() => $_clearField(4);
}

class CannedMessages extends $pb.GeneratedMessage {
  factory CannedMessages({
    $core.int? minReplies,
    $core.Iterable<$core.String>? reply,
    $core.int? maxReplies,
  }) {
    final result = create();
    if (minReplies != null) result.minReplies = minReplies;
    if (reply != null) result.reply.addAll(reply);
    if (maxReplies != null) result.maxReplies = maxReplies;
    return result;
  }

  CannedMessages._();

  factory CannedMessages.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory CannedMessages.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'CannedMessages',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'minReplies',
      protoName: 'minReplies',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..pPS(2, _omitFieldNames ? '' : 'reply')
    ..aI(
      3,
      _omitFieldNames ? '' : 'maxReplies',
      protoName: 'maxReplies',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CannedMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CannedMessages copyWith(void Function(CannedMessages) updates) =>
      super.copyWith((message) => updates(message as CannedMessages))
          as CannedMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CannedMessages create() => CannedMessages._();
  @$core.override
  CannedMessages createEmptyInstance() => create();
  static $pb.PbList<CannedMessages> createRepeated() =>
      $pb.PbList<CannedMessages>();
  @$core.pragma('dart2js:noInline')
  static CannedMessages getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CannedMessages>(create);
  static CannedMessages? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minReplies => $_getIZ(0);
  @$pb.TagNumber(1)
  set minReplies($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinReplies() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinReplies() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get reply => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get maxReplies => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxReplies($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxReplies() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxReplies() => $_clearField(3);
}

class NotificationIconRequest extends $pb.GeneratedMessage {
  factory NotificationIconRequest({
    $core.int? status,
    $core.int? pixelFormat,
    $core.int? size,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (pixelFormat != null) result.pixelFormat = pixelFormat;
    if (size != null) result.size = size;
    return result;
  }

  NotificationIconRequest._();

  factory NotificationIconRequest.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationIconRequest.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'NotificationIconRequest',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      2,
      _omitFieldNames ? '' : 'pixelFormat',
      protoName: 'pixelFormat',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(3, _omitFieldNames ? '' : 'size', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationIconRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationIconRequest copyWith(
    void Function(NotificationIconRequest) updates,
  ) =>
      super.copyWith((message) => updates(message as NotificationIconRequest))
          as NotificationIconRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationIconRequest create() => NotificationIconRequest._();
  @$core.override
  NotificationIconRequest createEmptyInstance() => create();
  static $pb.PbList<NotificationIconRequest> createRepeated() =>
      $pb.PbList<NotificationIconRequest>();
  @$core.pragma('dart2js:noInline')
  static NotificationIconRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationIconRequest>(create);
  static NotificationIconRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pixelFormat => $_getIZ(1);
  @$pb.TagNumber(2)
  set pixelFormat($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPixelFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearPixelFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);
}

class NotificationReply extends $pb.GeneratedMessage {
  factory NotificationReply({
    $core.int? unknown1,
    $core.String? message,
    $core.int? unknown3,
    $core.String? number,
  }) {
    final result = create();
    if (unknown1 != null) result.unknown1 = unknown1;
    if (message != null) result.message = message;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (number != null) result.number = number;
    return result;
  }

  NotificationReply._();

  factory NotificationReply.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationReply.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'NotificationReply',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'unknown1', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'number')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationReply copyWith(void Function(NotificationReply) updates) =>
      super.copyWith((message) => updates(message as NotificationReply))
          as NotificationReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationReply create() => NotificationReply._();
  @$core.override
  NotificationReply createEmptyInstance() => create();
  static $pb.PbList<NotificationReply> createRepeated() =>
      $pb.PbList<NotificationReply>();
  @$core.pragma('dart2js:noInline')
  static NotificationReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationReply>(create);
  static NotificationReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unknown1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set unknown1($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnknown1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnknown1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get number => $_getSZ(3);
  @$pb.TagNumber(4)
  set number($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearNumber() => $_clearField(4);
}

class NotificationIconPackage extends $pb.GeneratedMessage {
  factory NotificationIconPackage({
    $core.String? package,
  }) {
    final result = create();
    if (package != null) result.package = package;
    return result;
  }

  NotificationIconPackage._();

  factory NotificationIconPackage.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationIconPackage.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'NotificationIconPackage',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'package')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationIconPackage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationIconPackage copyWith(
    void Function(NotificationIconPackage) updates,
  ) =>
      super.copyWith((message) => updates(message as NotificationIconPackage))
          as NotificationIconPackage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationIconPackage create() => NotificationIconPackage._();
  @$core.override
  NotificationIconPackage createEmptyInstance() => create();
  static $pb.PbList<NotificationIconPackage> createRepeated() =>
      $pb.PbList<NotificationIconPackage>();
  @$core.pragma('dart2js:noInline')
  static NotificationIconPackage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationIconPackage>(create);
  static NotificationIconPackage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get package => $_getSZ(0);
  @$pb.TagNumber(1)
  set package($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackage() => $_clearField(1);
}

class Weather extends $pb.GeneratedMessage {
  factory Weather({
    WeatherCurrent? current,
    WeatherForecast? forecast,
    WeatherLocations? locations,
    WeatherLocation? location,
    WeatherPrefs? prefs,
  }) {
    final result = create();
    if (current != null) result.current = current;
    if (forecast != null) result.forecast = forecast;
    if (locations != null) result.locations = locations;
    if (location != null) result.location = location;
    if (prefs != null) result.prefs = prefs;
    return result;
  }

  Weather._();

  factory Weather.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Weather.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Weather',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<WeatherCurrent>(
      1,
      _omitFieldNames ? '' : 'current',
      subBuilder: WeatherCurrent.create,
    )
    ..aOM<WeatherForecast>(
      2,
      _omitFieldNames ? '' : 'forecast',
      subBuilder: WeatherForecast.create,
    )
    ..aOM<WeatherLocations>(
      4,
      _omitFieldNames ? '' : 'locations',
      subBuilder: WeatherLocations.create,
    )
    ..aOM<WeatherLocation>(
      5,
      _omitFieldNames ? '' : 'location',
      subBuilder: WeatherLocation.create,
    )
    ..aOM<WeatherPrefs>(
      6,
      _omitFieldNames ? '' : 'prefs',
      subBuilder: WeatherPrefs.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Weather clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Weather copyWith(void Function(Weather) updates) =>
      super.copyWith((message) => updates(message as Weather)) as Weather;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Weather create() => Weather._();
  @$core.override
  Weather createEmptyInstance() => create();
  static $pb.PbList<Weather> createRepeated() => $pb.PbList<Weather>();
  @$core.pragma('dart2js:noInline')
  static Weather getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Weather>(create);
  static Weather? _defaultInstance;

  @$pb.TagNumber(1)
  WeatherCurrent get current => $_getN(0);
  @$pb.TagNumber(1)
  set current(WeatherCurrent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrent() => $_clearField(1);
  @$pb.TagNumber(1)
  WeatherCurrent ensureCurrent() => $_ensure(0);

  @$pb.TagNumber(2)
  WeatherForecast get forecast => $_getN(1);
  @$pb.TagNumber(2)
  set forecast(WeatherForecast value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasForecast() => $_has(1);
  @$pb.TagNumber(2)
  void clearForecast() => $_clearField(2);
  @$pb.TagNumber(2)
  WeatherForecast ensureForecast() => $_ensure(1);

  /// response to 10, 5 (get location list) | payload of 10, 6 (set, update location list) | payload of 10, 8 (remove)
  @$pb.TagNumber(4)
  WeatherLocations get locations => $_getN(2);
  @$pb.TagNumber(4)
  set locations(WeatherLocations value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLocations() => $_has(2);
  @$pb.TagNumber(4)
  void clearLocations() => $_clearField(4);
  @$pb.TagNumber(4)
  WeatherLocations ensureLocations() => $_ensure(2);

  /// indication payload of 10, 3 (requested update) | payload of 10, 7 (set current, add to list)
  @$pb.TagNumber(5)
  WeatherLocation get location => $_getN(3);
  @$pb.TagNumber(5)
  set location(WeatherLocation value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(5)
  void clearLocation() => $_clearField(5);
  @$pb.TagNumber(5)
  WeatherLocation ensureLocation() => $_ensure(3);

  /// 10, 10
  @$pb.TagNumber(6)
  WeatherPrefs get prefs => $_getN(4);
  @$pb.TagNumber(6)
  set prefs(WeatherPrefs value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPrefs() => $_has(4);
  @$pb.TagNumber(6)
  void clearPrefs() => $_clearField(6);
  @$pb.TagNumber(6)
  WeatherPrefs ensurePrefs() => $_ensure(4);
}

class WeatherCurrent extends $pb.GeneratedMessage {
  factory WeatherCurrent({
    WeatherMetadata? metadata,
    $core.int? weatherCondition,
    WeatherUnitValue? temperature,
    WeatherUnitValue? humidity,
    WeatherUnitValue? wind,
    WeatherUnitValue? uv,
    WeatherUnitValue? aqi,
    WeatherWarnings? warning,
    $core.double? pressure,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    if (weatherCondition != null) result.weatherCondition = weatherCondition;
    if (temperature != null) result.temperature = temperature;
    if (humidity != null) result.humidity = humidity;
    if (wind != null) result.wind = wind;
    if (uv != null) result.uv = uv;
    if (aqi != null) result.aqi = aqi;
    if (warning != null) result.warning = warning;
    if (pressure != null) result.pressure = pressure;
    return result;
  }

  WeatherCurrent._();

  factory WeatherCurrent.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherCurrent.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherCurrent',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<WeatherMetadata>(
      1,
      _omitFieldNames ? '' : 'metadata',
      subBuilder: WeatherMetadata.create,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'weatherCondition',
      protoName: 'weatherCondition',
      fieldType: $pb.PbFieldType.QU3,
    )
    ..aOM<WeatherUnitValue>(
      3,
      _omitFieldNames ? '' : 'temperature',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherUnitValue>(
      4,
      _omitFieldNames ? '' : 'humidity',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherUnitValue>(
      5,
      _omitFieldNames ? '' : 'wind',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherUnitValue>(
      6,
      _omitFieldNames ? '' : 'uv',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherUnitValue>(
      7,
      _omitFieldNames ? '' : 'aqi',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherWarnings>(
      8,
      _omitFieldNames ? '' : 'warning',
      subBuilder: WeatherWarnings.create,
    )
    ..aD(9, _omitFieldNames ? '' : 'pressure', fieldType: $pb.PbFieldType.OF);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherCurrent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherCurrent copyWith(void Function(WeatherCurrent) updates) =>
      super.copyWith((message) => updates(message as WeatherCurrent))
          as WeatherCurrent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherCurrent create() => WeatherCurrent._();
  @$core.override
  WeatherCurrent createEmptyInstance() => create();
  static $pb.PbList<WeatherCurrent> createRepeated() =>
      $pb.PbList<WeatherCurrent>();
  @$core.pragma('dart2js:noInline')
  static WeatherCurrent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherCurrent>(create);
  static WeatherCurrent? _defaultInstance;

  @$pb.TagNumber(1)
  WeatherMetadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(WeatherMetadata value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => $_clearField(1);
  @$pb.TagNumber(1)
  WeatherMetadata ensureMetadata() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get weatherCondition => $_getIZ(1);
  @$pb.TagNumber(2)
  set weatherCondition($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeatherCondition() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeatherCondition() => $_clearField(2);

  @$pb.TagNumber(3)
  WeatherUnitValue get temperature => $_getN(2);
  @$pb.TagNumber(3)
  set temperature(WeatherUnitValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTemperature() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemperature() => $_clearField(3);
  @$pb.TagNumber(3)
  WeatherUnitValue ensureTemperature() => $_ensure(2);

  @$pb.TagNumber(4)
  WeatherUnitValue get humidity => $_getN(3);
  @$pb.TagNumber(4)
  set humidity(WeatherUnitValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasHumidity() => $_has(3);
  @$pb.TagNumber(4)
  void clearHumidity() => $_clearField(4);
  @$pb.TagNumber(4)
  WeatherUnitValue ensureHumidity() => $_ensure(3);

  @$pb.TagNumber(5)
  WeatherUnitValue get wind => $_getN(4);
  @$pb.TagNumber(5)
  set wind(WeatherUnitValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWind() => $_has(4);
  @$pb.TagNumber(5)
  void clearWind() => $_clearField(5);
  @$pb.TagNumber(5)
  WeatherUnitValue ensureWind() => $_ensure(4);

  @$pb.TagNumber(6)
  WeatherUnitValue get uv => $_getN(5);
  @$pb.TagNumber(6)
  set uv(WeatherUnitValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUv() => $_has(5);
  @$pb.TagNumber(6)
  void clearUv() => $_clearField(6);
  @$pb.TagNumber(6)
  WeatherUnitValue ensureUv() => $_ensure(5);

  @$pb.TagNumber(7)
  WeatherUnitValue get aqi => $_getN(6);
  @$pb.TagNumber(7)
  set aqi(WeatherUnitValue value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAqi() => $_has(6);
  @$pb.TagNumber(7)
  void clearAqi() => $_clearField(7);
  @$pb.TagNumber(7)
  WeatherUnitValue ensureAqi() => $_ensure(6);

  @$pb.TagNumber(8)
  WeatherWarnings get warning => $_getN(7);
  @$pb.TagNumber(8)
  set warning(WeatherWarnings value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWarning() => $_has(7);
  @$pb.TagNumber(8)
  void clearWarning() => $_clearField(8);
  @$pb.TagNumber(8)
  WeatherWarnings ensureWarning() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.double get pressure => $_getN(8);
  @$pb.TagNumber(9)
  set pressure($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPressure() => $_has(8);
  @$pb.TagNumber(9)
  void clearPressure() => $_clearField(9);
}

class WeatherMetadata extends $pb.GeneratedMessage {
  factory WeatherMetadata({
    $core.String? publicationTimestamp,
    $core.String? cityName,
    $core.String? locationName,
    $core.String? locationKey,
    $core.bool? isCurrentLocation,
  }) {
    final result = create();
    if (publicationTimestamp != null)
      result.publicationTimestamp = publicationTimestamp;
    if (cityName != null) result.cityName = cityName;
    if (locationName != null) result.locationName = locationName;
    if (locationKey != null) result.locationKey = locationKey;
    if (isCurrentLocation != null) result.isCurrentLocation = isCurrentLocation;
    return result;
  }

  WeatherMetadata._();

  factory WeatherMetadata.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherMetadata.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherMetadata',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(
      1,
      _omitFieldNames ? '' : 'publicationTimestamp',
      protoName: 'publicationTimestamp',
    )
    ..aQS(2, _omitFieldNames ? '' : 'cityName', protoName: 'cityName')
    ..aQS(3, _omitFieldNames ? '' : 'locationName', protoName: 'locationName')
    ..aOS(4, _omitFieldNames ? '' : 'locationKey', protoName: 'locationKey')
    ..aOB(
      5,
      _omitFieldNames ? '' : 'isCurrentLocation',
      protoName: 'isCurrentLocation',
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherMetadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherMetadata copyWith(void Function(WeatherMetadata) updates) =>
      super.copyWith((message) => updates(message as WeatherMetadata))
          as WeatherMetadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherMetadata create() => WeatherMetadata._();
  @$core.override
  WeatherMetadata createEmptyInstance() => create();
  static $pb.PbList<WeatherMetadata> createRepeated() =>
      $pb.PbList<WeatherMetadata>();
  @$core.pragma('dart2js:noInline')
  static WeatherMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherMetadata>(create);
  static WeatherMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publicationTimestamp => $_getSZ(0);
  @$pb.TagNumber(1)
  set publicationTimestamp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicationTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicationTimestamp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set cityName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationName => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationName() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isCurrentLocation => $_getBF(4);
  @$pb.TagNumber(5)
  set isCurrentLocation($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsCurrentLocation() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsCurrentLocation() => $_clearField(5);
}

class WeatherUnitValue extends $pb.GeneratedMessage {
  factory WeatherUnitValue({
    $core.String? unit,
    $core.int? value,
  }) {
    final result = create();
    if (unit != null) result.unit = unit;
    if (value != null) result.value = value;
    return result;
  }

  WeatherUnitValue._();

  factory WeatherUnitValue.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherUnitValue.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherUnitValue',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(1, _omitFieldNames ? '' : 'unit')
    ..aI(2, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.QS3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherUnitValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherUnitValue copyWith(void Function(WeatherUnitValue) updates) =>
      super.copyWith((message) => updates(message as WeatherUnitValue))
          as WeatherUnitValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherUnitValue create() => WeatherUnitValue._();
  @$core.override
  WeatherUnitValue createEmptyInstance() => create();
  static $pb.PbList<WeatherUnitValue> createRepeated() =>
      $pb.PbList<WeatherUnitValue>();
  @$core.pragma('dart2js:noInline')
  static WeatherUnitValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherUnitValue>(create);
  static WeatherUnitValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unit => $_getSZ(0);
  @$pb.TagNumber(1)
  set unit($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnit() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnit() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get value => $_getIZ(1);
  @$pb.TagNumber(2)
  set value($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class WeatherWarnings extends $pb.GeneratedMessage {
  factory WeatherWarnings({
    $core.Iterable<WeatherWarning>? warning,
  }) {
    final result = create();
    if (warning != null) result.warning.addAll(warning);
    return result;
  }

  WeatherWarnings._();

  factory WeatherWarnings.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherWarnings.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherWarnings',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..pPM<WeatherWarning>(
      1,
      _omitFieldNames ? '' : 'warning',
      subBuilder: WeatherWarning.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherWarnings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherWarnings copyWith(void Function(WeatherWarnings) updates) =>
      super.copyWith((message) => updates(message as WeatherWarnings))
          as WeatherWarnings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherWarnings create() => WeatherWarnings._();
  @$core.override
  WeatherWarnings createEmptyInstance() => create();
  static $pb.PbList<WeatherWarnings> createRepeated() =>
      $pb.PbList<WeatherWarnings>();
  @$core.pragma('dart2js:noInline')
  static WeatherWarnings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherWarnings>(create);
  static WeatherWarnings? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WeatherWarning> get warning => $_getList(0);
}

class WeatherWarning extends $pb.GeneratedMessage {
  factory WeatherWarning({
    $core.String? type,
    $core.String? level,
    $core.String? title,
    $core.String? description,
    $core.String? id,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (level != null) result.level = level;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (id != null) result.id = id;
    return result;
  }

  WeatherWarning._();

  factory WeatherWarning.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherWarning.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherWarning',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(1, _omitFieldNames ? '' : 'type')
    ..aQS(2, _omitFieldNames ? '' : 'level')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'id');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherWarning clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherWarning copyWith(void Function(WeatherWarning) updates) =>
      super.copyWith((message) => updates(message as WeatherWarning))
          as WeatherWarning;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherWarning create() => WeatherWarning._();
  @$core.override
  WeatherWarning createEmptyInstance() => create();
  static $pb.PbList<WeatherWarning> createRepeated() =>
      $pb.PbList<WeatherWarning>();
  @$core.pragma('dart2js:noInline')
  static WeatherWarning getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherWarning>(create);
  static WeatherWarning? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get level => $_getSZ(1);
  @$pb.TagNumber(2)
  set level($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get id => $_getSZ(4);
  @$pb.TagNumber(5)
  set id($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => $_clearField(5);
}

class WeatherLocations extends $pb.GeneratedMessage {
  factory WeatherLocations({
    $core.Iterable<WeatherLocation>? location,
  }) {
    final result = create();
    if (location != null) result.location.addAll(location);
    return result;
  }

  WeatherLocations._();

  factory WeatherLocations.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherLocations.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherLocations',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..pPM<WeatherLocation>(
      1,
      _omitFieldNames ? '' : 'location',
      subBuilder: WeatherLocation.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherLocations clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherLocations copyWith(void Function(WeatherLocations) updates) =>
      super.copyWith((message) => updates(message as WeatherLocations))
          as WeatherLocations;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherLocations create() => WeatherLocations._();
  @$core.override
  WeatherLocations createEmptyInstance() => create();
  static $pb.PbList<WeatherLocations> createRepeated() =>
      $pb.PbList<WeatherLocations>();
  @$core.pragma('dart2js:noInline')
  static WeatherLocations getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherLocations>(create);
  static WeatherLocations? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WeatherLocation> get location => $_getList(0);
}

class WeatherForecast extends $pb.GeneratedMessage {
  factory WeatherForecast({
    WeatherMetadata? metadata,
    ForecastEntries? entries,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    if (entries != null) result.entries = entries;
    return result;
  }

  WeatherForecast._();

  factory WeatherForecast.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherForecast.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherForecast',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQM<WeatherMetadata>(
      1,
      _omitFieldNames ? '' : 'metadata',
      subBuilder: WeatherMetadata.create,
    )
    ..aQM<ForecastEntries>(
      2,
      _omitFieldNames ? '' : 'entries',
      subBuilder: ForecastEntries.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherForecast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherForecast copyWith(void Function(WeatherForecast) updates) =>
      super.copyWith((message) => updates(message as WeatherForecast))
          as WeatherForecast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherForecast create() => WeatherForecast._();
  @$core.override
  WeatherForecast createEmptyInstance() => create();
  static $pb.PbList<WeatherForecast> createRepeated() =>
      $pb.PbList<WeatherForecast>();
  @$core.pragma('dart2js:noInline')
  static WeatherForecast getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherForecast>(create);
  static WeatherForecast? _defaultInstance;

  @$pb.TagNumber(1)
  WeatherMetadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(WeatherMetadata value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => $_clearField(1);
  @$pb.TagNumber(1)
  WeatherMetadata ensureMetadata() => $_ensure(0);

  @$pb.TagNumber(2)
  ForecastEntries get entries => $_getN(1);
  @$pb.TagNumber(2)
  set entries(ForecastEntries value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntries() => $_clearField(2);
  @$pb.TagNumber(2)
  ForecastEntries ensureEntries() => $_ensure(1);
}

class ForecastEntries extends $pb.GeneratedMessage {
  factory ForecastEntries({
    $core.Iterable<ForecastEntry>? entry,
  }) {
    final result = create();
    if (entry != null) result.entry.addAll(entry);
    return result;
  }

  ForecastEntries._();

  factory ForecastEntries.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ForecastEntries.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ForecastEntries',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )..pPM<ForecastEntry>(
      1,
      _omitFieldNames ? '' : 'entry',
      subBuilder: ForecastEntry.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForecastEntries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForecastEntries copyWith(void Function(ForecastEntries) updates) =>
      super.copyWith((message) => updates(message as ForecastEntries))
          as ForecastEntries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ForecastEntries create() => ForecastEntries._();
  @$core.override
  ForecastEntries createEmptyInstance() => create();
  static $pb.PbList<ForecastEntries> createRepeated() =>
      $pb.PbList<ForecastEntries>();
  @$core.pragma('dart2js:noInline')
  static ForecastEntries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForecastEntries>(create);
  static ForecastEntries? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ForecastEntry> get entry => $_getList(0);
}

class ForecastEntry extends $pb.GeneratedMessage {
  factory ForecastEntry({
    WeatherUnitValue? aqi,
    WeatherRange? conditionRange,
    WeatherRange? temperatureRange,
    $core.String? temperatureSymbol,
    WeatherSunriseSunset? sunriseSunset,
    WeatherUnitValue? wind,
  }) {
    final result = create();
    if (aqi != null) result.aqi = aqi;
    if (conditionRange != null) result.conditionRange = conditionRange;
    if (temperatureRange != null) result.temperatureRange = temperatureRange;
    if (temperatureSymbol != null) result.temperatureSymbol = temperatureSymbol;
    if (sunriseSunset != null) result.sunriseSunset = sunriseSunset;
    if (wind != null) result.wind = wind;
    return result;
  }

  ForecastEntry._();

  factory ForecastEntry.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ForecastEntry.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ForecastEntry',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<WeatherUnitValue>(
      1,
      _omitFieldNames ? '' : 'aqi',
      subBuilder: WeatherUnitValue.create,
    )
    ..aOM<WeatherRange>(
      2,
      _omitFieldNames ? '' : 'conditionRange',
      protoName: 'conditionRange',
      subBuilder: WeatherRange.create,
    )
    ..aOM<WeatherRange>(
      3,
      _omitFieldNames ? '' : 'temperatureRange',
      protoName: 'temperatureRange',
      subBuilder: WeatherRange.create,
    )
    ..aOS(
      4,
      _omitFieldNames ? '' : 'temperatureSymbol',
      protoName: 'temperatureSymbol',
    )
    ..aOM<WeatherSunriseSunset>(
      5,
      _omitFieldNames ? '' : 'sunriseSunset',
      protoName: 'sunriseSunset',
      subBuilder: WeatherSunriseSunset.create,
    )
    ..aOM<WeatherUnitValue>(
      6,
      _omitFieldNames ? '' : 'wind',
      subBuilder: WeatherUnitValue.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForecastEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForecastEntry copyWith(void Function(ForecastEntry) updates) =>
      super.copyWith((message) => updates(message as ForecastEntry))
          as ForecastEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ForecastEntry create() => ForecastEntry._();
  @$core.override
  ForecastEntry createEmptyInstance() => create();
  static $pb.PbList<ForecastEntry> createRepeated() =>
      $pb.PbList<ForecastEntry>();
  @$core.pragma('dart2js:noInline')
  static ForecastEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForecastEntry>(create);
  static ForecastEntry? _defaultInstance;

  @$pb.TagNumber(1)
  WeatherUnitValue get aqi => $_getN(0);
  @$pb.TagNumber(1)
  set aqi(WeatherUnitValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAqi() => $_has(0);
  @$pb.TagNumber(1)
  void clearAqi() => $_clearField(1);
  @$pb.TagNumber(1)
  WeatherUnitValue ensureAqi() => $_ensure(0);

  @$pb.TagNumber(2)
  WeatherRange get conditionRange => $_getN(1);
  @$pb.TagNumber(2)
  set conditionRange(WeatherRange value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConditionRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearConditionRange() => $_clearField(2);
  @$pb.TagNumber(2)
  WeatherRange ensureConditionRange() => $_ensure(1);

  @$pb.TagNumber(3)
  WeatherRange get temperatureRange => $_getN(2);
  @$pb.TagNumber(3)
  set temperatureRange(WeatherRange value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTemperatureRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemperatureRange() => $_clearField(3);
  @$pb.TagNumber(3)
  WeatherRange ensureTemperatureRange() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get temperatureSymbol => $_getSZ(3);
  @$pb.TagNumber(4)
  set temperatureSymbol($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemperatureSymbol() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperatureSymbol() => $_clearField(4);

  @$pb.TagNumber(5)
  WeatherSunriseSunset get sunriseSunset => $_getN(4);
  @$pb.TagNumber(5)
  set sunriseSunset(WeatherSunriseSunset value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSunriseSunset() => $_has(4);
  @$pb.TagNumber(5)
  void clearSunriseSunset() => $_clearField(5);
  @$pb.TagNumber(5)
  WeatherSunriseSunset ensureSunriseSunset() => $_ensure(4);

  @$pb.TagNumber(6)
  WeatherUnitValue get wind => $_getN(5);
  @$pb.TagNumber(6)
  set wind(WeatherUnitValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWind() => $_has(5);
  @$pb.TagNumber(6)
  void clearWind() => $_clearField(6);
  @$pb.TagNumber(6)
  WeatherUnitValue ensureWind() => $_ensure(5);
}

class WeatherRange extends $pb.GeneratedMessage {
  factory WeatherRange({
    $core.int? from,
    $core.int? to,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  WeatherRange._();

  factory WeatherRange.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherRange.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherRange',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'from', fieldType: $pb.PbFieldType.QS3)
    ..aI(2, _omitFieldNames ? '' : 'to', fieldType: $pb.PbFieldType.QS3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherRange copyWith(void Function(WeatherRange) updates) =>
      super.copyWith((message) => updates(message as WeatherRange))
          as WeatherRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherRange create() => WeatherRange._();
  @$core.override
  WeatherRange createEmptyInstance() => create();
  static $pb.PbList<WeatherRange> createRepeated() =>
      $pb.PbList<WeatherRange>();
  @$core.pragma('dart2js:noInline')
  static WeatherRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherRange>(create);
  static WeatherRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get from => $_getIZ(0);
  @$pb.TagNumber(1)
  set from($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get to => $_getIZ(1);
  @$pb.TagNumber(2)
  set to($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
}

class WeatherSunriseSunset extends $pb.GeneratedMessage {
  factory WeatherSunriseSunset({
    $core.String? sunrise,
    $core.String? sunset,
  }) {
    final result = create();
    if (sunrise != null) result.sunrise = sunrise;
    if (sunset != null) result.sunset = sunset;
    return result;
  }

  WeatherSunriseSunset._();

  factory WeatherSunriseSunset.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherSunriseSunset.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherSunriseSunset',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(1, _omitFieldNames ? '' : 'sunrise')
    ..aQS(2, _omitFieldNames ? '' : 'sunset');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherSunriseSunset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherSunriseSunset copyWith(void Function(WeatherSunriseSunset) updates) =>
      super.copyWith((message) => updates(message as WeatherSunriseSunset))
          as WeatherSunriseSunset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherSunriseSunset create() => WeatherSunriseSunset._();
  @$core.override
  WeatherSunriseSunset createEmptyInstance() => create();
  static $pb.PbList<WeatherSunriseSunset> createRepeated() =>
      $pb.PbList<WeatherSunriseSunset>();
  @$core.pragma('dart2js:noInline')
  static WeatherSunriseSunset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherSunriseSunset>(create);
  static WeatherSunriseSunset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sunrise => $_getSZ(0);
  @$pb.TagNumber(1)
  set sunrise($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSunrise() => $_has(0);
  @$pb.TagNumber(1)
  void clearSunrise() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sunset => $_getSZ(1);
  @$pb.TagNumber(2)
  set sunset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSunset() => $_has(1);
  @$pb.TagNumber(2)
  void clearSunset() => $_clearField(2);
}

class WeatherLocation extends $pb.GeneratedMessage {
  factory WeatherLocation({
    $core.String? code,
    $core.String? name,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    return result;
  }

  WeatherLocation._();

  factory WeatherLocation.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherLocation.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherLocation',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aQS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherLocation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherLocation copyWith(void Function(WeatherLocation) updates) =>
      super.copyWith((message) => updates(message as WeatherLocation))
          as WeatherLocation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherLocation create() => WeatherLocation._();
  @$core.override
  WeatherLocation createEmptyInstance() => create();
  static $pb.PbList<WeatherLocation> createRepeated() =>
      $pb.PbList<WeatherLocation>();
  @$core.pragma('dart2js:noInline')
  static WeatherLocation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherLocation>(create);
  static WeatherLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class WeatherPrefs extends $pb.GeneratedMessage {
  factory WeatherPrefs({
    $core.int? temperatureScale,
    $core.int? weatherWarningsEnabled,
  }) {
    final result = create();
    if (temperatureScale != null) result.temperatureScale = temperatureScale;
    if (weatherWarningsEnabled != null)
      result.weatherWarningsEnabled = weatherWarningsEnabled;
    return result;
  }

  WeatherPrefs._();

  factory WeatherPrefs.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WeatherPrefs.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WeatherPrefs',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(
      1,
      _omitFieldNames ? '' : 'temperatureScale',
      protoName: 'temperatureScale',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'weatherWarningsEnabled',
      protoName: 'weatherWarningsEnabled',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherPrefs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WeatherPrefs copyWith(void Function(WeatherPrefs) updates) =>
      super.copyWith((message) => updates(message as WeatherPrefs))
          as WeatherPrefs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherPrefs create() => WeatherPrefs._();
  @$core.override
  WeatherPrefs createEmptyInstance() => create();
  static $pb.PbList<WeatherPrefs> createRepeated() =>
      $pb.PbList<WeatherPrefs>();
  @$core.pragma('dart2js:noInline')
  static WeatherPrefs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WeatherPrefs>(create);
  static WeatherPrefs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get temperatureScale => $_getIZ(0);
  @$pb.TagNumber(1)
  set temperatureScale($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemperatureScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperatureScale() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get weatherWarningsEnabled => $_getIZ(1);
  @$pb.TagNumber(2)
  set weatherWarningsEnabled($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeatherWarningsEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeatherWarningsEnabled() => $_clearField(2);
}

class Schedule extends $pb.GeneratedMessage {
  factory Schedule({
    Alarms? alarms,
    AlarmDetails? createAlarm,
    Alarm? editAlarm,
    $core.int? ackId,
    AlarmDelete? deleteAlarm,
    SleepMode? sleepMode,
    Reminders? reminders,
    WorldClocks? worldClocks,
    $core.int? worldClockStatus,
    ReminderDetails? createReminder,
    Reminder? editReminder,
    ReminderDelete? deleteReminder,
  }) {
    final result = create();
    if (alarms != null) result.alarms = alarms;
    if (createAlarm != null) result.createAlarm = createAlarm;
    if (editAlarm != null) result.editAlarm = editAlarm;
    if (ackId != null) result.ackId = ackId;
    if (deleteAlarm != null) result.deleteAlarm = deleteAlarm;
    if (sleepMode != null) result.sleepMode = sleepMode;
    if (reminders != null) result.reminders = reminders;
    if (worldClocks != null) result.worldClocks = worldClocks;
    if (worldClockStatus != null) result.worldClockStatus = worldClockStatus;
    if (createReminder != null) result.createReminder = createReminder;
    if (editReminder != null) result.editReminder = editReminder;
    if (deleteReminder != null) result.deleteReminder = deleteReminder;
    return result;
  }

  Schedule._();

  factory Schedule.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Schedule.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Schedule',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<Alarms>(1, _omitFieldNames ? '' : 'alarms', subBuilder: Alarms.create)
    ..aOM<AlarmDetails>(
      2,
      _omitFieldNames ? '' : 'createAlarm',
      protoName: 'createAlarm',
      subBuilder: AlarmDetails.create,
    )
    ..aOM<Alarm>(
      3,
      _omitFieldNames ? '' : 'editAlarm',
      protoName: 'editAlarm',
      subBuilder: Alarm.create,
    )
    ..aI(
      4,
      _omitFieldNames ? '' : 'ackId',
      protoName: 'ackId',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<AlarmDelete>(
      5,
      _omitFieldNames ? '' : 'deleteAlarm',
      protoName: 'deleteAlarm',
      subBuilder: AlarmDelete.create,
    )
    ..aOM<SleepMode>(
      9,
      _omitFieldNames ? '' : 'sleepMode',
      protoName: 'sleepMode',
      subBuilder: SleepMode.create,
    )
    ..aOM<Reminders>(
      10,
      _omitFieldNames ? '' : 'reminders',
      subBuilder: Reminders.create,
    )
    ..aOM<WorldClocks>(
      11,
      _omitFieldNames ? '' : 'worldClocks',
      protoName: 'worldClocks',
      subBuilder: WorldClocks.create,
    )
    ..aI(
      13,
      _omitFieldNames ? '' : 'worldClockStatus',
      protoName: 'worldClockStatus',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOM<ReminderDetails>(
      14,
      _omitFieldNames ? '' : 'createReminder',
      protoName: 'createReminder',
      subBuilder: ReminderDetails.create,
    )
    ..aOM<Reminder>(
      15,
      _omitFieldNames ? '' : 'editReminder',
      protoName: 'editReminder',
      subBuilder: Reminder.create,
    )
    ..aOM<ReminderDelete>(
      17,
      _omitFieldNames ? '' : 'deleteReminder',
      protoName: 'deleteReminder',
      subBuilder: ReminderDelete.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Schedule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Schedule copyWith(void Function(Schedule) updates) =>
      super.copyWith((message) => updates(message as Schedule)) as Schedule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Schedule create() => Schedule._();
  @$core.override
  Schedule createEmptyInstance() => create();
  static $pb.PbList<Schedule> createRepeated() => $pb.PbList<Schedule>();
  @$core.pragma('dart2js:noInline')
  static Schedule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Schedule>(create);
  static Schedule? _defaultInstance;

  /// 17, 0 get
  @$pb.TagNumber(1)
  Alarms get alarms => $_getN(0);
  @$pb.TagNumber(1)
  set alarms(Alarms value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarms() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarms() => $_clearField(1);
  @$pb.TagNumber(1)
  Alarms ensureAlarms() => $_ensure(0);

  /// 17, 1
  @$pb.TagNumber(2)
  AlarmDetails get createAlarm => $_getN(1);
  @$pb.TagNumber(2)
  set createAlarm(AlarmDetails value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateAlarm() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateAlarm() => $_clearField(2);
  @$pb.TagNumber(2)
  AlarmDetails ensureCreateAlarm() => $_ensure(1);

  /// 17, 3 -> returns 17, 5
  @$pb.TagNumber(3)
  Alarm get editAlarm => $_getN(2);
  @$pb.TagNumber(3)
  set editAlarm(Alarm value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEditAlarm() => $_has(2);
  @$pb.TagNumber(3)
  void clearEditAlarm() => $_clearField(3);
  @$pb.TagNumber(3)
  Alarm ensureEditAlarm() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get ackId => $_getIZ(3);
  @$pb.TagNumber(4)
  set ackId($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAckId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAckId() => $_clearField(4);

  /// 17, 4
  @$pb.TagNumber(5)
  AlarmDelete get deleteAlarm => $_getN(4);
  @$pb.TagNumber(5)
  set deleteAlarm(AlarmDelete value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteAlarm() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteAlarm() => $_clearField(5);
  @$pb.TagNumber(5)
  AlarmDelete ensureDeleteAlarm() => $_ensure(4);

  /// 17, 8 get | 17, 9 set
  @$pb.TagNumber(9)
  SleepMode get sleepMode => $_getN(5);
  @$pb.TagNumber(9)
  set sleepMode(SleepMode value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSleepMode() => $_has(5);
  @$pb.TagNumber(9)
  void clearSleepMode() => $_clearField(9);
  @$pb.TagNumber(9)
  SleepMode ensureSleepMode() => $_ensure(5);

  /// 17, 14 get: 10 -> 2: 50 // max reminders?
  @$pb.TagNumber(10)
  Reminders get reminders => $_getN(6);
  @$pb.TagNumber(10)
  set reminders(Reminders value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReminders() => $_has(6);
  @$pb.TagNumber(10)
  void clearReminders() => $_clearField(10);
  @$pb.TagNumber(10)
  Reminders ensureReminders() => $_ensure(6);

  /// 17,10 get/ret | 17,11 create | 17,13 delete
  @$pb.TagNumber(11)
  WorldClocks get worldClocks => $_getN(7);
  @$pb.TagNumber(11)
  set worldClocks(WorldClocks value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasWorldClocks() => $_has(7);
  @$pb.TagNumber(11)
  void clearWorldClocks() => $_clearField(11);
  @$pb.TagNumber(11)
  WorldClocks ensureWorldClocks() => $_ensure(7);

  @$pb.TagNumber(13)
  $core.int get worldClockStatus => $_getIZ(8);
  @$pb.TagNumber(13)
  set worldClockStatus($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(13)
  $core.bool hasWorldClockStatus() => $_has(8);
  @$pb.TagNumber(13)
  void clearWorldClockStatus() => $_clearField(13);

  /// 17, 15
  @$pb.TagNumber(14)
  ReminderDetails get createReminder => $_getN(9);
  @$pb.TagNumber(14)
  set createReminder(ReminderDetails value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreateReminder() => $_has(9);
  @$pb.TagNumber(14)
  void clearCreateReminder() => $_clearField(14);
  @$pb.TagNumber(14)
  ReminderDetails ensureCreateReminder() => $_ensure(9);

  /// 17, 17
  @$pb.TagNumber(15)
  Reminder get editReminder => $_getN(10);
  @$pb.TagNumber(15)
  set editReminder(Reminder value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasEditReminder() => $_has(10);
  @$pb.TagNumber(15)
  void clearEditReminder() => $_clearField(15);
  @$pb.TagNumber(15)
  Reminder ensureEditReminder() => $_ensure(10);

  /// 17, 18
  @$pb.TagNumber(17)
  ReminderDelete get deleteReminder => $_getN(11);
  @$pb.TagNumber(17)
  set deleteReminder(ReminderDelete value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasDeleteReminder() => $_has(11);
  @$pb.TagNumber(17)
  void clearDeleteReminder() => $_clearField(17);
  @$pb.TagNumber(17)
  ReminderDelete ensureDeleteReminder() => $_ensure(11);
}

class Alarms extends $pb.GeneratedMessage {
  factory Alarms({
    $core.Iterable<Alarm>? alarm,
    $core.int? maxAlarms,
    $core.int? unknown3,
    $core.int? unknown4,
  }) {
    final result = create();
    if (alarm != null) result.alarm.addAll(alarm);
    if (maxAlarms != null) result.maxAlarms = maxAlarms;
    if (unknown3 != null) result.unknown3 = unknown3;
    if (unknown4 != null) result.unknown4 = unknown4;
    return result;
  }

  Alarms._();

  factory Alarms.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Alarms.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Alarms',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<Alarm>(1, _omitFieldNames ? '' : 'alarm', subBuilder: Alarm.create)
    ..aI(
      2,
      _omitFieldNames ? '' : 'maxAlarms',
      protoName: 'maxAlarms',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'unknown4', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarms clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarms copyWith(void Function(Alarms) updates) =>
      super.copyWith((message) => updates(message as Alarms)) as Alarms;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alarms create() => Alarms._();
  @$core.override
  Alarms createEmptyInstance() => create();
  static $pb.PbList<Alarms> createRepeated() => $pb.PbList<Alarms>();
  @$core.pragma('dart2js:noInline')
  static Alarms getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alarms>(create);
  static Alarms? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alarm> get alarm => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get maxAlarms => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxAlarms($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxAlarms() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxAlarms() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unknown4 => $_getIZ(3);
  @$pb.TagNumber(4)
  set unknown4($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown4() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown4() => $_clearField(4);
}

class Alarm extends $pb.GeneratedMessage {
  factory Alarm({
    $core.int? id,
    AlarmDetails? alarmDetails,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (alarmDetails != null) result.alarmDetails = alarmDetails;
    return result;
  }

  Alarm._();

  factory Alarm.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Alarm.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Alarm',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOM<AlarmDetails>(
      2,
      _omitFieldNames ? '' : 'alarmDetails',
      protoName: 'alarmDetails',
      subBuilder: AlarmDetails.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarm copyWith(void Function(Alarm) updates) =>
      super.copyWith((message) => updates(message as Alarm)) as Alarm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alarm create() => Alarm._();
  @$core.override
  Alarm createEmptyInstance() => create();
  static $pb.PbList<Alarm> createRepeated() => $pb.PbList<Alarm>();
  @$core.pragma('dart2js:noInline')
  static Alarm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alarm>(create);
  static Alarm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  AlarmDetails get alarmDetails => $_getN(1);
  @$pb.TagNumber(2)
  set alarmDetails(AlarmDetails value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAlarmDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlarmDetails() => $_clearField(2);
  @$pb.TagNumber(2)
  AlarmDetails ensureAlarmDetails() => $_ensure(1);
}

class AlarmDetails extends $pb.GeneratedMessage {
  factory AlarmDetails({
    HourMinute? time,
    $core.int? repeatMode,
    $core.int? repeatFlags,
    $core.bool? enabled,
    $core.int? smart,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (repeatMode != null) result.repeatMode = repeatMode;
    if (repeatFlags != null) result.repeatFlags = repeatFlags;
    if (enabled != null) result.enabled = enabled;
    if (smart != null) result.smart = smart;
    return result;
  }

  AlarmDetails._();

  factory AlarmDetails.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlarmDetails.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AlarmDetails',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<HourMinute>(
      2,
      _omitFieldNames ? '' : 'time',
      subBuilder: HourMinute.create,
    )
    ..aI(
      3,
      _omitFieldNames ? '' : 'repeatMode',
      protoName: 'repeatMode',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      4,
      _omitFieldNames ? '' : 'repeatFlags',
      protoName: 'repeatFlags',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..aI(7, _omitFieldNames ? '' : 'smart', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmDetails copyWith(void Function(AlarmDetails) updates) =>
      super.copyWith((message) => updates(message as AlarmDetails))
          as AlarmDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlarmDetails create() => AlarmDetails._();
  @$core.override
  AlarmDetails createEmptyInstance() => create();
  static $pb.PbList<AlarmDetails> createRepeated() =>
      $pb.PbList<AlarmDetails>();
  @$core.pragma('dart2js:noInline')
  static AlarmDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AlarmDetails>(create);
  static AlarmDetails? _defaultInstance;

  @$pb.TagNumber(2)
  HourMinute get time => $_getN(0);
  @$pb.TagNumber(2)
  set time(HourMinute value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(2)
  void clearTime() => $_clearField(2);
  @$pb.TagNumber(2)
  HourMinute ensureTime() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.int get repeatMode => $_getIZ(1);
  @$pb.TagNumber(3)
  set repeatMode($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(3)
  $core.bool hasRepeatMode() => $_has(1);
  @$pb.TagNumber(3)
  void clearRepeatMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get repeatFlags => $_getIZ(2);
  @$pb.TagNumber(4)
  set repeatFlags($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(4)
  $core.bool hasRepeatFlags() => $_has(2);
  @$pb.TagNumber(4)
  void clearRepeatFlags() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);

  @$pb.TagNumber(7)
  $core.int get smart => $_getIZ(4);
  @$pb.TagNumber(7)
  set smart($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(7)
  $core.bool hasSmart() => $_has(4);
  @$pb.TagNumber(7)
  void clearSmart() => $_clearField(7);
}

class AlarmDelete extends $pb.GeneratedMessage {
  factory AlarmDelete({
    $core.Iterable<$core.int>? id,
  }) {
    final result = create();
    if (id != null) result.id.addAll(id);
    return result;
  }

  AlarmDelete._();

  factory AlarmDelete.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlarmDelete.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'AlarmDelete',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..p<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.PU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmDelete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmDelete copyWith(void Function(AlarmDelete) updates) =>
      super.copyWith((message) => updates(message as AlarmDelete))
          as AlarmDelete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlarmDelete create() => AlarmDelete._();
  @$core.override
  AlarmDelete createEmptyInstance() => create();
  static $pb.PbList<AlarmDelete> createRepeated() => $pb.PbList<AlarmDelete>();
  @$core.pragma('dart2js:noInline')
  static AlarmDelete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AlarmDelete>(create);
  static AlarmDelete? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get id => $_getList(0);
}

class SleepMode extends $pb.GeneratedMessage {
  factory SleepMode({
    $core.bool? enabled,
    SleepModeSchedule? schedule,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (schedule != null) result.schedule = schedule;
    return result;
  }

  SleepMode._();

  factory SleepMode.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory SleepMode.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'SleepMode',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..a<$core.bool>(1, _omitFieldNames ? '' : 'enabled', $pb.PbFieldType.QB)
    ..aOM<SleepModeSchedule>(
      2,
      _omitFieldNames ? '' : 'schedule',
      subBuilder: SleepModeSchedule.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SleepMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SleepMode copyWith(void Function(SleepMode) updates) =>
      super.copyWith((message) => updates(message as SleepMode)) as SleepMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SleepMode create() => SleepMode._();
  @$core.override
  SleepMode createEmptyInstance() => create();
  static $pb.PbList<SleepMode> createRepeated() => $pb.PbList<SleepMode>();
  @$core.pragma('dart2js:noInline')
  static SleepMode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SleepMode>(create);
  static SleepMode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  SleepModeSchedule get schedule => $_getN(1);
  @$pb.TagNumber(2)
  set schedule(SleepModeSchedule value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSchedule() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchedule() => $_clearField(2);
  @$pb.TagNumber(2)
  SleepModeSchedule ensureSchedule() => $_ensure(1);
}

class SleepModeSchedule extends $pb.GeneratedMessage {
  factory SleepModeSchedule({
    HourMinute? start,
    HourMinute? end,
    $core.int? unknown3,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (unknown3 != null) result.unknown3 = unknown3;
    return result;
  }

  SleepModeSchedule._();

  factory SleepModeSchedule.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory SleepModeSchedule.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'SleepModeSchedule',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<HourMinute>(
      1,
      _omitFieldNames ? '' : 'start',
      subBuilder: HourMinute.create,
    )
    ..aOM<HourMinute>(
      2,
      _omitFieldNames ? '' : 'end',
      subBuilder: HourMinute.create,
    )
    ..aI(3, _omitFieldNames ? '' : 'unknown3', fieldType: $pb.PbFieldType.OU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SleepModeSchedule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SleepModeSchedule copyWith(void Function(SleepModeSchedule) updates) =>
      super.copyWith((message) => updates(message as SleepModeSchedule))
          as SleepModeSchedule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SleepModeSchedule create() => SleepModeSchedule._();
  @$core.override
  SleepModeSchedule createEmptyInstance() => create();
  static $pb.PbList<SleepModeSchedule> createRepeated() =>
      $pb.PbList<SleepModeSchedule>();
  @$core.pragma('dart2js:noInline')
  static SleepModeSchedule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SleepModeSchedule>(create);
  static SleepModeSchedule? _defaultInstance;

  @$pb.TagNumber(1)
  HourMinute get start => $_getN(0);
  @$pb.TagNumber(1)
  set start(HourMinute value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);
  @$pb.TagNumber(1)
  HourMinute ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  HourMinute get end => $_getN(1);
  @$pb.TagNumber(2)
  set end(HourMinute value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  HourMinute ensureEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get unknown3 => $_getIZ(2);
  @$pb.TagNumber(3)
  set unknown3($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnknown3() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnknown3() => $_clearField(3);
}

class Reminders extends $pb.GeneratedMessage {
  factory Reminders({
    $core.Iterable<Reminder>? reminder,
    $core.int? maxReminders,
  }) {
    final result = create();
    if (reminder != null) result.reminder.addAll(reminder);
    if (maxReminders != null) result.maxReminders = maxReminders;
    return result;
  }

  Reminders._();

  factory Reminders.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reminders.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Reminders',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<Reminder>(
      1,
      _omitFieldNames ? '' : 'reminder',
      subBuilder: Reminder.create,
    )
    ..aI(
      2,
      _omitFieldNames ? '' : 'maxReminders',
      protoName: 'maxReminders',
      fieldType: $pb.PbFieldType.OU3,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reminders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reminders copyWith(void Function(Reminders) updates) =>
      super.copyWith((message) => updates(message as Reminders)) as Reminders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reminders create() => Reminders._();
  @$core.override
  Reminders createEmptyInstance() => create();
  static $pb.PbList<Reminders> createRepeated() => $pb.PbList<Reminders>();
  @$core.pragma('dart2js:noInline')
  static Reminders getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reminders>(create);
  static Reminders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reminder> get reminder => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get maxReminders => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxReminders($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxReminders() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxReminders() => $_clearField(2);
}

class Reminder extends $pb.GeneratedMessage {
  factory Reminder({
    $core.int? id,
    ReminderDetails? reminderDetails,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (reminderDetails != null) result.reminderDetails = reminderDetails;
    return result;
  }

  Reminder._();

  factory Reminder.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reminder.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Reminder',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'id', fieldType: $pb.PbFieldType.OU3)
    ..aOM<ReminderDetails>(
      2,
      _omitFieldNames ? '' : 'reminderDetails',
      protoName: 'reminderDetails',
      subBuilder: ReminderDetails.create,
    );

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reminder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reminder copyWith(void Function(Reminder) updates) =>
      super.copyWith((message) => updates(message as Reminder)) as Reminder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reminder create() => Reminder._();
  @$core.override
  Reminder createEmptyInstance() => create();
  static $pb.PbList<Reminder> createRepeated() => $pb.PbList<Reminder>();
  @$core.pragma('dart2js:noInline')
  static Reminder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reminder>(create);
  static Reminder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ReminderDetails get reminderDetails => $_getN(1);
  @$pb.TagNumber(2)
  set reminderDetails(ReminderDetails value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReminderDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearReminderDetails() => $_clearField(2);
  @$pb.TagNumber(2)
  ReminderDetails ensureReminderDetails() => $_ensure(1);
}

class ReminderDetails extends $pb.GeneratedMessage {
  factory ReminderDetails({
    Date? date,
    Time? time,
    $core.int? repeatMode,
    $core.int? repeatFlags,
    $core.String? title,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (time != null) result.time = time;
    if (repeatMode != null) result.repeatMode = repeatMode;
    if (repeatFlags != null) result.repeatFlags = repeatFlags;
    if (title != null) result.title = title;
    return result;
  }

  ReminderDetails._();

  factory ReminderDetails.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReminderDetails.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ReminderDetails',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<Date>(1, _omitFieldNames ? '' : 'date', subBuilder: Date.create)
    ..aOM<Time>(2, _omitFieldNames ? '' : 'time', subBuilder: Time.create)
    ..aI(
      3,
      _omitFieldNames ? '' : 'repeatMode',
      protoName: 'repeatMode',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      4,
      _omitFieldNames ? '' : 'repeatFlags',
      protoName: 'repeatFlags',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aOS(5, _omitFieldNames ? '' : 'title');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReminderDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReminderDetails copyWith(void Function(ReminderDetails) updates) =>
      super.copyWith((message) => updates(message as ReminderDetails))
          as ReminderDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReminderDetails create() => ReminderDetails._();
  @$core.override
  ReminderDetails createEmptyInstance() => create();
  static $pb.PbList<ReminderDetails> createRepeated() =>
      $pb.PbList<ReminderDetails>();
  @$core.pragma('dart2js:noInline')
  static ReminderDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReminderDetails>(create);
  static ReminderDetails? _defaultInstance;

  @$pb.TagNumber(1)
  Date get date => $_getN(0);
  @$pb.TagNumber(1)
  set date(Date value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  Date ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  Time get time => $_getN(1);
  @$pb.TagNumber(2)
  set time(Time value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => $_clearField(2);
  @$pb.TagNumber(2)
  Time ensureTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get repeatMode => $_getIZ(2);
  @$pb.TagNumber(3)
  set repeatMode($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRepeatMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearRepeatMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get repeatFlags => $_getIZ(3);
  @$pb.TagNumber(4)
  set repeatFlags($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRepeatFlags() => $_has(3);
  @$pb.TagNumber(4)
  void clearRepeatFlags() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);
}

class ReminderDelete extends $pb.GeneratedMessage {
  factory ReminderDelete({
    $core.Iterable<$core.int>? id,
  }) {
    final result = create();
    if (id != null) result.id.addAll(id);
    return result;
  }

  ReminderDelete._();

  factory ReminderDelete.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReminderDelete.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ReminderDelete',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..p<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.PU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReminderDelete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReminderDelete copyWith(void Function(ReminderDelete) updates) =>
      super.copyWith((message) => updates(message as ReminderDelete))
          as ReminderDelete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReminderDelete create() => ReminderDelete._();
  @$core.override
  ReminderDelete createEmptyInstance() => create();
  static $pb.PbList<ReminderDelete> createRepeated() =>
      $pb.PbList<ReminderDelete>();
  @$core.pragma('dart2js:noInline')
  static ReminderDelete getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReminderDelete>(create);
  static ReminderDelete? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get id => $_getList(0);
}

class WorldClocks extends $pb.GeneratedMessage {
  factory WorldClocks({
    $core.Iterable<$core.String>? worldClock,
  }) {
    final result = create();
    if (worldClock != null) result.worldClock.addAll(worldClock);
    return result;
  }

  WorldClocks._();

  factory WorldClocks.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorldClocks.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'WorldClocks',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPS(1, _omitFieldNames ? '' : 'worldClock', protoName: 'worldClock')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorldClocks clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorldClocks copyWith(void Function(WorldClocks) updates) =>
      super.copyWith((message) => updates(message as WorldClocks))
          as WorldClocks;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorldClocks create() => WorldClocks._();
  @$core.override
  WorldClocks createEmptyInstance() => create();
  static $pb.PbList<WorldClocks> createRepeated() => $pb.PbList<WorldClocks>();
  @$core.pragma('dart2js:noInline')
  static WorldClocks getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorldClocks>(create);
  static WorldClocks? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get worldClock => $_getList(0);
}

class HourMinute extends $pb.GeneratedMessage {
  factory HourMinute({
    $core.int? hour,
    $core.int? minute,
  }) {
    final result = create();
    if (hour != null) result.hour = hour;
    if (minute != null) result.minute = minute;
    return result;
  }

  HourMinute._();

  factory HourMinute.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory HourMinute.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'HourMinute',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'hour', fieldType: $pb.PbFieldType.QU3)
    ..aI(2, _omitFieldNames ? '' : 'minute', fieldType: $pb.PbFieldType.QU3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HourMinute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HourMinute copyWith(void Function(HourMinute) updates) =>
      super.copyWith((message) => updates(message as HourMinute)) as HourMinute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HourMinute create() => HourMinute._();
  @$core.override
  HourMinute createEmptyInstance() => create();
  static $pb.PbList<HourMinute> createRepeated() => $pb.PbList<HourMinute>();
  @$core.pragma('dart2js:noInline')
  static HourMinute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HourMinute>(create);
  static HourMinute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hour => $_getIZ(0);
  @$pb.TagNumber(1)
  set hour($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHour() => $_has(0);
  @$pb.TagNumber(1)
  void clearHour() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minute => $_getIZ(1);
  @$pb.TagNumber(2)
  set minute($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinute() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinute() => $_clearField(2);
}

class DataUpload extends $pb.GeneratedMessage {
  factory DataUpload({
    DataUploadRequest? dataUploadRequest,
    DataUploadAck? dataUploadAck,
  }) {
    final result = create();
    if (dataUploadRequest != null) result.dataUploadRequest = dataUploadRequest;
    if (dataUploadAck != null) result.dataUploadAck = dataUploadAck;
    return result;
  }

  DataUpload._();

  factory DataUpload.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DataUpload.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DataUpload',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOM<DataUploadRequest>(
      1,
      _omitFieldNames ? '' : 'dataUploadRequest',
      protoName: 'dataUploadRequest',
      subBuilder: DataUploadRequest.create,
    )
    ..aOM<DataUploadAck>(
      2,
      _omitFieldNames ? '' : 'dataUploadAck',
      protoName: 'dataUploadAck',
      subBuilder: DataUploadAck.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUpload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUpload copyWith(void Function(DataUpload) updates) =>
      super.copyWith((message) => updates(message as DataUpload)) as DataUpload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataUpload create() => DataUpload._();
  @$core.override
  DataUpload createEmptyInstance() => create();
  static $pb.PbList<DataUpload> createRepeated() => $pb.PbList<DataUpload>();
  @$core.pragma('dart2js:noInline')
  static DataUpload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataUpload>(create);
  static DataUpload? _defaultInstance;

  /// 22, 0
  @$pb.TagNumber(1)
  DataUploadRequest get dataUploadRequest => $_getN(0);
  @$pb.TagNumber(1)
  set dataUploadRequest(DataUploadRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDataUploadRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearDataUploadRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  DataUploadRequest ensureDataUploadRequest() => $_ensure(0);

  @$pb.TagNumber(2)
  DataUploadAck get dataUploadAck => $_getN(1);
  @$pb.TagNumber(2)
  set dataUploadAck(DataUploadAck value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDataUploadAck() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataUploadAck() => $_clearField(2);
  @$pb.TagNumber(2)
  DataUploadAck ensureDataUploadAck() => $_ensure(1);
}

class DataUploadRequest extends $pb.GeneratedMessage {
  factory DataUploadRequest({
    $core.int? type,
    $core.List<$core.int>? md5sum,
    $core.int? size,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (md5sum != null) result.md5sum = md5sum;
    if (size != null) result.size = size;
    return result;
  }

  DataUploadRequest._();

  factory DataUploadRequest.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DataUploadRequest.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DataUploadRequest',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aI(1, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
      2,
      _omitFieldNames ? '' : 'md5sum',
      $pb.PbFieldType.OY,
    )
    ..aI(3, _omitFieldNames ? '' : 'size', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUploadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUploadRequest copyWith(void Function(DataUploadRequest) updates) =>
      super.copyWith((message) => updates(message as DataUploadRequest))
          as DataUploadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataUploadRequest create() => DataUploadRequest._();
  @$core.override
  DataUploadRequest createEmptyInstance() => create();
  static $pb.PbList<DataUploadRequest> createRepeated() =>
      $pb.PbList<DataUploadRequest>();
  @$core.pragma('dart2js:noInline')
  static DataUploadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataUploadRequest>(create);
  static DataUploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get md5sum => $_getN(1);
  @$pb.TagNumber(2)
  set md5sum($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMd5sum() => $_has(1);
  @$pb.TagNumber(2)
  void clearMd5sum() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);
}

class DataUploadAck extends $pb.GeneratedMessage {
  factory DataUploadAck({
    $core.List<$core.int>? md5sum,
    $core.int? unknown2,
    $core.int? resumePosition,
    $core.int? chunkSize,
  }) {
    final result = create();
    if (md5sum != null) result.md5sum = md5sum;
    if (unknown2 != null) result.unknown2 = unknown2;
    if (resumePosition != null) result.resumePosition = resumePosition;
    if (chunkSize != null) result.chunkSize = chunkSize;
    return result;
  }

  DataUploadAck._();

  factory DataUploadAck.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory DataUploadAck.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'DataUploadAck',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..a<$core.List<$core.int>>(
      1,
      _omitFieldNames ? '' : 'md5sum',
      $pb.PbFieldType.OY,
    )
    ..aI(2, _omitFieldNames ? '' : 'unknown2', fieldType: $pb.PbFieldType.OU3)
    ..aI(
      4,
      _omitFieldNames ? '' : 'resumePosition',
      protoName: 'resumePosition',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..aI(
      5,
      _omitFieldNames ? '' : 'chunkSize',
      protoName: 'chunkSize',
      fieldType: $pb.PbFieldType.OU3,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUploadAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataUploadAck copyWith(void Function(DataUploadAck) updates) =>
      super.copyWith((message) => updates(message as DataUploadAck))
          as DataUploadAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataUploadAck create() => DataUploadAck._();
  @$core.override
  DataUploadAck createEmptyInstance() => create();
  static $pb.PbList<DataUploadAck> createRepeated() =>
      $pb.PbList<DataUploadAck>();
  @$core.pragma('dart2js:noInline')
  static DataUploadAck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataUploadAck>(create);
  static DataUploadAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get md5sum => $_getN(0);
  @$pb.TagNumber(1)
  set md5sum($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMd5sum() => $_has(0);
  @$pb.TagNumber(1)
  void clearMd5sum() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unknown2 => $_getIZ(1);
  @$pb.TagNumber(2)
  set unknown2($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnknown2() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnknown2() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.int get resumePosition => $_getIZ(2);
  @$pb.TagNumber(4)
  set resumePosition($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(4)
  $core.bool hasResumePosition() => $_has(2);
  @$pb.TagNumber(4)
  void clearResumePosition() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get chunkSize => $_getIZ(3);
  @$pb.TagNumber(5)
  set chunkSize($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasChunkSize() => $_has(3);
  @$pb.TagNumber(5)
  void clearChunkSize() => $_clearField(5);
}

class ContactInfo extends $pb.GeneratedMessage {
  factory ContactInfo({
    $core.String? displayName,
    $core.String? phoneNumber,
  }) {
    final result = create();
    if (displayName != null) result.displayName = displayName;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  ContactInfo._();

  factory ContactInfo.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactInfo.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ContactInfo',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(2, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactInfo copyWith(void Function(ContactInfo) updates) =>
      super.copyWith((message) => updates(message as ContactInfo))
          as ContactInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactInfo create() => ContactInfo._();
  @$core.override
  ContactInfo createEmptyInstance() => create();
  static $pb.PbList<ContactInfo> createRepeated() => $pb.PbList<ContactInfo>();
  @$core.pragma('dart2js:noInline')
  static ContactInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContactInfo>(create);
  static ContactInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get displayName => $_getSZ(0);
  @$pb.TagNumber(1)
  set displayName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneNumber() => $_clearField(2);
}

class ContactList extends $pb.GeneratedMessage {
  factory ContactList({
    $core.Iterable<ContactInfo>? contactInfo,
  }) {
    final result = create();
    if (contactInfo != null) result.contactInfo.addAll(contactInfo);
    return result;
  }

  ContactList._();

  factory ContactList.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactList.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'ContactList',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..pPM<ContactInfo>(
      1,
      _omitFieldNames ? '' : 'contactInfo',
      protoName: 'contactInfo',
      subBuilder: ContactInfo.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactList copyWith(void Function(ContactList) updates) =>
      super.copyWith((message) => updates(message as ContactList))
          as ContactList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactList create() => ContactList._();
  @$core.override
  ContactList createEmptyInstance() => create();
  static $pb.PbList<ContactList> createRepeated() => $pb.PbList<ContactList>();
  @$core.pragma('dart2js:noInline')
  static ContactList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContactList>(create);
  static ContactList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContactInfo> get contactInfo => $_getList(0);
}

class Phonebook extends $pb.GeneratedMessage {
  factory Phonebook({
    $core.String? requestedPhoneNumber,
    ContactInfo? contactInfo,
    ContactList? contactList,
  }) {
    final result = create();
    if (requestedPhoneNumber != null)
      result.requestedPhoneNumber = requestedPhoneNumber;
    if (contactInfo != null) result.contactInfo = contactInfo;
    if (contactList != null) result.contactList = contactList;
    return result;
  }

  Phonebook._();

  factory Phonebook.fromBuffer(
    $core.List<$core.int> data, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(data, registry);
  factory Phonebook.fromJson(
    $core.String json, [
    $pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Phonebook',
    package: const $pb.PackageName(_omitMessageNames ? '' : 'xiaomi'),
    createEmptyInstance: create,
  )
    ..aOS(
      2,
      _omitFieldNames ? '' : 'requestedPhoneNumber',
      protoName: 'requestedPhoneNumber',
    )
    ..aOM<ContactInfo>(
      3,
      _omitFieldNames ? '' : 'contactInfo',
      protoName: 'contactInfo',
      subBuilder: ContactInfo.create,
    )
    ..aOM<ContactList>(
      4,
      _omitFieldNames ? '' : 'contactList',
      protoName: 'contactList',
      subBuilder: ContactList.create,
    )
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Phonebook clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Phonebook copyWith(void Function(Phonebook) updates) =>
      super.copyWith((message) => updates(message as Phonebook)) as Phonebook;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Phonebook create() => Phonebook._();
  @$core.override
  Phonebook createEmptyInstance() => create();
  static $pb.PbList<Phonebook> createRepeated() => $pb.PbList<Phonebook>();
  @$core.pragma('dart2js:noInline')
  static Phonebook getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Phonebook>(create);
  static Phonebook? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get requestedPhoneNumber => $_getSZ(0);
  @$pb.TagNumber(2)
  set requestedPhoneNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestedPhoneNumber() => $_has(0);
  @$pb.TagNumber(2)
  void clearRequestedPhoneNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  ContactInfo get contactInfo => $_getN(1);
  @$pb.TagNumber(3)
  set contactInfo(ContactInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContactInfo() => $_has(1);
  @$pb.TagNumber(3)
  void clearContactInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  ContactInfo ensureContactInfo() => $_ensure(1);

  @$pb.TagNumber(4)
  ContactList get contactList => $_getN(2);
  @$pb.TagNumber(4)
  set contactList(ContactList value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContactList() => $_has(2);
  @$pb.TagNumber(4)
  void clearContactList() => $_clearField(4);
  @$pb.TagNumber(4)
  ContactList ensureContactList() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
