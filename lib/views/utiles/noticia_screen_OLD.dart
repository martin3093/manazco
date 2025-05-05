// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// //backend
// import 'package:manazco/bloc/noticia_bloc/noticia_bloc.dart';
// import 'package:manazco/bloc/noticia_bloc/noticia_event.dart';
// import 'package:manazco/bloc/noticia_bloc/noticia_state.dart';
// import 'package:manazco/components/noticias/crear_noticia_screen.dart';
// import 'package:manazco/components/noticias/eliminar_noticia_screen.dart';
// import 'package:manazco/components/noticias/noticia_modal.dart';
// import 'package:manazco/domain/noticia.dart';
// //component
// import 'package:manazco/constants.dart';
// import 'package:manazco/helpers/noticia_card_helper.dart';
// import 'package:manazco/views/categoria_dos_screen.dart';

// class NoticiaScreen extends StatefulWidget {
//   const NoticiaScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _NoticiaScreenState createState() => _NoticiaScreenState();
// }

// class _NoticiaScreenState extends State<NoticiaScreen> {
//   late NoticiaBloc _noticiaBloc;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _noticiaBloc = NoticiaBloc();
//     _noticiaBloc.add(LoadNoticiasEvent());

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//               _scrollController.position.maxScrollExtent &&
//           !(_noticiaBloc.state is NoticiasLoadingMoreState) &&
//           _noticiaBloc.hasMore) {
//         _noticiaBloc.add(LoadMoreNoticiasEvent());
//       }
//     });
//   }

//   Future<void> _refreshNoticias() async {
//     _noticiaBloc.add(RefreshNoticiasEvent());
//   }

//   void _editarNoticia(Noticia noticia) {
//     NoticiaModal.mostrarModal(
//       context: context,
//       noticia: noticia.toJson(), // Pasa los datos de la noticia al modal
//       onSave: () {
//         _noticiaBloc.add(EditNoticiaEvent(noticia.id, {...noticia.toJson()}));
//       },
//     );
//   }

//   void _eliminarNoticia(String noticiaId) {
//     EliminarNoticiaPopup.mostrarPopup(
//       context: context,
//       noticiaId: noticiaId,
//       onNoticiaEliminada: () {
//         _noticiaBloc.add(DeleteNoticiaEvent(noticiaId));
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _noticiaBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200], // Fondo gris claro
//       appBar: AppBar(
//         title: const Text(Constantes.tituloApp),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.category),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CategoriaScreendos(),
//                 ),
//               );
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(20.0),
//           child: BlocBuilder<NoticiaBloc, NoticiaState>(
//             bloc: _noticiaBloc,
//             builder: (context, state) {
//               final lastUpdated =
//                   state is NoticiasLoadedState ? state.lastUpdated : null;
//               return lastUpdated != null
//                   ? Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Text(
//                       'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(lastUpdated)}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   )
//                   : const SizedBox(height: 0);
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           CrearNoticiaPopup.mostrarPopup(context).then((value) {
//             _noticiaBloc.add(RefreshNoticiasEvent());
//           });
//         },
//         tooltip: 'Agregar Noticia',
//         child: const Icon(Icons.add),
//       ),
//       body: BlocConsumer<NoticiaBloc, NoticiaState>(
//         bloc: _noticiaBloc,
//         listener: (context, state) {
//           if (state is NoticiasErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is NoticiasInitialState ||
//               state is NoticiasLoadingState &&
//                   !(state is NoticiasLoadingMoreState)) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is NoticiasLoadedState ||
//               state is NoticiasLoadingMoreState) {
//             final noticias =
//                 state is NoticiasLoadedState
//                     ? state.noticias
//                     : (state as NoticiasLoadingMoreState).noticias;

//             final isLoadingMore = state is NoticiasLoadingMoreState;

//             if (noticias.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No hay noticias disponibles',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: _refreshNoticias,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: noticias.length + (isLoadingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index < noticias.length) {
//                     final noticia = noticias[index];
//                     return Column(
//                       children: [
//                         NoticiaCardHelper.buildNoticiaCard(
//                           noticia: noticia,
//                           onEdit: () => _editarNoticia(noticia),
//                           onDelete: () => _eliminarNoticia(noticia.id),
//                         ),
//                         // Línea divisoria
//                         Divider(
//                           color: Colors.grey[500], // Color gris
//                           thickness: 0.5, // Grosor de la línea
//                           height: 1, // Espaciado vertical
//                         ),
//                       ],
//                     );
//                   } else {
//                     return const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             );
//           } else {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Ocurrió un error al cargar las noticias',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _refreshNoticias,
//                     child: const Text('Intentar nuevamente'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
