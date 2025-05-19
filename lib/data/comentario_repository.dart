import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manazco/api/service/comentarios_service.dart';
import 'package:manazco/data/base_repository.dart';
import 'package:manazco/domain/comentario.dart';
import 'package:manazco/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioRepository extends BaseRepository {
  final ComentariosService _service = ComentariosService();

  // Caché en memoria para comentarios
  final Map<String, List<Comentario>> _cacheComentarios = {};

  // Clave para la persistencia
  static const String _keyComentariosPersistencia = 'comentarios_cache';

  // Tiempo de validez de la caché en milisegundos (10 minutos)
  static const int _cacheDuracionMs = 10 * 60 * 1000;

  // Marcas de tiempo para cada noticia
  final Map<String, int> _cacheTiempos = {};

  // Constructor - inicializa la caché desde la persistencia
  ComentarioRepository() {
    _cargarCachePersistente();
  }

  /// Carga los comentarios almacenados en SharedPreferences
  Future<void> _cargarCachePersistente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_keyComentariosPersistencia);

      if (cachedData != null) {
        final Map<String, dynamic> cacheMap = jsonDecode(cachedData);

        // Reconstruir caché de comentarios
        cacheMap.forEach((noticiaId, comentariosJson) {
          // Convertir cada item JSON a un Comentario
          final comentariosList =
              (comentariosJson as List)
                  .map(
                    (item) =>
                        ComentarioMapper.fromMap(item as Map<String, dynamic>),
                  )
                  .toList();

          _cacheComentarios[noticiaId] = comentariosList;

          // Establecer tiempo actual como tiempo de caché
          _cacheTiempos[noticiaId] = DateTime.now().millisecondsSinceEpoch;
        });

        debugPrint('✅ Caché de comentarios cargada desde persistencia');
      }
    } catch (e) {
      debugPrint('⚠️ Error al cargar caché de comentarios: $e');
      // Si hay un error, simplemente comenzamos con caché vacía
    }
  }

  /// Guarda la caché actual en SharedPreferences
  Future<void> _guardarCachePersistente() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Crear un mapa para almacenamiento
      final Map<String, dynamic> cacheParaGuardar = {};

      // Convertir cada lista de comentarios a formato JSON serializable
      _cacheComentarios.forEach((noticiaId, comentarios) {
        try {
          // Usar try/catch para cada noticia por separado
          cacheParaGuardar[noticiaId] =
              comentarios.map((comentario) => comentario.toMap()).toList();
        } catch (e) {
          debugPrint(
            '⚠️ Error al convertir comentarios para noticia $noticiaId: $e',
          );
          // Seguir con la siguiente noticia
        }
      });

      // Guardar como string JSON
      if (cacheParaGuardar.isNotEmpty) {
        await prefs.setString(
          _keyComentariosPersistencia,
          jsonEncode(cacheParaGuardar),
        );
        debugPrint(
          '✅ Caché de comentarios guardada en persistencia - ${cacheParaGuardar.length} noticias',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error al guardar caché de comentarios: $e');
    }
  }

  /// Verifica si la caché para una noticia es válida (no expirada)
  bool _esCacheValida(String noticiaId) {
    if (!_cacheComentarios.containsKey(noticiaId) ||
        !_cacheTiempos.containsKey(noticiaId)) {
      return false;
    }

    final tiempoGuardado = _cacheTiempos[noticiaId]!;
    final tiempoActual = DateTime.now().millisecondsSinceEpoch;

    // Verificar si la caché ha expirado
    return (tiempoActual - tiempoGuardado) < _cacheDuracionMs;
  }

  /// Invalida la caché para una noticia específica
  void _invalidarCache(String noticiaId) {
    _cacheComentarios.remove(noticiaId);
    _cacheTiempos.remove(noticiaId);
    debugPrint('🗑️ Caché de comentarios invalidada para noticia: $noticiaId');
  }

  /// Actualiza la caché para una noticia
  Future<void> _actualizarCache(
    String noticiaId,
    List<Comentario> comentarios,
  ) async {
    _cacheComentarios[noticiaId] = comentarios;
    _cacheTiempos[noticiaId] = DateTime.now().millisecondsSinceEpoch;
    await _guardarCachePersistente();
    debugPrint('♻️ Caché de comentarios actualizada para noticia: $noticiaId');
  }

  /// Obtiene los comentarios asociados a una noticia específica
  /// Utiliza caché si está disponible y es válida
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId, {
    bool forzarRecarga = false,
  }) async {
    logOperationStart('obtener', 'comentarios', noticiaId);

    try {
      // Si la caché es válida y no se fuerza recarga, usarla
      if (!forzarRecarga && _esCacheValida(noticiaId)) {
        debugPrint('📋 Usando caché para comentarios de noticia: $noticiaId');
        logOperationSuccess('obtenidos desde caché', 'comentarios', noticiaId);
        return _cacheComentarios[noticiaId]!;
      }

      // Si no hay caché válida o se forzó recarga, obtener de la API
      final comentarios = await _service.obtenerComentariosPorNoticia(
        noticiaId,
      );

      // Actualizar la caché con los nuevos datos
      await _actualizarCache(noticiaId, comentarios);

      logOperationSuccess('obtenidos', 'comentarios', noticiaId);
      return comentarios;
    } catch (e) {
      // En caso de error y si hay caché (aunque expirada), usarla como fallback
      if (_cacheComentarios.containsKey(noticiaId)) {
        debugPrint(
          '⚠️ Error al obtener comentarios, usando caché expirada como fallback',
        );
        return _cacheComentarios[noticiaId]!;
      }

      if (e is ApiException) {
        rethrow; // Relanza la excepción para que la maneje el BLoC
      }
      debugPrint('❌ Error inesperado al obtener comentarios: $e');
      throw ApiException('Error inesperado al obtener comentarios.');
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    try {
      checkIdNotEmpty(noticiaId, 'noticia');
      checkFieldNotEmpty(texto, 'texto del comentario');

      logOperationStart('agregar', 'comentario', noticiaId);

      await _service.agregarComentario(noticiaId, texto, autor, fecha);

      // Invalidar caché para que se recargue con el nuevo comentario
      _invalidarCache(noticiaId);

      logOperationSuccess('agregado', 'comentario', noticiaId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado al agregar comentario: $e');
      throw ApiException('Error inesperado al agregar comentario.');
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      logOperationStart('contar', 'comentarios', noticiaId);

      // Si hay caché válida, contar desde ahí
      if (_esCacheValida(noticiaId)) {
        final count = _cacheComentarios[noticiaId]!.length;
        logOperationSuccess('contados desde caché', 'comentarios', noticiaId);
        return count;
      }

      final count = await _service.obtenerNumeroComentarios(noticiaId);

      logOperationSuccess('contados', 'comentarios', noticiaId);
      return count;
    } catch (e) {
      // Si hay caché (aunque expirada), usarla para contar
      if (_cacheComentarios.containsKey(noticiaId)) {
        return _cacheComentarios[noticiaId]!.length;
      }

      if (e is ApiException) {
        rethrow;
      }
      debugPrint('⚠️ Error al obtener número de comentarios: $e');
      return 0; // En caso de error, retornamos 0 como valor seguro
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
    required String noticiaId, // Añadimos noticiaId para gestionar la caché
  }) async {
    try {
      checkIdNotEmpty(comentarioId, 'comentario');
      logOperationStart('reaccionar a', 'comentario', comentarioId);

      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );

      // Invalidar la caché para que se recargue con los cambios
      _invalidarCache(noticiaId);

      logOperationSuccess('reacción agregada a', 'comentario', comentarioId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado al reaccionar al comentario: $e');
      throw ApiException('Error inesperado al reaccionar al comentario.');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
    required String noticiaId, // Añadimos noticiaId para gestionar la caché
  }) async {
    try {
      checkIdNotEmpty(comentarioId, 'comentario');
      checkFieldNotEmpty(texto, 'texto del subcomentario');

      logOperationStart('agregar subcomentario a', 'comentario', comentarioId);

      final resultado = await _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );

      if (resultado['success'] == true) {
        // Invalidar la caché para que se recargue con los subcomentarios
        _invalidarCache(noticiaId);

        logOperationSuccess(
          'subcomentario agregado a',
          'comentario',
          comentarioId,
        );
      } else {
        debugPrint('❌ Error al agregar subcomentario: ${resultado['message']}');
      }

      return resultado;
    } catch (e) {
      debugPrint('❌ Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}',
      };
    }
  }

  /// Limpia toda la caché de comentarios
  Future<void> limpiarCache() async {
    _cacheComentarios.clear();
    _cacheTiempos.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyComentariosPersistencia);

    debugPrint('🧹 Caché de comentarios limpiada completamente');
  }
}
