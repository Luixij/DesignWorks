import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();

  static const _kToken = 'jwt_token';
  static const _kRole = 'user_role';

  Future<void> saveSession({required String token, required String role}) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kRole, value: role);
  }

  Future<String?> getToken() => _storage.read(key: _kToken);
  Future<String?> getRole() => _storage.read(key: _kRole);

  Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kRole);
  }

  Future<void> debugPrintSession() async {
    final t = await getToken();
    final r = await getRole();
    print('STORE token null? ${t == null} | role=$r');
  }
}