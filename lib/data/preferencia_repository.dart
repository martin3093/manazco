import 'package:flutter/foundation.dart';
import 'package:manazco/api/service/preferencia_service.dart';
import 'package:manazco/data/base_repository.dart';
import 'package:manazco/domain/preferencia.dart';
import 'package:manazco/exceptions/api_exception.dart';

class PreferenciaRepository extends BaseRepository {
  final PreferenciaService _preferenciaService = PreferenciaService();

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      logOperationStart('obtener', 'categorías seleccionadas');

      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();

      logOperationSuccess('obtenidas', 'categorías seleccionadas');
      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        // En caso de error desconocido, devolver lista vacía para no romper la UI
        debugPrint('Error al obtener categorías seleccionadas: $e');
        return [];
      }
    }
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      logOperationStart('guardar', 'categorías seleccionadas');

      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await _preferenciaService.getPreferencias();

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);

      logOperationSuccess('guardadas', 'categorías seleccionadas');
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        debugPrint('Error al guardar categorías seleccionadas: $e');
        throw ApiException('Error al guardar preferencias: $e');
      }
    }
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    try {
      checkIdNotEmpty(categoriaId, 'categoría');
      logOperationStart('agregar', 'categoría al filtro', categoriaId);

      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      }

      logOperationSuccess('agregada', 'categoría al filtro', categoriaId);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        debugPrint('Error al agregar categoría: $e');
        throw ApiException('Error al agregar categoría: $e');
      }
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      checkIdNotEmpty(categoriaId, 'categoría');
      logOperationStart('eliminar', 'categoría del filtro', categoriaId);

      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);

      logOperationSuccess('eliminada', 'categoría del filtro', categoriaId);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        debugPrint('Error al eliminar categoría: $e');
        throw ApiException('Error al eliminar categoría: $e');
      }
    }
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    try {
      logOperationStart('limpiar', 'filtros de categorías');

      await guardarCategoriasSeleccionadas([]);

      // Limpiar también la caché
      if (_cachedPreferencias != null) {
        _cachedPreferencias = Preferencia.empty();
      }

      logOperationSuccess('limpiados', 'filtros de categorías');
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        debugPrint('Error al limpiar filtros: $e');
        throw ApiException('Error al limpiar filtros: $e');
      }
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    logOperationStart('invalidar', 'caché de preferencias');
    _cachedPreferencias = null;
    logOperationSuccess('invalidada', 'caché de preferencias');
  }
}
