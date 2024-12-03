import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  static const String categoryUrl = 'https://opentdb.com/api_category.php';
  static const String questionUrl = 'https://opentdb.com/api.php';

  Future<List<Map<String, String>>> fetchCategories() async {
  final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    
    final categories = (data['trivia_categories'] as List)
        .map((category) {
          
          return {
            'id': category['id'].toString(), 
            'name': category['name'].toString(), 
          };
        }).toList();

    return categories;
  } else {
    throw Exception('Failed to load categories');
  }
}

  Future<List<Question>> fetchQuestions({
    required int amount,
    String? category,
    String? difficulty,
    String? type,
  }) async {
    final url = Uri.parse(
      '$questionUrl?amount=$amount'
      '${category != null ? '&category=$category' : ''}'
      '${difficulty != null ? '&difficulty=$difficulty' : ''}'
      '${type != null ? '&type=$type' : ''}',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'] as List;
      return data.map((q) => Question.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
