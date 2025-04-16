import 'package:flutter/material.dart';
import 'package:manazco/components/task_modal.dart';
import 'package:manazco/views/task/detalle_tarea_screen.dart';

import '../../api/service/task_service.dart'; // Importa el servicio de tareas
import '../../constants/constants.dart'; // Importa las constantes
import '../../domain/task.dart'; // Importa la clase Task
import '../../helpers/task_card_helper.dart'; // Importa el helper para los Cards

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TaskService taskService = TaskService(); // Instancia del servicio
  final ScrollController _scrollController =
      ScrollController(); // Controlador de scroll
  late List<Task> tasks = []; // Lista de tareas obtenida del servicio
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  bool _isLoading = false; // Indica si se están cargando más tareas

  @override
  void initState() {
    super.initState();
    _loadInitialTasks(); // Carga las tareas iniciales
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreTasks(); // Carga más tareas al llegar al final
      }
    });
  }

  // Método para cargar las tareas iniciales
  void _loadInitialTasks() async {
    setState(() {
      _isLoading = true;
    });

    final initialTasks = await taskService.getTasksWithSteps();
    setState(() {
      tasks = initialTasks;
      _isLoading = false;
    });
  }

  @override
  // Método para cargar más tareas
  void _loadMoreTasks() async {
    if (_isLoading) return; // Evita cargar más si ya está cargando
    setState(() {
      _isLoading = true;
    });

    final moreTasks = await taskService.getMoreTasksWithSteps();
    setState(() {
      tasks.addAll(moreTasks); // Agrega las nuevas tareas a la lista actual
      _isLoading = false;
    });
  }

  // Método para mostrar el modal de agregar o editar tarea

  void addnewTask(String titulo, String detalle, DateTime fecha) async {
    Task nuevaTarea = await taskService.addNewTask(titulo, detalle, fecha);

    // Crea una nueva tarea
    setState(() {
      // Usa el servicio para agregar la tarea
      tasks.insert(
        0,
        nuevaTarea,
      ); // Agrega la nueva tarea al inicio de la lista local
    });
  }

  void deleteTask(int index) {
    setState(() {
      final taskToDelete = tasks[index]; // Obtén la tarea a eliminar
      taskService.deleteTasktest(
        index,
      ); // Usa el servicio para eliminar la tarea
      tasks.remove(taskToDelete); // Elimina la tarea de la lista local
    });
  }

  void updateTask(int index, String titulo, String detalle, DateTime fecha) {
    final tareaModificada = Task(
      title: titulo,
      type: detalle,
      description: detalle,
      fecha: fecha,
      fechaLimite: fecha,
      pasos: tasks[index].pasos, // Mantén los pasos existentes
    );

    setState(() {
      taskService.updateTask(
        index,
        tareaModificada,
      ); // Actualiza en el servicio
      tasks[index] = tareaModificada; // Actualiza en la lista local
    });
  }

  void _mostrarModalAgregarTarea({int? index}) {
    final Task? tarea = index != null ? tasks[index] : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskModal(
          task: tarea,
          onSave: (String title, String type, DateTime fecha) {
            if (index == null) {
              addnewTask(title, type, fecha); // Agregar nueva tarea
            } else {
              updateTask(index, title, type, fecha); // Editar tarea existente
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas - Total: ${tasks.length}')),
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
                      child: construirTarjetaDeportiva(
                        task,
                        index,
                        () => _mostrarModalAgregarTarea(
                          index: index,
                        ), // Editar tarea
                        () => deleteTask(index),
                        tasks,
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
