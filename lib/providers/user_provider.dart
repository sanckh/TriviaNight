import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';

class UserProvider with ChangeNotifier {
  late User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    _user.username = newUsername;
    notifyListeners();
  }
}
