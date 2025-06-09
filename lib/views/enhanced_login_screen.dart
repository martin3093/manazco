import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/auth/auth_bloc.dart';
import 'package:manazco/bloc/auth/auth_event.dart';
import 'package:manazco/bloc/auth/auth_state.dart';
import 'package:manazco/domain/login_request.dart';
import 'package:manazco/api/service/biometric_service.dart';
import 'package:manazco/views/biometric_auth_screen.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isBiometricAvailable = false;
  bool _hasSavedUser = false;
  Map<String, String>? _savedUser;
  bool _checkingBiometric = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    try {
      final canUse = await BiometricService.puedeUsarHuella();
      final hasSaved = await BiometricService.tieneUsuarioGuardado();
      final savedUser = await BiometricService.obtenerUsuarioGuardado();

      setState(() {
        _isBiometricAvailable = canUse;
        _hasSavedUser = hasSaved;
        _savedUser = savedUser;
        _checkingBiometric = false;
      });

      // Si hay usuario guardado, mostrar opción de login rápido
      if (hasSaved && savedUser != null) {
        _showBiometricLoginOption();
      }
    } catch (e) {
      setState(() {
        _checkingBiometric = false;
      });
    }
  }

  void _showBiometricLoginOption() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text('Acceso Rápido'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        _savedUser!['nombre']![0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¿Quieres acceder como ${_savedUser!['nombre']}?',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Usa tu huella digital para acceder rápidamente',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Usar contraseña'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _loginWithBiometric();
                    },
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Usar Huella'),
                  ),
                ],
              ),
        );
      }
    });
  }

  Future<void> _loginWithBiometric() async {
    try {
      final userCredentials = await BiometricService.loginConHuella();

      if (userCredentials != null) {
        // Usar las credenciales obtenidas para hacer login real
        final loginRequest = LoginRequest(
          username: userCredentials['username']!,
          password: userCredentials['password']!,
        );
        // ignore: use_build_context_synchronously
        context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: loginRequest.username,
            password: loginRequest.password,
          ),
        );
      } else {
        _showMessage('Autenticación biométrica fallida', isError: true);
      }
    } catch (e) {
      _showMessage('Error en autenticación: $e', isError: true);
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      context.read<AuthBloc>().add(
        AuthLoginRequested(email: username, password: password),
      );
    }
  }

  Future<void> _offerBiometricSetup(String username, String password) async {
    if (!_isBiometricAvailable) return;

    // Verificar si ya tiene huella configurada
    final alreadyConfigured =
        await BiometricService.usuarioTieneHuellaConfigurada(username);
    if (alreadyConfigured) return;

    final shouldSetup = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.fingerprint, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text('Configurar Acceso Rápido'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.security,
                  size: 64,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¿Quieres usar tu huella digital para acceder más rápido la próxima vez?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Podrás iniciar sesión sin escribir tu contraseña.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Ahora no'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Configurar'),
              ),
            ],
          ),
    );

    if (shouldSetup == true) {
      final configured = await BiometricService.guardarUsuarioConHuella(
        username: username,
        password: password,
      );

      if (configured) {
        _showMessage(
          '¡Huella configurada! Podrás usarla en el próximo login.',
          isError: false,
        );
        _checkBiometricStatus(); // Actualizar estado
      } else {
        _showMessage('No se pudo configurar la huella', isError: true);
      }
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to BiometricAuthScreen after successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BiometricAuthScreen(),
              ),
            );

            // Login exitoso - ofrecer configurar huella si no está configurada (de forma asíncrona)
            if (_isBiometricAvailable) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  _offerBiometricSetup(
                    _usernameController.text.trim(),
                    _passwordController.text,
                  );
                }
              });
            }
          } else if (state is AuthFailure) {
            _showMessage(state.error.message, isError: true);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo y título
                        Image.asset(
                          'assets/images/sodep_logo.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ManAzco',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestión Inteligente',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Botón de login biométrico si hay usuario guardado
                        if (_hasSavedUser &&
                            _savedUser != null &&
                            !_checkingBiometric) ...[
                          _buildBiometricLoginButton(),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'o inicia sesión',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Formulario de login
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Campo username
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  helperText:
                                      'Usuarios: profeltes, monimoney, sodep, gricequeen',
                                  helperStyle: const TextStyle(fontSize: 10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu usuario';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Campo contraseña
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  helperText: 'Contraseña: sodep',
                                  helperStyle: const TextStyle(fontSize: 10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu contraseña';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              // Botón de login
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;

                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child:
                                          isLoading
                                              ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                              : const Text(
                                                'Iniciar Sesión',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Información de biometría
                        if (_isBiometricAvailable && !_hasSavedUser) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fingerprint,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Después del login podrás habilitar acceso con huella',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricLoginButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: _loginWithBiometric,
        icon: const Icon(Icons.fingerprint, color: Colors.white),
        label: Column(
          children: [
            Text(
              'Acceder como ${_savedUser!['nombre']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Usar huella digital',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
