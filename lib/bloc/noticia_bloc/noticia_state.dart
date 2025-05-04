import 'package:equatable/equatable.dart';
import 'package:manazco/domain/noticia.dart';

abstract class NoticiaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoticiasInitialState extends NoticiaState {
  @override
  List<Object> get props => [];
}

class NoticiasLoadingState extends NoticiaState {}

class NoticiasLoadingMoreState extends NoticiaState {
  final List<Noticia> noticias;
  final bool hasMore;
  final DateTime? lastUpdated;

  NoticiasLoadingMoreState(this.noticias, this.hasMore, this.lastUpdated);

  @override
  List<Object?> get props => [noticias, hasMore, lastUpdated];
}

class NoticiasLoadedState extends NoticiaState {
  final List<Noticia> noticias;
  final bool hasMore;
  final DateTime? lastUpdated;

  NoticiasLoadedState(this.noticias, this.hasMore, this.lastUpdated);

  @override
  List<Object?> get props => [noticias, hasMore, lastUpdated];
}

class NoticiasErrorState extends NoticiaState {
  final String message;

  NoticiasErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
