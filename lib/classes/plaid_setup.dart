class PlaidSetup {
  final bool success;
  final int error;
  const PlaidSetup({required this.success, required this.error});

  factory PlaidSetup.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'success': bool success,
        'error': int error,
      } =>
        PlaidSetup(success: success, error: error),
      {
        'success': bool success,
      } =>
        PlaidSetup(success: success, error: -1),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
