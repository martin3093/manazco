import 'dart:async';

class MockAuthService {
  Future<bool> login(String username, String password) async {
    // Verifica que las credenciales no sean nulas ni vacías
    if (username.isEmpty || password.isEmpty) {
      // print('Error: Usuario o contraseña vacíos.');
      return false;
    }

    // Simula un retraso para imitar una llamada a un servicio real
    await Future.delayed(Duration(seconds: 1));

    // Imprime las credenciales en la consola
    print('Intentando iniciar sesión con:');
    print('Usuario: $username');
    print('Contraseña: $password');

    // Retorna true para simular un login exitoso
    return true;
  }
}

void main() async {
  final authService = MockAuthService();

  // Simula un login
  final success = await authService.login('usuario_prueba', 'contrasena123');

  if (success) {
    print('Inicio de sesión exitoso.');
  } else {
    print('Error en el inicio de sesión.');
  }
}
