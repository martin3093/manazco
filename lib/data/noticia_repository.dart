import 'dart:async';
import 'package:manazco/domain/noticia.dart'; // Para generar valores aleatorios
import 'package:dio/dio.dart';
import 'package:manazco/constants.dart';
import 'package:manazco/exceptions/api_exception.dart'; // Para la clase Constantes

class NoticiaRepository {
  final Dio _dioNew = Dio();
  final List<Noticia> _allNoticias = [];
  /*
  final Dio _dioNew = Dio();
  final List<Noticia> _allNoticias = [];
  //desafio semana 4
  
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get(Constantes.urlnoticias);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;

        // Mapea las noticias del JSON a objetos Noticia
        return noticiasJson.map((json) {
          return Noticia(
            id: json['_id'] ?? '',
            titulo: json['titulo'] ?? 'Sin título',
            descripcion: json['descripcion'] ?? 'Sin descripción',
            fuente: json['fuente'] ?? 'Fuente desconocida',
            publicadaEl:
                DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
            imageUrl: json['urlImagen'] ?? '',
            categoriaId: json['categoriaId'] ?? Constantes.defaultCategoriaId,
          );
        }).toList();
      } else {
        throw Exception(
          'Error al obtener las noticias: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al conectar con la API de CrudCrud: $e');
    }
  }
    Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get('');

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;

        // Mapea las noticias del JSON a objetos Noticia
        return noticiasJson.map((json) {
          return Noticia(
            id: json['_id'] ?? '',
            titulo: json['titulo'] ?? 'Sin título',
            descripcion: json['descripcion'] ?? 'Sin descripción',
            fuente: json['fuente'] ?? 'Fuente desconocida',
            publicadaEl:
                DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
            imageUrl: json['urlImagen'] ?? '',
            categoriaId: json['categoriaId'] ?? Constantes.defaultCategoriaId,
          );
        }).toList();
      } else if (response.statusCode == 400) {
        throw ApiException('Solicitud incorrecta (400). Verifica los parámetros.');
      } else if (response.statusCode == 401) {
        throw ApiException('No autorizado (401). Verifica tus credenciales.');
      } else if (response.statusCode == 404) {
        throw ApiException('Noticias no encontradas (404).');
      } else if (response.statusCode == 500) {
        throw ApiException('Error del servidor (500). Intenta más tarde.');
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
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
  // crud

  /// Crea una nueva noticia en la API de CrudCrud
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
    try {
      final response = await _dioNew.post(
        Constantes.urlnoticias,
        data: noticia,
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear la noticia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API de CrudCrud: $e');
    }
  }

  /// Edita una noticia en la API de CrudCrud
  Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
    try {
      final url = '${Constantes.urlnoticias}/$id'; // Construye la URL con el ID
      final response = await _dioNew.put(url, data: noticia);

      if (response.statusCode != 200) {
        throw Exception('Error al editar la noticia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  //eliminar noticia
  /// Elimina una noticia de la API de CrudCrud
  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${Constantes.urlnoticias}/$id'; // Construye la URL con el ID
      final response = await _dioNew.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar la noticia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  Future<List<Noticia>> getPaginatedNoticia1({
    required int pageNumber,
    required int pageSize,
    bool ordenarPorFecha = true, // Nuevo parámetro
  }) async {
    try {
      final response = await _dioNew.get(
        Constantes.urlnoticias,
        queryParameters: {'page': pageNumber, 'pageSize': pageSize},
      );

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;

        // Mapea las noticias y ordena según el criterio
        final noticias =
            noticiasJson.map((json) {
              return Noticia(
                id: json['_id'] ?? '',
                titulo: json['titulo'] ?? 'Sin título',
                descripcion: json['descripcion'] ?? 'Sin descripción',
                fuente: json['fuente'] ?? 'Fuente desconocida',
                publicadaEl:
                    DateTime.tryParse(json['publicadaEl'] ?? '') ??
                    DateTime.now(),
                imageUrl: json['urlImagen'] ?? '',
                categoriaId:
                    json['categoriaId'] ?? Constantes.defaultCategoriaId,
              );
            }).toList();

        // Ordenar las noticias
        noticias.sort((a, b) {
          if (ordenarPorFecha) {
            return b.publicadaEl.compareTo(
              a.publicadaEl,
            ); // Más reciente primero
          } else {
            return a.fuente.compareTo(b.fuente); // Orden alfabético por fuente
          }
        });

        return noticias;
      } else {
        throw Exception(
          'Error al obtener las noticias: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  /// Devuelve una lista de noticias paginadas

  Future<List<Noticia>> getNoticiasPaginadas({
    required int pageNumber,
    int pageSize = 5,
  }) async {
    // Calcula los índices de inicio y fin para la página solicitada
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Si el índice de fin está fuera del rango de la lista actual, genera más noticias
    while (_allNoticias.length < endIndex) {
      final nuevasNoticias =
          await getNoticias(); // Llama al método y espera el resultado

      // Verifica si se obtuvieron nuevas noticias
      if (nuevasNoticias.isEmpty) {
        // print('No se pudieron obtener más noticias.');
        break; // Sal del bucle si no hay más noticias
      }

      // Agrega solo las noticias que no están ya en la lista
      for (var noticia in nuevasNoticias) {
        if (!_allNoticias.contains(noticia)) {
          _allNoticias.add(noticia);
        }
      }
    }

    // Si el índice inicial está fuera del rango, devuelve una lista vacía
    if (startIndex >= _allNoticias.length) {
      return [];
    }

    // Devuelve la sublista correspondiente a la página solicitada
    return _allNoticias.sublist(
      startIndex,
      endIndex > _allNoticias.length ? _allNoticias.length : endIndex,
    );
  }
*/

