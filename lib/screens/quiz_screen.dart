import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/question.dart';
import 'package:http/http.dart' as http;
import 'quiz_summary_screen.dart';


class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final String category;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.numberOfQuestions,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}


class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  String feedbackMessage = '';
  bool showFeedback = false;
  List<String> options = [];
  

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=${widget.numberOfQuestions}&category=${widget.category}&difficulty=${widget.difficulty}&type=${widget.type}';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        
        print('API Response: $data');

        setState(() {
          questions = (data['results'] as List)
              .map((questionData) => Question.fromJson(questionData))
              .toList();

          
          print('Questions loaded: ${questions.length}');

          options = questions.isNotEmpty
              ? questions[currentQuestionIndex].allOptions
              : [];
        });

        if (questions.isEmpty) {
          print('No questions found for the given settings.');
        }
      } else {
        print('Failed to fetch questions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }


  void markAnswer(String selectedOption) {
    final currentQuestion = questions[currentQuestionIndex];
    final isCorrect = selectedOption == currentQuestion.correctAnswer;

    setState(() {
      
      feedbackMessage =
          isCorrect ? 'Correct!' : 'Incorrect! The correct answer is: ${currentQuestion.correctAnswer}';
      showFeedback = true;

      
      if (isCorrect) {
        score++;
      }
    });

    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showFeedback = false; 
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++; 
          options = questions[currentQuestionIndex].allOptions; 
        } else {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizSummaryScreen(
                totalQuestions: questions.length,
                correctAnswers: score,
              ),
            ),
          );
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),

            
            ...options.map((option) => ElevatedButton(
                  onPressed: showFeedback ? null : () => markAnswer(option),
                  child: Text(option),
                )),

            
            if (showFeedback)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  feedbackMessage,
                  style: TextStyle(
                    color: feedbackMessage.startsWith('Correct') ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

