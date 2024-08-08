class PlaidTransactions {
  final bool success;
  final int error;
  final List<dynamic>? uncatTransactions;
  final List<dynamic>? wantTransaction;
  final List<dynamic>? needTransaction;
  final List<dynamic>? investTransaction;
  final List<dynamic>? incomeTransaction;
  final String? plaidCursor;
  const PlaidTransactions(
      {required this.success,
      required this.error,
      required this.uncatTransactions,
      required this.wantTransaction,
      required this.needTransaction,
      required this.investTransaction,
      required this.incomeTransaction,
      required this.plaidCursor});

  factory PlaidTransactions.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'success': bool success,
        'error': int error,
      } =>
        PlaidTransactions(
          success: success,
          error: error,
          uncatTransactions: null,
          wantTransaction: null,
          needTransaction: null,
          investTransaction: null,
          incomeTransaction: null,
          plaidCursor: null,
        ),
      {
        'success': bool success,
        'uncat_transactions': List<dynamic> uncatTransaction,
        'want_transactions': List<dynamic> wantTransactions,
        'need_transactions': List<dynamic> needTransactions,
        'invest_transactions': List<dynamic> investTransaction,
        'income_transactions': List<dynamic> incomeTransactions,
        'plaid_cursor': String plaidCursor,
      } =>
        PlaidTransactions(
            success: success,
            error: -1,
            uncatTransactions: uncatTransaction,
            wantTransaction: wantTransactions,
            needTransaction: needTransactions,
            investTransaction: investTransaction,
            incomeTransaction: incomeTransactions,
            plaidCursor: plaidCursor),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
