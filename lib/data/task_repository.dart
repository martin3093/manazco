import '../domain/task.dart';

class TaskRepository {
  static final List<Task> _tasks = [
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

  int _taskCounter = _tasks.length; // Contador para generar nuevas tareas

  // Método para obtener tareas existentes
  List<Task> getTasks() {
    return _tasks;
  }

  // Método para cargar más tareas (simula la carga dinámica)
  List<Task> loadMoreTasks(int count) {
    final List<Task> newTasks = List.generate(count, (index) {
      _taskCounter++;
      return Task(
        title: 'Tarea $_taskCounter',
        type:
            _taskCounter % 2 == 0
                ? 'normal'
                : 'urgente', // Alterna entre 'normal' y 'urgente'
        fecha: DateTime.now().subtract(Duration(days: _taskCounter)),
      );
    });

    _tasks.addAll(newTasks); // Agrega las nuevas tareas a la lista existente
    return newTasks; // Devuelve las nuevas tareas
  }
}
