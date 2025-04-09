/*import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();

  // Función para obtener las tareas desde el repositorio
  List<Task> getTasks() {
    return _repository.getTasks();
  }

  // Función para agregar una nueva tarea
  void addTask(Task task) {
    _repository.getTasks().add(task);
    print('Tarea agregada: ${task.title}');
  }

  // Función para eliminar una tarea
  void deleteTask(int index) {
    _repository.getTasks().removeAt(index);
  }

  // Función para modificar una tarea existente
  void updateTask(int index, Task updatedTask) {
    _repository.getTasks()[index] = updatedTask;
  }
}
*/
import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();
  static const int pageSize = 7; // Tamaño de cada página

  // Función para obtener las tareas desde el repositorio
  List<Task> getTasks({required int page}) {
    final allTasks =
        _repository.getTasks(); // Obtén todas las tareas del repositorio
    final startIndex = page * pageSize; // Índice inicial de la página
    final endIndex = startIndex + pageSize; // Índice final de la página
    if (startIndex >= allTasks.length) {
      return []; // Si no hay más tareas, devuelve una lista vacía
    }
    return allTasks.sublist(
      startIndex,
      endIndex > allTasks.length ? allTasks.length : endIndex,
    );
  }

  // Función para agregar una nueva tarea
  void addTask(Task task) {
    _repository.getTasks().add(task);
    print('Tarea agregada: ${task.title}');
  }

  // Función para eliminar una tarea
  void deleteTask(int index) {
    _repository.getTasks().removeAt(index);
  }

  // Función para modificar una tarea existente
  void updateTask(int index, Task updatedTask) {
    _repository.getTasks()[index] = updatedTask;
  }

  // Método para obtener pasos según el título de la tarea
  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    final fechaStr =
        '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';

    return [
      'Paso 1: Planificar antes del $fechaStr',
      'Paso 2: Ejecutar antes del $fechaStr',
      'Paso 3: Revisar antes del $fechaStr',

      /*'Paso 1: Planificar antes del ${fechaLimite.toLocal()}',
      'Paso 2: Ejecutar antes del ${fechaLimite.toLocal()}',
      'Paso 3: Revisar antes del ${fechaLimite.toLocal()}',*/
    ];
  }
}
