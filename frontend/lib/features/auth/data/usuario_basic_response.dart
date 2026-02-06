/// DTO que representa la información básica del usuario autenticado.
///
/// Corresponde a la respuesta del endpoint GET /auth/me del backend.
///
/// Campos:
/// - id: Identificador único del usuario
/// - nombre: Nombre completo del usuario
/// - email: Email del usuario
/// - rol: Rol del usuario (ADMIN, DISENADOR, etc.)
class UsuarioBasicResponse {
  final int id;
  final String nombre;
  final String email;
  final String rol;

  const UsuarioBasicResponse({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory UsuarioBasicResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioBasicResponse(
      id: (json['id'] as num).toInt(),
      nombre: (json['nombre'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      rol: (json['rol'] ?? '').toString().toUpperCase(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'rol': rol,
  };

  @override
  String toString() => 'UsuarioBasicResponse(id: $id, nombre: $nombre, email: $email, rol: $rol)';
}