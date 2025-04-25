import 'package:flutter/material.dart';
import 'package:manazco/api/service/categoria_service.dart';
import 'package:manazco/domain/categoria.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:manazco/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({Key? key}) : super(key: key);

  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  List<Categoria> categorias = [];
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  /// Carga las categorías desde el servicio
  Future<void> _loadCategorias() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedCategorias = await _categoriaService.getCategorias();
      setState(() {
        categorias = fetchedCategorias;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      String errorMessage = 'Error desconocido';
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }

  /// Agrega una nueva categoría
  Future<void> _agregarCategoria() async {
    final nuevaCategoriaData = await _mostrarDialogCategoria(context);
    if (nuevaCategoriaData != null) {
      try {
        final nuevaCategoria = Categoria(
          id: null,
          nombre: nuevaCategoriaData['nombre'],
          descripcion: nuevaCategoriaData['descripcion'],
          imagenUrl: nuevaCategoriaData['imagenUrl'],
        );

        await _categoriaService.crearCategoria(nuevaCategoria);
        _loadCategorias();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Constantes.successCreated)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar la categoría: $e')),
        );
      }
    }
  }

  /// Edita una categoría existente
  Future<void> _editarCategoria(Categoria categoria) async {
    final categoriaEditadaData = await _mostrarDialogCategoria(
      context,
      categoria: categoria,
    );
    if (categoriaEditadaData != null) {
      try {
        final categoriaEditada = Categoria(
          id: categoria.id,
          nombre: categoriaEditadaData['nombre'],
          descripcion: categoriaEditadaData['descripcion'],
          imagenUrl: categoriaEditadaData['imagenUrl'],
        );

        await _categoriaService.editarCategoria(
          categoria.id!,
          categoriaEditada,
        );
        _loadCategorias();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Constantes.successUpdated)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar la categoría: $e')),
        );
      }
    }
  }

  /// Elimina una categoría
  Future<void> _eliminarCategoria(String id) async {
    try {
      await _categoriaService.eliminarCategoria(id);
      _loadCategorias();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(Constantes.successDeleted)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría: $e')),
      );
    }
  }

  /// Muestra un diálogo para agregar o editar una categoría
  Future<Map<String, dynamic>?> _mostrarDialogCategoria(
    BuildContext context, {
    Categoria? categoria,
  }) async {
    final TextEditingController nombreController = TextEditingController(
      text: categoria?.nombre ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: categoria?.descripcion ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: categoria?.imagenUrl ?? '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la Imagen',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty &&
                    descripcionController.text.isNotEmpty &&
                    imagenUrlController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                    'imagenUrl': imagenUrlController.text,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(Constantes.errorEmptyFields)),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(
                child: Text(
                  'Ocurrió un error al cargar las categorías.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
              : categorias.isEmpty
              ? const Center(
                child: Text(
                  'No hay categorías disponibles.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return Card(
                    child: ListTile(
                      title: Text(categoria.nombre),
                      subtitle: Text(categoria.descripcion),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarCategoria(categoria),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarCategoria(categoria.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCategoria,
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }
}
