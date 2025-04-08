import 'package:flutter/material.dart';
import '../domain/task.dart'; // Importa la clase Task
import '../components/custom_card.dart'; // Importa el componente CustomCard
import '../constants.dart'; // Importa las constantes

Widget buildTaskCard(Task task, VoidCallback onEdit, VoidCallback onDelete) {
  // Procesa los datos de la tarea
  final Map<String, dynamic> taskData = {
    'icon': task.type == 'normal' ? Icons.task : Icons.warning,
    'iconColor': task.type == 'normal' ? Colors.blue : Colors.red,
    'title': task.title,
    'type': '$TASK_TYPE_LABEL${task.type}',
    'date': task.fecha.toLocal().toString().split(' ')[0],
  };

  // Pasa los datos procesados al CustomCard
  return CustomCard(data: taskData, onEdit: onEdit, onDelete: onDelete);
}
