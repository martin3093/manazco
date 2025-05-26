// lib/bloc/contador_tarea/contador_tarea_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/contador_tarea/contador_tarea_event.dart';
import 'package:manazco/bloc/contador_tarea/contador_tarea_state.dart';

class ContadorTareaBloc extends Bloc<ContadorTareaEvent, ContadorTareaState> {
  ContadorTareaBloc() : super(const ContadorTareaState()) {
    on<IncrementarContadorEvent>(_onIncrementar);
    on<DecrementarContadorEvent>(_onDecrementar);
    on<ActualizarContadorEvent>(_onActualizarContador);
  }

  void _onIncrementar(
    IncrementarContadorEvent event,
    Emitter<ContadorTareaState> emit,
  ) {
    emit(
      ContadorTareaState.fromTareas(
        state.totalTareas,
        state.tareasCompletadas + 1,
      ),
    );
  }

  void _onDecrementar(
    DecrementarContadorEvent event,
    Emitter<ContadorTareaState> emit,
  ) {
    final nuevasCompletadas =
        state.tareasCompletadas > 0 ? state.tareasCompletadas - 1 : 0;

    emit(ContadorTareaState.fromTareas(state.totalTareas, nuevasCompletadas));
  }

  void _onActualizarContador(
    ActualizarContadorEvent event,
    Emitter<ContadorTareaState> emit,
  ) {
    final total = event.tareas.length;
    final completadas = event.tareas.where((t) => t.completada).length;

    emit(ContadorTareaState.fromTareas(total, completadas));
  }
}
