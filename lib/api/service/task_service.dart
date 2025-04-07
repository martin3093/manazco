import '../../data/task_repository.dart';
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
