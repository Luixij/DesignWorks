import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                    onPressed: () => context.go('/trabajos/$trabajoId/estado'),
                    child: const Text('Cambiar estado'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go('/trabajos/$trabajoId/historial'),
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
                onPressed: () => context.go('/trabajos/$trabajoId/comentarios/nuevo'),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
