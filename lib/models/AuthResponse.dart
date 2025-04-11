// auth_response.dart
class AuthResponse {
  String? token;
  DateTime? expiration;
  String? error;

  AuthResponse({this.token, this.expiration, this.error});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      expiration:
          json['expiration'] != null
              ? DateTime.parse(json['expiration'])
              : null,
      error: json['error'],
    );
  }
}
