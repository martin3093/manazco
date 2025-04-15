import 'package:flutter/material.dart';
import '../api/service/quote_service.dart';
import '../domain/quote.dart';
import '../constants_new.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();
  final List<Quote> quotesList = [];
  final double spacingHeight = 10; // Espaciado entre tarjetas
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        _loadQuotes();
      }
    });
  }

  Future<void> _loadQuotes() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(
        pageNumber: currentPage,
        pageSize: AppConstants.page_size,
      );

      setState(() {
        quotesList.addAll(newQuotes);
        isLoading = false;
        hasMore = newQuotes.length == AppConstants.page_size;
        if (hasMore) currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppConstants.error_message)));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo gris claro
      appBar: AppBar(title: const Text(AppConstants.title_app)),
      body:
          quotesList.isEmpty && isLoading
              ? const Center(child: Text(AppConstants.loading_message))
              : ListView.builder(
                controller: _scrollController,
                itemCount: quotesList.length + (isLoading ? 1 : 0),
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < quotesList.length) {
                    final quote = quotesList[index];
                    final formattedDate = DateFormat(
                      AppConstants.date_format,
                    ).format(quote.lastUpdated);

                    return Column(
                      children: [
                        Card(
                          elevation: 4,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quote.companyName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color:
                                        quote.changePercentage >= 0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                                Text('Actualizado: $formattedDate'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: spacingHeight,
                        ), // Espaciado entre tarjetas
                      ],
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
    );
  }
}
