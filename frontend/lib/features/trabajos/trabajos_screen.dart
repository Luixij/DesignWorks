import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

class TrabajosScreen extends ConsumerWidget {
  const TrabajosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trabajos')),
      body: Center(
        child: FutureBuilder<String?>(
          future: ref.read(secureStoreProvider).getRole(),
          builder: (context, snap) {
            return Text('Sesión OK. Rol: ${snap.data ?? "-"}');
          },
        ),
      ),
    );
  }
}
