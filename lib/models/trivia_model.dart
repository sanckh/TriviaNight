import 'package:flutter/foundation.dart';
import 'package:html_unescape/html_unescape.dart';

class TriviaModel with ChangeNotifier {
  String _question;
  String _answer;

  String get question => _question;
  String get answer => _answer;
  
  int _score = 0;
  int get score => _score;
  //constructor
  TriviaModel(this._answer, this._question);

  void setQuestion(String question) {
    _question = question;
    notifyListeners();
  }

  void setAnswer(String answer) {
    _answer = answer;
    notifyListeners();
  }

  void incrementScore() {
    _score += 1;
    notifyListeners();
  }
}
