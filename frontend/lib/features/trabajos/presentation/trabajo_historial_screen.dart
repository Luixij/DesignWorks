import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrabajoHistorialScreen extends StatelessWidget {
  final int trabajoId;
  const TrabajoHistorialScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Historial del trabajo #$trabajoId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            const ListTile(title: Text('Creado'), subtitle: Text('Motivo: ...')),
            const ListTile(title: Text('En progreso'), subtitle: Text('Motivo: ...')),
          ],
        ),
      ),
    );
  }
}
