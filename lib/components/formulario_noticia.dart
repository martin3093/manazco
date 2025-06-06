import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manazco/constants/constantes.dart';
import 'package:manazco/domain/categoria.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/theme/theme.dart'; // Importar el tema

class FormularioNoticia extends StatefulWidget {
  final Noticia? noticia; // Noticia existente para edición (null para creación)
  final List<Categoria> categorias; // Lista de categorías disponibles

  const FormularioNoticia({super.key, this.noticia, required this.categorias});

  @override
  State<FormularioNoticia> createState() => _FormularioNoticiaState();
}

class _FormularioNoticiaState extends State<FormularioNoticia> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fuenteController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _fechaController;
  DateTime _fechaSeleccionada = DateTime.now();
  String _selectedCategoriaId = CategoriaConstantes.defaultcategoriaId;
  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(
      text: widget.noticia?.titulo ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.noticia?.descripcion ?? '',
    );
    _fuenteController = TextEditingController(
      text: widget.noticia?.fuente ?? '',
    );
    _imagenUrlController = TextEditingController(
      text: widget.noticia?.urlImagen ?? '',
    );
    _fechaSeleccionada = widget.noticia?.publicadaEl ?? DateTime.now();
    _fechaController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_fechaSeleccionada),
    );

    // Verificar si el ID de categoría existe en la lista antes de asignarlo
    if (widget.noticia?.categoriaId != null) {
      final existeCategoria = widget.categorias.any(
        (c) => c.id == widget.noticia!.categoriaId,
      );
      _selectedCategoriaId =
          existeCategoria
              ? widget.noticia!.categoriaId!
              : CategoriaConstantes.defaultcategoriaId;
    } else {
      _selectedCategoriaId = CategoriaConstantes.defaultcategoriaId;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fuenteController.dispose();
    _imagenUrlController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    if (!context.mounted) return;

    try {
      final DateTime? fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 1)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (fechaSeleccionada != null) {
        setState(() {
          _fechaSeleccionada = fechaSeleccionada;
          _fechaController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(fechaSeleccionada);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al seleccionar fecha: $e")),
        );
      }
    }
  }

  void _guardarNoticia() {
    if (_formKey.currentState!.validate()) {
      final noticia = Noticia(
        id: widget.noticia?.id,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fuente: _fuenteController.text,
        publicadaEl: _fechaSeleccionada,
        urlImagen:
            _imagenUrlController.text.isEmpty
                ? "https://picsum.photos/200/300"
                : _imagenUrlController.text,
        categoriaId: _selectedCategoriaId,
      );
      Navigator.of(context).pop(noticia);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.noticia == null ? 'Agregar Noticia' : 'Editar Noticia',
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fuenteController,
                decoration: const InputDecoration(labelText: 'Fuente'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una fuente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                  suffixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la URL de una imagen';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de fecha
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de publicación',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _seleccionarFecha,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Selector de categoría
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoría'),
                value: _selectedCategoriaId,
                items: [
                  // Opción por defecto
                  const DropdownMenuItem<String>(
                    value: CategoriaConstantes.defaultcategoriaId,
                    child: Text('Sin categoría'),
                  ),
                  // Opciones de categorías cargadas
                  ...widget.categorias
                      .where(
                        (categoria) =>
                            categoria.id != null && categoria.id!.isNotEmpty,
                      )
                      .map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria.id!,
                          child: Text(categoria.nombre),
                        );
                      }),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategoriaId = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: AppTheme.modalSecondaryButtonStyle(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarNoticia,
          style: AppTheme.modalActionButtonStyle(),
          child: Text(widget.noticia == null ? 'Agregar' : 'Guardar'),
        ),
      ],
    );
  }
}
