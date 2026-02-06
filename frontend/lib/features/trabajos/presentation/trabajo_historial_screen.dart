import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';

class TrabajoHistorialScreen extends ConsumerWidget {
  final int trabajoId;
  const TrabajoHistorialScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistorial = ref.watch(trabajoHistorialProvider(trabajoId));

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Historial de Estados',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: asyncHistorial.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
                            Icon(Icons.history, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No hay historial disponible',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    // Ordenar por fecha descendente (más reciente primero)
                    final historialOrdenado = List.from(historial)
                      ..sort((a, b) => b.fecha.compareTo(a.fecha));

                    return ListView.builder(
                      itemCount: historialOrdenado.length,
                      itemBuilder: (context, index) {
                        final item = historialOrdenado[index];
                        final isFirst = index == 0;
                        final isLast = index == historialOrdenado.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline visual
                            Column(
                              children: [
                                if (!isFirst)
                                  Container(
                                    width: 2,
                                    height: 12,
                                    color: Colors.grey.shade300,
                                  ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _getColorForEstado(item.estado),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: isFirst
                                      ? const Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 60,
                                    color: Colors.grey.shade300,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Contenido
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _getEstadoLabel(item.estado),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: _getColorForEstado(item.estado),
                                              ),
                                            ),
                                          ),
                                          if (isFirst)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'ACTUAL',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.usuario.nombre,
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatDateTime(item.fecha),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (item.motivo.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.comment,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  item.motivo,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEstadoLabel(EstadoTrabajo estado) {
    switch (estado) {
      case EstadoTrabajo.CREADO:
        return 'Creado';
      case EstadoTrabajo.EN_PROGRESO:
        return 'En Progreso';
      case EstadoTrabajo.EN_REVISION:
        return 'En Revisión';
      case EstadoTrabajo.ENTREGADO:
        return 'Entregado';
      case EstadoTrabajo.CANCELADO:
        return 'Cancelado';
    }
  }

  Color _getColorForEstado(EstadoTrabajo estado) {
    switch (estado) {
      case EstadoTrabajo.CREADO:
        return Colors.blue;
      case EstadoTrabajo.EN_PROGRESO:
        return Colors.orange;
      case EstadoTrabajo.EN_REVISION:
        return Colors.purple;
      case EstadoTrabajo.ENTREGADO:
        return Colors.green;
      case EstadoTrabajo.CANCELADO:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}