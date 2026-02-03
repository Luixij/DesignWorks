class HomeStats {
  final int enProgreso;
  final int enRevision;
  final int entregados;
  final int creados;
  final int cancelados;
  final int total;

  const HomeStats({
    required this.enProgreso,
    required this.enRevision,
    required this.entregados,
    required this.creados,
    required this.cancelados,
    required this.total,
  });

  factory HomeStats.empty() => const HomeStats(
    enProgreso: 0,
    enRevision: 0,
    entregados: 0,
    creados: 0,
    cancelados: 0,
    total: 0,
  );
}