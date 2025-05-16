import 'package:manazco/views/contador.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:manazco/views/task_screen.dart';
import 'package:manazco/views/start_screen.dart';
import 'package:manazco/views/quote_screen.dart';
import 'package:manazco/views/noticias_screen.dart';
import 'package:manazco/views/category_screen.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagina de bienvenida')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 174, 206),
              ),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista de Tareas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Contador'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Contador'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('Juego de preguntas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Cotizaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuoteScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Noticias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticiaScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Categorias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                // Obtenemos el servicio de almacenamiento seguro
                final secureStorage = GetIt.instance<SecureStorageService>();

                // Limpiamos los datos de sesión
                await secureStorage.clearAllSessionData();

                if (!context.mounted) return;
                Navigator.pop(context);
                // Usamos pushReplacement para que no se pueda regresar a esta pantalla con el botón atrás
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido/a, $username!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
