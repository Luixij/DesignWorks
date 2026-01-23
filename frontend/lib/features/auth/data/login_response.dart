class LoginResponse {
  final String token;
  final String rol;

  LoginResponse({required this.token, required this.rol});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: (json['token'] ?? '') as String,
      rol: (json['rol'] ?? '') as String,
    );
  }
}
