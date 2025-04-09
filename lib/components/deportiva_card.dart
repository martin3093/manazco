import 'package:flutter/material.dart';

import '../views/detalle_tarea_screen.dart'; // Importa la pantalla de detalle
import '../domain/task.dart'; // Importa la clase Task

class DeportivaCard extends StatelessWidget {
  final String imageUrl; // URL de la imagen
  final String title; // Título de la tarjeta
  final List<String> steps; // Lista de pasos
  final String deadline; // Fecha límite
  final VoidCallback onEdit; // Callback para editar
  final VoidCallback onDelete; // Callback para eliminar
  final Task task; // Objeto Task para pasar a la pantalla de detalle

  const DeportivaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.steps,
    required this.deadline,
    required this.onEdit,
    required this.onDelete,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de detalle y pasa la URL de la imagen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetalleTareaScreen(
                  task: task,
                  imageUrl: imageUrl, // Pasa la URL de la imagen
                ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 8, // Elevación sombreada
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borde redondeado
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen aleatoria
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Negrita
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Pasos (hasta 3 líneas)
                  Text(
                    steps.isNotEmpty
                        ? steps.take(3).join('\n')
                        : 'Sin pasos disponibles',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  // Descripción con la fecha límite
                  Text(
                    'Fecha límite: $deadline',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
