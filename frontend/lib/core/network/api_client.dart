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
        // =========================================================
        // 1) Detección de endpoints especiales
        //    (para no mezclar login con sesión expirada)
        // =========================================================
        final path = options.path; // Ej: /auth/login
        final method = options.method.toUpperCase();

        final isLoginRequest =
        (method == 'POST' && path.contains('/auth/login'));

        // =========================================================
        // 2) Añadir token SOLO si NO es el endpoint de login
        //    (opcional pero recomendado para evitar enviar token viejo)
        // =========================================================
        if (!isLoginRequest) {
          final token = await store.getToken();

          // Normaliza token
          if (token != null && token.trim().isNotEmpty) {
            final t = token.startsWith('Bearer ') ? token.substring(7) : token;
            options.headers['Authorization'] = 'Bearer $t';
          }
        }

        // =========================================================
        // 3) Log SIEMPRE (para depuración)
        // =========================================================
        print('➡️ ${options.method} ${options.uri}');
        print('🔐 Authorization: ${options.headers['Authorization'] ?? 'NULL'}');

        handler.next(options);
      },
      onError: (e, handler) async {
        // =========================================================
        // Log de errores
        // =========================================================
        print(
          '❌ ${e.response?.statusCode} ${e.requestOptions.method} ${e.requestOptions.uri}',
        );
        print('🧾 RESP: ${e.response?.data}');

        final status = e.response?.statusCode;
        final path = e.requestOptions.path; // Ej: /auth/login
        final method = e.requestOptions.method.toUpperCase();

        // =========================================================
        // Evitar confusión:
        // - 401 en /auth/login = credenciales inválidas (NO logout global)
        // - 401 en otros endpoints = token inválido/expirado (SÍ logout)
        // =========================================================
        final isLoginRequest =
        (method == 'POST' && path.contains('/auth/login'));

        if (status == 401 && !isLoginRequest) {
          await store.clear();
          onUnauthorized();
        }

        // =========================================================
        // IMPORTANTE:
        // Propagar el error correctamente para que el Repository lo capture
        // =========================================================
        handler.reject(e);
      },
    ));

    return ApiClient._(dio);
  }
}