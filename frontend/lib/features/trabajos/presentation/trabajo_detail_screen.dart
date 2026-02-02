import 'package:flutter/material.dart';
import 'trabajo_cambiar_estado_dialog.dart';
import 'trabajo_historial_screen.dart';
import 'trabajo_nuevo_comentario_dialog.dart';

class TrabajoDetailScreen extends StatelessWidget {
  final int trabajoId;
  const TrabajoDetailScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle #$trabajoId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Aquí irá el detalle real (TrabajoDetailResponse)', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 12),

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

            // Placeholder
            const Card(child: ListTile(title: Text('Comentario ejemplo'), subtitle: Text('...'))),

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
    );
  }
}