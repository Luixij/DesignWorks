import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_store.dart';
import 'login_request.dart';
import 'login_response.dart';

class AuthRepository {
  final ApiClient api;
  final SecureStore store;

  AuthRepository(this.api, this.store);

  Future<LoginResponse> login(LoginRequest req) async {
    final Response res = await api.dio.post(
      '/auth/login',
      data: req.toJson(),
    );

    if (res.data is! Map<String, dynamic>) {
      throw Exception('Respuesta inesperada del login: ${res.data}');
    }

    final login = LoginResponse.fromJson(res.data as Map<String, dynamic>);

    // IMPORTANTE: limpiar sesión anterior y guardar la nueva
    await store.clear();
    await store.saveSession(token: login.token, role: login.rol);

    // (Opcional) logs para verificar
    // print('🔐 Rol guardado: ${await store.getRole()}');
    // print('🔐 Token guardado null? ${(await store.getToken()) == null}');

    return login;
  }
}
