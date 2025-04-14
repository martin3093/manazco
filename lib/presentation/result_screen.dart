import 'package:flutter/material.dart';
import 'package:manazco/constants_new.dart';
import 'start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.finalScore,
    required this.totalQuestions,
  });
  // final int score;

  // const ResultScreen(String finalScore, {super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.titleApp)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$AppConstants.finalScore $finalScore',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                );
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
