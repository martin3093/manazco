import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constantes {
  static const String tituloApp = 'Noticias Técnicas';
  static const String mensajeCargando = 'Cargando noticias...';
  static const String listaVacia = 'No hay noticias disponibles';
  static const String mensajeError = 'Error al cargar noticias';
  static const String formatoFecha = 'dd/MM/yyyy HH:mm';
  static const int tamanoPaginaConst = 8;
  static const double espaciadoAlto = 10;

  static const String baseUrlNew = 'https://crudcrud.com/api/';
  static const String apiKeyNew = '3433f12af2af47739e2cf483b83922ec';

  //static const String crudCrudUrl =

  //  'https://crudcrud.com/api/3433f12af2af47739e2cf483b83922ec/noticias';
  static const String tooltipOrden = 'Cambiar orden';
  static String get crudCrudUrl => dotenv.env['CRUD_CRUD_URL'] ?? '';
  static String get urlnoticias => '$crudCrudUrl/noticias';
  static String get urlCategorias => '$crudCrudUrl/categorias';
  static String errorNocategoria = 'Categoría no encontrada';
  static const String defaultCategoriaId = 'sin_categoria'; // ID por defecto
  static const int timeoutSeconds = 10;
  // Mensajes de error
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'Noticias no encontradas';
  static const String errorServer = 'Error del servidor';
  static const String errorTimeout = 'Tiempo de espera agotado';

  static const String successCreated = 'Categoría creada exitosamente';
  static const String successUpdated = 'Categoría actualizada exitosamente';
  static const String successDeleted = 'Categoría eliminada exitosamente';
  static const String errorEmptyFields = 'Todos los campos son obligatorios';
}
