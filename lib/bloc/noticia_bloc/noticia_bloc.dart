import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/noticia_bloc/noticia_event.dart';
import 'package:manazco/bloc/noticia_bloc/noticia_state.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/data/noticia_repository.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  final NoticiaRepository noticiaRepository = di<NoticiaRepository>();
  List<Noticia> _noticias = [];

  NoticiaBloc() : super(NoticiasInitialState()) {
    on<LoadNoticiasEvent>(_onLoadNoticias);
    on<AddNoticiaEvent>(_onAddNoticia);
    on<EditNoticiaEvent>(_onEditNoticia);
    on<DeleteNoticiaEvent>(_onDeleteNoticia);
    on<RefreshNoticiasEvent>(_onRefreshNoticias);
    on<LoadMoreNoticiasEvent>(_onLoadMoreNoticias);
  }

  Future<void> _onLoadNoticias(
    LoadNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    emit(NoticiasLoadingState());

    try {
      _noticias = await noticiaRepository.getNoticias(
        pageNumber: 1,
        pageSize: Constantes.tamanoPaginaConst,
      );

      emit(
        NoticiasLoadedState(
          _noticias,
          _noticias.length == Constantes.tamanoPaginaConst,
          DateTime.now(),
        ),
      );
    } catch (e) {
      String errorMessage = Constantes.mensajeError;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      }
      emit(NoticiasErrorState(errorMessage));
    }
  }

  Future<void> _onLoadMoreNoticias(
    LoadMoreNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    final currentState = state;
    if (!(currentState is NoticiasLoadedState) || !(currentState.hasMore)) {
      return;
    }

    try {
      emit(
        NoticiasLoadingMoreState(
          List.from(_noticias),
          currentState.hasMore,
          currentState.lastUpdated,
        ),
      );

      // Calcular la página siguiente basada en la cantidad de noticias actuales
      int nextPage =
          (_noticias.length / Constantes.tamanoPaginaConst).ceil() + 1;

      final nuevasNoticias = await noticiaRepository.getPaginatedNoticia(
        pageNumber: nextPage,
        pageSize: Constantes.tamanoPaginaConst,
      );

      if (nuevasNoticias.isNotEmpty) {
        _noticias.addAll(nuevasNoticias);
        bool hasMore = nuevasNoticias.length == Constantes.tamanoPaginaConst;

        emit(
          NoticiasLoadedState(List.from(_noticias), hasMore, DateTime.now()),
        );
      } else {
        emit(NoticiasLoadedState(List.from(_noticias), false, DateTime.now()));
      }
    } catch (e) {
      String errorMessage = Constantes.mensajeError;
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      }
      emit(NoticiasErrorState(errorMessage));
    }
  }

  Future<void> _onRefreshNoticias(
    RefreshNoticiasEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    await _onLoadNoticias(LoadNoticiasEvent(), emit);
  }

  Future<void> _onAddNoticia(
    AddNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      // Guardar en la API
      await noticiaRepository.crearNoticia(
        titulo: event.noticia['titulo'],
        descripcion: event.noticia['descripcion'],
        fuente: event.noticia['fuente'],
        publicadaEl: event.noticia['publicadaEl'],
        urlImagen: event.noticia['urlImagen'],
      );

      // Después de crear, recargar noticias para obtener datos actualizados con IDs
      _noticias = await noticiaRepository.getNoticias(
        pageNumber: 1,
        pageSize: Constantes.tamanoPaginaConst,
      );

      emit(
        NoticiasLoadedState(
          _noticias,
          _noticias.length == Constantes.tamanoPaginaConst,
          DateTime.now(),
        ),
      );
    } catch (e) {
      String errorMessage = 'Error al agregar la noticia';
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      }
      emit(NoticiasErrorState(errorMessage));
    }
  }

  Future<void> _onEditNoticia(
    EditNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      // Guardar en la API
      await noticiaRepository.editarNoticia(
        id: event.id,
        titulo: event.noticia['titulo'],
        descripcion: event.noticia['descripcion'],
        fuente: event.noticia['fuente'],
        publicadaEl: event.noticia['publicadaEl'],
        urlImagen: event.noticia['urlImagen'],
      );

      // Recargar noticias para obtener datos frescos con actualizaciones
      _noticias = await noticiaRepository.getNoticias(
        pageNumber: 1,
        pageSize: Constantes.tamanoPaginaConst,
      );

      emit(
        NoticiasLoadedState(
          _noticias,
          _noticias.length == Constantes.tamanoPaginaConst,
          DateTime.now(),
        ),
      );
    } catch (e) {
      String errorMessage = 'Error al editar la noticia';
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      }
      emit(NoticiasErrorState(errorMessage));
    }
  }

  Future<void> _onDeleteNoticia(
    DeleteNoticiaEvent event,
    Emitter<NoticiaState> emit,
  ) async {
    try {
      // Eliminar de la API
      await noticiaRepository.eliminarNoticia(event.id);

      // Actualizar el estado local en lugar de recargar desde la API
      _noticias.removeWhere((n) => n.id == event.id);

      emit(
        NoticiasLoadedState(
          _noticias,
          state is NoticiasLoadedState
              ? (state as NoticiasLoadedState).hasMore
              : false,
          DateTime.now(),
        ),
      );
    } catch (e) {
      String errorMessage = 'Error al eliminar la noticia';
      if (e is ApiException) {
        errorMessage = 'Error ${e.statusCode}: ${e.message}';
      }
      emit(NoticiasErrorState(errorMessage));
    }
  }
}
