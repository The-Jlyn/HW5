import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question $currentQuestion of $totalQuestions",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: currentQuestion / totalQuestions,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
      ],
    );
  }
}
