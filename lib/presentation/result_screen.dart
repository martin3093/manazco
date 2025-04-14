import 'package:flutter/material.dart';
import '../constants_new.dart';
import 'start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final String scoreText = 'Puntuación Final: $finalScore/$totalQuestions';
    final String feedbackMessage =
        finalScore > (totalQuestions / 2)
            ? '¡Buen trabajo!'
            : '¡Sigue practicando!';
    const double spacingHeight = 20.0; // Espaciado entre elementos
    final Color buttonColor =
        finalScore > (totalQuestions / 2) ? Colors.blue : Colors.green;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppConstants.titleApp),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scoreText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: spacingHeight,
              ), // Espaciado entre puntaje y mensaje
              Text(
                feedbackMessage,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Cambia el color del botón
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StartScreen(),
                    ),
                    (route) => false, // Elimina todas las pantallas anteriores
                  );
                },
                child: const Text(
                  AppConstants.playAgain,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
