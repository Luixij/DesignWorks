import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'login_request.dart';
import 'login_response.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<LoginResponse> login(LoginRequest req) async {
    final Response res = await api.dio.post(
      '/auth/login',
      data: req.toJson(),
    );

    if (res.data is Map<String, dynamic>) {
      return LoginResponse.fromJson(res.data as Map<String, dynamic>);
    }

    // Si tu backend devuelve algo distinto, aquí lo detectas rápido
    throw Exception('Respuesta inesperada del login: ${res.data}');
  }
}
