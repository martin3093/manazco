import 'package:manazco/data/quote_repository.dart';
import 'package:manazco/domain/quote.dart';
import 'package:manazco/constants/constants_new.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  /// Obtiene cotizaciones paginadas con validaciones
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = AppConstants.pageSize,
  }) async {
    if (pageNumber < 1) {
      throw Exception(AppConstants.errorMessage);
    }
    if (pageSize <= 0) {
      throw Exception(AppConstants.errorMessage);
    }

    // Llama al repositorio para obtener las cotizaciones paginadas
    return await _repository.getQuotes(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
