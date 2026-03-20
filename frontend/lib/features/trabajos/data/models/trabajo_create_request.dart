import 'enums.dart';

/// Equivalente Dart de TrabajoCreateRequest.java
class TrabajoCreateRequest {
  final String titulo;
  final String cliente;
  final String descripcion;
  final Prioridad prioridad;
  final String? fechaFin; // formato "yyyy-MM-dd"
  final List<Map<String, dynamic>> participantes;
  final List<Map<String, dynamic>> requisitos;

  TrabajoCreateRequest({
    required this.titulo,
    required this.cliente,
    required this.descripcion,
    required this.prioridad,
    this.fechaFin,
    this.participantes = const [],
    this.requisitos = const [],
  });

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'cliente': cliente,
    'descripcion': descripcion,
    'prioridad': prioridad.toJson(),
    if (fechaFin != null) 'fechaFin': fechaFin,
    'participantes': participantes,
    'requisitos': requisitos,
  };
}