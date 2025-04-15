import 'dart:async';
import '../domain/quote.dart';

class QuoteRepository {
  Future<List<Quote>> getQuotes() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un delay de 2 segundos
    return [
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
      // Nuevas cotizaciones añadidas
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
      Quote(
        companyName: 'Adobe',
        stockPrice: 650.00,
        changePercentage: 0.0,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Intel',
        stockPrice: 55.30,
        changePercentage: -0.5,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'NVIDIA',
        stockPrice: 220.15,
        changePercentage: 2.8,
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
