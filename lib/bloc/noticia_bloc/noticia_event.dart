import 'package:equatable/equatable.dart';
import 'package:manazco/domain/noticia.dart';

abstract class NoticiaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNoticiasEvent extends NoticiaEvent {}

class LoadMoreNoticiasEvent extends NoticiaEvent {}

class RefreshNoticiasEvent extends NoticiaEvent {}

class AddNoticiaEvent extends NoticiaEvent {
  final Map<String, dynamic> noticia;

  AddNoticiaEvent(this.noticia);

  @override
  List<Object?> get props => [noticia];
}

class EditNoticiaEvent extends NoticiaEvent {
  final String id;
  final Map<String, dynamic> noticia;

  EditNoticiaEvent(this.id, this.noticia);

  @override
  List<Object?> get props => [id, noticia];
}

class DeleteNoticiaEvent extends NoticiaEvent {
  final String id;

  DeleteNoticiaEvent(this.id);

  @override
  List<Object?> get props => [id];
}
