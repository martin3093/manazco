import 'package:manazco/api/service/noticia_service.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/constants.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService = NoticiaService();

  /// Obtiene cotizaciones paginadas con validaciones
  Future<List<Noticia>> getPaginatedNoticia({
    required int pageNumber,
    int pageSize = Constantes.tamanoPaginaConst,
  }) async {
    if (pageNumber < 1) {
      throw Exception(Constantes.mensajeError);
    }
    if (pageSize <= 0) {
      throw Exception(Constantes.mensajeError);
    }

    final noticia = await _noticiaService.getNoticiasPaginadas(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    for (final noticia in noticia) {
      // Formatear la fecha de publicación
      if (noticia.titulo.isEmpty ||
          noticia.descripcion.isEmpty ||
          noticia.fuente.isEmpty) {
        throw Exception(
          '${Constantes.mensajeError} Los campos título, descripción y fuente no pueden estar vacíos.',
        );
      }
    }
    return noticia;
  }

  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
  }) async {
    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
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
