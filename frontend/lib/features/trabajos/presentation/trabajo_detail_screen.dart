import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';
import 'trabajo_cambiar_estado_dialog.dart';
import 'trabajo_historial_screen.dart';
import 'trabajo_nuevo_comentario_dialog.dart';

class TrabajoDetailScreen extends ConsumerWidget {
  final int trabajoId;
  const TrabajoDetailScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(trabajoDetailProvider(trabajoId));

    return asyncDetail.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (detail) => Scaffold(
        appBar: AppBar(title: Text(detail.titulo)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Información del trabajo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.titulo,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cliente: ${detail.cliente}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Estado: ${_getEstadoLabel(detail.estadoActual)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: _getColorForEstado(detail.estadoActual),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Prioridad: ${_getPrioridadLabel(detail.prioridad)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: _getColorForPrioridad(detail.prioridad),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicio: ${_formatDate(detail.fechaInicio)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      if (detail.fechaFin != null)
                        Text(
                          'Fin: ${_formatDate(detail.fechaFin!)}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      if (detail.descripcion.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Descripción:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(detail.descripcion),
                      ],
                      if (detail.participantes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Participantes:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ...detail.participantes.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• ${p.nombre} (${p.email}) - ${p.rolEnTrabajo.name}'),
                        )),
                      ],
                      if (detail.requisitos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Requisitos:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ...detail.requisitos.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• ${r.descripcion}'),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TrabajoCambiarEstadoDialog(trabajoId: trabajoId),
                        );
                      },
                      child: const Text('Cambiar estado'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TrabajoHistorialScreen(trabajoId: trabajoId),
                        );
                      },
                      child: const Text('Ver historial'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comentarios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '(${detail.comentarios.length})',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Lista de comentarios REAL
              if (detail.comentarios.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No hay comentarios todavía',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ...detail.comentarios.map((comentario) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                comentario.usuario.nombre.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comentario.usuario.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _formatDateTime(comentario.fecha),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(comentario.texto),
                      ],
                    ),
                  ),
                )),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TrabajoNuevoComentarioDialog(trabajoId: trabajoId),
                    );
                  },
                  child: const Icon(Icons.add),
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

  String _getPrioridadLabel(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.BAJA:
        return 'Baja';
      case Prioridad.MEDIA:
        return 'Media';
      case Prioridad.ALTA:
        return 'Alta';
      case Prioridad.URGENTE:
        return 'Urgente';
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

  Color _getColorForPrioridad(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.BAJA:
        return Colors.grey;
      case Prioridad.MEDIA:
        return Colors.blue;
      case Prioridad.ALTA:
        return Colors.orange;
      case Prioridad.URGENTE:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}