import 'package:flutter/material.dart';
import 'package:manazco/api/service/quote_service.dart';
import 'package:manazco/data/quote_repository.dart';
import 'package:manazco/domain/quote.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/components/quote_card.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteService quoteService = QuoteService(QuoteRepository());
  final ScrollController _scrollController = ScrollController();
  List<Quote> quotesList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes(); // Carga las cotizaciones iniciales
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoading) {
        _loadQuotes(); // Carga más cotizaciones al llegar al final del scroll
      }
    });
  }

  Future<void> _loadInitialQuotes() async {
    setState(() {
      isLoading = true;
      quotesList.clear();
      currentPage = 1;
      hasMore = true;
    });

    try {
      // Llama a getQuotes para cargar la primera página
      final initialQuotes = await quoteService.getQuotes(
        pageNumber: currentPage,
        pageSize: AppConstants.pageSize,
      );

      setState(() {
        if (initialQuotes.isEmpty) {
          hasMore = false; // No hay datos iniciales para cargar
        } else {
          quotesList.addAll(initialQuotes);
          currentPage++;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppConstants.errorMessage)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadQuotes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Llama a getPaginatedQuotes para cargar la siguiente página
      final newQuotes = await quoteService.getPaginatedQuotes(
        pageNumber: currentPage,
        pageSize: AppConstants.pageSize,
      );

      setState(() {
        if (newQuotes.isEmpty) {
          hasMore = false; // No hay más datos para cargar
        } else {
          quotesList.addAll(newQuotes);
          currentPage++;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppConstants.errorMessage)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double spacingHeight = 10;
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.titleAppFinance)),
      body: Container(
        color: Colors.grey[200],
        child:
            quotesList.isEmpty && isLoading
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(AppConstants.loadingmessage),
                    ],
                  ),
                )
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: quotesList.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == quotesList.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final quote = quotesList[index];
                    return QuoteCard(
                      quote: quote,
                      spacingHeight: spacingHeight,
                    );
                  },
                ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
