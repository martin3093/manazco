import 'package:bloc/bloc.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_event.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_state.dart';
import 'package:manazco/data/categoria_repository.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<LoadCategoriasEvent>(_onLoadCategorias);
    on<AddCategoriaEvent>(_onAddCategoria);
    on<EditCategoriaEvent>(_onEditCategoria);
    on<DeleteCategoriaEvent>(_onDeleteCategoria);
  }

  Future<void> _onInit(
    CategoriaInitEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    await _onLoadCategorias(LoadCategoriasEvent(), emit);
  }

  Future<void> _onLoadCategorias(
    LoadCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(CategoriaLoading());

    try {
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al cargar categorías: ${e.toString()}'));
    }
  }

  Future<void> _onAddCategoria(
    AddCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.crearCategoria(event.categoria);
      await _onLoadCategorias(LoadCategoriasEvent(), emit);
    } catch (e) {
      emit(CategoriaError('Error al crear categoría: ${e.toString()}'));
    }
  }

  Future<void> _onEditCategoria(
    EditCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.editarCategoria(event.id, event.categoria);
      await _onLoadCategorias(LoadCategoriasEvent(), emit);
    } catch (e) {
      emit(CategoriaError('Error al editar categoría: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      await categoriaRepository.eliminarCategoria(event.id);
      await _onLoadCategorias(LoadCategoriasEvent(), emit);
    } catch (e) {
      emit(CategoriaError('Error al eliminar categoría: ${e.toString()}'));
    }
  }
}
