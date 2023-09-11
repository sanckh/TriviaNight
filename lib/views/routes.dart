import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'scoreboard_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/login': (BuildContext context) => LoginScreen(),
  '/scoreboard': (BuildContext context) => ScoreboardScreen(),
};
