import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../trabajos/application/trabajos_providers.dart';
import '../../perfil/application/user_profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(homeStatsProvider);
    final asyncUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: asyncStats.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error cargando estadísticas: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(homeStatsProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          data: (stats) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo dinámico con el nombre del usuario
              asyncUser.when(
                loading: () => const Text(
                  'Hola',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                error: (_, __) => const Text(
                  'Hola',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                data: (user) {
                  if (user == null) {
                    return const Text(
                      'Hola',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  }

                  // Obtener solo el primer nombre
                  final primerNombre = user.nombre.split(' ').first;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $primerNombre',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            user.rol.toUpperCase() == 'ADMIN'
                                ? Icons.admin_panel_settings
                                : Icons.design_services,
                            size: 16,
                            color: user.colorAvatar,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.rolFormateado,
                            style: TextStyle(
                              fontSize: 14,
                              color: user.colorAvatar,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Tienes ${stats.total} trabajo${stats.total != 1 ? 's' : ''} asignado${stats.total != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Cards de estadísticas
              _StatCard(
                title: 'Creados',
                count: stats.creados,
                icon: Icons.new_releases_outlined,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'En progreso',
                count: stats.enProgreso,
                icon: Icons.hourglass_empty_outlined,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'En revisión',
                count: stats.enRevision,
                icon: Icons.visibility_outlined,
                color: Colors.purple,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Entregados',
                count: stats.entregados,
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Cancelados',
                count: stats.cancelados,
                icon: Icons.cancel_outlined,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}