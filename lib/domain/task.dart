/*class Task {
  final String title;
  final String type;
  final DateTime fecha;

  Task({required this.title, this.type = 'normal', required this.fecha});
}

*/
class Task {
  final String title;
  final String type;
  final String description; // Campo opcional para la descripción
  final DateTime fecha;
  final DateTime fechaLimite; // Nuevo campo para la fecha límite
  final List<String> pasos; // Nuevo campo para los pasos

  Task({
    required this.title,
    this.type = 'normal',
    required this.description,
    required this.fecha,
    required this.fechaLimite, // Campo obligatorio
    this.pasos = const [], // Valor por defecto vacío
  });
}
