import 'package:flutter/material.dart';
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
  bool isGameStarted = false;
  final TextEditingController _controller = TextEditingController();
  bool isMultipleChoice = false;
  List<String> multipleChoiceOptions = [];
  // For animations
  Key _key = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'),
      ),
      body: Column(
        children: [
          // Display player scores
          Text("Scores: ${gameState.playerScores.join(' - ')}"),

          // Display whose turn it is
          Text("Player ${gameState.currentPlayer + 1}'s Turn"),
          Center(
            child: isGameStarted ? buildGameUI() : buildStartUI(),
          ),
        ],
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
    List<String>? incorrectAnswers =
        currentTrivia['incorrect_answers'] as List<String>?;
    String? correctAnswer = currentTrivia['correct_answer'];

    List<String> choices = [];

    if (incorrectAnswers != null) {
      choices.addAll(incorrectAnswers);
    }
    if (correctAnswer != null) {
      choices.add(correctAnswer);
    }

    choices.shuffle();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: isLoading
                ? LoadingIndicator()
                : Text(
                    currentTrivia['question'] ??
                        'Press Next Question to start!',
                    key: _key,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
          ),
          ...choices.map((choice) => RadioListTile(
              title: Text(choice),
              value: choice,
              groupValue: _controller.text,
              onChanged: (String? value) {
                setState(() {
                  _controller.text = value!;
                });
              })),
          ElevatedButton(
            onPressed: () {
              checkAnswer(_controller.text);
              _controller.clear();
            },
            child: Text('Check Answer'),
          ),
          ElevatedButton(
              onPressed: _fetchNewQuestion, child: Text('Next Question')),
        ],
      ),
    );
  }

  void _fetchNewQuestion() async {
    try {
      List<Map<String, dynamic>> triviaQuestions =
          await fetchTriviaQuestions(1, widget.category);
      Map<String, dynamic> firstQuestion = triviaQuestions.first;

      setState(() {
        question = firstQuestion['question'];
        currentTrivia['question'] = firstQuestion['question'];
        currentTrivia['answer'] = firstQuestion['correct_answer'];
        multipleChoiceOptions = List<String>.from(firstQuestion['incorrect_answers']);
        multipleChoiceOptions.add(firstQuestion['correct_answer']);
        multipleChoiceOptions.shuffle();
      });
    } catch (e) {
      print("Error fetching trivia questions: $e");
    }
  }

  void checkAnswer(String userAnswer) {
    final correctAnswer = currentTrivia['answer'];
    final gameState = Provider.of<GameState>(context, listen: false);
    String message;

    if (userAnswer == "" || userAnswer.trim().isEmpty) {
      message = "You didn't enter an answer!";
    } else {
      bool isCorrect = false;

      //check for basic string match
      if (correctAnswer!.toLowerCase() == userAnswer.toLowerCase().trim()) {
        isCorrect = true;
      }

      //check substring match
      if (correctAnswer
              .toLowerCase()
              .contains(userAnswer.toLowerCase().trim()) ||
          userAnswer
              .toLowerCase()
              .trim()
              .contains(correctAnswer.toLowerCase())) {
        isCorrect = true;
      }

      //check date match
      if (DateTime.tryParse(correctAnswer) != null &&
          DateTime.tryParse(userAnswer) != null) {
        DateTime correctDate = DateTime.parse(correctAnswer);
        DateTime userDate = DateTime.parse(userAnswer);

        if (correctDate == userDate) {
          isCorrect = true;
        }
      }

      if (isCorrect == true) {
        gameState.updateScore();
        message = 'Correct!';
      } else {
        message = 'Wrong answer. The correct answer is $correctAnswer.';
      }
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2),
          ),
        )
        .closed
        .then((reason) {
      _fetchNewQuestion();
      Provider.of<GameState>(context, listen: false).nextPlayer();
    });
  }
}

class GameState extends ChangeNotifier {
  int currentPlayer = 0;
  List<int> playerScores = [];

  //constructor
  GameState(int numPlayers) {
    playerScores = List.filled(numPlayers, 0);
  }

  void updateScore() {
    playerScores[currentPlayer]++;
    notifyListeners();
  }

  void nextPlayer() {
    currentPlayer = (currentPlayer + 1) % playerScores.length;
    notifyListeners();
  }
}
