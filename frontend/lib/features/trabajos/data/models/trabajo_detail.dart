import 'enums.dart';
import 'usuario_basic.dart';
import 'participante.dart';
import 'requisito.dart';
import 'comentario.dart';
import 'historial_estado.dart';

class TrabajoDetail {
  final int id;
  final String titulo;
  final String cliente;
  final String descripcion;
  final String? imagenUrl;        // Campo adjunto_url / imagen_url de la tabla trabajos
  final Prioridad prioridad;
  final EstadoTrabajo estadoActual;
  final DateTime fechaInicio;
  final DateTime? fechaFin;

  final UsuarioBasic creadoPor;
  final List<Participante> participantes;
  final List<Requisito> requisitos;
  final List<Comentario> comentarios;
  final List<HistorialEstado> historial;

  const TrabajoDetail({
    required this.id,
    required this.titulo,
    required this.cliente,
    required this.descripcion,
    this.imagenUrl,
    required this.prioridad,
    required this.estadoActual,
    required this.fechaInicio,
    required this.fechaFin,
    required this.creadoPor,
    required this.participantes,
    required this.requisitos,
    required this.comentarios,
    required this.historial,
  });

  factory TrabajoDetail.fromJson(Map<String, dynamic> json) => TrabajoDetail(
    id: (json['id'] as num).toInt(),
    titulo: (json['titulo'] ?? '') as String,
    cliente: (json['cliente'] ?? '') as String,
    descripcion: (json['descripcion'] ?? '') as String,
    // Intenta los nombres más comunes que puede tener el campo en el backend
    imagenUrl: (json['imagenUrl'] ?? json['imagen_url'] ?? json['adjuntoUrl'] ?? json['adjunto_url']) as String?,
    prioridad: (json['prioridad'] as String).toPrioridad(),
    estadoActual: (json['estadoActual'] as String).toEstadoTrabajo(),
    fechaInicio: DateTime.parse(json['fechaInicio'] as String),
    fechaFin: json['fechaFin'] == null ? null : DateTime.parse(json['fechaFin'] as String),
    creadoPor: UsuarioBasic.fromJson(json['creadoPor'] as Map<String, dynamic>),
    participantes: (json['participantes'] as List<dynamic>)
        .map((e) => Participante.fromJson(e as Map<String, dynamic>))
        .toList(),
    requisitos: (json['requisitos'] as List<dynamic>)
        .map((e) => Requisito.fromJson(e as Map<String, dynamic>))
        .toList(),
    comentarios: (json['comentarios'] as List<dynamic>)
        .map((e) => Comentario.fromJson(e as Map<String, dynamic>))
        .toList(),
    historial: (json['historial'] as List<dynamic>)
        .map((e) => HistorialEstado.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}