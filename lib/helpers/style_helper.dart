import 'package:flutter/material.dart';

class StyleHelper {
  // Estilo para el nombre de la empresa
  static const TextStyle companyNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Estilo para el precio
  static const TextStyle stockPriceStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  // Estilo para el cambio porcentual (positivo)
  static const TextStyle changePositiveStyle = TextStyle(
    fontSize: 16,
    color: Colors.green,
  );

  // Estilo para el cambio porcentual (negativo)
  static const TextStyle changeNegativeStyle = TextStyle(
    fontSize: 16,
    color: Colors.red,
  );

  // Estilo para la fecha de actualización
  static const TextStyle lastUpdatedStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
