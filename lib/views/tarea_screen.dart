// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:manazco/bloc/tarea/tarea_bloc.dart';
// import 'package:manazco/bloc/tarea/tarea_event.dart';
// import 'package:manazco/bloc/tarea/tarea_state.dart';
// import 'package:manazco/components/add_task_modal.dart';
// import 'package:manazco/components/custom_bottom_navigation_bar.dart';
// import 'package:manazco/components/last_updated_header.dart';
// import 'package:manazco/components/side_menu.dart';
// import 'package:manazco/constants/constantes.dart';
// import 'package:manazco/domain/tarea.dart';
// import 'package:manazco/helpers/dialog_helper.dart';
// import 'package:manazco/helpers/snackbar_helper.dart';
// import 'package:manazco/helpers/snackbar_manager.dart';
// import 'package:manazco/helpers/task_card_helper.dart';
// import 'package:manazco/views/tarea_detalles_screen.dart';

// class TareaScreen extends StatelessWidget {
//   const TareaScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Limpiar cualquier SnackBar existente al entrar a esta pantalla
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!SnackBarManager().isConnectivitySnackBarShowing) {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       }
//     });

//     // Cargar las tareas al entrar a la pantalla
//     context.read<TareaBloc>().add(LoadTareasEvent());

//     return const _TareaScreenContent();
//   }
// }

// class _TareaScreenContent extends StatefulWidget {
//   const _TareaScreenContent();

//   @override
//   _TareaScreenContentState createState() => _TareaScreenContentState();
// }

// class _TareaScreenContentState extends State<_TareaScreenContent> {
//   final ScrollController _scrollController = ScrollController();
//   static const int _limitePorPagina = 5;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final state = context.read<TareaBloc>().state;
//       if (state is TareaLoaded && state.hayMasTareas) {
//         context.read<TareaBloc>().add(
//           LoadMoreTareasEvent(
//             pagina: state.paginaActual + 1,
//             limite: _limitePorPagina,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<TareaBloc, TareaState>(
//       listener: (context, state) {
//         if (state is TareaError) {
//           SnackBarHelper.manejarError(context, state.error);
//         } else if (state is TareaOperationSuccess) {
//           SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);
//         }
//       },
//       builder: (context, state) {
//         DateTime? lastUpdated;
//         if (state is TareaLoaded) {
//           lastUpdated = state.lastUpdated;
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               state is TareaLoaded
//                   ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
//                   : TareasConstantes.tituloAppBar,
//             ),
//             centerTitle: true,
//           ),
//           drawer: const SideMenu(),
//           backgroundColor: Colors.grey[200],
//           body: Column(
//             children: [
//               LastUpdatedHeader(lastUpdated: lastUpdated),
//               Expanded(child: _construirCuerpoTareas(context, state)),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () => _mostrarModalAgregarTarea(context),
//             tooltip: 'Agregar Tarea',
//             child: const Icon(Icons.add),
//           ),
//           bottomNavigationBar: const CustomBottomNavigationBar(
//             selectedIndex: 0,
//           ),
//         );
//       },
//     );
//   }

//   Widget _construirCuerpoTareas(BuildContext context, TareaState state) {
//     if (state is TareaInitial ||
//         (state is TareaLoading && state is! TareaLoaded)) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state is TareaError && state is! TareaLoaded) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               state.error.message,
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => context.read<TareaBloc>().add(LoadTareasEvent()),
//               child: const Text('Reintentar'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state is TareaLoaded) {
//       return RefreshIndicator(
//         onRefresh: () async {
//           context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
//         },
//         child:
//             state.tareas.isEmpty
//                 ? ListView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       child: const Center(
//                         child: Text(TareasConstantes.listaVacia),
//                       ),
//                     ),
//                   ],
//                 )
//                 : ListView.builder(
//                   controller: _scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   itemCount: state.tareas.length + (state.hayMasTareas ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (index == state.tareas.length) {
//                       return const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }

