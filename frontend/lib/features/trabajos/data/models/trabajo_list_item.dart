import 'enums.dart';

class TrabajoListItem {
  final int id;
  final String titulo;
  final String cliente;
  final Prioridad prioridad;
  final EstadoTrabajo estadoActual;
  final DateTime fechaInicio;
  final DateTime? fechaFin;

  const TrabajoListItem({
    required this.id,
    required this.titulo,
    required this.cliente,
    required this.prioridad,
    required this.estadoActual,
    required this.fechaInicio,
    this.fechaFin,
  });

  factory TrabajoListItem.fromJson(Map<String, dynamic> json) => TrabajoListItem(
    id: (json['id'] as num).toInt(),
    titulo: (json['titulo'] ?? '') as String,
    cliente: (json['cliente'] ?? '') as String,
    prioridad: (json['prioridad'] as String).toPrioridad(),
    estadoActual: (json['estadoActual'] as String).toEstadoTrabajo(),
    fechaInicio: DateTime.parse(json['fechaInicio'] as String),
    fechaFin: json['fechaFin'] == null ? null : DateTime.parse(json['fechaFin'] as String),
  );
}
