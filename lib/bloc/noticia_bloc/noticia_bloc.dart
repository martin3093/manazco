// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:manazco/bloc/noticia_bloc/noticia_event.dart';
// import 'package:manazco/bloc/noticia_bloc/noticia_state.dart';
// import 'package:manazco/data/noticia_repository.dart';

// class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
//   final NoticiaRepository noticiaRepository;

//   NoticiaBloc(this.noticiaRepository) : super(NoticiasInitialState()) {
//     on<LoadNoticiasEvent>((event, emit) async {
//       emit(NoticiasLoadingState());
//       try {
//         final noticias = await noticiaRepository.obtenerNoticias();
//         emit(NoticiasLoadedState(noticias));
//       } catch (e) {
//         emit(NoticiasErrorState('Error al cargar las noticias'));
//       }
//     });

//     on<AddNoticiaEvent>((event, emit) async {
//       try {
//         await noticiaRepository.crearNoticia(event.noticia);
//         add(LoadNoticiasEvent()); // Recarga las noticias
//       } catch (e) {
//         emit(NoticiasErrorState('Error al agregar la noticia'));
//       }
//     });

//     on<EditNoticiaEvent>((event, emit) async {
//       try {
//         await noticiaRepository.editarNoticia(event.id, event.noticia);
//         add(LoadNoticiasEvent()); // Recarga las noticias
//       } catch (e) {
//         emit(NoticiasErrorState('Error al editar la noticia'));
//       }
//     });

//     on<DeleteNoticiaEvent>((event, emit) async {
//       try {
//         await noticiaRepository.eliminarNoticia(event.id);
//         add(LoadNoticiasEvent()); // Recarga las noticias
//       } catch (e) {
//         emit(NoticiasErrorState('Error al eliminar la noticia'));
//       }
//     });
//   }
// }
