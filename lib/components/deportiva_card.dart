import 'package:flutter/material.dart';
import 'package:manazco/helpers/task_card_helper.dart';

import 'package:manazco/views/task/detalle_tarea_screen.dart'; // Importa la pantalla de detalle
import 'package:manazco/domain/task.dart'; // Importa la clase Task

class DeportivaCard extends StatelessWidget {
  final String imageUrl; // URL de la imagen
  final String title; // Título de la tarjeta
  final List<String> steps; // Lista de pasos
  final String deadline; // Fecha límite
  final VoidCallback onEdit; // Callback para editar
  final VoidCallback onDelete; // Callback para eliminar
  final Task task; // Objeto Task para pasar a la pantalla de detalle
  final List<Task> tasks; // Lista completa de tareas
  final int index; // Índice actual de la tarea

  const DeportivaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.steps,
    required this.deadline,
    required this.onEdit,
    required this.onDelete,
    required this.task,
    required this.tasks,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetalleTareaScreen(
                  task: task,
                  imageUrl: imageUrl,
                  tasks: tasks,
                  index: index,
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
                  CommonWidgetsHelper.buildBoldTitle(task.title),
                  CommonWidgetsHelper.buildSpacing(),
                  // Pasos (hasta 3 líneas)
                  CommonWidgetsHelper.buildInfoLines(
                    'Tipo: ${task.type}',
                    'Fecha límite: ${task.fechaLimite.toLocal().toString().split(' ')[0]}',
                    task.pasos.isNotEmpty
                        ? 'Primer paso: ${task.pasos[0]}'
                        : 'Sin pasos',
                  ),
                  CommonWidgetsHelper.buildSpacing(),
                  // Descripción con la fecha límite
                  Text(
                    'Fecha límite: $deadline',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    task.type == 'normal' ? Icons.task : Icons.warning,
                    color: task.type == 'normal' ? Colors.blue : Colors.red,
                  ),
                  CommonWidgetsHelper.buildSpacing(),
                  Text(
                    'Estado: ${task.type}',
                    style: const TextStyle(fontSize: 16),
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
