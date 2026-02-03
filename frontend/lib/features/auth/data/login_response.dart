class LoginResponse {
  final String token;
  final String rol;

  LoginResponse({required this.token, required this.rol});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final rawRol = (json['rol'] ?? '').toString().trim().toUpperCase();

    // Normalizar DISEÑADOR -> DISENADOR
    final normalizedRol = rawRol.replaceAll('Ñ', 'N');

    return LoginResponse(
      token: (json['token'] ?? '').toString(),
      rol: normalizedRol,
    );
  }
}
