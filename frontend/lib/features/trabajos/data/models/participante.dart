import 'enums.dart';

class Participante {
  final int usuarioId;
  final String nombre;
  final String email;
  final Rol rolEnTrabajo;

  const Participante({
    required this.usuarioId,
    required this.nombre,
    required this.email,
    required this.rolEnTrabajo,
  });

  factory Participante.fromJson(Map<String, dynamic> json) => Participante(
    usuarioId: (json['usuarioId'] as num).toInt(),
    nombre: (json['nombre'] ?? '') as String,
    email: (json['email'] ?? '') as String,
    rolEnTrabajo: (json['rolEnTrabajo'] as String).toRol(),
  );
}
