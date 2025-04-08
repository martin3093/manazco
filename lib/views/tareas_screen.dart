import 'package:flutter/material.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:manazco/views/welcome_screen.dart';
import '../api/service/task_service.dart'; // Importa el servicio de tareas
import '../constants.dart'; // Importa las constantes
import '../domain/task.dart'; // Importa la clase Task
import '../helpers/task_card_helper.dart'; // Importa el helper para los Cards

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TaskService taskService = TaskService(); // Instancia del servicio
  final ScrollController _scrollController =
      ScrollController(); // Controlador de scroll
  late List<Task> tasks; // Lista de tareas obtenida del servicio
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  bool _isLoading = false; // Indica si se están cargando más tareas

  @override
  @override
  void initState() {
    super.initState();
    tasks = taskService.getTasks(page: 0); // Carga la primera página de tareas
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreTasks(); // Carga más tareas al llegar al final
      }
    });
  }

  int _currentPage = 0; // Página actual

  void _loadMoreTasks() async {
    if (_isLoading) return; // Evita cargar más si ya está cargando
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simula un retraso de carga

    setState(() {
      final nextTasks = taskService.getTasks(
        page: _currentPage,
      ); // Obtén la página actual
      if (nextTasks.isNotEmpty) {
        tasks.addAll(nextTasks); // Agrega las nuevas tareas a la lista actual
        _currentPage++; // Incrementa la página actual
      }
      _isLoading = false; // Finaliza el estado de carga
    });
  }

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
      tasks.insert(
        0,
        nuevaTarea,
      ); // Agrega la nueva tarea al inicio de la lista local
    });
  }

  void deleteTask(int index) {
    setState(() {
      final taskToDelete = tasks[index]; // Obtén la tarea a eliminar
      taskService.deleteTask(index); // Usa el servicio para eliminar la tarea
      tasks.remove(taskToDelete); // Elimina la tarea de la lista local
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
      ); // Actualiza la tarea en el servicio
      tasks[index] = tareaModificada; // Actualiza la tarea en la lista local
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
                    addTask(
                      titulo,
                      detalle,
                      fechaSeleccionada!,
                    ); // Llama a la función correcta
                  } else {
                    updateTask(
                      index,
                      titulo,
                      detalle,
                      fechaSeleccionada!,
                    ); // Edita la tarea
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
      appBar: AppBar(title: const Text(TITLE_APPBAR)),
      backgroundColor: Colors.grey[200], // Cambia el fondo a gris claro
      body:
          tasks.isEmpty
              ? const Center(
                child: Text(
                  EMPTY_LIST, // Usa la constante para el mensaje de lista vacía
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                controller:
                    _scrollController, // Asigna el controlador de scroll
                itemCount:
                    tasks.length + 1, // Añade 1 para el indicador de carga
                itemBuilder: (context, index) {
                  if (index < tasks.length) {
                    final task = tasks[index];
                    return Dismissible(
                      key: Key(task.title), // Identificador único
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteTask(index); // Elimina la tarea al deslizar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${task.title} eliminada')),
                        );
                      },
                      child: buildTaskCard(
                        task,
                        () => _mostrarModalAgregarTarea(
                          index: index,
                        ), // Editar tarea
                        () => deleteTask(index), // Eliminar tarea
                      ),
                    );
                  } else {
                    return _isLoading
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                        : const SizedBox.shrink(); // Indicador de carga
                  }
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
