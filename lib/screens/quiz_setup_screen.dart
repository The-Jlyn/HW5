import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  final ApiService apiService = ApiService();

  String selectedCategory = '9'; 
  String selectedDifficulty = 'easy'; 
  String selectedType = 'multiple'; 

  int numberOfQuestions = 5;
  List<Map<String, String>> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await apiService.fetchCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<int>(
              value: numberOfQuestions,
              items: [5, 10, 15].map((e) {
                return DropdownMenuItem(value: e, child: Text("$e Questions"));
              }).toList(),
              onChanged: (value) => setState(() => numberOfQuestions = value!),
            ),
            if (categories.isNotEmpty)
              DropdownButton<String>(
                value: selectedCategory,
                hint: Text("Select Category"),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category['id'],
                    child: Text(category['name']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
            DropdownButton<String>(
              value: selectedDifficulty,
              hint: Text("Select Difficulty"),
              items: ['easy', 'medium', 'hard'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) => setState(() => selectedDifficulty = value!),
            ),
            DropdownButton<String>(
              value: selectedType,
              hint: Text("Select Type"),
              items: ['multiple', 'boolean'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type == 'boolean' ? 'True/False' : 'Multiple Choice'),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedType = value!),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      numberOfQuestions: numberOfQuestions,
                      category: selectedCategory,
                      difficulty: selectedDifficulty,
                      type: selectedType,
                    ),
                  ),
                );
              },
              child: Text("Start Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
