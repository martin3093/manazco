import 'package:flutter/material.dart';
import 'package:manazco/api/service/task_service.dart';
import '../domain/task.dart'; // Importa la clase Task
import '../components/custom_card.dart'; // Importa el componente CustomCard
import '../constants.dart'; // Importa las constantes

final TaskService _taskService = TaskService();
Widget buildTaskCard(Task task, VoidCallback onEdit, VoidCallback onDelete) {
  // Procesa los datos de la tarea
  final List<String> steps = _taskService.obtenerPasos(
    task.title,
    task.fechaLimite,
  );
  final Map<String, dynamic> taskData = {
    'icon': task.type == 'normal' ? Icons.task : Icons.warning,
    'iconColor': task.type == 'normal' ? Colors.blue : Colors.red,
    'title': task.title,
    'type': '$TASK_TYPE_LABEL${task.type}',
    'date': task.fecha.toLocal().toString().split(' ')[0],
    //'steps': task.pasos, // Incluye los pasos de la tarea
    'steps': steps,
  };

  // Pasa los datos procesados al CustomCard
  return CustomCard(data: taskData, onEdit: onEdit, onDelete: onDelete);
}
