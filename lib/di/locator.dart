import 'package:manazco/data/categoria_repository.dart';
import 'package:manazco/data/noticia_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  di.registerSingleton<SharedPreferences>(sharedPreferences);
  //di.registerSingleton<DbService>(DbService());

  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerSingleton<NoticiaRepository>(NoticiaRepository());
}