//                     final tarea = state.tareas[index];
//                     return Dismissible(
//                       key: Key(tarea.id.toString()),
//                       background: Container(
//                         color: Colors.red,
//                         alignment: Alignment.centerRight,
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: const Icon(Icons.delete, color: Colors.white),
//                       ),
//                       direction: DismissDirection.startToEnd,
//                       confirmDismiss: (direction) async {
//                         return await DialogHelper.mostrarConfirmacion(
//                           context: context,
//                           titulo: 'Confirmar eliminación',
//                           mensaje:
//                               '¿Estás seguro de que deseas eliminar esta tarea?',
//                           textoCancelar: 'Cancelar',
//                           textoConfirmar: 'Eliminar',
//                         );
//                       },
//                       onDismissed: (_) {
//                         context.read<TareaBloc>().add(
//                           DeleteTareaEvent(tarea.id!),
//                         );
//                       },
//                       child: GestureDetector(
//                         onTap:
//                             () => _mostrarDetallesTarea(
//                               context,
//                               index,
//                               state.tareas,
//                             ),
//                         child: construirTarjetaDeportiva(
//                           tarea,
//                           tarea.id!,
//                           () => _mostrarModalEditarTarea(context, tarea),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   void _mostrarDetallesTarea(
//     BuildContext context,
//     int indice,
//     List<Tarea> tareas,
//   ) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TaskDetailsScreen(tareas: tareas, indice: indice),
//       ),
//     );
//   }

//   void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (dialogContext) => AddTaskModal(
//             taskToEdit: tarea,
//             onTaskAdded: (Tarea tareaEditada) {
//               context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
//             },
//           ),
//     );
//   }

//   void _mostrarModalAgregarTarea(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (dialogContext) => AddTaskModal(
//             onTaskAdded: (Tarea nuevaTarea) {
//               context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
//             },
//           ),
//     );
//   }
// }
// lib/screens/tareas_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/contador_tarea/contador_tarea_bloc.dart';
import 'package:manazco/bloc/contador_tarea/contador_tarea_event.dart';
import 'package:manazco/bloc/contador_tarea/contador_tarea_state.dart';
import 'package:manazco/bloc/tarea/tarea_bloc.dart';
import 'package:manazco/bloc/tarea/tarea_event.dart';
import 'package:manazco/bloc/tarea/tarea_state.dart';
import 'package:manazco/data/tarea_repository.dart';
import 'package:manazco/domain/tarea.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Conserva el TareaBloc existente
        BlocProvider(create: (context) => TareaBloc()..add(LoadTareasEvent())),
        // Añade el ContadorTareaBloc
        BlocProvider(create: (context) => ContadorTareaBloc()),
      ],
      child: _TareasView(),
    );
  }
}

class _TareasView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Recargar tareas
              context.read<TareaBloc>().add(LoadTareasEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Indicador de progreso
          _ProgresoWidget(),

          // Lista de tareas
          Expanded(child: _TareasListWidget()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Código para añadir nueva tarea
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProgresoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContadorTareaBloc, ContadorTareaState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progreso:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${state.tareasCompletadas} de ${state.totalTareas} tareas completadas',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.porcentaje,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TareasListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TareaBloc, TareaState>(
      listener: (context, state) {
        // Actualizar el contador cuando se carguen tareas
        if (state is TareaLoaded) {
          context.read<ContadorTareaBloc>().add(
            ActualizarContadorEvent(state.tareas),
          );
        }

        // Mostrar SnackBar cuando se completa/descompleta una tarea
        if (state is TareaCompletada) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.mensaje)));

          // También actualizamos el contador cuando se completa/descompleta una tarea
          context.read<ContadorTareaBloc>().add(
            ActualizarContadorEvent(state.tareas),
          );
        }
      },
      builder: (context, state) {
        if (state is TareaLoaded) {
          if (state.tareas.isEmpty) {
            return const Center(child: Text('No tienes tareas pendientes'));
          }

          return ListView.builder(
            itemCount: state.tareas.length,
            itemBuilder: (context, index) {
              final tarea = state.tareas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    tarea.titulo,
                    style: TextStyle(
                      decoration:
                          tarea.completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(tarea.descripcion ?? ''),
                  trailing: Checkbox(
                    value: tarea.completada,
                    onChanged: (bool? value) {
                      if (value != null && tarea.id != null) {
                        context.read<TareaBloc>().add(
                          CompletarTareaEvent(
                            tareaId: tarea.id!,
                            completada: value,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        }

        if (state is TareaLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(child: Text('Cargando tareas...'));
      },
    );
  }
}
