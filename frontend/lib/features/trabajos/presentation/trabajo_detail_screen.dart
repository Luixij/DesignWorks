import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/trabajos_providers.dart';
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
                        'Estado: ${detail.estadoActual.name}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _getColorForEstado(detail.estadoActual.name),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (detail.descripcion != null) ...[
                        const SizedBox(height: 8),
                        Text(detail.descripcion!),
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
              const Text('Comentarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Lista de comentarios (placeholder por ahora)
              const Card(
                child: ListTile(
                  title: Text('Comentario ejemplo'),
                  subtitle: Text('...'),
                ),
              ),

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

  Color _getColorForEstado(String estado) {
    switch (estado.toUpperCase()) {
      case 'CREADO':
        return Colors.blue;
      case 'EN_PROGRESO':
        return Colors.orange;
      case 'EN_REVISION':
        return Colors.purple;
      case 'ENTREGADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}