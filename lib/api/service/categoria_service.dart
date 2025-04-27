import 'package:dio/dio.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/domain/categoria.dart';
import 'package:manazco/domain/noticia.dart';
import 'package:manazco/exceptions/api_exception.dart';

class CategoriaService {
  final Dio _dio;

  CategoriaService()
    : _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(
            milliseconds: (Constantes.timeoutSeconds * 1000),
          ),
          receiveTimeout: const Duration(
            milliseconds: (Constantes.timeoutSeconds * 1000),
          ),
        ),
      );

  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(Constantes.urlCategorias);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        throw ApiException(Constantes.mensajeError, statusCode: 400);
      } else if (response.statusCode == 401) {
        throw ApiException(Constantes.errorUnauthorized, statusCode: 401);
      } else if (response.statusCode == 404) {
        throw ApiException(Constantes.errorNotFound, statusCode: 404);
      } else if (response.statusCode == 500) {
        throw ApiException(Constantes.errorServer, statusCode: 500);
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(Constantes.errorTimeout, statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        Constantes.urlCategorias,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      final url = '${Constantes.urlCategorias}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${Constantes.urlCategorias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de categorías: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
