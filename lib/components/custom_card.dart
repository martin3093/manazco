import 'package:flutter/material.dart';
import 'package:manazco/constants.dart' as AppConstants;

class CustomCard extends StatelessWidget {
  final Map<String, dynamic> data; // Datos procesados del helper
  final VoidCallback onEdit; // Callback para editar
  final VoidCallback onDelete; // Callback para eliminar

  const CustomCard({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
      ),
      child: ListTile(
        leading: Icon(
          data['icon'], // Icono procesado
          color: data['iconColor'], // Color del icono procesado
        ),
        title: Text(
          data['title'], // Título procesado
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['type']), // Tipo de tarea procesado
            Text(
              data['date'], // Fecha procesada
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4), // Espacio entre la fecha y los pasos
            Text(
              '${AppConstants.PASOS_TITULO} ${data['steps'] != null && data['steps'].isNotEmpty ? data['steps'][0] : 'Sin pasos'}',
            ), // Muestra solo el primer paso o "Sin pasos"
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit, // Llama al callback de edición
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete, // Llama al callback de eliminación
            ),
          ],
        ),
      ),
    );
  }
}
