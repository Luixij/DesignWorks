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

      final login =
      LoginResponse.fromJson(loginRes.data as Map<String, dynamic>);

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
      // ============================================
      // Manejo de errores HTTP (Dio)
      // - Prioridad: mensaje del backend (ErrorResponse.message)
      // - Fallback: mensajes por defecto según statusCode
      // ============================================
      final status = e.response?.statusCode;

      // Intenta leer mensaje del backend (ErrorResponse.message)
      String? backendMessage;
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data['message'] is String) {
        backendMessage = data['message'] as String;
      }

      if (status == 401) {
        // Credenciales inválidas
        throw Exception(backendMessage ?? 'Credenciales inválidas');
      } else if (status == 403) {
        // Usuario desactivado / acceso denegado
        throw Exception(backendMessage ?? 'Usuario desactivado');
      } else {
        // Otros errores: red, 500, timeouts, etc.
        throw Exception(backendMessage ?? 'Error de conexión: ${e.message}');
      }
    } catch (e) {
      // ============================================
      // Cualquier otro error inesperado
      // ============================================
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
      // ============================================
      // Manejo de errores en /auth/me
      // - Prioridad: mensaje del backend (ErrorResponse.message)
      // - 401 normalmente significa token inválido/expirado
      // ============================================
      final status = e.response?.statusCode;

      String? backendMessage;
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        backendMessage = data['message'] as String;
      }

      if (status == 401) {
        // Nota:
        // Si tu ApiClient ya hace store.clear() + onUnauthorized() en 401,
        // esto puede ser redundante, pero no hace daño.
        await store.clear();
        throw Exception(backendMessage ?? 'Sesión expirada');
      }

      throw Exception(
        backendMessage ?? 'Error obteniendo información del usuario: ${e.message}',
      );
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