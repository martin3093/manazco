/*import 'package:flutter/material.dart';
import '../domain/task.dart';

class DetalleTareaScreen extends StatelessWidget {
  final Task task;
  final String imageUrl;

  const DetalleTareaScreen({
    super.key,
    required this.task,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Center(
        child: Container(
          width: 350, // Ancho fijo para centrar el contenido
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
            border: Border.all(
              color:
                  Colors
                      .grey
                      .shade300, // Color del borde similar a las tarjetas
              width: 1.5, // Grosor del borde
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Sombra más suave
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen de la tarea
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Título de la tarea
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 8),

              ...task.pasos.map((paso) => Text('- $paso')).toList(),

              //Text(task.pasos.join('\n'), style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: 'Fecha límite: ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text:
                          '${task.fechaLimite.day}/${task.fechaLimite.month}/${task.fechaLimite.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Negrita
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import '../domain/task.dart';

class DetalleTareaScreen extends StatelessWidget {
  final Task task;
  final String imageUrl;

  const DetalleTareaScreen({
    super.key,
    required this.task,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Center(
        child: Container(
          width: 350, // Ancho fijo para centrar el contenido
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
            border: Border.all(
              color:
                  Colors
                      .grey
                      .shade300, // Color del borde similar a las tarjetas
              width: 1.5, // Grosor del borde
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Sombra más suave
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alineación a la izquierda
            children: [
              // Imagen de la tarea
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Título de la tarea
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify, // Justificar el título
              ),
              const SizedBox(height: 16),
              // Pasos de la tarea
              const Text(
                'Pasos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...task.pasos.map(
                (paso) => Text(
                  '- $paso',
                  textAlign: TextAlign.justify, // Justificar los pasos
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              // Fecha límite
              RichText(
                text: TextSpan(
                  text: 'Fecha límite: ',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text:
                          '${task.fechaLimite.day}/${task.fechaLimite.month}/${task.fechaLimite.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Negrita
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
