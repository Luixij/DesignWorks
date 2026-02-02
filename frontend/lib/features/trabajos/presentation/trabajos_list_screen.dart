import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrabajosListScreen extends StatelessWidget {
  const TrabajosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder: luego lo conectamos a la API real
    final fakeIds = [1, 2, 3];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Proyectos', style: TextStyle(fontSize: 26)),
          const SizedBox(height: 12),
          for (final id in fakeIds)
            Card(
              child: ListTile(
                title: Text('Trabajo #$id'),
                subtitle: const Text('Tap para ver detalle'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => context.go('/trabajos/$id'),
              ),
            ),
        ],
      ),
    );
  }
}
