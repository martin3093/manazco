import '../../data/task_repository.dart';
import '../../data/assistant_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository();

  final TaskRepository _repository = TaskRepository();

  static const int pageSize = 5; // Tamaño de cada página

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

  int _currentPage = 0; // Página actual para la carga incremental

  // Método para obtener las tareas iniciales con pasos
  Future<List<Task>> getTasksWithSteps() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simula un retraso

      final tareas = _repository.getTasks().take(pageSize).toList();

      final tareasConPasos = await Future.wait(
        tareas.map((tarea) async {
          if (tarea.pasos.isEmpty) {
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
      print('Error al obtener tareas iniciales: $e');
      return [];
    }
  }

  // Método para cargar más tareas con pasos
  Future<List<Task>> getMoreTasksWithSteps() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simula un retraso

      final startIndex = _currentPage * pageSize;
      final tareas =
          _repository.getTasks().skip(startIndex).take(pageSize).toList();

      if (tareas.isEmpty) {
        return []; // No hay más tareas para cargar
      }

      final tareasConPasos = await Future.wait(
        tareas.map((tarea) async {
          if (tarea.pasos.isEmpty) {
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

      _currentPage++; // Incrementa la página actual
      return tareasConPasos;
    } catch (e) {
      print('Error al cargar más tareas: $e');
      return [];
    }
  }
}
