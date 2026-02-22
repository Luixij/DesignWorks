import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';
import '../data/models/trabajo_list_item.dart';

// ── Paleta de colores por estado (compartida con home_screen) ─────────────────
// bg = fondo del badge/chip activo, fg = texto sobre ese fondo
const _estadoColors = {
  EstadoTrabajo.EN_PROGRESO: (
  bg: Color(0xFFB5D5A8),
  fg: Color(0xFF2D5A1B),
  label: 'En progreso',
  ),
  EstadoTrabajo.EN_REVISION: (
  bg: Color(0xFF8ECFBB),
  fg: Color(0xFF1A5A46),
  label: 'En revisión',
  ),
  EstadoTrabajo.ENTREGADO: (
  bg: Color(0xFF9DB8D9),
  fg: Color(0xFF1A3A5A),
  label: 'Entregado',
  ),
  EstadoTrabajo.CREADO: (
  bg: Color(0xFFD4D97A),
  fg: Color(0xFF4A4E0A),
  label: 'Creado',
  ),
  EstadoTrabajo.CANCELADO: (
  bg: Color(0xFFE8A598),
  fg: Color(0xFF5A1A10),
  label: 'Cancelado',
  ),
};

const _kBgColor = Color(0xFFF4F4F2);
const _kPadH = 20.0;

// Provider para el filtro seleccionado
final estadoFiltroProvider = StateProvider<EstadoTrabajo?>((ref) => null);

class TrabajosListScreen extends ConsumerWidget {
  const TrabajosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(trabajosListProvider);
    final filtroSeleccionado = ref.watch(estadoFiltroProvider);

    return ColoredBox(
      color: _kBgColor,
      child: SafeArea(
        child: asyncList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $e'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(trabajosActionsProvider).refreshList(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (list) {
            final listaFiltrada = filtroSeleccionado == null
                ? list
                : list
                .where((t) => t.estadoActual == filtroSeleccionado)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(_kPadH, 20, _kPadH, 0),
                  child: Text(
                    'Proyectos',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Chips de filtro ──────────────────────────────────────────
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: _kPadH),
                    children: [
                      _FilterChip(
                        estado: EstadoTrabajo.EN_PROGRESO,
                        filtroActual: filtroSeleccionado,
                        onTap: () => _toggleFiltro(
                            ref, filtroSeleccionado, EstadoTrabajo.EN_PROGRESO),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        estado: EstadoTrabajo.EN_REVISION,
                        filtroActual: filtroSeleccionado,
                        onTap: () => _toggleFiltro(
                            ref, filtroSeleccionado, EstadoTrabajo.EN_REVISION),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        estado: EstadoTrabajo.ENTREGADO,
                        filtroActual: filtroSeleccionado,
                        onTap: () => _toggleFiltro(
                            ref, filtroSeleccionado, EstadoTrabajo.ENTREGADO),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        estado: EstadoTrabajo.CREADO,
                        filtroActual: filtroSeleccionado,
                        onTap: () => _toggleFiltro(
                            ref, filtroSeleccionado, EstadoTrabajo.CREADO),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        estado: EstadoTrabajo.CANCELADO,
                        filtroActual: filtroSeleccionado,
                        onTap: () => _toggleFiltro(
                            ref, filtroSeleccionado, EstadoTrabajo.CANCELADO),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Lista ────────────────────────────────────────────────────
                Expanded(
                  child: listaFiltrada.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          filtroSeleccionado == null
                              ? 'No hay proyectos'
                              : 'No hay proyectos en este estado',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _kPadH),
                    itemCount: listaFiltrada.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _TrabajoCard(
                          trabajo: listaFiltrada[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleFiltro(
      WidgetRef ref, EstadoTrabajo? actual, EstadoTrabajo nuevo) {
    ref.read(estadoFiltroProvider.notifier).state =
    actual == nuevo ? null : nuevo;
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final EstadoTrabajo estado;
  final EstadoTrabajo? filtroActual;
  final VoidCallback onTap;

  const _FilterChip({
    required this.estado,
    required this.filtroActual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = filtroActual == estado;
    final colors = _estadoColors[estado]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.bg : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colors.bg : const Color(0xFFDDDDDD),
          ),
        ),
        child: Text(
          colors.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? colors.fg : const Color(0xFF2D3142),
          ),
        ),
      ),
    );
  }
}

// ── Trabajo Card ──────────────────────────────────────────────────────────────

class _TrabajoCard extends StatelessWidget {
  final TrabajoListItem trabajo;

  const _TrabajoCard({required this.trabajo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/trabajos/${trabajo.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Título + flecha ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    trabajo.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_outward,
                  size: 20,
                  color: Color(0xFF2D3142),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Cliente ────────────────────────────────────────────────────
            const Text(
              'Cliente',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A8FA3),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trabajo.cliente,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),

            // ── Fecha + Badge estado ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Color(0xFF8A8FA3),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatFecha(trabajo.fechaInicio),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A8FA3),
                      ),
                    ),
                  ],
                ),
                _EstadoBadge(estado: trabajo.estadoActual),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}, ${fecha.year}';
  }
}

// ── Estado Badge ──────────────────────────────────────────────────────────────

class _EstadoBadge extends StatelessWidget {
  final EstadoTrabajo estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final colors = _estadoColors[estado]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        colors.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.fg,
        ),
      ),
    );
  }
}