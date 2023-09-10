import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Categories'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Science'),
            onTap: () => Navigator.pushNamed(context, '/game'),
          ),
          ListTile(
            title: const Text('History'),
            onTap: () => Navigator.pushNamed(context, '/game'),
          ),
        ],
      ),
    );
  }
}
