import 'package:flutter/material.dart';
import 'package:manazco/api/service/task_service.dart';
import 'package:manazco/components/deportiva_card.dart';
import '../domain/task.dart'; // Importa la clase Task
import '../components/custom_card.dart'; // Importa el componente CustomCard
import '../constants.dart'; // Importa las constantes

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
    'type': '$TASK_TYPE_LABEL${task.type}',
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
