import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_store.dart';
import 'login_request.dart';
import 'login_response.dart';
import 'usuario_basic_response.dart';

class AuthRepository {
  final ApiClient api;
  final SecureStore store;

  AuthRepository(this.api, this.store);

  /// Login completo con flujo de 2 pasos:
  /// 1) POST /auth/login -> token + rol
  /// 2) GET /auth/me     -> id + nombre + email + rol
  Future<LoginResponse> login(LoginRequest req) async {
    try {
      // ============================================
      // PASO 1: Autenticación (obtener token)
      // ============================================
      final Response loginRes = await api.dio.post(
        '/auth/login',
        data: req.toJson(),
      );

      if (loginRes.data is! Map<String, dynamic>) {
        throw Exception('Respuesta inesperada del login: ${loginRes.data}');
      }

      final login = LoginResponse.fromJson(loginRes.data as Map<String, dynamic>);

      // ============================================
      // PASO 2: Limpiar sesión anterior
      // ============================================
      await store.clear();

      // ============================================
      // PASO 3: Guardar token y rol (mínimo) para poder llamar /auth/me
      // ============================================
      await store.saveToken(login.token);
      await store.saveRole(login.rol);

      // ============================================
      // PASO 4: Obtener información completa del usuario
      // ============================================
      final userInfo = await getCurrentUser();

      // ============================================
      // PASO 5: Guardar información del usuario (incluido rol definitivo)
      // ============================================
      await store.saveUserId(userInfo.id);
      await store.saveUserName(userInfo.nombre);
      await store.saveUserEmail(userInfo.email);
      await store.saveRole(userInfo.rol);

      return login;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales inválidas');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Usuario desactivado');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado durante el login: $e');
    }
  }

  /// GET /auth/me
  /// Requiere que el token ya esté guardado en SecureStore.
  Future<UsuarioBasicResponse> getCurrentUser() async {
    try {
      final Response res = await api.dio.get('/auth/me');

      if (res.data is! Map<String, dynamic>) {
        throw Exception('Respuesta inesperada de /auth/me: ${res.data}');
      }

      return UsuarioBasicResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await store.clear();
        throw Exception('Sesión expirada');
      }
      throw Exception('Error obteniendo información del usuario: ${e.message}');
    }
  }

  /// Refresca la info del usuario desde servidor y actualiza SecureStore
  Future<void> refreshUserInfo() async {
    final userInfo = await getCurrentUser();

    await store.saveUserId(userInfo.id);
    await store.saveUserName(userInfo.nombre);
    await store.saveUserEmail(userInfo.email);
    await store.saveRole(userInfo.rol);
  }
}
