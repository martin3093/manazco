import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/components/noticia_card.dart';

class NoticiaCardHelper {
  /// Construye un widget NoticiaCard directamente desde una instancia de Noticia
  static Widget buildNoticiaCard(Noticia noticia, String imageUrl) {
    final formattedDate = DateFormat(
      Constantes.formatoFecha,
    ).format(noticia.publicadaEl);

    return NoticiaCard(
      titulo: noticia.titulo,
      //descripcion: noticia.descripcion,
      fuente: noticia.fuente,
      publicadaEl: formattedDate,
      imageUrl: imageUrl,
    );
  }
}
