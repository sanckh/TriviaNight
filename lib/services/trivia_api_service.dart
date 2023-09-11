import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

Future<List<Map<String, dynamic>>> fetchTriviaQuestions(int amount, int category) async {
  final String url = 'https://opentdb.com/api.php?amount=$amount&category=$category&type=multiple';
  final http.Response response = await http.get(Uri.parse(url));
  var unescape = HtmlUnescape();

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(data['results']);
    print(results);
    //decode html entities
    for (var question in results) {
      question['question'] = unescape.convert(question['question']);
    }
    for(var answer in results){
      answer['correct_answer'] = unescape.convert(answer['correct_answer']);
    }
    for(var incorrect in results){
      incorrect['incorrect_answers'] = unescape.convert(incorrect['incorrect_answers']);
    }

    return results;

  } else {
    throw Exception('Failed to load trivia questions');
  }
}

Future<List<Map<String, dynamic>>> fetchCategories() async {
  const String url = 'https://opentdb.com/api_category.php';
  final http.Response response = await http.get(Uri.parse(url));

  if(response.statusCode == 200) {
    final Map<String, dynamic> apiResponse = json.decode(response.body);

    //Extract the categories
    final List<dynamic> categories = apiResponse['trivia_categories'];


    return List<Map<String, dynamic>>.from(categories);
  } else{
    throw Exception('Failed to load categories');
  }
}
