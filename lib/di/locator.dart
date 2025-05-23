import 'package:manazco/bloc/reporte/reporte_bloc.dart';
import 'package:manazco/data/auth_repository.dart';
import 'package:manazco/data/categoria_repository.dart';
import 'package:manazco/data/comentario_repository.dart';
import 'package:manazco/data/noticia_repository.dart';
import 'package:manazco/data/preferencia_repository.dart';
import 'package:manazco/data/reporte_repository.dart';
import 'package:manazco/helpers/connectivity_service.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}
