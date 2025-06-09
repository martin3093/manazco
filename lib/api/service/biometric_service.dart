import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Claves para guardar datos
  static const String _keyHuellaHabilitada = 'huella_habilitada';
  static const String _keyUsuarioUsername = 'usuario_username_huella';
  static const String _keyUsuarioPassword =
      'usuario_password_huella'; // ✅ Agregar password
  static const String _keyUsuarioNombre = 'usuario_nombre_huella';

  // ✅ Lista de usuarios reales (misma que AuthService)
  static const List<Map<String, String>> usuariosValidos = [
    {'username': 'profeltes', 'password': 'sodep', 'nombre': 'Prof Eltes'},
    {'username': 'monimoney', 'password': 'sodep', 'nombre': 'Moni Money'},
    {'username': 'sodep', 'password': 'sodep', 'nombre': 'Sodep Admin'},
    {'username': 'gricequeen', 'password': 'sodep', 'nombre': 'Grice Queen'},
  ];

  // ✅ Verificar si el dispositivo puede usar huella
  static Future<bool> puedeUsarHuella() async {
    try {
      final bool disponible = await _auth.canCheckBiometrics;
      final bool compatible = await _auth.isDeviceSupported();
      return disponible && compatible;
    } catch (e) {
      print('Error verificando huella: $e');
      return false;
    }
  }

  // ✅ Autenticar con huella
  static Future<bool> autenticarConHuella(String mensaje) async {
    try {
      return await _auth.authenticate(
        localizedReason: mensaje,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // ✅ Obtener nombre del usuario por username
  static String obtenerNombreUsuario(String username) {
    final usuario = usuariosValidos.firstWhere(
      (user) => user['username'] == username,
      orElse: () => {'nombre': username}, // Fallback al username
    );
    return usuario['nombre'] ?? username;
  }

  // ✅ Guardar usuario con huella habilitada (usando datos reales)
  static Future<bool> guardarUsuarioConHuella({
    required String username,
    required String password,
  }) async {
    try {
      // Verificar que el usuario es válido
      final esValido = usuariosValidos.any(
        (user) => user['username'] == username && user['password'] == password,
      );

      if (!esValido) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      // Primero verificar la huella
      final autenticado = await autenticarConHuella(
        'Confirma tu huella para habilitar el acceso rápido',
      );

      if (!autenticado) {
        return false;
      }

      // Guardar datos del usuario
      final nombre = obtenerNombreUsuario(username);
      await prefs.setBool(_keyHuellaHabilitada, true);
      await prefs.setString(_keyUsuarioUsername, username);
      await prefs.setString(_keyUsuarioPassword, password);
      await prefs.setString(_keyUsuarioNombre, nombre);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Verificar si hay usuario con huella guardado
  static Future<bool> tieneUsuarioGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyHuellaHabilitada) ?? false;
    } catch (e) {
      return false;
    }
  }

  // ✅ Obtener datos del usuario guardado
  static Future<Map<String, String>?> obtenerUsuarioGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habilitada = prefs.getBool(_keyHuellaHabilitada) ?? false;

      if (!habilitada) return null;

      final username = prefs.getString(_keyUsuarioUsername);
      final password = prefs.getString(_keyUsuarioPassword);
      final nombre = prefs.getString(_keyUsuarioNombre);

      if (username == null || password == null || nombre == null) return null;

      return {'username': username, 'password': password, 'nombre': nombre};
    } catch (e) {
      return null;
    }
  }

  // ✅ Login con huella (retorna credenciales para AuthService)
  static Future<Map<String, String>?> loginConHuella() async {
    try {
      // Verificar que hay usuario guardado
      final usuario = await obtenerUsuarioGuardado();
      if (usuario == null) return null;

      // Autenticar con huella
      final autenticado = await autenticarConHuella(
        'Usa tu huella para iniciar sesión como ${usuario['nombre']}',
      );

      if (autenticado) {
        return {
          'username': usuario['username']!,
          'password': usuario['password']!,
          'nombre': usuario['nombre']!,
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ✅ Eliminar usuario guardado (deshabilitar huella)
  static Future<bool> eliminarUsuarioGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyHuellaHabilitada);
      await prefs.remove(_keyUsuarioUsername);
      await prefs.remove(_keyUsuarioPassword);
      await prefs.remove(_keyUsuarioNombre);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Verificar si un usuario específico ya tiene huella configurada
  static Future<bool> usuarioTieneHuellaConfigurada(String username) async {
    try {
      final usuario = await obtenerUsuarioGuardado();
      return usuario != null && usuario['username'] == username;
    } catch (e) {
      return false;
    }
  }
}
