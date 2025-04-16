import 'package:flutter/material.dart';
import 'package:manazco/helpers/style_helper.dart';

import 'package:flutter/material.dart';
import 'package:manazco/helpers/style_helper.dart';

class NoticiaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;

  const NoticiaCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la noticia
            Text(
              titulo,
              style:
                  StyleHelper
                      .companyNameStyle, // Puedes usar un estilo adecuado
            ),
            const SizedBox(height: 8),
            // Descripción de la noticia
            Text(
              descripcion,
              style:
                  StyleHelper
                      .stockPriceStyle, // Cambia el estilo si es necesario
            ),
            const SizedBox(height: 8),
            // Fuente de la noticia
            Text('Fuente: $fuente', style: StyleHelper.lastUpdatedStyle),
            const SizedBox(height: 8),
            // Fecha de publicación
            Text(
              'Publicada el: $publicadaEl',
              style: StyleHelper.lastUpdatedStyle,
            ),
          ],
        ),
      ),
    );
  }
}
