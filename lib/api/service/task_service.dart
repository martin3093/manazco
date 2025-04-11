import '../../data/task_repository.dart';
import '../../data/assistant_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

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

  //clase que se conecta a una API para obtener los pasos de una tarea
  Future<Task> addNewTask(String titulo, String detalle, DateTime fecha) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    final pasos =
        await _assistantRepository
            .obtenerPasosRepository(titulo, fecha)
            .take(2)
            .toList();

    // Crear la nueva tarea
    final nuevaTarea = Task(
      title: titulo,
      type: 'normal',
      description: detalle,
      fecha: fecha,
      fechaLimite: fecha,
      pasos: pasos,
    );
    _repository.getTasks().add(nuevaTarea);
    return nuevaTarea;
  }

  void deleteTasktest(int index) {
    final tasks = _repository.getTasks();
    if (index >= 0 && index < tasks.length) {
      print('SE ELIMINO: Índice $index .');
      tasks.removeAt(index);
    } else {
      print(
        'Error: Índice $index fuera de rango. No se puede eliminar la tarea.',
      );
    }
  }

  // Función para modificar una tarea existente
  void updateTask(int index, Task updatedTask) {
    _repository.getTasks()[index] = updatedTask;
  }

  List<String> obtenerPasosRepo(String titulo, DateTime fechaLimite) {
    final pasos =
        _assistantRepository
            .obtenerPasosRepository(titulo, fechaLimite)
            .take(2)
            .toList();
    print(
      'Pasos generados por AssistantRepository: $pasos',
    ); // Imprime los pasos en consola
    return pasos.take(2).toList();
  }

  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 4}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final tareas = _repository.getTasks().skip(inicio).take(limite).toList();

      final tareasConPasos = await Future.wait(
        tareas.map((tarea) async {
          if (tarea.pasos == null || tarea.pasos!.isEmpty) {
            final pasos = await obtenerPasosRepo(
              tarea.title,
              tarea.fechaLimite,
            );
            return Task(
              title: tarea.title,
              type: tarea.type,
              description: tarea.description,
              fecha: tarea.fecha,
              fechaLimite: tarea.fechaLimite,
              pasos: pasos,
            );
          }
          return tarea;
        }),
      );

      return tareasConPasos;
    } catch (e) {
      print('Error al obtener tareas: $e');
      return [];
    }
  }
}
