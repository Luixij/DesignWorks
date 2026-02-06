import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyRole = 'user_role';

  // ======================
  // TOKEN
  // ======================

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // ======================
  // USER ID
  // ======================

  Future<void> saveUserId(int id) async {
    await _storage.write(key: _keyUserId, value: id.toString());
  }

  Future<int?> getUserId() async {
    final value = await _storage.read(key: _keyUserId);
    if (value == null) return null;
    return int.tryParse(value);
  }

  // ======================
  // USER NAME
  // ======================

  Future<void> saveUserName(String name) async {
    await _storage.write(key: _keyUserName, value: name);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }

  // ======================
  // USER EMAIL
  // ======================

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  // ======================
  // USER ROLE
  // ======================

  Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: _keyRole);
  }

  // ======================
  // CLEAR SESSION
  // ======================

  Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserName);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyRole);
  }
}
