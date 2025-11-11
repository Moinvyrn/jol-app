import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Saves the auth token securely.
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// Retrieves the stored auth token.
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Deletes the stored auth token.
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// Checks if a user is logged in by verifying the token exists and is non-empty.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}