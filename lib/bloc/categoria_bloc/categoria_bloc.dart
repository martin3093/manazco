import 'package:bloc/bloc.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_event.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_state.dart';
import 'package:manazco/data/categoria_repository.dart';
import 'package:manazco/domain/categoria.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();
  List<Categoria> _categorias = [];

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
      _categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(_categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al cargar categorías: ${e.toString()}'));
    }
  }

  Future<void> _onAddCategoria(
    AddCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      // Save to API
      await categoriaRepository.crearCategoria(event.categoria);

      // After creating, reload categories to get fresh data with IDs
      _categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(_categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al crear categoría: ${e.toString()}'));
    }
  }

  Future<void> _onEditCategoria(
    EditCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      // Save to API
      await categoriaRepository.editarCategoria(event.id, event.categoria);

      // Reload categories to get fresh data with updates
      _categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(_categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al editar categoría: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    try {
      // Delete from API
      await categoriaRepository.eliminarCategoria(event.id);

      // Update local state instead of reloading from API
      _categorias.removeWhere((c) => c.id == event.id);
      emit(CategoriaLoaded(_categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Error al eliminar categoría: ${e.toString()}'));
    }
  }
}
