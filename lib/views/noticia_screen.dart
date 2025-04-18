import 'package:flutter/material.dart';
//backend
import 'package:manazco/api/service/noticia_service.dart';
import 'package:manazco/domain/noticia.dart';
//component
import 'package:manazco/constants.dart';

import 'package:manazco/helpers/noticia_card_helper.dart';
import 'package:manazco/components/noticia_card.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _NoticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> noticiasList = [];
  final double spacingHeight = 10; // Espaciado entre tarjetas
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        _loadNoticias();
      }
    });
  }

  Future<void> _loadNoticias() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newNoticias = await _NoticiaService.getPaginatedNoticia(
        pageNumber: currentPage,
        pageSize: Constantes.tamanoPaginaConst,
      );

      setState(() {
        noticiasList.addAll(newNoticias);
        isLoading = false;
        hasMore = newNoticias.length == Constantes.tamanoPaginaConst;
        if (hasMore) currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(Constantes.mensajeError)));
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
      appBar: AppBar(title: const Text(Constantes.tituloApp)),
      body:
          noticiasList.isEmpty && isLoading
              ? const Center(child: Text(Constantes.mensajeCargando))
              : ListView.builder(
                controller: _scrollController,
                itemCount: noticiasList.length + (isLoading ? 1 : 0),
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < noticiasList.length) {
                    final noticia = noticiasList[index];
                    final noticiaData = NoticiaCardHelper.buildNoticiaData(
                      noticia,
                    );

                    return Column(
                      children: [
                        NoticiaCard(
                          titulo: noticiaData['titulo'],
                          descripcion: noticiaData['descripcion'],
                          fuente: noticiaData['fuente'],
                          publicadaEl: noticiaData['publicadaEl'],
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
