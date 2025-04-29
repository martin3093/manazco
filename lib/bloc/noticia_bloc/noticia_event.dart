abstract class NoticiaEvent {}

class LoadNoticiasEvent extends NoticiaEvent {}

class AddNoticiaEvent extends NoticiaEvent {
  final Map<String, dynamic> noticia;

  AddNoticiaEvent(this.noticia);
}

class EditNoticiaEvent extends NoticiaEvent {
  final String id;
  final Map<String, dynamic> noticia;

  EditNoticiaEvent(this.id, this.noticia);
}

class DeleteNoticiaEvent extends NoticiaEvent {
  final String id;

  DeleteNoticiaEvent(this.id);
}
