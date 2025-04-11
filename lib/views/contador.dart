import 'package:flutter/material.dart';

// Importa la pantalla de login

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message;
    Color messageColor;

    // Determina el mensaje y el color según el valor del contador
    if (_counter > 0) {
      message = 'Contador en positivo';
      messageColor = Colors.green;
    } else if (_counter == 0) {
      message = 'Contador en cero';
      messageColor = Colors.black;
    } else {
      message = 'Contador en negativo';
      messageColor = Colors.red;
    }
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // Text('Hola soy Katty'),
            //const Text('Hola soy Alejandra'),
            /*
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Advertencia'),
                      content: const Text(
                        'Esta es una advertencia importante.',
                      ),
                      actions: <Widget>[
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
              },
              child: const Text('Mostrar Advertencia'),
            ),*/
            const SizedBox(height: 16),
            Text(message, style: TextStyle(fontSize: 18, color: messageColor)),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones al final
        children: [
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _counter = 0; // Reinicia el contador a 0
              });
            },
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
