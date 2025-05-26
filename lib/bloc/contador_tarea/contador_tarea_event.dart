// lib/bloc/contador_tarea/contador_tarea_event.dart
import 'package:equatable/equatable.dart';
import 'package:manazco/domain/tarea.dart';

abstract class ContadorTareaEvent extends Equatable {
  const ContadorTareaEvent();

  @override
  List<Object?> get props => [];
}

class IncrementarContadorEvent extends ContadorTareaEvent {}

class DecrementarContadorEvent extends ContadorTareaEvent {}

class ActualizarContadorEvent extends ContadorTareaEvent {
  final List<Tarea> tareas;

  const ActualizarContadorEvent(this.tareas);

  @override
  List<Object?> get props => [tareas];
}
