// import 'dart:async';
// import '../domain/quote.dart';

// class QuoteRepository {
//   // Lista completa de cotizaciones
//   final List<Quote> _allQuotes = [
//     Quote(
//       companyName: 'Apple',
//       stockPrice: 150.25,
//       changePercentage: 2.5,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Microsoft',
//       stockPrice: 299.99,
//       changePercentage: 1.2,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Amazon',
//       stockPrice: 3450.50,
//       changePercentage: -0.8,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Tesla',
//       stockPrice: 720.30,
//       changePercentage: 3.1,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Facebook',
//       stockPrice: 355.10,
//       changePercentage: -2.0,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Google',
//       stockPrice: 2800.50,
//       changePercentage: -1.3,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Netflix',
//       stockPrice: 590.20,
//       changePercentage: 4.5,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Adobe',
//       stockPrice: 650.00,
//       changePercentage: 0.0,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'Intel',
//       stockPrice: 55.30,
//       changePercentage: -0.5,
//       lastUpdated: DateTime.now(),
//     ),
//     Quote(
//       companyName: 'NVIDIA',
//       stockPrice: 220.15,
//       changePercentage: 2.8,
//       lastUpdated: DateTime.now(),
//     ),
//   ];

//   /// Devuelve una lista de cotizaciones paginadas
//   Future<List<Quote>> getQuotes({
//     required int pageNumber,
//     int pageSize = 5,
//   }) async {
//     await Future.delayed(
//       const Duration(seconds: 2),
//     ); // Simula un delay de 2 segundos

//     // Calcula los índices de inicio y fin para la página solicitada
//     final startIndex = (pageNumber - 1) * pageSize;
//     final endIndex = startIndex + pageSize;

//     // Si el índice inicial está fuera del rango, devuelve una lista vacía
//     if (startIndex >= _allQuotes.length) {
//       return [];
//     }

//     // Devuelve la sublista correspondiente a la página solicitada
//     return _allQuotes.sublist(
//       startIndex,
//       endIndex > _allQuotes.length ? _allQuotes.length : endIndex,
//     );
//   }
// }

import 'dart:async';
import 'dart:math'; // Para generar valores aleatorios
import 'package:manazco/domain/quote.dart';

class QuoteRepository {
  // Lista inicial de cotizaciones predefinidas
  final List<Quote> _allQuotes = [
    Quote(
      companyName: 'Apple',
      stockPrice: 150.25,
      changePercentage: 2.5,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Microsoft',
      stockPrice: 299.99,
      changePercentage: 1.2,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Amazon',
      stockPrice: 3450.50,
      changePercentage: -0.8,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Tesla',
      stockPrice: 720.30,
      changePercentage: 3.1,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Facebook',
      stockPrice: 355.10,
      changePercentage: -2.0,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Google',
      stockPrice: 2800.50,
      changePercentage: -1.3,
      lastUpdated: DateTime.now(),
    ),
    Quote(
      companyName: 'Netflix',
      stockPrice: 590.20,
      changePercentage: 4.5,
      lastUpdated: DateTime.now(),
    ),
  ];

  /// Genera una cotización aleatoria
  Quote _generateRandomQuote(int index) {
    final random = Random();
    final companyNames = [
      'Adobe',
      'Intel',
      'NVIDIA',
      'Spotify',
      'Twitter',
      'Snapchat',
      'Uber',
      'Lyft',
      'Zoom',
      'Slack',
    ];

    return Quote(
      companyName:
          companyNames[random.nextInt(companyNames.length)], // Nombre aleatorio
      stockPrice: double.parse(
        (random.nextDouble() * 1000).toStringAsFixed(2),
      ), // Precio entre 0 y 1000
      changePercentage: double.parse(
        (random.nextDouble() * 20 - 10).toStringAsFixed(2),
      ), // Cambio entre -10% y 10%
      lastUpdated: DateTime.now().subtract(
        Duration(
          minutes: random.nextInt(
            60,
          ), // Última actualización en los últimos 60 minutos
        ),
      ),
    );
  }

  /// Devuelve una lista de cotizaciones paginadas
  Future<List<Quote>> getQuotes({
    required int pageNumber,
    int pageSize = 5,
  }) async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un delay de 2 segundos

    // Calcula los índices de inicio y fin para la página solicitada
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Si el índice de fin está fuera del rango de la lista actual, genera más cotizaciones
    while (_allQuotes.length < endIndex) {
      _allQuotes.add(_generateRandomQuote(_allQuotes.length));
    }

    // Si el índice inicial está fuera del rango, devuelve una lista vacía
    if (startIndex >= _allQuotes.length) {
      return [];
    }

    // Devuelve la sublista correspondiente a la página solicitada
    return _allQuotes.sublist(
      startIndex,
      endIndex > _allQuotes.length ? _allQuotes.length : endIndex,
    );
  }
}