  /// Obtiene todas las noticias desde la API
  /*
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get(Constantes.urlnoticias);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;

        // Mapea las noticias del JSON a objetos Noticia
        return noticiasJson.map((json) {
          return Noticia(
            id: json['_id'] ?? '',
            titulo: json['titulo'] ?? 'Sin título',
            descripcion: json['descripcion'] ?? 'Sin descripción',
            fuente: json['fuente'] ?? 'Fuente desconocida',
            publicadaEl:
                DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
            imageUrl: json['urlImagen'] ?? '',
            categoriaId: json['categoriaId'] ?? Constantes.defaultCategoriaId,
          );
        }).toList();
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Solicitud incorrecta (400). Verifica los parámetros.',
        );
      } else if (response.statusCode == 401) {
        throw ApiException('No autorizado (401). Verifica tus credenciales.');
      } else if (response.statusCode == 404) {
        throw ApiException('Noticias no encontradas (404).');
      } else if (response.statusCode == 500) {
        throw ApiException('Error del servidor (500). Intenta más tarde.');
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
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
*/
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get(Constantes.urlnoticias);

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
      final response = await _dioNew.post(
        Constantes.urlnoticias,
        data: noticia,
      );

      if (response.statusCode == 201) {
        // Éxito: La noticia fue creada
        return;
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Solicitud incorrecta (400). Verifica los datos enviados.',
        );
      } else if (response.statusCode == 401) {
        throw ApiException('No autorizado (401). Verifica tus credenciales.');
      } else if (response.statusCode == 404) {
        throw ApiException('Endpoint no encontrado (404).');
      } else if (response.statusCode == 500) {
        throw ApiException('Error del servidor (500). Intenta más tarde.');
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
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

  /// Edita una noticia en la API
  Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
    try {
      final url = '${Constantes.urlnoticias}/$id'; // Construye la URL con el ID
      final response = await _dioNew.put(url, data: noticia);

      if (response.statusCode == 200) {
        // Éxito: La noticia fue editada
        return;
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Solicitud incorrecta (400). Verifica los datos enviados.',
        );
      } else if (response.statusCode == 401) {
        throw ApiException('No autorizado (401). Verifica tus credenciales.');
      } else if (response.statusCode == 404) {
        throw ApiException('Noticia no encontrada (404).');
      } else if (response.statusCode == 500) {
        throw ApiException('Error del servidor (500). Intenta más tarde.');
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
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
      final url = '${Constantes.urlnoticias}/$id'; // Construye la URL con el ID
      final response = await _dioNew.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Éxito: La noticia fue eliminada
        return;
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Solicitud incorrecta (400). Verifica los datos enviados.',
        );
      } else if (response.statusCode == 401) {
        throw ApiException('No autorizado (401). Verifica tus credenciales.');
      } else if (response.statusCode == 404) {
        throw ApiException('Noticia no encontrada (404).');
      } else if (response.statusCode == 500) {
        throw ApiException('Error del servidor (500). Intenta más tarde.');
      } else {
        throw ApiException('Error desconocido: ${response.statusCode}');
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

  Future<List<Noticia>> getNoticiasPaginadas({
    required int pageNumber,
    int pageSize = 5,
  }) async {
    // Calcula los índices de inicio y fin para la página solicitada
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Si el índice de fin está fuera del rango de la lista actual, genera más noticias
    while (_allNoticias.length < endIndex) {
      final nuevasNoticias =
          await getNoticias(); // Llama al método y espera el resultado

      // Verifica si se obtuvieron nuevas noticias
      if (nuevasNoticias.isEmpty) {
        // print('No se pudieron obtener más noticias.');
        break; // Sal del bucle si no hay más noticias
      }

      // Agrega solo las noticias que no están ya en la lista
      for (var noticia in nuevasNoticias) {
        if (!_allNoticias.contains(noticia)) {
          _allNoticias.add(noticia);
        }
      }
    }

    // Si el índice inicial está fuera del rango, devuelve una lista vacía
    if (startIndex >= _allNoticias.length) {
      return [];
    }

    // Devuelve la sublista correspondiente a la página solicitada
    return _allNoticias.sublist(
      startIndex,
      endIndex > _allNoticias.length ? _allNoticias.length : endIndex,
    );
  }
}
