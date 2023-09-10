import 'package:flutter/material.dart';

class ScoreboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/scoreboard');
          },
          child: Text('Score Board'),
        ),
      ),
    );
  }
}
