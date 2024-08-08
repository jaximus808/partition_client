class PlaidTransactions {
  final bool success;
  final int error;
  final List<dynamic>? uncatTransactions;
  final List<dynamic>? wantTransaction;
  final List<dynamic>? needTransaction;
  final List<dynamic>? investTransaction;
  final double? totalIncome;
  const PlaidTransactions({
    required this.success,
    required this.error,
    required this.uncatTransactions,
    required this.wantTransaction,
    required this.needTransaction,
    required this.investTransaction,
    required this.totalIncome,
  });

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
          totalIncome: null,
        ),
      {
        'success': bool success,
        'uncat_transactions': List<dynamic> uncatTransaction,
        'want_transactions': List<dynamic> wantTransactions,
        'need_transactions': List<dynamic> needTransactions,
        'invest_transactions': List<dynamic> investTransaction,
        'total_income': double totalIncome,
      } =>
        PlaidTransactions(
          success: success,
          error: -1,
          uncatTransactions: uncatTransaction,
          wantTransaction: wantTransactions,
          needTransaction: needTransactions,
          investTransaction: investTransaction,
          totalIncome: totalIncome,
        ),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
