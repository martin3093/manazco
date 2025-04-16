import 'package:intl/intl.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/domain/noticia.dart';

class NoticiaCardHelper {
  /// Construye los datos necesarios para mostrar una tarjeta de noticia
  static Map<String, dynamic> buildNoticiaData(Noticia noticia) {
    //final formattedDate =
    //  '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}';

    final formattedDate = DateFormat(
      Constantes.formatoFecha,
    ).format(noticia.publicadaEl);

    return {
      'titulo': noticia.titulo,
      'descripcion': noticia.descripcion,
      'fuente': noticia.fuente,
      'publicadaEl': formattedDate,
    };
  }
}
