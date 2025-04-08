import 'package:flutter/material.dart';
import '../domain/task.dart'; // Importa la clase Task

class DetalleTareaScreen extends StatelessWidget {
  final Task task;
  final String imageUrl; // URL de la imagen

  const DetalleTareaScreen({
    super.key,
    required this.task,
    required this.imageUrl, // Recibe la URL de la imagen
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la tarea
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl, // Usa la URL pasada como parámetro
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Título de la tarea
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Fecha límite
            Text(
              'Fecha límite: ${task.fechaLimite.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Pasos de la tarea
            const Text(
              'Pasos para completar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...task.pasos.map((paso) => Text('- $paso')).toList(),
          ],
        ),
      ),
    );
  }
}
