import 'package:flutter/material.dart';

class QuizSummaryScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  QuizSummaryScreen({
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'You answered $correctAnswers out of $totalQuestions questions correctly.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
