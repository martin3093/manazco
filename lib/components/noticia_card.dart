// import 'package:flutter/material.dart';
// import 'package:manazco/components/mybuttonrow.dart';
// import 'package:manazco/helpers/style_helper.dart';

// class NoticiaCard extends StatelessWidget {
//   final String titulo;
//   final String descripcion;
//   final String fuente;
//   final String publicadaEl;
//   final String imageUrl; // URL de la imagen

//   const NoticiaCard({
//     super.key,
//     required this.titulo,
//     required this.descripcion,
//     required this.fuente,
//     required this.publicadaEl,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Fila superior: Título, tiempo y la imagen
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Título y tiempo
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Título en negrita
//                       Text(
//                         titulo,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       // Tiempo de publicación
//                       Text(
//                         '$fuente · $publicadaEl',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //const SizedBox(width: 8),
//                 // Imagen pequeña al lado derecho
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.network(
//                     imageUrl,
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             // Descripción de la noticia
//             Text(
//               descripcion,
//               maxLines: 3, // Limita la descripción a 3 líneas
//               overflow:
//                   TextOverflow
//                       .ellipsis, // Muestra "..." si el texto es muy largo
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             // Fila de botones (MyButtonRow)
//             const MyButtonRow(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:manazco/components/mybuttonrow.dart';
// import 'package:manazco/helpers/style_helper.dart'; // Ya no se usa StyleHelper aquí

class NoticiaCard extends StatelessWidget {
  final String titulo;
  // final String descripcion; // Eliminamos la descripción
  final String fuente;
  final String publicadaEl;
  final String imageUrl; // URL de la imagen

  const NoticiaCard({
    super.key,
    required this.titulo,
    // required this.descripcion, // Eliminamos la descripción
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Padding para simular el contentPadding del ListTile
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ), // Ajusta el padding vertical si es necesario
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start, // Centrar verticalmente los elementos en el Row
        children: [
          // 1. Imagen a la izquierda (Leading)
          //  SizedBox(
          //  width: 80.0, // Ancho similar al ListTile
          // height: 60.0, // Alto similar al ListTile
          /* child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                // Placeholder mientras carga
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  );
                },
                // Widget a mostrar en caso de error
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),*/
          //),
          //    const SizedBox(width: 16.0), // Espacio entre imagen y texto
          // 2. Título y Subtítulo en el medio (Title & Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize
                      .min, // Para que la columna no ocupe más alto de lo necesario
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Ajusta el tamaño si es necesario
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Espacio entre título y subtítulo
                Text(
                  '$fuente · $publicadaEl',
                  style: TextStyle(
                    fontSize: 12, // Tamaño más pequeño para el subtítulo
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              // Imagen
              SizedBox(
                width: 80.0,
                height: 60.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8.0), // Espacio entre imagen y botones
              // Botones debajo de la imagen
              const MyButtonRow(),
            ],
          ),
        ],
      ),
    );
  }
}
