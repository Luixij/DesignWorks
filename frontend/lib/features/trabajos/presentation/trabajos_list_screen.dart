import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';

class TrabajosListScreen extends ConsumerWidget {
  const TrabajosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(trabajosListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: asyncList.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Column(
            children: [
              Text('Error: $e'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(trabajosActionsProvider).refreshList(),
                child: const Text('Reintentar'),
              )
            ],
          ),
          data: (list) => ListView(
            children: [
              const Text('Proyectos', style: TextStyle(fontSize: 26)),
              const SizedBox(height: 12),
              for (final t in list)
                Card(
                  child: ListTile(
                    title: Text(t.titulo),
                    subtitle: Text(t.cliente),
                    trailing: Text(t.estadoActual.name),
                    onTap: () => context.go('/trabajos/${t.id}'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
