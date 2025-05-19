// Ubicación: lib/data/cache_manager.dart
class CacheManager {
  // Singleton
  static final CacheManager _instance = CacheManager._internal();
  
  factory CacheManager() => _instance;
  
  CacheManager._internal();
  
  // Cache compartida
  final Map<String, dynamic> _globalCache = {};
  final Map<String, int> _cacheTiempos = {};
  
  // Métodos para manejar caché global...
}