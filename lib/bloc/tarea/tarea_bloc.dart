import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/tarea/tarea_event.dart';
import 'package:manazco/bloc/tarea/tarea_state.dart';
import 'package:manazco/data/tarea_repository.dart';
import 'package:manazco/domain/tarea.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = di<TareasRepository>();
  static const int _limitePorPagina = 5;

  TareaBloc() : super(TareaInitial()) {
    on<LoadTareasEvent>(_onLoadTareas);
    on<LoadMoreTareasEvent>(_onLoadMoreTareas);
    on<CreateTareaEvent>(_onCreateTarea);
    on<UpdateTareaEvent>(_onUpdateTarea);
    on<DeleteTareaEvent>(_onDeleteTarea);
    on<CompletarTareaEvent>(_onCompletarTarea); // Añadir esta línea
  }

  Future<void> _onLoadTareas(
    LoadTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );
      emit(
        TareaLoaded(
          tareas: tareas,
          lastUpdated: DateTime.now(),
          hayMasTareas: tareas.length >= _limitePorPagina,
          paginaActual: 0,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onLoadMoreTareas(
    LoadMoreTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    if (state is TareaLoaded) {
      final currentState = state as TareaLoaded;
      try {
        final nuevasTareas = await _tareaRepository.obtenerTareas(
          forzarRecarga: true,
        );

        emit(
          TareaLoaded(
            tareas: [...currentState.tareas, ...nuevasTareas],
            lastUpdated: DateTime.now(),
            hayMasTareas: nuevasTareas.length >= event.limite,
            paginaActual: event.pagina,
          ),
        );
      } catch (e) {
        if (e is ApiException) {
          emit(TareaError(e));
        }
      }
    }
  }

  Future<void> _onCreateTarea(
    CreateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final nuevaTarea = await _tareaRepository.agregarTarea(event.tarea);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas = [nuevaTarea, ...currentState.tareas];

        emit(
          TareaCreated(
            tareas,
            TipoOperacionTarea.crear,
            'Tarea creada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onUpdateTarea(
    UpdateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final tareaActualizada = await _tareaRepository.actualizarTarea(
        event.tarea,
      );
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.tarea.id ? tareaActualizada : tarea;
            }).toList();

        emit(
          TareaUpdated(
            tareas,
            TipoOperacionTarea.editar,
            'Tarea actualizada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onDeleteTarea(
    DeleteTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      await _tareaRepository.eliminarTarea(event.id);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.where((t) => t.id != event.id).toList();

        emit(
          TareaDeleted(
            tareas,
            TipoOperacionTarea.eliminar,
            'Tarea eliminada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  //
  Future<void> _onCompletarTarea(
    CompletarTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;

        // Encontrar la tarea por ID
        final index = currentState.tareas.indexWhere(
          (t) => t.id == event.tareaId,
        );

        if (index != -1) {
          // Obtener la tarea actual
          final tarea = currentState.tareas[index];

          // Crear una nueva tarea con el estado completado actualizado
          final tareaActualizada = Tarea(
            id: tarea.id,
            usuario: tarea.usuario,
            titulo: tarea.titulo,
            tipo: tarea.tipo,
            descripcion: tarea.descripcion,
            fecha: tarea.fecha,
            fechaLimite: tarea.fechaLimite,
            completada: event.completada,
          );

          // Actualizar la tarea en el repositorio
          await _tareaRepository.actualizarTarea(tareaActualizada);

          // Actualizar la lista de tareas
          final tareas = List<Tarea>.from(currentState.tareas);
          tareas[index] = tareaActualizada;

          // Emitir el estado de tarea completada
          emit(
            TareaCompletada(
              tareas,
              TipoOperacionTarea.editar,
              event.completada
                  ? 'Tarea completada'
                  : 'Tarea marcada como pendiente',
              tareaId: event.tareaId,
              completada: event.completada,
            ),
          );

          // Emitir el estado actualizado de tareas cargadas
          emit(
            TareaLoaded(
              tareas: tareas,
              lastUpdated: DateTime.now(),
              hayMasTareas: currentState.hayMasTareas,
              paginaActual: currentState.paginaActual,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        TareaError(ApiException('Error al completar tarea: ${e.toString()}')),
      );
    }
  }
}
