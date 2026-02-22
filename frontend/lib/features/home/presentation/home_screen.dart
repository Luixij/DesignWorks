import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../trabajos/application/trabajos_providers.dart';
import '../../perfil/application/user_profile_provider.dart';

// Color de fondo compartido con el resto de pantallas
const _kBgColor = Color(0xFFF4F4F2);
const _kPadH = 20.0;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(homeStatsProvider);
    final asyncUser = ref.watch(currentUserProvider);

    return ColoredBox(
      color: _kBgColor,
      child: SafeArea(
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
          data: (stats) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: _kPadH, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Saludo dinámico ────────────────────────────────────────
                asyncUser.when(
                  loading: () => const Text(
                    'Hola',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  error: (_, __) => const Text(
                    'Hola',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  data: (user) {
                    if (user == null) {
                      return const Text(
                        'Hola',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      );
                    }
                    final primerNombre = user.nombre.split(' ').first;
                    return Row(
                      children: [
                        Text(
                          'Hola, $primerNombre',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          user.rol.toUpperCase() == 'ADMIN'
                              ? Icons.admin_panel_settings
                              : Icons.design_services,
                          size: 16,
                          color: user.colorAvatar,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'Actualmente tienes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D3142),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${stats.total} Trabajo${stats.total != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Stat Cards ─────────────────────────────────────────────
                _BigStatCard(
                  title: 'En progreso',
                  count: stats.enProgreso,
                  icon: Icons.code,
                  backgroundColor: const Color(0xFFB5D5A8),
                ),
                const SizedBox(height: 14),
                _BigStatCard(
                  title: 'En revisión',
                  count: stats.enRevision,
                  icon: Icons.search,
                  backgroundColor: const Color(0xFF8ECFBB),
                ),
                const SizedBox(height: 14),
                _BigStatCard(
                  title: 'Entregados',
                  count: stats.entregados,
                  icon: Icons.check,
                  backgroundColor: const Color(0xFF9DB8D9),
                ),
                const SizedBox(height: 14),
                _BigStatCard(
                  title: 'Creados',
                  count: stats.creados,
                  icon: Icons.schedule,
                  backgroundColor: const Color(0xFFD4D97A),
                ),
                const SizedBox(height: 14),
                _BigStatCard(
                  title: 'Cancelados',
                  count: stats.cancelados,
                  icon: Icons.close,
                  backgroundColor: const Color(0xFFE8A598),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color backgroundColor;

  const _BigStatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 20,
            child: Icon(icon, size: 22, color: Colors.black.withOpacity(0.45)),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.6),
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}