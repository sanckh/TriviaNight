import 'package:flutter/material.dart';
import 'package:trivia_night/utils/game_configuration.dart';
import 'package:trivia_night/views/game_screen.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final int id;
  final GameConfiguration gameConfiguration;

  //Constructor
  CategoryCard({
    required this.title,
     required this.id,
     required this.gameConfiguration
     });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                category: id,
                gameConfiguration: gameConfiguration,
              )
            )
          );
        },
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}