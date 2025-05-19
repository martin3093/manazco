import 'package:manazco/api/service/auth_service.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/domain/login_response.dart';
import 'package:manazco/domain/login_request.dart';
import 'package:manazco/data/base_repository.dart';
import 'package:manazco/exceptions/api_exception.dart';

class AuthRepository extends BaseRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      // Validamos campos usando métodos de BaseRepository
      checkFieldNotEmpty(email, 'email');
      checkFieldNotEmpty(password, 'password');

      logOperationStart('iniciar sesión', 'usuario', email);

      final loginRequest = LoginRequest(username: email, password: password);
      final LoginResponse response = await _authService.login(loginRequest);

      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);

      logOperationSuccess('iniciada sesión', 'usuario', email);
      return true;
    } catch (e) {
      if (e is ApiException) {
        // Ya está formateado, solo lo propagamos
        logOperationStart('error al iniciar sesión', 'usuario', email);
        rethrow;
      } else {
        logOperationStart(
          'error inesperado al iniciar sesión',
          'usuario',
          email,
        );
        throw ApiException('Error al iniciar sesión: ${e.toString()}');
      }
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final email = await _secureStorage.getUserEmail() ?? 'usuario';
      logOperationStart('cerrar sesión', 'usuario', email);

      await _secureStorage.clearJwt();
      await _secureStorage.clearUserEmail();

      logOperationSuccess('cerrada sesión', 'usuario', email);
    } catch (e) {
      logOperationStart('error al cerrar sesión', 'usuario');
      throw ApiException('Error al cerrar sesión: ${e.toString()}');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      // Siempre retorna false para forzar la pantalla de login
      return false;
    } catch (e) {
      logOperationStart('error al verificar autenticación', 'usuario');
      return false;
    }
  }

  /// Get current auth token
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.getJwt();
    } catch (e) {
      logOperationStart('error al obtener token', 'autenticación');
      return null;
    }
  }
}
