import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trivia_night/models/trivia_model.dart';
import 'package:trivia_night/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? question;
  Map<String, String> currentTrivia = {};
  bool isLoading = false;
  bool isGameStarted = false;  // New variable to track game state
  final TextEditingController _controller = TextEditingController();
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
      ),
      body: Center(
        child: isGameStarted ? buildGameUI() : buildStartUI(),
      ),
    );
  }

  Widget buildStartUI() {
    return ElevatedButton(
      onPressed: () {
         _fetchNewQuestion();
        setState(() {
          isGameStarted = true;
        });
      },
      child: Text('Start'),
    );
  }

  Widget buildGameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: isLoading
              ? LoadingIndicator()
              : Text(
                  currentTrivia['question'] ?? 'Press Next Question to start!',
                  key: _key,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
        ),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter your answer',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            checkAnswer(_controller.text);
            _controller.clear();
          },
          child: Text('Submit Answer'),
        ),
        ElevatedButton(
          onPressed: _fetchNewQuestion,
          child: Text('Next Question'),
        ),
      ],
    );
  }


  void _fetchNewQuestion() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await _db.collection('trivia_questions').get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    final random = Random();
    final randomIndex = random.nextInt(documents.length); // Get a random index
    final doc = documents[randomIndex];

    setState(() {
      question = doc['question'];
      currentTrivia['question'] = doc['question'];
      currentTrivia['answer'] = doc['answer'];
    });
  }

  void checkAnswer(String userAnswer) {
    // Assuming 'currentTrivia' is populated with the current question and answer
    final correctAnswer = currentTrivia['answer']; //get this from Firestore document

    String message;

    if (userAnswer == "" || userAnswer.trim().isEmpty) {
      message = "You didn't enter an answer!";
    } else {
      final isCorrect = (userAnswer.toLowerCase() == correctAnswer!.toLowerCase());

      if (isCorrect) {
        Provider.of<TriviaModel>(context, listen: false).incrementScore();
        message = 'Correct!';
      } else {
        message = 'Wrong answer. The correct answer is $correctAnswer.';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
