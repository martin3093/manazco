import '../domain/task.dart';

class TaskRepository {
  int _taskCounte1r = 0;
  static final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: 'normal',

      fecha: DateTime.now(),
      fechaLimite: DateTime.now().add(const Duration(days: 1)),
      description: 'hola', // Fecha límite: 1 día desde hoy
      pasos: [],
    ),
    Task(
      title: 'Tarea 2',
      type: 'urgente',
      description: 'hola',
      fecha: DateTime.now().subtract(const Duration(days: 1)),
      fechaLimite: DateTime.now().add(
        const Duration(days: 2),
      ), // Fecha límite: 2 días desde hoy
      pasos: [],
    ),
    Task(
      title: 'Tarea 3',
      type: 'normal',
      description: 'hola',
      fecha: DateTime.now().subtract(const Duration(days: 2)),
      fechaLimite: DateTime.now().add(
        const Duration(days: 3),
      ), // Fecha límite: 3 días desde hoy
      pasos: [],
    ),
    Task(
      title: 'Tarea 4',
      type: 'urgente',
      description: 'hola',
      fecha: DateTime.now().subtract(const Duration(days: 3)),
      fechaLimite: DateTime.now().add(
        const Duration(days: 4),
      ), // Fecha límite: 4 días desde hoy
      pasos: [],
    ),
    Task(
      title: 'Tarea 5',
      type: 'normal',
      description: 'hola',
      fecha: DateTime.now().subtract(const Duration(days: 4)),
      fechaLimite: DateTime.now().add(
        const Duration(days: 5),
      ), // Fecha límite: 5 días desde hoy
      pasos: [],
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
        type: _taskCounter % 2 == 0 ? 'normal' : 'urgente',
        description: 'hola', // Alterna entre 'normal' y 'urgente'
        fecha: DateTime.now().subtract(Duration(days: _taskCounter)),
        fechaLimite: DateTime.now().add(
          Duration(days: _taskCounter % 5 + 1),
        ), // Fecha límite dinámica
        pasos: [],
      );
    });

    _tasks.addAll(newTasks); // Agrega las nuevas tareas a la lista existente
    return newTasks; // Devuelve las nuevas tareas
  }
}
