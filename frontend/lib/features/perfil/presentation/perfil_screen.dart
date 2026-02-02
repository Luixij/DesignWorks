import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perfil', style: TextStyle(fontSize: 26)),
            const SizedBox(height: 12),

            // Placeholder: luego lo alimentamos con datos del token o endpoint /me
            const CircleAvatar(radius: 38),
            const SizedBox(height: 12),
            const Text('Luis Imaicela', style: TextStyle(fontSize: 22)),
            const Text('luis_diseñador@email.com'),

            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(secureStoreProvider).clear();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
