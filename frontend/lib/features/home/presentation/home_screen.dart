import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hola, Luis', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Resumen de trabajos (placeholder)', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 20),

            // Placeholder: luego lo conectamos a un provider que compute counts por estado
            const Card(child: ListTile(title: Text('En progreso'), trailing: Text('0'))),
            const Card(child: ListTile(title: Text('En revisión'), trailing: Text('0'))),
            const Card(child: ListTile(title: Text('Entregados'), trailing: Text('0'))),
            const Card(child: ListTile(title: Text('Creados'), trailing: Text('0'))),

            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/trabajos'),
              child: const Text('Ver todos los trabajos'),
            ),
          ],
        ),
      ),
    );
  }
}
