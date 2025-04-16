import 'package:flutter/material.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key}); // Constructor constante agregado

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _contador = 0;

  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi App')), // const agregado al Text

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              /*agrega un resaldador de dimension 20 al texto */
              color: Colors.blueAccent, // Modificación 1
              padding: EdgeInsets.all(20), // Modificación 2
              child: const Text(
                'Hola, Flutter',
                style: TextStyle(fontSize: 24),
              ), // const agregado al Text
            ),

            Text(
              'Veces presionado: $_contador', // Modificación 1
              style: TextStyle(color: Colors.blue), // Modificación 3
            ),
            SizedBox(height: 30), // Modificación 2
            ElevatedButton(
              onPressed: _incrementarContador,
              child: Text('Toca aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
