import 'package:manazco/api/service/noticia_service.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService = NoticiaService();

  /// Obtiene cotizaciones paginadas con validaciones
  /// Obtiene todas las categorías desde el repositorio
  Future<List<Noticia>> getCategorias() async {
    try {
      return await _noticiaService.getNoticias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
    String? categoriaId,
  }) async {
    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
      'categoriaId': categoriaId ?? Constantes.defaultCategoriaId,
    };

    await _noticiaService.crearNoticia(noticia);
  }

  Future<void> editarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
    String? categoriaId,
  }) async {
    if (id.isEmpty) {
      throw Exception('El ID de la noticia no puede estar vacío.');
    }

    if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
      throw Exception(
        'Los campos título, descripción y fuente no pueden estar vacíos.',
      );
    }

    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
      'categoriaId': categoriaId ?? Constantes.defaultCategoriaId,
    };

    await _noticiaService.editarNoticia(id, noticia);
  }

  Future<void> eliminarNoticia(String id) async {
    if (id.isEmpty) {
      throw Exception(
        '${Constantes.mensajeError} El ID de la noticia no puede estar vacío.',
      );
    }

    await _noticiaService.eliminarNoticia(id);
  }
}
