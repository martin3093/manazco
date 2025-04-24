import 'package:flutter/material.dart';
//backend
import 'package:manazco/api/service/noticia_service.dart';
import 'package:manazco/components/noticias/crear_noticia_screen.dart';
import 'package:manazco/components/noticias/eliminar_noticia_screen.dart';
import 'package:manazco/components/noticias/noticia_modal.dart';
import 'package:manazco/domain/noticia.dart';
//component
import 'package:manazco/constants.dart';

import 'package:manazco/helpers/noticia_card_helper.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> noticiasList = [];
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
      final newNoticias = await _noticiaService.getPaginatedNoticia(
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
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text(Constantes.mensajeError)));
    }
  }

  void _editarNoticia(Noticia noticia) {
    NoticiaModal.mostrarModal(
      context: context,
      noticia: noticia.toJson(), // Pasa los datos de la noticia al modal
      onSave: _loadNoticias, // Recarga las noticias después de guardar
    );
  }

  void _eliminarNoticia(String noticiaId) {
    EliminarNoticiaPopup.mostrarPopup(
      context: context,
      noticiaId: noticiaId,
      onNoticiaEliminada: () {
        setState(() {
          noticiasList.removeWhere((noticia) => noticia.id == noticiaId);
        });
      },
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CrearNoticiaPopup.mostrarPopup(context);
        },
        tooltip: 'Agregar Noticia',
        child: const Icon(Icons.add),
      ),
      body:
          noticiasList.isEmpty && isLoading
              ? const Center(child: Text(Constantes.mensajeCargando))
              : ListView.builder(
                controller: _scrollController,
                itemCount: noticiasList.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < noticiasList.length) {
                    final noticia = noticiasList[index];

                    return Column(
                      children: [
                        NoticiaCardHelper.buildNoticiaCard(
                          noticia: noticia,
                          onEdit:
                              () => _editarNoticia(noticia), // Editar noticia
                          onDelete:
                              () => _eliminarNoticia(
                                noticia.id,
                              ), // Eliminar noticia
                        ),
                        // Línea divisoria
                        Divider(
                          color: Colors.grey[500], // Color negro
                          thickness: 0.5, // Grosor de la línea
                          height: 1, // Espaciado vertical
                        ),
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
