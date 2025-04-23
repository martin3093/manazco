import 'package:manazco/data/noticia_repository.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/constants.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

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

    final noticia = await _repository.getNoticias(
      // pageNumber: pageNumber,
      // pageSize: pageSize,
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

    await _repository.crearNoticia(noticia);
  }
}
