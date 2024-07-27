class GoogleSignUp {
  final bool success;
  final String? jwt;
  const GoogleSignUp({required this.success, this.jwt});

  factory GoogleSignUp.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'success': bool success,
        'jwt': String jwt,
      } =>
        GoogleSignUp(success: success, jwt: jwt),
      _ => throw const FormatException('Failed to create object'),
    };
  }
}
