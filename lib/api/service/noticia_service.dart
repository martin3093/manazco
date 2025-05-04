import 'dart:async';
import 'package:manazco/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart';

class NoticiaService {
  final Dio _dio;

  NoticiaService()
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

  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dio.get(Constantes.urlnoticias);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;
        return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
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
      throw ApiException('Error al conectar con la API de noticias: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
    try {
      final response = await _dio.post(Constantes.urlnoticias, data: noticia);

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Edita una noticia existente en la API
  Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
    try {
      final url = '${Constantes.urlnoticias}/$id';
      final response = await _dio.put(url, data: noticia);

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Elimina una noticia de la API
  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${Constantes.urlnoticias}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Tiempo de espera agotado', statusCode: 408);
      }
      throw ApiException('Error al conectar con la API de noticias: $e');
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
