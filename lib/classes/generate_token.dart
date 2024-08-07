//plaid token
class Token {
  final String expiration;
  final String linkToken;
  final String requestId;
  final bool success;
  const Token(
      {required this.expiration,
      required this.linkToken,
      required this.requestId,
      required this.success});

  factory Token.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'expiration': String expiration,
        'link_token': String linkToken,
        'request_id': String requestId
      } =>
        Token(
            expiration: expiration,
            linkToken: linkToken,
            requestId: requestId,
            success: true),
      {'success': bool success} => Token(
          expiration: '',
          linkToken: '',
          requestId: '',
          success: success,
        ),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
