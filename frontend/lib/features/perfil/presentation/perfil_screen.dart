import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../application/user_profile_provider.dart';
import '../../trabajos/application/trabajos_providers.dart';

const _kBgColor = Color(0xFFF4F4F2);
const _kPadH = 20.0;

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(currentUserRefreshableProvider);
    final asyncStats = ref.watch(homeStatsProvider);

    return ColoredBox(
      color: _kBgColor,
      child: SafeArea(
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
                    onPressed: () =>
                        ref.invalidate(currentUserRefreshableProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (user) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: _kPadH, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Icono logout alineado a la derecha ─────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await ref.read(secureStoreProvider).clear();
                        ref.invalidate(currentUserProvider);
                        ref.invalidate(currentUserRefreshableProvider);
                        if (context.mounted) context.go('/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Avatar ─────────────────────────────────────────────
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.colorAvatar.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
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
                  const SizedBox(height: 20),

                  // ── Nombre ─────────────────────────────────────────────
                  Text(
                    user.nombre,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Email ──────────────────────────────────────────────
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A8FA3),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Card Rol ───────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rol',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A8FA3),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.rolFormateado,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.rol.toUpperCase() == 'ADMIN'
                              ? 'Puedes gestionar todos los proyectos'
                              : 'Puedes gestionar los trabajos asignados',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8FA3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Mi actividad ───────────────────────────────────────
                  asyncStats.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 12),
                          Text(
                            'Error cargando estadísticas',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    data: (stats) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título + total
                        const Text(
                          'Mi actividad',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${stats.total} ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const TextSpan(
                                text: 'Proyectos asignados',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF2D3142),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card En progreso
                        _BigStatCard(
                          title: 'En progreso',
                          count: stats.enProgreso,
                          icon: Icons.code,
                          backgroundColor: const Color(0xFFB5D5A8),
                        ),
                        const SizedBox(height: 14),

                        // Card Entregados
                        _BigStatCard(
                          title: 'Entregados',
                          count: stats.entregados,
                          icon: Icons.check,
                          backgroundColor: const Color(0xFF9DB8D9),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Big Stat Card (misma que home_screen) ─────────────────────────────────────

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
            child: Icon(
              icon,
              size: 22,
              color: Colors.black.withOpacity(0.45),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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