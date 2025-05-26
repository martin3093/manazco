// lib/bloc/contador_tarea/contador_tarea_state.dart
import 'package:equatable/equatable.dart';

class ContadorTareaState extends Equatable {
  final int totalTareas;
  final int tareasCompletadas;
  final double porcentaje;

  const ContadorTareaState({
    this.totalTareas = 0,
    this.tareasCompletadas = 0,
    this.porcentaje = 0.0,
  });

  factory ContadorTareaState.fromTareas(int total, int completadas) {
    return ContadorTareaState(
      totalTareas: total,
      tareasCompletadas: completadas,
      porcentaje: total > 0 ? completadas / total : 0.0,
    );
  }

  @override
  List<Object?> get props => [totalTareas, tareasCompletadas, porcentaje];
}
