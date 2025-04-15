import 'package:flutter/material.dart';
import 'package:manazco/main.dart' show MyApp, main;
import 'package:manazco/views/game/start_screen.dart';
import 'package:manazco/views/contador.dart';

//import 'package:kgaona/views/tareasscreen.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:manazco/views/quote_screen.dart';
import 'package:manazco/views/task/tareas_screen.dart';
import 'package:manazco/views/pantalla_principal.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> quotes = [];
  bool isLoading = false;

  Future<void> fetchQuotes() async {
    setState(() {
      isLoading = true;
    });

    // Simulación de una llamada a una API o base de datos
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
    setState(() {
      quotes = [
        'Cotización 1: 100',
        'Cotización 2: 200',
        'Cotización 3: 300',
        'Cotización 4: 400',
      ];
      isLoading = false;
    });
  }

  void _mostrarCotizaciones() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cotizaciones'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  quotes.map((quote) => ListTile(title: Text(quote))).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Lógica para manejar la navegación según el índice seleccionado
    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1: // Añadir Tarea
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TareasScreen()),
        );

        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Inicio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tareas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TareasScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Contador'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'contador'),
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
              leading: const Icon(Icons.videogame_asset),
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
              leading: Icon(Icons.exit_to_app),
              title: Text('Salir'),
              onTap: () {
                // Cierra la aplicación
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirmar'),
                      content: Text('¿Estás seguro de que deseas salir?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ); // Redirige al login
                          },
                          child: Text('Salir'),
                        ),
                      ],
                    );
                  },
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
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: fetchQuotes,
              child: const Text('Listar Cotizaciones'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ...quotes.map((quote) => Text(quote)).toList(),
            ElevatedButton(
              onPressed: _mostrarCotizaciones,
              child: Text("Cotizaciones"),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice del elemento seleccionado
        onTap: _onItemTapped, // Maneja el evento de selección
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tareas'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}
