import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();

  // Función para obtener las tareas desde el repositorio
  List<Task> getTasks() {
    return _repository.getTasks();
  }

  // Función para filtrar tareas por tipo
  List<Task> getTasksByType(String type) {
    return _repository.getTasks().where((task) => task.type == type).toList();
  }

  // Función para filtrar tareas por fecha
  List<Task> getTasksByDate(DateTime date) {
    return _repository.getTasks().where((task) => task.fecha == date).toList();
  }
}
