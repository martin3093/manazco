import 'dart:async';
import 'package:manazco/domain/noticia.dart'; // Para generar valores aleatorios
import 'package:dio/dio.dart';
import 'package:manazco/constants.dart'; // Para la clase Constantes

class NoticiaRepository {
  final Dio _dioNew = Dio();
  // final String _baseUrlNew = 'https://newsapi.org/v2/everything';
  // final String _apiKeyNew = '6578a9258e4448a8b908d094ea7f4351';

  /// Obtiene noticias relacionadas con "papa" desde la API de NewsAPI
  Future<List<Map<String, dynamic>>> fetchNews({
    int page = 1,
    int pageSize = 10,
    String query = 'papa',
    String language = 'es',
    String sortBy = 'publishedAt',
    int pageNumber = 1,
  }) async {
    try {
      final response = await _dioNew.get(
        Constantes.baseUrlNew,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'q': query,
          'language': language,
          'sortBy': sortBy,
        },
        options: Options(
          headers: {
            'x-api-key':
                Constantes.apiKeyNew, // Agrega el API Key como encabezado
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'];
        return articles.map((article) {
          return {
            'titulo': article['title'],
            'descripcion': article['description'],
            'fuente': article['source']['name'],
            'publicadaEl': article['publishedAt'],
            'imageUrl': article['urlToImage'],
          };
        }).toList();
      } else {
        throw Exception(
          'Error al obtener las noticias: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  // Future<List<Noticia>> getNoticias({
  //   required int pageNumber,
  //   int pageSize = 5,
  // }) async {
  //   // Calcula los índices de inicio y fin para la página solicitada
  //   final startIndex = (pageNumber - 1) * pageSize;

  //   try {
  //     // Llama a la API para obtener las noticias
  //     final noticiasApi = await fetchNoticiasCrudCrud(
  //       // pageNumber: pageNumber,
  //       // pageSize: pageSize,
  //     );

  //     // Si el índice inicial está fuera del rango, devuelve una lista vacía
  //     if (startIndex >= noticiasApi.length) {
  //       return [];
  //     }

  //     // Devuelve la sublista correspondiente a la página solicitada
  //     final endIndex = startIndex + pageSize;
  //     final noticiasPaginadas = noticiasApi.sublist(
  //       startIndex,
  //       endIndex > noticiasApi.length ? noticiasApi.length : endIndex,
  //     );

  //     // Mapea las noticias a objetos Noticia
  //     return noticiasPaginadas.map((noticia) {
  //       return Noticia(
  //         titulo: noticia['titulo'] ?? 'Sin título',
  //         descripcion: noticia['descripcion'] ?? 'Sin descripción',
  //         fuente: noticia['fuente'] ?? 'Fuente desconocida',
  //         publicadaEl:
  //             DateTime.tryParse(noticia['publicadaEl'] ?? '') ?? DateTime.now(),
  //         imageUrl: noticia['imageUrl'] ?? '',
  //       );
  //     }).toList();
  //   } catch (e) {
  //     throw Exception('Error al obtener las noticias: $e');
  //   }
  // }

  //desafio semana 4
  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await _dioNew.get(Constantes.crudCrudUrl);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;

        // Mapea las noticias del JSON a objetos Noticia
        return noticiasJson.map((json) {
          return Noticia(
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

  Future<List<Noticia>> getPaginatedNoticia({
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

  // Future<List<Noticia>> getNoticias({
  //   required int pageNumber,
  //   int pageSize = 5,
  // }) async {
  //   // Simula un delay de 2 segundos

  //   // Calcula los índices de inicio y fin para la página solicitada
  //   final startIndex = (pageNumber - 1) * pageSize;
  //   final endIndex = startIndex + pageSize;

  //   // Si el índice de fin está fuera del rango de la lista actual, genera más noticias
  //   // while (_allNoticias.length < endIndex) {
  //   //   _allNoticias.add(_generateRandomNoticia(_allNoticias.length));
  //   // }

  //   // Si el índice inicial está fuera del rango, devuelve una lista vacía
  //   if (startIndex >= getNoticiasApi.length) {
  //     return [];
  //   }

  //   // Devuelve la sublista correspondiente a la página solicitada
  //   return _allNoticias.sublist(
  //     startIndex,
  //     endIndex > _allNoticias.length ? _allNoticias.length : endIndex,
  //   );
  // }
}
