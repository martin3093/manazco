import 'package:flutter/material.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:manazco/views/welcome_screen.dart';
import '../api/service/task_service.dart'; // Importa el servicio de tareas
import '../constants.dart'; // Importa las constantes
import '../domain/task.dart'; // Importa la clase Task

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TaskService taskService = TaskService(); // Instancia del servicio
  late List<Task> tasks; // Lista de tareas obtenida del servicio
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar

  @override
  void initState() {
    super.initState();
    tasks = taskService.getTasks(); // Obtiene las tareas al iniciar
  }

  void _agregarTarea(String titulo, String detalle, DateTime fecha) {
    final nuevaTarea = Task(
      title: titulo,
      type: 'normal',
      fecha: fecha,
    ); // Crea una nueva tarea
    setState(() {
      taskService.addTask(nuevaTarea); // Usa el servicio para agregar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }

  void _eliminarTarea(int index) {
    setState(() {
      taskService.deleteTask(index); // Usa el servicio para eliminar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }

  /*
  void _modificarTarea(
    int index,
    String titulo,
    String detalle,
    DateTime fecha,
  ) {
    final tareaModificada = Task(
      title: titulo,
      type: detalle,
      fecha: fecha,
    ); // Crea la tarea modificada
    setState(() {
      taskService.updateTask(
        index,
        tareaModificada,
      ); // Usa el servicio para modificar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }
*/
  // Método para mostrar el modal de agregar o editar tarea
  // Este método se encarga de mostrar un modal para agregar o editar una tarea.
  // Si se pasa un índice, se asume que se está editando una tarea existente.
  // Si no se pasa un índice, se asume que se está agregando una nueva tarea.
  // El modal contiene campos de texto para el título, detalle y fecha de la tarea.
  // Al presionar el botón "Guardar", se valida que todos los campos estén completos
  // y se agrega o edita la tarea en la lista de tareas.
  void addTask(String titulo, String detalle, DateTime fecha) {
    final nuevaTarea = Task(
      title: titulo,
      type: 'normal',
      fecha: fecha,
    ); // Crea una nueva tarea
    setState(() {
      taskService.addTask(nuevaTarea); // Usa el servicio para agregar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }

  void deleteTask(int index) {
    setState(() {
      taskService.deleteTask(index); // Usa el servicio para eliminar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }

  void updateTask(int index, String titulo, String detalle, DateTime fecha) {
    final tareaModificada = Task(
      title: titulo,
      type: detalle,
      fecha: fecha,
    ); // Crea la tarea modificada
    setState(() {
      taskService.updateTask(
        index,
        tareaModificada,
      ); // Usa el servicio para modificar la tarea
      tasks = taskService.getTasks(); // Actualiza la lista local
    });
  }

  void _mostrarModalAgregarTarea({int? index}) {
    final TextEditingController tituloController = TextEditingController(
      text: index != null ? tasks[index].title : '',
    );
    final TextEditingController detalleController = TextEditingController(
      text: index != null ? tasks[index].type : '',
    );
    final TextEditingController fechaController = TextEditingController(
      text:
          index != null
              ? tasks[index].fecha.toLocal().toString().split(' ')[0]
              : '',
    );
    DateTime? fechaSeleccionada = index != null ? tasks[index].fecha : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detalleController,
                decoration: const InputDecoration(
                  labelText: 'Detalle',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  hintText: 'Seleccionar Fecha',
                ),
                onTap: () async {
                  DateTime? nuevaFecha = await showDatePicker(
                    context: context,
                    initialDate: fechaSeleccionada ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (nuevaFecha != null) {
                    setState(() {
                      fechaSeleccionada = nuevaFecha;
                      fechaController.text =
                          nuevaFecha.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final titulo = tituloController.text.trim();
                final detalle = detalleController.text.trim();

                if (titulo.isNotEmpty &&
                    detalle.isNotEmpty &&
                    fechaSeleccionada != null) {
                  if (index == null) {
                    _agregarTarea(titulo, detalle, fechaSeleccionada!);
                  } else {
                    setState(() {
                      tasks[index] = Task(
                        title: titulo,
                        type: detalle,
                        fecha: fechaSeleccionada!,
                      );
                    });
                  }
                  Navigator.pop(context); // Cierra el modal y guarda la tarea
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos.'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_APPBAR),
      ), // Usa la constante para el título
      body:
          tasks.isEmpty
              ? const Center(
                child: Text(
                  EMPTY_LIST, // Usa la constante para el mensaje de lista vacía
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Icon(
                      task.type == 'normal'
                          ? Icons.task
                          : Icons.warning, // Icono según el tipo
                      color:
                          task.type == 'normal'
                              ? Colors.blue
                              : Colors.red, // Color según el tipo
                    ),
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$TASK_TYPE_LABEL${task.type}', // Usa la constante para el tipo
                        ),
                        Text(
                          task.fecha.toLocal().toString().split(
                            ' ',
                          )[0], // Muestra la fecha
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _mostrarModalAgregarTarea(
                              index: index,
                            ); // Editar tarea
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _eliminarTarea(index); // Eliminar tarea
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(),
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice del elemento seleccionado
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}
