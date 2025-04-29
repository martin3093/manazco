import 'package:equatable/equatable.dart';
import 'package:manazco/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInitEvent extends CategoriaEvent {}

class LoadCategoriasEvent extends CategoriaEvent {}

class AddCategoriaEvent extends CategoriaEvent {
  final Categoria categoria;

  AddCategoriaEvent(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class EditCategoriaEvent extends CategoriaEvent {
  final String id;
  final Categoria categoria;

  EditCategoriaEvent(this.id, this.categoria);

  @override
  List<Object?> get props => [id, categoria];
}

class DeleteCategoriaEvent extends CategoriaEvent {
  final String id;

  DeleteCategoriaEvent(this.id);

  @override
  List<Object?> get props => [id];
}
