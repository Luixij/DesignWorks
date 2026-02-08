import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';

// Provider para el filtro seleccionado
final estadoFiltroProvider = StateProvider<EstadoTrabajo?>((ref) => null);

class TrabajosListScreen extends ConsumerWidget {
  const TrabajosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(trabajosListProvider);
    final filtroSeleccionado = ref.watch(estadoFiltroProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  onPressed: () => ref.read(trabajosActionsProvider).refreshList(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (list) {
            // Filtrar la lista según el estado seleccionado
            final listaFiltrada = filtroSeleccionado == null
                ? list
                : list.where((t) => t.estadoActual == filtroSeleccionado).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con título y búsqueda
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Proyectos',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // TODO: Implementar búsqueda
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Chips de filtro
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Creados',
                        estado: EstadoTrabajo.CREADO,
                        filtroActual: filtroSeleccionado,
                        onSelected: (selected) {
                          ref.read(estadoFiltroProvider.notifier).state =
                          selected ? EstadoTrabajo.CREADO : null;
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'En progreso',
                        estado: EstadoTrabajo.EN_PROGRESO,
                        filtroActual: filtroSeleccionado,
                        onSelected: (selected) {
                          ref.read(estadoFiltroProvider.notifier).state =
                          selected ? EstadoTrabajo.EN_PROGRESO : null;
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'En revisión',
                        estado: EstadoTrabajo.EN_REVISION,
                        filtroActual: filtroSeleccionado,
                        onSelected: (selected) {
                          ref.read(estadoFiltroProvider.notifier).state =
                          selected ? EstadoTrabajo.EN_REVISION : null;
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Entregados',
                        estado: EstadoTrabajo.ENTREGADO,
                        filtroActual: filtroSeleccionado,
                        onSelected: (selected) {
                          ref.read(estadoFiltroProvider.notifier).state =
                          selected ? EstadoTrabajo.ENTREGADO : null;
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Cancelados',
                        estado: EstadoTrabajo.CANCELADO,
                        filtroActual: filtroSeleccionado,
                        onSelected: (selected) {
                          ref.read(estadoFiltroProvider.notifier).state =
                          selected ? EstadoTrabajo.CANCELADO : null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de proyectos
                Expanded(
                  child: listaFiltrada.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filtroSeleccionado == null
                              ? 'No hay proyectos'
                              : 'No hay proyectos en este estado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final trabajo = listaFiltrada[index];
                      return _TrabajoCard(trabajo: trabajo);
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

  Widget _buildFilterChip({
    required String label,
    required EstadoTrabajo estado,
    required EstadoTrabajo? filtroActual,
    required Function(bool) onSelected,
  }) {
    final isSelected = filtroActual == estado;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey.shade200,
      selectedColor: _getColorForEstado(estado).withOpacity(0.2),
      checkmarkColor: _getColorForEstado(estado),
      labelStyle: TextStyle(
        color: isSelected ? _getColorForEstado(estado) : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Color _getColorForEstado(EstadoTrabajo estado) {
    switch (estado) {
      case EstadoTrabajo.CREADO:
        return Colors.blue;
      case EstadoTrabajo.EN_PROGRESO:
        return Colors.green;
      case EstadoTrabajo.EN_REVISION:
        return Colors.orange;
      case EstadoTrabajo.ENTREGADO:
        return Colors.blue.shade700;
      case EstadoTrabajo.CANCELADO:
        return Colors.red;
    }
  }
}

class _TrabajoCard extends StatelessWidget {
  final trabajo;

  const _TrabajoCard({required this.trabajo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.go('/trabajos/${trabajo.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y flecha
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trabajo.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
              const SizedBox(height: 8),

              // Cliente
              Row(
                children: [
                  const Text(
                    'Cliente',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      trabajo.cliente,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fecha y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        _formatFecha(trabajo.fechaInicio),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  _buildEstadoChip(trabajo.estadoActual),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoChip(EstadoTrabajo estado) {
    Color color;
    String label;

    switch (estado) {
      case EstadoTrabajo.CREADO:
        color = Colors.blue;
        label = 'Creado';
        break;
      case EstadoTrabajo.EN_PROGRESO:
        color = Colors.green;
        label = 'En progreso';
        break;
      case EstadoTrabajo.EN_REVISION:
        color = Colors.orange;
        label = 'En revisión';
        break;
      case EstadoTrabajo.ENTREGADO:
        color = Colors.blue.shade700;
        label = 'Entregado';
        break;
      case EstadoTrabajo.CANCELADO:
        color = Colors.red;
        label = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    final meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}, ${fecha.year}';
  }
}