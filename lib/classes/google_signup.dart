class GoogleSignUp {
  final bool success;
  final String? jwt;
  final int? error;
  const GoogleSignUp({required this.success, this.jwt, this.error});

  factory GoogleSignUp.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'success': bool success, 'jwt': String jwt, 'error': int error} =>
        GoogleSignUp(
          success: success,
          jwt: jwt,
          error: error,
        ),
      _ => throw const FormatException('Failed to create object'),
    };
  }
}
