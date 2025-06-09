import 'package:manazco/api/service/base_service.dart';
import 'package:manazco/domain/login_request.dart';
import 'package:manazco/domain/login_response.dart';
import 'package:manazco/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      dynamic data;
      final List<LoginRequest> usuariosTest = [
        const LoginRequest(username: 'profeltes', password: 'sodep'),
        const LoginRequest(username: 'monimoney', password: 'sodep'),
        const LoginRequest(username: 'sodep', password: 'sodep'),
        const LoginRequest(username: 'gricequeen', password: 'sodep'),
      ];

      // Verificar si las credenciales coinciden con algún usuario de prueba
      bool credencialesValidas = usuariosTest.any(
        (usuario) =>
            usuario.username == request.username &&
            usuario.password == request.password,
      );

      if (credencialesValidas) {
        try {
          // Intentar autenticación online
          data = await postUnauthorized('/login', data: request.toJson());
        } catch (e) {
          // Si falla la conexión, usar respuesta offline para usuarios válidos
          data = {
            'session_token':
                'offline_token_${request.username}_${DateTime.now().millisecondsSinceEpoch}',
          };
        }
      }

      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException('Error de autenticación: respuesta vacía');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Error en login');
      }
    }
  }
}
