import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivia_night/models/trivia_model.dart';
import 'package:trivia_night/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String question = "What is the capital of Thailand?";
  bool isLoading = false;
  int _currentIndex = 0;
  Map<String, String> currentTrivia = {};
  // For animations
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TriviaModel>(
          builder: (context, trivia, child) {
            return Text('Score: ${trivia.score}');
          },
        ),
      ), // <--- Closing parenthesis should be here.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: isLoading
                  ? LoadingIndicator()
                  : Text(
                      question,
                      key: _key,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
            ),
            ElevatedButton(
              onPressed:
                  _fetchNewQuestion, // Make sure you have this function defined or replace it with your logic
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }


  void _fetchNewQuestion() {
    final random = Random();
    _currentIndex = random.nextInt(triviaData.length); // Get a random index
    currentTrivia = triviaData[_currentIndex]; // Fetch the trivia at the random index
    setState(() {
      question = currentTrivia['question']!;
    });
  }

  void checkAnswer(String userAnswer) {
    final correctAnswer = currentTrivia['answer'];
    final isCorrect = (userAnswer == correctAnswer);

    if (isCorrect) {
      // Increment score, show snackbar, etc.
    }
  }

  // This is a simple placeholder. The actual questions and answers will be fetched from Firestore later on.
final List<Map<String, String>> triviaData = [
  {
    'question': 'What is the capital of Thailand?',
    'answer': 'Bangkok'
  },
  {
    'question': 'What is the smallest planet in our solar system?',
    'answer': 'Mercury'
  },
  // Add more question-answer pairs here
];

}
