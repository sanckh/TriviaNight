import 'package:flutter/foundation.dart';

class TriviaModel with ChangeNotifier {
  String _question;
  String _answer;

  String get question => _question;
  String get answer => _answer;
  
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
}
