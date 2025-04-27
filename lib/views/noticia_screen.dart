import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//backend
import 'package:manazco/data/noticia_repository.dart';
import 'package:manazco/components/noticias/crear_noticia_screen.dart';
import 'package:manazco/components/noticias/eliminar_noticia_screen.dart';
import 'package:manazco/components/noticias/noticia_modal.dart';
import 'package:manazco/domain/noticia.dart';
//component
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:manazco/helpers/error_helper.dart';

import 'package:manazco/helpers/noticia_card_helper.dart';
import 'package:manazco/views/categoria_screen.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticiaScreenState createState() => _NoticiaScreenState();
}

class _NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> noticiasList = [];
  int currentPage = 1;

  bool hasMore = true;

  bool isLoading = false; // Indica si los datos están cargando
  bool hasError = false; // Indica si ocurrió un error
  DateTime? lastUpdated; // Fecha y hora de la última actualización

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

  /*
  Future<void> _loadNoticias() async {
    setState(() {
      isLoading = true; // Comienza la carga
      hasError = false; // Resetea el estado de error
    });

    try {
      // Llama al servicio para obtener las noticias
      final newNoticias = await _noticiaService.getPaginatedNoticia(
        pageNumber: currentPage,
        pageSize: Constantes.tamanoPaginaConst,
      );

      setState(() {
        noticiasList.addAll(newNoticias); // Agrega las noticias a la lista
        isLoading = false; // Finaliza la carga
        hasMore = newNoticias.length == Constantes.tamanoPaginaConst;
        if (hasMore) currentPage++;
        lastUpdated =
            DateTime.now(); // Actualiza la fecha y hora de la última actualización
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Finaliza la carga
        hasError = true; // Marca que ocurrió un error
      });

      // Determina el mensaje y el color del error
      String errorMessage = Constantes.mensajeError;
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }

      // Muestra el SnackBar con el mensaje y el color
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }
*/
  Future<void> _loadNoticias() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final noticias = await _noticiaRepository.getPaginatedNoticia(
        pageNumber: currentPage,
        pageSize: Constantes.tamanoPaginaConst,
      );

      setState(() {
        noticiasList.addAll(noticias);
        isLoading = false;
        hasMore = noticias.length == Constantes.tamanoPaginaConst;
        if (hasMore) currentPage++;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      String errorMessage = Constantes.mensajeError;
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        switch (e.statusCode) {
          case 400:
          case 500:
            errorMessage = e.message;
            errorColor = Colors.red;
            break;
          case 401:
            errorMessage = e.message;
            errorColor = Colors.orange;
            break;
          case 404:
            errorMessage = e.message;
            errorColor = Colors.grey;
            break;
          default:
            errorMessage = 'Error desconocido.';
            errorColor = Colors.grey;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
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
      appBar: AppBar(
        title: const Text(Constantes.tituloApp),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriaScreen(),
                ),
              );
            },
          ),
        ],
        bottom:
            lastUpdated != null
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(lastUpdated!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
                : null,
      ),
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
