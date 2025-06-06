import 'package:flutter/material.dart';
import 'package:manazco/components/side_menu.dart';
import 'package:manazco/components/welcome_animation.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _userEmail = '';
  @override
  void initState() {
    super.initState();
    _verificarAutenticacionYCargarEmail();
  }

  Future<void> _verificarAutenticacionYCargarEmail() async {
    final SecureStorageService secureStorage = di<SecureStorageService>();
    final token = await secureStorage.getJwt();
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
      return;
    }
    final email = await secureStorage.getUserEmail() ?? 'Usuario';
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reemplazamos el texto con nuestra animación
            Expanded(child: WelcomeAnimation(username: _userEmail)),
          ],
        ),
      ),
    );
  }
}
