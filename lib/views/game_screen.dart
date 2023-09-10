import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String question = "What is the capital of Thailand?";
  //For animations
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: Text(
                question,
                key: _key,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                )
              )
            ),
            ElevatedButton(
              onPressed: _changeQuestion,
              child: Text('Next Question'),
            )
          ]
        )
      ),
    );
  }

  void _changeQuestion() {
    setState(() {
      question = "What is 2 + 2?";
      _key = UniqueKey();
    });
  }
}
