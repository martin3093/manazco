import 'package:flutter/material.dart';
import 'package:manazco/domain/task.dart';

class DetalleTareaScreen extends StatelessWidget {
  final Task task;
  final String imageUrl;
  final List<Task> tasks;
  final int index;

  const DetalleTareaScreen({
    super.key,
    required this.task,
    required this.imageUrl,
    required this.tasks,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            // Deslizar hacia la derecha
            if (index > 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetalleTareaScreen(
                        task: tasks[index - 1],
                        imageUrl: imageUrl,
                        tasks: tasks,
                        index: index - 1,
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No hay tareas antes de esta tarea'),
                ),
              );
            }
          } else if (details.primaryVelocity! < 0) {
            // Deslizar hacia la izquierda
            if (index < tasks.length - 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetalleTareaScreen(
                        task: tasks[index + 1],
                        imageUrl: imageUrl,
                        tasks: tasks,
                        index: index + 1,
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No hay tareas después de esta tarea'),
                ),
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(task.title)),
        body: Center(
          child: Container(
            width: 350, // Ancho fijo para centrar el contenido
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
              border: Border.all(
                color:
                    Colors
                        .grey
                        .shade300, // Color del borde similar a las tarjetas
                width: 1.5, // Grosor del borde
              ),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black12, // Sombra más suave
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alineación a la izquierda
              children: [
                // Imagen de la tarea
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Título de la tarea
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify, // Justificar el título
                ),
                const SizedBox(height: 16),
                // Pasos de la tarea
                const Text(
                  'Pasos:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...task.pasos.map(
                  (paso) => Text(
                    '- $paso',
                    textAlign: TextAlign.justify, // Justificar los pasos
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Fecha límite
                RichText(
                  text: TextSpan(
                    text: 'Fecha límite: ',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            '${task.fechaLimite.day}/${task.fechaLimite.month}/${task.fechaLimite.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Negrita
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
