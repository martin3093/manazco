import 'package:manazco/api/service/auth_service.dart';
import 'package:manazco/data/preferencia_repository.dart';
import 'package:manazco/data/tarea_repository.dart';
import 'package:manazco/domain/login_request.dart';
import 'package:manazco/domain/login_response.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final _secureStorage = di<SecureStorageService>();
  final _tareaRepository = di<TareasRepository>();
  final preferenciaRepository = di<PreferenciaRepository>();
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }
      preferenciaRepository.invalidarCache();
      final loginRequest = LoginRequest(username: email, password: password);
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      // Reset biometric verification on new login
      await _secureStorage.setBiometricVerified(false);
      await preferenciaRepository.cargarDatos();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    preferenciaRepository.invalidarCache();
    _tareaRepository.limpiarCache();
    await _secureStorage
        .clearAllSessionData(); // This will clear JWT, user email, and biometric verification
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}
