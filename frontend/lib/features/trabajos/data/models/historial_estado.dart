import 'enums.dart';
import 'usuario_basic.dart';

class HistorialEstado {
  final int id;
  final EstadoTrabajo estado;
  final DateTime fecha;
  final String motivo;
  final UsuarioBasic usuario;

  const HistorialEstado({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.motivo,
    required this.usuario,
  });

  factory HistorialEstado.fromJson(Map<String, dynamic> json) => HistorialEstado(
    id: (json['id'] as num).toInt(),
    estado: (json['estado'] as String).toEstadoTrabajo(),
    fecha: DateTime.parse(json['fecha'] as String),
    motivo: (json['motivo'] ?? '') as String,
    usuario: UsuarioBasic.fromJson(json['usuario'] as Map<String, dynamic>),
  );
}
