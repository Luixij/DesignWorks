import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/ui/app_shell.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/perfil/presentation/perfil_screen.dart';
import 'features/trabajos/presentation/trabajos_list_screen.dart';
import 'features/trabajos/presentation/trabajo_detail_screen.dart';
import 'features/trabajos/presentation/trabajo_historial_screen.dart';
import 'features/trabajos/presentation/trabajo_cambiar_estado_dialog.dart';
import 'features/trabajos/presentation/trabajo_nuevo_comentario_dialog.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) async {
        final container = ProviderScope.containerOf(context, listen: false);
        final token = await container.read(secureStoreProvider).getToken();

        final loggingIn = state.matchedLocation == '/login';

        if (token == null || token.isEmpty) {
          return loggingIn ? null : '/login';
        }

        // Si ya está logueado y va a /login -> lo mandamos al Home
        return loggingIn ? '/home' : null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),

        /// Shell con BottomNav: Home / Trabajos / Perfil
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/trabajos',
              builder: (context, state) => const TrabajosListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return TrabajoDetailScreen(trabajoId: id);
                  },
                  routes: [
                    // Popups como en wireframes (dialogs)
                    GoRoute(
                      path: 'historial',
                      pageBuilder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return DialogPage(child: TrabajoHistorialScreen(trabajoId: id));
                      },
                    ),
                    GoRoute(
                      path: 'estado',
                      pageBuilder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return DialogPage(child: TrabajoCambiarEstadoDialog(trabajoId: id));
                      },
                    ),
                    GoRoute(
                      path: 'comentarios/nuevo',
                      pageBuilder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return DialogPage(child: TrabajoNuevoComentarioDialog(trabajoId: id));
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const PerfilScreen(),
            ),
          ],
        ),
      ],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(goRouterProvider.notifier).state = _router;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

/// Página tipo diálogo (para popups estilo wireframe)
class DialogPage extends Page<void> {
  final Widget child;
  const DialogPage({required this.child});

  @override
  Route<void> createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      builder: (_) => child,
    );
  }
}
