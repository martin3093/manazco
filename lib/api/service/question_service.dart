import 'package:manazco/data/question_repository.dart';
import 'package:manazco/domain/question.dart';

class QuestionService {
  final List<Question> questions = [];

  Future<List<Question>> getQuestions() async {
    final QuestionRepository repository = QuestionRepository();
    final questions = await repository.getQuestions();
    return questions;
  }
}
