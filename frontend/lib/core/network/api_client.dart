import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../storage/secure_store.dart';

class ApiClient {
  final Dio dio;
  ApiClient._(this.dio);

  factory ApiClient({
    required SecureStore store,
    required void Function() onUnauthorized,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await store.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await store.clear();       // RF2: token inválido/caducado -> limpiar sesión
          onUnauthorized();          // volver a login
        }
        handler.next(e);
      },
    ));

    return ApiClient._(dio);
  }
}
