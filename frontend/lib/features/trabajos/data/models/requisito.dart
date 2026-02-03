class Requisito {
  final int id;
  final String descripcion;
  final String? adjuntoUrl;

  const Requisito({required this.id, required this.descripcion, this.adjuntoUrl});

  factory Requisito.fromJson(Map<String, dynamic> json) => Requisito(
    id: (json['id'] as num).toInt(),
    descripcion: (json['descripcion'] ?? '') as String,
    adjuntoUrl: json['adjuntoUrl'] as String?,
  );
}
