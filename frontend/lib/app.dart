import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



import 'core/providers.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/trabajos/trabajos_screen.dart';

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
        // Importante: NO uses `ref` aquí (explico abajo).
        final container = ProviderScope.containerOf(context, listen: false);
        final token = await container.read(secureStoreProvider).getToken();

        final loggingIn = state.matchedLocation == '/login';

        if (token == null || token.isEmpty) {
          return loggingIn ? null : '/login';
        }
        return loggingIn ? '/trabajos' : null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/trabajos',
          builder: (context, state) => const TrabajosScreen(),
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
