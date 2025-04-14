// import 'package:flutter/material.dart';
// import '../api/service/question_service.dart';
// import '../domain/question.dart';
// import 'result_screen.dart';
// import '../constants_new.dart';

// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   GameScreenState createState() => GameScreenState();
// }

// class GameScreenState extends State<GameScreen> {
//   int currentQuestionIndex = 0;
//   int userScore = 0;
//   List<Question> questionsList = [];
//   String questionCounterText = '';
//   int? selectedAnswerIndex;
//   bool? isCorrectAnswer;
//   @override
//   void initState() {
//     super.initState();
//     loadQuestions();
//   }

//   void loadQuestions() async {
//     final questionService = QuestionService();
//     questionsList = await questionService.getQuestions();
//     setState(() {
//       questionCounterText =
//           'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
//     });
//   }

//   void handleAnswer(int selectedIndex) {
//     setState(() {
//       selectedAnswerIndex = selectedIndex;
//       isCorrectAnswer =
//           questionsList[currentQuestionIndex].correctAnswerIndex ==
//           selectedIndex;
//       print('Selected Answer Index: $selectedAnswerIndex');
//       print('Is Correct Answer: $isCorrectAnswer');
//     });

//     final String snackBarMessage =
//         isCorrectAnswer == true ? '¡Correcto!' : 'Incorrecto';
//     final Color snackBarColor =
//         isCorrectAnswer == true ? Colors.green : Colors.red;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(snackBarMessage),
//         backgroundColor: snackBarColor,
//         duration: const Duration(seconds: 1),
//       ),
//     );

//     Future.delayed(const Duration(seconds: 1), () {
//       if (!mounted) return;
//       if (isCorrectAnswer == true) {
//         userScore++;
//       }

//       if (currentQuestionIndex < questionsList.length - 1) {
//         setState(() {
//           currentQuestionIndex++;
//           selectedAnswerIndex = null;
//           isCorrectAnswer = null;
//           questionCounterText =
//               'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
//         });
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => ResultScreen(
//                   finalScore: userScore,
//                   totalQuestions: questionsList.length,
//                 ),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     const double spacingHeight = 16.0;
//     if (questionsList.isEmpty) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final currentQuestion = questionsList[currentQuestionIndex];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(AppConstants.titleApp),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               questionCounterText,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: spacingHeight),
//             Text(
//               currentQuestion.questionText,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Column(
//               children: List.generate(
//                 currentQuestion.answerOptions.length,
//                 (index) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: ElevatedButton(
//                     onPressed:
//                         selectedAnswerIndex == null
//                             ? () => handleAnswer(index)
//                             : null,
//                     style: ButtonStyle(
//                       backgroundColor: WidgetStateProperty.resolveWith<Color>((
//                         Set<WidgetState> states,
//                       ) {
//                         if (selectedAnswerIndex == index) {
//                           return isCorrectAnswer == true
//                               ? Colors.green
//                               : Colors.red;
//                         }
//                         return Colors.blue;
//                       }),
//                       padding: WidgetStateProperty.all(
//                         const EdgeInsets.symmetric(
//                           vertical: 16.0,
//                           horizontal: 24.0,
//                         ),
//                       ),
//                       shape: WidgetStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       currentQuestion.answerOptions[index],
//                       style: const TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../api/service/question_service.dart';
import '../domain/question.dart';
import 'result_screen.dart';
import '../constants_new.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  List<Question> questionsList = [];
  int currentQuestionIndex = 0;
  int userScore = 0;
  bool? isCorrectAnswer;
  String questionCounterText = '';
  final double spacingHeight = 16; // Espaciado entre elementos
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _questionService.getQuestions();
      setState(() {
        questionsList = questions;
        questionCounterText =
            'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las preguntas')),
      );
    }
  }

  void handleAnswer(int selectedIndex) {
    setState(() {
      isCorrectAnswer =
          selectedIndex ==
          questionsList[currentQuestionIndex].correctAnswerIndex;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (isCorrectAnswer == true) {
        userScore++;
      }

      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++;
          questionCounterText =
              'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
          isCorrectAnswer = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  finalScore: userScore,
                  totalQuestions: questionsList.length,
                ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questionsList.isEmpty) {
      return Scaffold(
        body: Center(
          child: const Text(
            'No hay preguntas disponibles',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final currentQuestion = questionsList[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.titleApp)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionCounterText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ), // Texto gris
            ),
            const SizedBox(height: 16),
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: spacingHeight,
            ), // Espaciado entre pregunta y opciones
            ...currentQuestion.answerOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isSelected =
                  isCorrectAnswer != null &&
                  index == currentQuestion.correctAnswerIndex;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected
                          ? Colors
                              .green // Botón verde si es correcto
                          : Colors.blue, // Botón azul por defecto
                ),
                onPressed:
                    isCorrectAnswer == null
                        ? () => handleAnswer(index)
                        : null, // Desactiva el botón después de seleccionar
                child: Text(answer),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
