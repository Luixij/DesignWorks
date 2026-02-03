class UsuarioBasic {
  final int id;
  final String nombre;
  final String email;

  const UsuarioBasic({required this.id, required this.nombre, required this.email});

  factory UsuarioBasic.fromJson(Map<String, dynamic> json) => UsuarioBasic(
    id: (json['id'] as num).toInt(),
    nombre: (json['nombre'] ?? '') as String,
    email: (json['email'] ?? '') as String,
  );
}
