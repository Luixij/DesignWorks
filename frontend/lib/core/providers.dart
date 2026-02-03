import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'network/api_client.dart';
import 'storage/secure_store.dart';
import '../features/auth/data/auth_repository.dart';

// Secure storage
final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

// Router (para redirecciones globales)
final goRouterProvider = StateProvider<GoRouter?>((ref) => null);

// ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final router = ref.watch(goRouterProvider); // watch, no read
  final store = ref.read(secureStoreProvider);

  return ApiClient(
    store: store,
    onUnauthorized: () => router?.go('/login'),
  );
});

// Repos
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(apiClientProvider);
  final store = ref.read(secureStoreProvider);

  // ✅ ahora AuthRepository necesita (api, store)
  return AuthRepository(api, store);
});
