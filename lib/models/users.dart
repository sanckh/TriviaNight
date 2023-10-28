import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  String avatar;
  int gamesPlayed;
  int correctAnswers;
  List<String> categoriesPlayed;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar = "",
    this.gamesPlayed = 0,
    this.correctAnswers = 0,
    this.categoriesPlayed = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'avatar': avatar,
      'games_played': gamesPlayed,
      'correct_answers': correctAnswers,
      'categories_played': categoriesPlayed,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      username: data['username'],
      email: data['email'],
      avatar: data['avatar'] ?? 'defaultAvatarURL', //make sure to create this
      gamesPlayed: data['games_played'] ?? 0,
      correctAnswers: data['correct_answers'] ?? 0,
      categoriesPlayed: List<String>.from(data['categories_played'] ?? []),
    );
  }
}
