import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trivia_night/models/categories.dart';
import 'package:trivia_night/models/question.dart';

const String baseUrl = 'https://opentdb.com/api.php';

Future<List<Question>> getQuestions(Category category, int? total, String? difficulty) async {
  http.Response? res; // Declare it here
  String url = "$baseUrl?amount=$total&category=${category.id}";
  
  if(difficulty != null) {
    url = "$url&difficulty=$difficulty";
  }

  try {
    res = await http.get(Uri.parse(url)); // Assign the value here
  } catch (e, stackTrace) {
    print('Caught an error or exception: $e \n $stackTrace');
    return []; // Returning an empty list or you could throw an exception
  }

  if (res != null && res.statusCode == 200) {
    List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
    return Question.fromData(questions);
  } else {
    print('Failed to load questions. HTTP Status Code: ${res?.statusCode}');
    return []; // Returning an empty list or you could throw an exception
  }
}
