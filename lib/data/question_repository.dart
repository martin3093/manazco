import '../domain/question.dart';

class QuestionRepository {
  final List<Question> _questions = [
    Question(
      questionText: '¿Cuál es la capital de Francia?',
      answerOptions: ['Madrid', 'París', 'Roma'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuál es el planeta más cercano al Sol?',
      answerOptions: ['Venus', 'Mercurio', 'Marte'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: '¿Cuántos continentes hay en el mundo?',
      answerOptions: ['5', '6', '7'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText:
          '¿Qué planeta es conocido como el planeta rojo?', // Nueva pregunta añadida
      answerOptions: ['Júpiter', 'Marte', 'Venus'],
      correctAnswerIndex: 1,
    ),
  ];

  List<Question> getQuestions() {
    return _questions;
  }
}
