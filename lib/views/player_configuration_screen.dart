import 'package:flutter/material.dart';
import 'package:trivia_night/utils/game_configuration.dart';
import 'package:trivia_night/views/home_screen.dart';

class PlayerConfigurationScreen extends StatefulWidget {
  @override
  _PlayerConfigurationScreenState createState() => _PlayerConfigurationScreenState();
}

class _PlayerConfigurationScreenState extends State<PlayerConfigurationScreen> {
  int numPlayers = 2;
  int winningPoints = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player Configuration")),
      body: Column(
        children: [
          ListTile(
            title: Text("Number of Players"),
            trailing: DropdownButton<int>(
              value: numPlayers,
              items: [1, 2, 3, 4, 5]
                  .map((int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  numPlayers = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Winning Points"),
            trailing: DropdownButton<int>(
              value: winningPoints,
              items: [5, 10, 15, 20, 25]
                  .map((int value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  winningPoints = newValue!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to game screen and pass the player and point configurations
              GameConfiguration gameConfig = GameConfiguration(numPlayers, winningPoints);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (contex) => HomeScreen(
                    gameConfiguration: gameConfig,
                  )
                )
              );
            },
            child: Text("Start Game"),
          )
        ],
      ),
    );
  }
}
