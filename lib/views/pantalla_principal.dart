import 'package:flutter/material.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key}); // Constructor constante agregado

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
              color: Colors.green, // Modificación 1
              padding: EdgeInsets.all(20), // Modificación 2
              child: const Text(
                'Hola, Flutter',
                style: TextStyle(fontSize: 24),
              ), // const agregado al Text
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Presionar'), // const agregado al Text
            ),
          ],
        ),
      ),
    );
  }
}
