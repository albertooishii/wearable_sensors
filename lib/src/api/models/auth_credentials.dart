// 📦 Wearable Sensors Package - Auth Credentials Model
// Copyright (c) 2025 Alberto Oishi. Licensed under MPL-2.0.

/// Authentication credentials for wearable devices
///
/// Generic model for storing auth data required by various devices.
/// Vendor-specific implementations should extend or wrap this model.
class AuthCredentials {
  const AuthCredentials({
    this.authKey,
    this.username,
    this.password,
    this.token,
    this.userId,
    this.vendorSpecific,
  });

  /// Authentication key (e.g., hex string for Xiaomi devices)
  final String? authKey;

  /// Username for authentication (if required)
  final String? username;

  /// Password for authentication (if required)
  final String? password;

  /// Token for authentication (e.g., OAuth token)
  final String? token;

  /// User ID associated with the device
  final String? userId;

  /// Vendor-specific authentication data
  ///
  /// Use this for vendor-specific fields that don't fit
  /// in the generic model. For example:
  ///
  /// ```dart
  /// vendorSpecific: {
  ///   'xiaomi_secret_key': '0x...',
  ///   'xiaomi_user_id': '1234567890',
  ///   'fitbit_client_id': '...',
  /// }
  /// ```
  final Map<String, dynamic>? vendorSpecific;

  /// Whether these credentials have an auth key
  bool get hasAuthKey => authKey != null && authKey!.isNotEmpty;

  /// Whether these credentials have a token
  bool get hasToken => token != null && token!.isNotEmpty;

  /// Whether these credentials have username/password
  bool get hasUserPass =>
      username != null &&
      username!.isNotEmpty &&
      password != null &&
      password!.isNotEmpty;

  /// Whether these credentials are empty (no auth data)
  bool get isEmpty =>
      !hasAuthKey && !hasToken && !hasUserPass && vendorSpecific == null;

  AuthCredentials copyWith({
    String? authKey,
    String? username,
    String? password,
    String? token,
    String? userId,
    Map<String, dynamic>? vendorSpecific,
  }) {
    return AuthCredentials(
      authKey: authKey ?? this.authKey,
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      vendorSpecific: vendorSpecific ?? this.vendorSpecific,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (authKey != null) 'authKey': authKey,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (token != null) 'token': token,
      if (userId != null) 'userId': userId,
      if (vendorSpecific != null) 'vendorSpecific': vendorSpecific,
    };
  }

  factory AuthCredentials.fromJson(Map<String, dynamic> json) {
    return AuthCredentials(
      authKey: json['authKey'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      vendorSpecific: json['vendorSpecific'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'AuthCredentials(hasAuthKey: $hasAuthKey, '
        'hasToken: $hasToken, hasUserPass: $hasUserPass)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCredentials &&
          other.authKey == authKey &&
          other.username == username &&
          other.token == token &&
          other.userId == userId;

  @override
  int get hashCode => Object.hash(authKey, username, token, userId);
}
