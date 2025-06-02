import 'package:flutter/material.dart';
import 'package:manazco/components/tarea_card.dart';
import 'package:manazco/domain/tarea.dart';
import 'package:manazco/helpers/snackbar_helper.dart';

class TaskDetailsScreen extends StatelessWidget {
  final List<Tarea> tareas;
  final int indice;

  const TaskDetailsScreen({
    super.key,
    required this.tareas,
    required this.indice,
  });

  @override
  Widget build(BuildContext context) {
    // Ocultar cualquier SnackBar activo cuando se navegue a una nueva tarjeta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });

    final theme = Theme.of(context);
    final Tarea tarea = tareas[indice];
    // Aumentar dimensiones y agregar parámetros de calidad
    final String imageUrl =
        'https://picsum.photos/seed/${tarea.id}/${1080}/${720}?quality=100';
    final String fechaLimiteDato =
        tarea.fechaLimite != null
            ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
            : 'Sin fecha límite';

    return Scaffold(
      // Usar colores de fondo del tema
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              // Deslizar hacia la derecha - retroceder
              if (indice > 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice - 1,
                        ),
                  ),
                );
              } else {
                // Usar SnackBarHelper para mantener consistencia con el tema
                SnackBarHelper.mostrarInfo(
                  context,
                  mensaje: 'No hay tareas antes de esta tarea',
                );
              }
            } else if (details.primaryVelocity! < 0) {
              // Deslizar hacia la izquierda - avanzar
              if (indice < tareas.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice + 1,
                        ),
                  ),
                );
              } else {
                // Usar SnackBarHelper para mantener consistencia con el tema
                SnackBarHelper.mostrarInfo(
                  context,
                  mensaje: 'No hay más tareas después de esta',
                );
              }
            }
          }
        },
        child: SafeArea(
          child: Padding(
            // Usar padding consistente con el tema
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Center(
              child: TaskCard(
                tarea: tarea,
                imageUrl: imageUrl,
                fechaLimiteDato: fechaLimiteDato,
                onBackPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
