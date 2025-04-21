import 'package:flutter/material.dart';

class MyButtonRow extends StatelessWidget {
  const MyButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      //  mainAxisSize: MainAxisSize.min, // Para que el Row ocupe el mínimo espacio horizontal necesario
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.star_border), // Icono de estrella vacía
          onPressed: () {
            // Aquí va la lógica cuando se presiona el botón de favorito
            print('Botón de favorito presionado');
            // Puedes cambiar el icono a Icons.star para indicar que está marcado
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Aquí va la lógica cuando se presiona el botón de compartir
            print('Botón de compartir presionado');
            // Implementa la funcionalidad de compartir aquí
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert), // Icono de tres puntos verticales
          onSelected: (String result) {
            // Aquí va la lógica cuando se selecciona una opción del menú
            print('Opción seleccionada: $result');
            // Implementa las acciones para cada opción del menú
          },
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'opcion1',
                  child: Text('Opción 1'),
                ),
                const PopupMenuItem<String>(
                  value: 'opcion2',
                  child: Text('Opción 2'),
                ),
                const PopupMenuItem<String>(
                  value: 'opcion3',
                  child: Text('Opción 3'),
                ),
              ],
        ),
      ],
    );
  }
}
