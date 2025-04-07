import '../domain/task.dart';

class TaskRepository {
  static final List<Task> tasks = [
    Task(title: 'Tarea 1', type: 'normal', fecha: DateTime.now()),
    Task(
      title: 'Tarea 2',
      type: 'urgente',
      fecha: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      title: 'Tarea 3',
      type: 'normal',
      fecha: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Task(
      title: 'Tarea 4',
      type: 'urgente',
      fecha: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Task(
      title: 'Tarea 5',
      type: 'normal',
      fecha: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  List<Task> getTasks() {
    return tasks;
  }
}
