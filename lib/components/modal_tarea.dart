import 'package:flutter/material.dart';
import '../domain/task.dart'; // Importa la clase Task

void mostrarModalTarea({
  required BuildContext context,
  Task? task,
  required Function(String titulo, String detalle, DateTime fecha) onSave,
}) {
  final TextEditingController tituloController = TextEditingController(
    text: task?.title ?? '',
  );
  final TextEditingController detalleController = TextEditingController(
    text: task?.type ?? '',
  );
  final TextEditingController fechaController = TextEditingController(
    text:
        task != null ? task.fechaLimite.toLocal().toString().split(' ')[0] : '',
  );
  DateTime? fechaSeleccionada = task?.fechaLimite;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(task == null ? 'Agregar Tarea' : 'Editar Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detalleController,
              decoration: const InputDecoration(
                labelText: 'Detalle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                hintText: 'Seleccionar Fecha',
              ),
              onTap: () async {
                DateTime? nuevaFecha = await showDatePicker(
                  context: context,
                  initialDate: fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (nuevaFecha != null) {
                  fechaSeleccionada = nuevaFecha;
                  fechaController.text =
                      nuevaFecha.toLocal().toString().split(' ')[0];
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el modal sin guardar
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final titulo = tituloController.text.trim();
              final detalle = detalleController.text.trim();

              if (titulo.isNotEmpty &&
                  detalle.isNotEmpty &&
                  fechaSeleccionada != null) {
                onSave(titulo, detalle, fechaSeleccionada!);
                Navigator.pop(context); // Cierra el modal
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
    },
  );
}
