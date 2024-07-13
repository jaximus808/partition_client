class Token {
  final String expiration;
  final String linkToken;
  final String requestId;
  const Token(
      {required this.expiration,
      required this.linkToken,
      required this.requestId});

  factory Token.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'expiration': String expiration,
        'link_token': String linkToken,
        'request_id': String requestId
      } =>
        Token(
            expiration: expiration, linkToken: linkToken, requestId: requestId),
      _ => throw const FormatException('Failed to load token.'),
    };
  }
}
