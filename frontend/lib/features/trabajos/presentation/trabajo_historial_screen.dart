import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';

const _estadoColors = {
  EstadoTrabajo.EN_PROGRESO: (
  bg: Color(0xFFB5D5A8),
  fg: Color(0xFF2D5A1B),
  label: 'En progreso',
  icon: Icons.code,
  ),
  EstadoTrabajo.EN_REVISION: (
  bg: Color(0xFF8ECFBB),
  fg: Color(0xFF1A5A46),
  label: 'En revisión',
  icon: Icons.search,
  ),
  EstadoTrabajo.ENTREGADO: (
  bg: Color(0xFF9DB8D9),
  fg: Color(0xFF1A3A5A),
  label: 'Entregado',
  icon: Icons.check,
  ),
  EstadoTrabajo.CREADO: (
  bg: Color(0xFFD4D97A),
  fg: Color(0xFF4A4E0A),
  label: 'Creado',
  icon: Icons.schedule,
  ),
  EstadoTrabajo.CANCELADO: (
  bg: Color(0xFFE8A598),
  fg: Color(0xFF5A1A10),
  label: 'Cancelado',
  icon: Icons.close,
  ),
};

class TrabajoHistorialScreen extends ConsumerWidget {
  final int trabajoId;
  const TrabajoHistorialScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistorial = ref.watch(trabajoHistorialProvider(trabajoId));

    return Dialog(
      backgroundColor: const Color(0xFFF4F4F2),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Título + cerrar ──────────────────────────────────────────
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Historial del trabajo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Lista ────────────────────────────────────────────────────
            Expanded(
              child: asyncHistorial.when(
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Error al cargar historial: $e'),
                    ],
                  ),
                ),
                data: (historial) {
                  if (historial.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 48, color: Color(0xFF8A8FA3)),
                          SizedBox(height: 8),
                          Text(
                            'No hay historial disponible',
                            style: TextStyle(color: Color(0xFF8A8FA3)),
                          ),
                        ],
                      ),
                    );
                  }

                  final historialOrdenado = List.from(historial)
                    ..sort((a, b) => b.fecha.compareTo(a.fecha));

                  return ListView.separated(
                    itemCount: historialOrdenado.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = historialOrdenado[index];
                      final colors = _estadoColors[item.estado]!;
                      final isFirst = index == 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Estado + ícono
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    colors.label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colors.fg,
                                    ),
                                  ),
                                ),
                                // Badge ACTUAL solo en el primero
                                if (isFirst)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.bg,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'ACTUAL',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: colors.fg,
                                      ),
                                    ),
                                  )
                                else
                                  Icon(
                                    colors.icon,
                                    size: 20,
                                    color: const Color(0xFF8A8FA3),
                                  ),
                              ],
                            ),

                            // Motivo (si existe)
                            if (item.motivo.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Motivo',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8A8FA3),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.motivo,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4A4E5A),
                                  height: 1.4,
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),
                            const Divider(color: Color(0xFFEEEEEE), height: 1),
                            const SizedBox(height: 10),

                            // Fecha + usuario
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: Color(0xFF8A8FA3),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatFecha(item.fecha),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF8A8FA3),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  item.usuario.nombre,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime date) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} ${meses[date.month - 1]}, ${date.year}';
  }
}