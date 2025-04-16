import 'package:flutter/material.dart';
import 'package:manazco/components/quote_card.dart';
import 'package:manazco/api/service/quote_service.dart';
import 'package:manazco/domain/quote.dart';
import 'package:manazco/constants/constants_new.dart';
import 'package:manazco/helpers/quote_card_helper.dart';

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
                    final quoteData = QuoteCardHelper.buildQuoteData(quote);

                    return Column(
                      children: [
                        QuoteCard(
                          companyName: quoteData['companyName'],
                          stockPrice: quoteData['stockPrice'],
                          changePercentage: quoteData['changePercentage'],
                          formattedDate: quoteData['formattedDate'],
                          isPositiveChange: quoteData['isPositiveChange'],
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
