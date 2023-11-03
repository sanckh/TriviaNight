import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trivia_night/models/categories.dart';
import 'package:trivia_night/models/question.dart';
import 'package:trivia_night/services/trivia_api_service.dart';
import 'package:trivia_night/views/error.dart';
import 'package:trivia_night/views/quiz_page.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category? category;

  const QuizOptionsDialog({Key? key, this.category}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;
  String? _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    //Determine whether we are light or dark mode:
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    Color activeColor = isDarkMode
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    Color inactiveColor = isDarkMode
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
        : Theme.of(context).colorScheme.onSurface;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              widget.category!.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 10.0),
          Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: _buildChipSelection<int>(
              value: _noOfQuestions!,
              values: [10, 20, 30, 40, 50],
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onSelected: _selectNumberOfQuestions,
            ),
          ),
          SizedBox(height: 20.0),
          Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: _buildChipSelection<String?>(
              value: _difficulty,
              values: [null, "easy", "medium", "hard"],
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onSelected: _selectDifficulty,
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _startQuiz,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(activeColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    "Start Quiz",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildChipSelection<T>({
    required T value,
    required List<T> values,
    required Color activeColor,
    required Color inactiveColor,
    required void Function(T) onSelected,
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 16.0,
      spacing: 16.0,
      children: values
          .map((e) => ActionChip(
                label: Text(e.toString()),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: e == value ? activeColor : inactiveColor,
                onPressed: () => onSelected(e),
              ))
          .toList(),
    );
  }

  void _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  void _selectDifficulty(String? s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions =
          await getQuestions(widget.category!, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuizPage(
                    questions: questions,
                    category: widget.category,
                  )));
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}
