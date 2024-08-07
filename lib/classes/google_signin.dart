class GoogleSignIn {
  final bool success;
  final String? jwt;
  final int? error;
  final int? page;
  const GoogleSignIn({required this.success, this.jwt, this.error, this.page});

  factory GoogleSignIn.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'success': bool success,
        'jwt': String jwt,
        'error': int error,
        'page': null
      } =>
        GoogleSignIn(success: success, jwt: jwt, error: error),
      {
        'success': bool success,
        'jwt': String jwt,
        'error': int error,
        'page': int page
      } =>
        GoogleSignIn(
          success: success,
          jwt: jwt,
          error: error,
          page: page,
        ),
      _ => throw const FormatException('Failed to create object'),
    };
  }
}
