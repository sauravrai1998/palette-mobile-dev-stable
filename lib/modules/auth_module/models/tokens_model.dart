class TokensModel {
  final String role;
  final String accessToken;
  final String refreshToken;

  TokensModel(
      {required this.role,
      required this.accessToken,
      required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {
      'role': this.role,
      'accessToken': this.accessToken,
      'refreshToken': this.refreshToken
    };
  }

  factory TokensModel.fromMap(Map item) {
    return TokensModel(
      role: item['role'].toString(),
      accessToken: item['data']['accessToken'].toString(),
      refreshToken: item['data']['refreshToken'].toString(),
    );
  }
}
