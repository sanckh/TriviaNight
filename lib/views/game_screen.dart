import 'package:flutter/material.dart';
import 'package:trivia_night/models/trivia_model.dart';
import 'package:trivia_night/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:trivia_night/services/trivia_api_service.dart';
import 'package:trivia_night/utils/game_configuration.dart';

class GameScreen extends StatefulWidget {
  final int category;
  final GameConfiguration gameConfiguration;

  GameScreen({
    required this.category,
    required this.gameConfiguration,
    });

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
  void initState() {
    super.initState();
    print("Number of Players: ${widget.gameConfiguration.numPlayers}");
    print("Winning points: ${widget.gameConfiguration.winningPoints}");
  }

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
  try {
    List<Map<String, dynamic>> triviaQuestions = await fetchTriviaQuestions(1, widget.category);
    Map<String, dynamic> firstQuestion = triviaQuestions.first;

    setState(() {
      question = firstQuestion['question'];
      currentTrivia['question'] = firstQuestion['question'];
      currentTrivia['answer'] = firstQuestion['correct_answer'];
    });
  } catch (e) {
    print("Error fetching trivia questions: $e");
  }
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
