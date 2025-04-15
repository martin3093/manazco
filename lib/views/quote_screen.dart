import 'package:flutter/material.dart';
import '../../api/service/quote_service.dart';
import '../domain/quote.dart';
import '../constants_new.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final int _pageSize = 5; // Tamaño de la página
  int _currentPage = 1; // Página actual
  List<Quote> _quotes = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Llama al método getPaginatedQuotes
      final newQuotes = await _quoteService.getPaginatedQuotes(
        pageNumber: _currentPage, // Cambia "page" a "pageNumber"
        pageSize: _pageSize, // Parámetro correcto
      );

      setState(() {
        _quotes.addAll(newQuotes);
        _isLoading = false;
        _hasMore = newQuotes.length == _pageSize;
        if (_hasMore) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppConstants.error_message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.title_app)),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            _loadQuotes();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _quotes.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _quotes.length) {
              final quote = _quotes[index];
              return ListTile(
                title: Text(quote.companyName),
                subtitle: Text(
                  'Precio: \$${quote.stockPrice.toStringAsFixed(2)} | Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                ),
                trailing: Text(
                  'Actualizado: ${quote.lastUpdated.hour}:${quote.lastUpdated.minute}',
                ),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),

      // body: NotificationListener<ScrollNotification>(
      //   onNotification: (scrollNotification) {
      //     if (scrollNotification is ScrollEndNotification &&
      //         scrollNotification.metrics.pixels ==
      //             scrollNotification.metrics.maxScrollExtent) {
      //       _loadQuotes();
      //     }
      //     return false;
      //   },
      //   child: ListView.builder(
      //     itemCount: _quotes.length + (_hasMore ? 1 : 0),
      //     itemBuilder: (context, index) {
      //       if (index < _quotes.length) {
      //         final quote = _quotes[index];
      //         return ListTile(
      //           title: Text(quote.companyName),
      //           subtitle: Text(
      //             'Precio: \$${quote.stockPrice.toStringAsFixed(2)} | Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
      //           ),
      //           trailing: Text(
      //             'Actualizado: ${quote.lastUpdated.hour}:${quote.lastUpdated.minute}',
      //           ),
      //         );
      //       } else {
      //         return const Center(
      //           child: Padding(
      //             padding: EdgeInsets.all(16.0),
      //             child: CircularProgressIndicator(),
      //           ),
      //         );
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
