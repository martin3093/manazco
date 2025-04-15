import 'package:flutter/material.dart';

class PantallaCambioColor extends StatefulWidget {
  @override
  _PantallaCambioColorState createState() => _PantallaCambioColorState();
}

class _PantallaCambioColorState extends State<PantallaCambioColor> {
  List<Color> _colores = [Colors.blue, Colors.red, Colors.green];
  int _indiceColor = 0;
  Color _colorActual = Colors.white; // Color inicial

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length;
      _colorActual = _colores[_indiceColor]; // Cambia el color actual
    });
  }

  void _cambiarColorblanco() {
    setState(() {
      _colorActual = Colors.white; // Color inicial
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cambio de Color')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              color: _colorActual,
              child: Center(child: Text('¡Cambio de color!')),
            ),

            ElevatedButton(
              onPressed: _cambiarColor,
              child: Text('Cambiar Color'),
            ),
            ElevatedButton(
              onPressed: _cambiarColorblanco,
              child: Text('Cambiar Color blanco '),
            ),
          ],
        ),
      ),
    );
  }
}
