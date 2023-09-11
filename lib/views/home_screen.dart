import 'package:flutter/material.dart';
import 'package:trivia_night/widgets/category_card.dart';
import 'package:trivia_night/services/trivia_api_service.dart';
import 'package:trivia_night/utils/game_configuration.dart';

class HomeScreen extends StatefulWidget {
  final GameConfiguration gameConfiguration;

  HomeScreen({required this.gameConfiguration});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GameConfiguration gameConfiguration;

  @override
  void initState() {
    super.initState();
    gameConfiguration = widget.gameConfiguration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return CategoryCard(
                  title: category['name'],
                   id: category['id'],
                   gameConfiguration: gameConfiguration,
                   );
              },
            );
          }
        },
      ),
    );
  }
}
