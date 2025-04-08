import 'package:flutter/material.dart';
import '../api/service/task_service.dart'; // Importa el servicio de tareas
import '../constants.dart'; // Importa las constantes
import '../domain/task.dart'; // Importa la clase Task
import '../helpers/task_card_helper.dart'; // Importa el helper para los Cards
import '../data/task_repository.dart'; // Importa el repositorio de tareas

class PruebaTarea2Screen extends StatefulWidget {
  const PruebaTarea2Screen({super.key});

  @override
  _PruebaTarea2ScreenState createState() => _PruebaTarea2ScreenState();
}

class _PruebaTarea2ScreenState extends State<PruebaTarea2Screen> {
  final TaskRepository taskRepository =
      TaskRepository(); // Instancia del repositorio
  final ScrollController _scrollController =
      ScrollController(); // Controlador de scroll
  List<Task> tasks = []; // Lista de tareas cargadas
  int _loadedTasks = 5; // Número inicial de tareas cargadas
  bool _isLoading = false; // Indica si se están cargando más tareas

  @override
  void initState() {
    super.initState();
    _loadInitialTasks(); // Carga las tareas iniciales
    _scrollController.addListener(_onScroll); // Escucha el scroll
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpia el controlador al destruir el widget
    super.dispose();
  }

  void _loadInitialTasks() {
    setState(() {
      tasks = taskRepository.getTasks().take(_loadedTasks).toList();
    });
  }

  void _loadMoreTasks() async {
    if (_isLoading) return; // Evita cargar más si ya está cargando
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simula un retraso de carga

    setState(() {
      final allTasks = taskRepository.getTasks();
      final nextTasks = allTasks.skip(tasks.length).take(5).toList();
      tasks.addAll(nextTasks);
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreTasks(); // Carga más tareas al llegar al final
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Tarea 2')),
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
                    return buildTaskCard(
                      task,
                      () => _mostrarModalAgregarTarea(
                        index: index,
                      ), // Editar tarea
                      () => deleteTask(index), // Eliminar tarea
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
    );
  }

  void _mostrarModalAgregarTarea({int? index}) {
    // Código para mostrar el modal de agregar/editar tarea
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Elimina la tarea de la lista local
    });
  }
}
