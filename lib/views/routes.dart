import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'game_screen.dart';
import 'scoreboard_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/login': (BuildContext context) => LoginScreen(),
  '/home': (BuildContext context) => HomeScreen(),
  '/game': (BuildContext context) => GameScreen(),
  '/scoreboard': (BuildContext context) => ScoreboardScreen(),
};
