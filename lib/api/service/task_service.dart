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
    final pasos = _assistantRepository.obtenerPasosRepository(titulo, fecha);

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

  // Función para eliminar una tarea
  void deleteTask(int index) {
    _repository.getTasks().removeAt(index);
  }

  // Función para modificar una tarea existente
  void updateTask(int index, Task updatedTask) {
    _repository.getTasks()[index] = updatedTask;
  }

  /*
  // Función para modificar una tarea existente
  void updateTask(int index, Task updatedTask) {
    _repository.getTasks()[index] = updatedTask;
  }
*/
  // Método para obtener pasos según el título de la tarea
  List<String> obtenerPasosRepo(String titulo, DateTime fechaLimite) {
    final pasos = _assistantRepository.obtenerPasosRepository(
      titulo,
      fechaLimite,
    );
    print(
      'Pasos generados por AssistantRepository: $pasos',
    ); // Imprime los pasos en consola
    return pasos;
  }
  /*
Para probar si se conecta a AssistantRepository, puedes usar el siguiente código:
  void testAssistantRepository() {
    final taskService = TaskService();
    final titulo = 'Tarea de prueba';
    final fechaLimite = DateTime.now().add(const Duration(days: 7));

    // Llama al método y verifica la consola
    final pasos = taskService.obtenerPasosRepo(titulo, fechaLimite);
    print('Resultado de obtenerPasosRepo: $pasos');
  }


*/

  List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    final fechaStr =
        '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';

    return [
      'Paso 1: Planificar antes del $fechaStr',
      'Paso 2: Ejecutar antes del $fechaStr',
      'Paso 3: Revisar antes del $fechaStr',
    ];
  }
}
