import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  CategoryCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/game');
        },
        child: Center(
          child: Text(
            title,
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