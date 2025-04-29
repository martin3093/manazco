import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_bloc.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_event.dart';
import 'package:manazco/bloc/categoria_bloc/categoria_state.dart';
import 'package:manazco/domain/categoria.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:manazco/helpers/error_helper.dart';

class CategoriaScreendos extends StatefulWidget {
  const CategoriaScreendos({Key? key}) : super(key: key);

  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreendos> {
  late CategoriaBloc _categoriaBloc;

  @override
  void initState() {
    super.initState();
    _categoriaBloc = CategoriaBloc();
    _categoriaBloc.add(CategoriaInitEvent());
  }

  @override
  void dispose() {
    _categoriaBloc.close();
    super.dispose();
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

        _categoriaBloc.add(AddCategoriaEvent(nuevaCategoria));
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

        _categoriaBloc.add(EditCategoriaEvent(categoria.id!, categoriaEditada));
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
      _categoriaBloc.add(DeleteCategoriaEvent(id));
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
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        bloc: _categoriaBloc,
        listener: (context, state) {
          if (state is CategoriaError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CategoriaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriaError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar las categorías.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (state is CategoriaLoaded) {
            final categorias = state.categorias;
            return categorias.isEmpty
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
                              onPressed:
                                  () => _eliminarCategoria(categoria.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
          } else {
            return const Center(child: Text('Cargando categorías...'));
          }
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
