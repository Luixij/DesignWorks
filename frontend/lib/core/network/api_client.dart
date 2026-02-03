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

        // Normaliza token
        if (token != null && token.trim().isNotEmpty) {
          final t = token.startsWith('Bearer ') ? token.substring(7) : token;
          options.headers['Authorization'] = 'Bearer $t';
        }

        //  Log SIEMPRE
        print('➡️ ${options.method} ${options.uri}');
        print('🔐 Authorization: ${options.headers['Authorization'] ?? 'NULL'}');

        handler.next(options);
      },
      onError: (e, handler) async {
        print('❌ ${e.response?.statusCode} ${e.requestOptions.method} ${e.requestOptions.uri}');
        print('🧾 RESP: ${e.response?.data}');

        //  Solo logout si ES realmente 401
        if (e.response?.statusCode == 401) {
          await store.clear();
          onUnauthorized();
        }

        handler.next(e);
      },
    ));

    return ApiClient._(dio);
  }
}
