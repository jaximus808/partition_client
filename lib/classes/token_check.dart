class TokenCheck {
  final int loginStatus;
  final bool success;
  final String username;
  const TokenCheck({
    required this.loginStatus,
    required this.success,
    required this.username,
  });

  factory TokenCheck.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'loginStatus': int status,
        'success': bool success,
        'username': String username,
      } =>
        TokenCheck(loginStatus: status, success: success, username: username),
      _ => throw const FormatException('Failed to create object'),
    };
  }
}
