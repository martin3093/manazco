import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt_token';
  static const _userEmailKey = 'user_email';
  static const _biometricVerifiedKey = 'biometric_verified';

  Future<void> saveJwt(String jwt) async {
    await _storage.write(key: _jwtKey, value: jwt);
  }

  Future<String?> getJwt() async {
    return await _storage.read(key: _jwtKey);
  }

  Future<void> clearJwt() async {
    await _storage.delete(key: _jwtKey);
  }

  // Métodos para manejar el correo del usuario
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  Future<void> clearUserEmail() async {
    await _storage.delete(key: _userEmailKey);
  }

  // Métodos para manejar la verificación biométrica
  Future<void> setBiometricVerified(bool verified) async {
    await _storage.write(
      key: _biometricVerifiedKey,
      value: verified.toString(),
    );
  }

  Future<bool> getBiometricVerified() async {
    final value = await _storage.read(key: _biometricVerifiedKey);
    return value == 'true';
  }

  Future<void> clearBiometricVerified() async {
    await _storage.delete(key: _biometricVerifiedKey);
  }

  // Método para limpiar todos los datos de sesión
  Future<void> clearAllSessionData() async {
    await clearJwt();
    await clearUserEmail();
    await clearBiometricVerified();
  }
}
