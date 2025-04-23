import 'package:flutter/material.dart';
import 'package:manazco/domain/task.dart';

class TaskModal extends StatefulWidget {
  final Task? task; // Tarea existente (para editar)
  final Function(String title, String type, DateTime fecha) onSave;

  const TaskModal({super.key, this.task, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _TaskModalState createState() => _TaskModalState();
}

class _TaskModalState extends State<TaskModal> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _tituloController.text = widget.task!.title;
      _detalleController.text = widget.task!.type;
      _fechaSeleccionada = widget.task!.fecha;
      _fechaController.text =
          widget.task!.fecha.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Agregar Tarea' : 'Editar Tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _detalleController,
            decoration: const InputDecoration(
              labelText: 'Detalle',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fechaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Fecha',
              border: OutlineInputBorder(),
              hintText: 'Seleccionar Fecha',
            ),
            onTap: () async {
              DateTime? nuevaFecha = await showDatePicker(
                context: context,
                initialDate: _fechaSeleccionada ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (nuevaFecha != null) {
                setState(() {
                  _fechaSeleccionada = nuevaFecha;
                  _fechaController.text =
                      nuevaFecha.toLocal().toString().split(' ')[0];
                });
              }
            },
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
            final titulo = _tituloController.text.trim();
            final detalle = _detalleController.text.trim();

            if (titulo.isNotEmpty &&
                detalle.isNotEmpty &&
                _fechaSeleccionada != null) {
              widget.onSave(titulo, detalle, _fechaSeleccionada!);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, completa todos los campos.'),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
