import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../auth/data/usuario_basic_response.dart';

/// Modelo que representa la información del usuario actual
class CurrentUser {
  final int id;
  final String nombre;
  final String email;
  final String rol;

  const CurrentUser({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory CurrentUser.fromSecureStore({
    required int id,
    required String nombre,
    required String email,
    required String rol,
  }) {
    return CurrentUser(
      id: id,
      nombre: nombre,
      email: email,
      rol: rol,
    );
  }

  factory CurrentUser.fromUsuarioBasic(UsuarioBasicResponse response) {
    return CurrentUser(
      id: response.id,
      nombre: response.nombre,
      email: response.email,
      rol: response.rol,
    );
  }

  String get rolFormateado {
    switch (rol.toUpperCase()) {
      case 'ADMIN':
        return 'Administrador';
      case 'DISENADOR':
      case 'DISEÑADOR':
        return 'Diseñador';
      default:
        return rol;
    }
  }

  String get iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes[0].substring(0, 1).toUpperCase();
    return '${partes[0].substring(0, 1)}${partes[1].substring(0, 1)}'.toUpperCase();
  }

  Color get colorAvatar {
    switch (rol.toUpperCase()) {
      case 'ADMIN':
        return const Color(0xFF1976D2);
      case 'DISENADOR':
      case 'DISEÑADOR':
        return const Color(0xFF7B1FA2);
      default:
        return const Color(0xFF616161);
    }
  }

  @override
  String toString() => 'CurrentUser(id: $id, nombre: $nombre, email: $email, rol: $rol)';
}

/// Provider que obtiene la información del usuario actual desde SecureStore.
/// Si faltan datos, intenta hidratar llamando a /auth/me.
final currentUserProvider = FutureProvider<CurrentUser?>((ref) async {
  print('\n📊 currentUserProvider: Iniciando lectura de SecureStore...');
  final store = ref.read(secureStoreProvider);

  final id = await store.getUserId();
  final nombre = await store.getUserName();
  final email = await store.getUserEmail();
  final rol = await store.getRole();

  print('  📊 Datos leídos:');
  print('     ID: $id');
  print('     Nombre: $nombre');
  print('     Email: $email');
  print('     Rol: $rol');

  final incomplete = (id == null || nombre == null || email == null || rol == null);

  if (incomplete) {
    print('  ⚠️ DATOS INCOMPLETOS en SecureStore. Intentando hidratar desde /auth/me...');

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final userInfo = await authRepo.getCurrentUser();

      await store.saveUserId(userInfo.id);
      await store.saveUserName(userInfo.nombre);
      await store.saveUserEmail(userInfo.email);
      await store.saveRole(userInfo.rol);

      final user = CurrentUser.fromUsuarioBasic(userInfo);
      print('  ✅ Hidratado desde servidor: ${user.toString()}\n');
      return user;
    } catch (e) {
      print('  ❌ No se pudo hidratar desde servidor: $e');
      // Si no se puede hidratar (token inválido, etc.), devolvemos null.
      return null;
    }
  }

  final user = CurrentUser.fromSecureStore(
    id: id!,
    nombre: nombre!,
    email: email!,
    rol: rol!,
  );

  print('  CurrentUser creado: ${user.toString()}\n');
  return user;
});

/// Provider que refresca la información del usuario desde el servidor.
/// Llama a GET /auth/me y actualiza el SecureStore.
final currentUserRefreshableProvider = FutureProvider.autoDispose<CurrentUser>((ref) async {
  print('\n🔄 currentUserRefreshableProvider: Refrescando desde servidor...');
  final authRepo = ref.read(authRepositoryProvider);
  final store = ref.read(secureStoreProvider);

  final userInfo = await authRepo.getCurrentUser();
  print('  📦 Datos recibidos del servidor: ${userInfo.toString()}');

  await store.saveUserName(userInfo.nombre);
  await store.saveUserEmail(userInfo.email);
  await store.saveUserId(userInfo.id);
  await store.saveRole(userInfo.rol);

  // Para que Home/otros widgets que usan currentUserProvider se actualicen
  ref.invalidate(currentUserProvider);

  final user = CurrentUser.fromUsuarioBasic(userInfo);
  print('  ✅ Usuario refrescado: ${user.toString()}\n');

  return user;
});

class UserProfileActions {
  final Ref ref;
  UserProfileActions(this.ref);

  Future<void> refresh() async {
    print('🔄 UserProfileActions.refresh()');
    ref.invalidate(currentUserRefreshableProvider);
    await ref.read(currentUserRefreshableProvider.future);
  }

  void invalidateCache() {
    print('🗑️ UserProfileActions.invalidateCache()');
    ref.invalidate(currentUserProvider);
  }
}

final userProfileActionsProvider = Provider<UserProfileActions>((ref) {
  return UserProfileActions(ref);
});
