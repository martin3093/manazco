class AssistantRepository {
  List<String> obtenerPasosRepository(String titulo, DateTime fechaLimite) {
    final fechaStr =
        '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';

    return [
      'Paso 1: Planificar antes del $fechaStr',
      'Paso 2: Ejecutar antes del $fechaStr',
      'Paso 3: Revisar antes del $fechaStr',
    ];
  }
}
