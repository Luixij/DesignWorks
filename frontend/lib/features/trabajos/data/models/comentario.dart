import 'usuario_basic.dart';

class Comentario {
  final int id;
  final String texto;
  final DateTime fecha;
  final UsuarioBasic usuario;

  const Comentario({
    required this.id,
    required this.texto,
    required this.fecha,
    required this.usuario,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
    id: (json['id'] as num).toInt(),
    texto: (json['texto'] ?? '') as String,
    fecha: DateTime.parse(json['fecha'] as String),
    usuario: UsuarioBasic.fromJson(json['usuario'] as Map<String, dynamic>),
  );
}
