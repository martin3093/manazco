import 'package:manazco/api/service/comentario_service.dart';
import 'package:manazco/api/service/noticia_service.dart';
import 'package:manazco/api/service/tarea_service.dart';
import 'package:manazco/bloc/reporte/reporte_bloc.dart';
import 'package:manazco/data/auth_repository.dart';
import 'package:manazco/data/categoria_repository.dart';
import 'package:manazco/data/comentario_repository.dart';
import 'package:manazco/data/noticia_repository.dart';
import 'package:manazco/data/preferencia_repository.dart';
import 'package:manazco/data/reporte_repository.dart';
import 'package:manazco/data/tarea_repository.dart';
import 'package:manazco/helpers/connectivity_service.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/helpers/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // Registrar primero los servicios básicos
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(),
  );
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Servicios de API
  di.registerLazySingleton<TareaService>(() => TareaService());
  di.registerLazySingleton<ComentarioService>(() => ComentarioService());
  di.registerLazySingleton<NoticiaService>(() => NoticiaService());

  // Repositorios
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TareasRepository>(() => TareasRepository());

  // BLoCs
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}
