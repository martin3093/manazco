import 'package:flutter/material.dart';
import 'package:manazco/api/service/task_service.dart';
import 'package:manazco/components/deportiva_card.dart';
import 'package:manazco/domain/task.dart'; // Importa la clase Task
import 'package:manazco/components/custom_card.dart'; // Importa el CustomCard
import 'package:manazco/constants/constants.dart'; // Importa las constantes

final TaskService _taskService = TaskService();
Widget buildTaskCard(Task task, VoidCallback onEdit, VoidCallback onDelete) {
  // Procesa los datos de la tarea
  final List<String> steps = _taskService.obtenerPasosRepo(
    task.title,
    task.fechaLimite,
  );
  final Map<String, dynamic> taskData = {
    'icon': task.type == 'normal' ? Icons.task : Icons.warning,
    'iconColor': task.type == 'normal' ? Colors.blue : Colors.red,
    'title': task.title,
    'type': '$taskTypeLabel${task.type}',
    'date': task.fecha.toLocal().toString().split(' ')[0],
    'steps': steps,
  };

  // Pasa los datos procesados al CustomCard
  return CustomCard(data: taskData, onEdit: onEdit, onDelete: onDelete);
}

Widget construirTarjetaDeportiva(
  Task task,
  int index,
  VoidCallback onEdit,
  VoidCallback onDelete,
  List<Task> tasks,
) {
  // Construye una tarjeta con formato deportivo
  return DeportivaCard(
    imageUrl:
        'https://picsum.photos/200/300?random=$index', // Imagen aleatoria basada en el índice
    title: task.title,
    steps: task.pasos,
    deadline: task.fechaLimite.toLocal().toString().split(' ')[0],
    onEdit: onEdit, // Callback para editar
    onDelete: onDelete,
    task: task, // Callback para eliminar
    tasks: tasks, // Lista completa de tareas
    index: index, // Índice actual de la tarea
  );
}

class CommonWidgetsHelper {
  // Título en negrita con tamaño 22
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // Muestra hasta 3 líneas de información
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1),
        if (line2 != null) Text(line2),
        if (line3 != null) Text(line3),
      ],
    );
  }

  // Pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  // Espaciador (SizedBox de altura 8)
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  // Borde redondeado
  static BoxDecoration buildRoundedBorder() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    );
  }
}
