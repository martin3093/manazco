import 'package:manazco/domain/noticia.dart';

abstract class NoticiaState {}

class NoticiasInitialState extends NoticiaState {}

class NoticiasLoadingState extends NoticiaState {}

class NoticiasLoadedState extends NoticiaState {
  final List<Noticia> noticias;

  NoticiasLoadedState(this.noticias);
}

class NoticiasErrorState extends NoticiaState {
  final String message;

  NoticiasErrorState(this.message);
}
