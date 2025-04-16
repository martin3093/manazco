import 'dart:async';
import 'dart:math';
import 'package:manazco/domain/noticia.dart'; // Para generar valores aleatorios

class NoticiaRepository {
  // Lista inicial de noticias predefinidas
  final List<Noticia> _allNoticias = [
    Noticia(
      titulo: 'Nueva tecnología revolucionaria',
      descripcion:
          'Se ha presentado una nueva tecnología que cambiará el mundo.',
      fuente: 'Tech News',
      publicadaEl: DateTime.now(),
    ),
    Noticia(
      titulo: 'Avances en inteligencia artificial',
      descripcion: 'La IA está transformando industrias a un ritmo acelerado.',
      fuente: 'AI Today',
      publicadaEl: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Noticia(
      titulo: 'Exploración espacial',
      descripcion: 'Nuevas misiones a Marte están en desarrollo.',
      fuente: 'Space News',
      publicadaEl: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Noticia(
      titulo: 'Cambio climático',
      descripcion: 'Expertos advierten sobre los efectos del cambio climático.',
      fuente: 'Global News',
      publicadaEl: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Noticia(
      titulo: 'Innovaciones en salud',
      descripcion: 'Nuevas tecnologías están mejorando la atención médica.',
      fuente: 'Health Weekly',
      publicadaEl: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Noticia(
      titulo: 'Economía global',
      descripcion: 'Los mercados financieros enfrentan desafíos importantes.',
      fuente: 'Finance Daily',
      publicadaEl: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Noticia(
      titulo: 'Deportes internacionales',
      descripcion: 'Grandes eventos deportivos están en marcha.',
      fuente: 'Sports World',
      publicadaEl: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  /// Genera una noticia aleatoria
  Noticia _generateRandomNoticia(int index) {
    final random = Random();
    final titulos = [
      'Descubrimiento científico',
      'Avances en tecnología',
      'Noticias de última hora',
      'Tendencias globales',
      'Innovaciones en transporte',
      'Nuevas políticas públicas',
      'Eventos culturales destacados',
      'Progreso en energías renovables',
      'Impacto de la economía digital',
      'Exploración de nuevos mercados',
    ];

    final descripciones = [
      'Un avance significativo ha sido reportado.',
      'Se han presentado nuevas soluciones tecnológicas.',
      'Un evento importante está ocurriendo en este momento.',
      'Se destacan nuevas tendencias en el ámbito global.',
      'Nuevas formas de transporte están revolucionando el sector.',
      'Se implementan políticas que buscan mejorar la calidad de vida.',
      'Eventos culturales están captando la atención mundial.',
      'Las energías renovables están ganando terreno.',
      'La economía digital está transformando industrias.',
      'Nuevas oportunidades están surgiendo en mercados emergentes.',
    ];

    final fuentes = [
      'Tech News',
      'Global Times',
      'Daily Report',
      'World Insights',
      'Innovation Weekly',
      'Economic Review',
      'Cultural Digest',
      'Energy Today',
      'Digital Trends',
      'Market Watch',
    ];

    return Noticia(
      titulo: titulos[random.nextInt(titulos.length)], // Título aleatorio
      descripcion:
          descripciones[random.nextInt(
            descripciones.length,
          )], // Descripción aleatoria
      fuente: fuentes[random.nextInt(fuentes.length)], // Fuente aleatoria
      publicadaEl: DateTime.now().subtract(
        Duration(
          minutes: random.nextInt(1440), // Publicada en las últimas 24 horas
        ),
      ),
    );
  }

  /// Devuelve una lista de noticias paginadas
  Future<List<Noticia>> getNoticias({
    required int pageNumber,
    int pageSize = 5,
  }) async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un delay de 2 segundos

    // Calcula los índices de inicio y fin para la página solicitada
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Si el índice de fin está fuera del rango de la lista actual, genera más noticias
    while (_allNoticias.length < endIndex) {
      _allNoticias.add(_generateRandomNoticia(_allNoticias.length));
    }

    // Si el índice inicial está fuera del rango, devuelve una lista vacía
    if (startIndex >= _allNoticias.length) {
      return [];
    }

    // Devuelve la sublista correspondiente a la página solicitada
    return _allNoticias.sublist(
      startIndex,
      endIndex > _allNoticias.length ? _allNoticias.length : endIndex,
    );
  }
}
