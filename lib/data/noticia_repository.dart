import 'package:flutter/foundation.dart';
import 'package:manazco/api/service/noticia_sevice.dart';
import 'package:manazco/data/base_repository.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';

class NoticiaRepository extends BaseRepository {
  final NoticiaService _service = NoticiaService();

  /// Obtiene cotizaciones paginadas con validaciones
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      logOperationStart('obtener', 'noticias');
      final noticias = await _service.getNoticias();
      logOperationSuccess('obtenidas', 'noticias');
      return noticias;
    } catch (e) {
      handleError(e, 'al obtener', 'noticias');
      if (e is ApiException) {
        rethrow; // Relanza la excepción para que la maneje la capa superior
      }
      debugPrint('Error inesperado al obtener noticias: $e');
      throw ApiException('Error inesperado al obtener noticias.');
    }
  }

  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    try {
      // Validaciones centralizadas
      checkFieldNotEmpty(titulo, 'título');
      checkFieldNotEmpty(descripcion, 'descripción');
      checkFieldNotEmpty(fuente, 'fuente');

      logOperationStart('crear', 'noticia');
      final noticia = Noticia(
        titulo: titulo,
        descripcion: descripcion,
        fuente: fuente,
        publicadaEl: publicadaEl,
        urlImagen: urlImagen,
        categoriaId: categoriaId,
      );

      await _service.crearNoticia(noticia);

      logOperationSuccess('creada', 'noticia');
    } catch (e) {
      handleError(e, 'al crear', 'noticia');
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al crear noticia: $e');
      throw ApiException('Error inesperado al crear noticia.');
    }
  }

  Future<void> eliminarNoticia(String id) async {
    try {
      // Validaciones centralizadas
      checkIdNotEmpty(id, 'noticia');

      logOperationStart('eliminar', 'noticia');
      if (id.isEmpty) {
        throw Exception(
          '${NoticiaConstantes.mensajeError} El ID de la noticia no puede estar vacío.',
        );
      }

      await _service.eliminarNoticia(id);
      logOperationSuccess('eliminada', 'noticia', id);
    } catch (e) {
      handleError(e, 'al eliminar', 'noticia');
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al eliminar noticia: $e');
      throw ApiException('Error inesperado al eliminar noticia.');
    }
  }

  Future<void> actualizarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    try {
      checkIdNotEmpty(id, 'noticia');
      checkFieldNotEmpty(titulo, 'título');
      checkFieldNotEmpty(descripcion, 'descripción');
      checkFieldNotEmpty(fuente, 'fuente');

      logOperationStart('actualizar', 'noticia', id);
      if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
        throw ApiException(
          'Los campos título, descripción y fuente no pueden estar vacíos.',
        );
      }
      final noticia = Noticia(
        titulo: titulo,
        descripcion: descripcion,
        fuente: fuente,
        publicadaEl: publicadaEl,
        urlImagen: urlImagen,
        categoriaId: categoriaId,
      );

      await _service.editarNoticia(id, noticia);
      logOperationSuccess('actualizada', 'noticia', id);
    } catch (e) {
      handleError(e, 'al actualizar', 'noticia');
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al editar noticia: $e');
      throw ApiException('Error inesperado al editar noticia.');
    }
  }
}
