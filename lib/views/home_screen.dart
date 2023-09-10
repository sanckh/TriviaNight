import 'package:flutter/material.dart';
import 'package:trivia_night/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                CategoryCard('Science'),
                CategoryCard('History'),
                // Add more categories
              ],
            ),
          )
        ],
      ),
    );
  }
}
