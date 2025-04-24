import 'dart:async';
import 'package:manazco/domain/noticia.dart'; // Para generar valores aleatorios
import 'package:dio/dio.dart';
import 'package:manazco/constants.dart'; // Para la clase Constantes

class NoticiaRepository {
  final Dio _dioNew = Dio();
  final List<Noticia> _allNoticias = [];
  //desafio semana 4
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get(Constantes.crudCrudUrl);

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
  // crud

  /// Crea una nueva noticia en la API de CrudCrud
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
    try {
      final response = await _dioNew.post(
        Constantes.crudCrudUrl,
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
      final url = '${Constantes.crudCrudUrl}/$id'; // Construye la URL con el ID
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
      final url = '${Constantes.crudCrudUrl}/$id'; // Construye la URL con el ID
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
        Constantes.crudCrudUrl,
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
}
