class SetTransaction {
  final bool success;
  final int error;
  final List<dynamic>? newUncatTransactions;
  final String? newPlaidCursor;
  const SetTransaction(
      {required this.success,
      required this.error,
      required this.newUncatTransactions,
      required this.newPlaidCursor});

  factory SetTransaction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'success': bool success,
        'error': int error,
      } =>
        SetTransaction(
          success: success,
          error: error,
          newUncatTransactions: null,
          newPlaidCursor: null,
        ),
      {
        'success': bool success,
        'new_uncat_trans': List<dynamic> newUncatTransactions,
        'new_plaid_cursor': String newPlaidCursor,
      } =>
        SetTransaction(
          success: success,
          error: -1,
          newUncatTransactions: newUncatTransactions,
          newPlaidCursor: newPlaidCursor,
        ),
      {
        'success': bool success,
      } =>
        SetTransaction(
          success: success,
          error: -1,
          newUncatTransactions: null,
          newPlaidCursor: null,
        ),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
