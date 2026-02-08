import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../application/user_profile_provider.dart';
import '../../trabajos/application/trabajos_providers.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PERFIL SIEMPRE hidrata desde servidor
    final asyncUser = ref.watch(currentUserRefreshableProvider);
    // Obtenemos las estadísticas de trabajos
    final asyncStats = ref.watch(homeStatsProvider);

    return Scaffold(
      body: SafeArea(
        child: asyncUser.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error cargando perfil: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(secureStoreProvider).clear();
                      if (context.mounted) context.go('/login');
                    },
                    child: const Text('Cerrar sesión y volver al login'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(currentUserRefreshableProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (user) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con botón de logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            await ref.read(secureStoreProvider).clear();
                            ref.invalidate(currentUserProvider);
                            ref.invalidate(currentUserRefreshableProvider);
                            if (context.mounted) context.go('/login');
                          },
                          tooltip: 'Cerrar sesión',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Avatar circular grande
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: user.colorAvatar.withOpacity(0.15),
                        child: Text(
                          user.iniciales,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: user.colorAvatar,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nombre
                    Center(
                      child: Text(
                        user.nombre,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email
                    Center(
                      child: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Card de Rol
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rol',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  user.rol.toUpperCase() == 'ADMIN'
                                      ? Icons.admin_panel_settings
                                      : Icons.design_services,
                                  size: 22,
                                  color: user.colorAvatar,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  user.rolFormateado,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.rol.toUpperCase() == 'ADMIN'
                                  ? 'Puedes gestionar todos los proyectos'
                                  : 'Puedes gestionar los trabajos asignados',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sección "Mi actividad"
                    const Text(
                      'Mi actividad',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estadísticas
                    asyncStats.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Card(
                        color: Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Error cargando estadísticas',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (stats) => Column(
                        children: [
                          // Total de proyectos asignados
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    color: Colors.grey.shade700,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${stats.total} Proyectos asignados',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // En progreso (estilo home_screen)
                          Card(
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.withOpacity(0.1),
                                child: const Icon(
                                  Icons.hourglass_empty_outlined,
                                  color: Colors.orange,
                                ),
                              ),
                              title: const Text(
                                'En progreso',
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                stats.enProgreso.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Entregados (estilo home_screen)
                          Card(
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.withOpacity(0.1),
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                              title: const Text(
                                'Entregados',
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                stats.entregados.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}