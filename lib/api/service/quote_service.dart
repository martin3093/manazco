// // import '/data/quote_repository.dart';
// // import '/domain/quote.dart';

// // class QuoteService {
// //   final QuoteRepository _repository = QuoteRepository();

// //   Future<List<Quote>> fetchQuotes() {
// //     return _repository.getQuotes();
// //   }
// // }
// import '/data/quote_repository.dart';
// import '/domain/quote.dart';

// class QuoteService {
//   final QuoteRepository _repository = QuoteRepository();

//   /// Obtiene cotizaciones paginadas.
//   Future<List<Quote>> fetchQuotes({
//     required int page,
//     required int pageSize,
//   }) async {
//     // Obtiene todas las cotizaciones del repositorio
//     final allQuotes = await _repository.getQuotes();

//     // Valida que las cotizaciones tengan datos válidos
//     final validQuotes =
//         allQuotes.where((quote) => _isValidQuote(quote)).toList();

//     // Calcula el índice inicial y final para la paginación
//     final startIndex = (page - 1) * pageSize;
//     final endIndex = startIndex + pageSize;

//     // Devuelve la página solicitada
//     if (startIndex >= validQuotes.length) {
//       return [];
//     }
//     return validQuotes.sublist(
//       startIndex,
//       endIndex > validQuotes.length ? validQuotes.length : endIndex,
//     );
//   }

//   /// Valida que una cotización tenga datos válidos.
//   bool _isValidQuote(Quote quote) {
//     return quote.companyName.isNotEmpty &&
//         quote.stockPrice >= 0 &&
//         quote.changePercentage >= -100 &&
//         quote.changePercentage <= 100;
//   }
// }
import '/data/quote_repository.dart';
import '/domain/quote.dart';
import '/constants_new.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  /// Obtiene cotizaciones paginadas con validaciones.
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = 5, // Valor por defecto
  }) async {
    // Validaciones de los parámetros
    if (pageNumber < 1) {
      throw Exception(AppConstants.error_message);
    }
    if (pageSize <= 0) {
      throw Exception(AppConstants.error_message);
    }

    // Obtiene todas las cotizaciones del repositorio
    final allQuotes = await _repository.getQuotes();

    // Filtra las cotizaciones válidas
    final filteredQuotes =
        allQuotes.where((quote) {
          if (quote.stockPrice <= 0) {
            return false;
          }
          if (quote.changePercentage < -100 || quote.changePercentage > 100) {
            throw Exception(AppConstants.error_message); // Validación adicional
          }
          return true;
        }).toList();

    // Ordena las cotizaciones por stockPrice de mayor a menor
    filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));

    // Calcula los índices para la paginación
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Simula un delay para consistencia con el repositorio
    await Future.delayed(const Duration(seconds: 2));

    // Devuelve la página solicitada
    if (startIndex >= filteredQuotes.length) {
      return [];
    }
    return filteredQuotes.sublist(
      startIndex,
      endIndex > filteredQuotes.length ? filteredQuotes.length : endIndex,
    );
  }
}
