import 'package:intl/intl.dart';
import 'package:manazco/domain/quote.dart';
import 'package:manazco/constants/constants_new.dart';

class QuoteCardHelper {
  /// Construye los datos necesarios para mostrar una tarjeta de cotización
  static Map<String, dynamic> buildQuoteData(Quote quote) {
    final formattedDate = DateFormat(
      AppConstants.date_format,
    ).format(quote.lastUpdated);

    return {
      'companyName': quote.companyName,
      'stockPrice': '\$${quote.stockPrice.toStringAsFixed(2)}',
      'changePercentage': '${quote.changePercentage.toStringAsFixed(2)}%',
      'formattedDate': formattedDate,
      'isPositiveChange': quote.changePercentage >= 0,
    };
  }
}
