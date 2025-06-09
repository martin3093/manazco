import 'package:flutter/material.dart';
import 'package:manazco/api/service/biometric_service.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/views/welcome_screen.dart';
import 'package:watch_it/watch_it.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  String _username = '';
  String _userEmail = '';
  bool _isAuthenticating = false;
  String _statusMessage = '';
  bool _authFailed = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _authenticate();
  }

  Future<void> _loadUserData() async {
    try {
      final email = await _secureStorage.getUserEmail();
      setState(() {
        _userEmail = email ?? 'Usuario';
        // Extract username from email
        _username = _extractUsernameFromEmail(_userEmail);
      });
    } catch (e) {
      // Handle error
    }
  }

  String _extractUsernameFromEmail(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email;
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _statusMessage = 'Verificando huella...';
    });

    try {
      final canUseBiometric = await BiometricService.puedeUsarHuella();

      if (!canUseBiometric) {
        setState(() {
          _statusMessage = 'Tu dispositivo no soporta autenticación biométrica';
          _authFailed = true;
          _isAuthenticating = false;
        });

        // Even if biometric isn't supported, we'll consider it verified
        // This prevents users with unsupported devices from being stuck
        await _secureStorage.setBiometricVerified(true);
        _proceedToWelcomeScreen();
        return;
      }

      final authenticated = await BiometricService.autenticarConHuella(
        'Confirma tu identidad con huella para continuar',
      );

      if (authenticated) {
        // Mark as verified and proceed
        await _secureStorage.setBiometricVerified(true);
        _proceedToWelcomeScreen();
      } else {
        setState(() {
          _statusMessage = 'Autenticación biométrica fallida';
          _authFailed = true;
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _authFailed = true;
        _isAuthenticating = false;
      });
    }
  }

  void _proceedToWelcomeScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  void _skipBiometricVerification() async {
    // Mark biometric as verified even when skipping
    await _secureStorage.setBiometricVerified(true);
    _proceedToWelcomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de Identidad'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User circle avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Text(
                _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User name text
            Text(
              'Bienvenido, $_username',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              _userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Fingerprint icon
            Icon(
              Icons.fingerprint,
              size: 100,
              color:
                  _isAuthenticating
                      ? theme.colorScheme.primary
                      : (_authFailed ? Colors.red : Colors.grey),
            ),

            const SizedBox(height: 24),

            // Status message
            Text(
              _statusMessage.isNotEmpty
                  ? _statusMessage
                  : 'Usa tu huella para continuar',
              style: TextStyle(
                fontSize: 16,
                color: _authFailed ? Colors.red : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Retry button if auth failed
            if (_authFailed)
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.refresh),
                label: const Text('Intentar de nuevo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),

            // Alternative login button
            const SizedBox(height: 16),
            TextButton(
              onPressed: _skipBiometricVerification,
              child: const Text('Omitir verificación'),
            ),
          ],
        ),
      ),
    );
  }
}
