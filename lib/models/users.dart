import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String username;
  final String email;
  String avatar;
  int gamesPlayed;
  int correctAnswers;
  List<String> categoriesPlayed;
  double averageScore;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.avatar = 'assets/triviaplaceholdericon.png',
      this.gamesPlayed = 0,
      this.correctAnswers = 0,
      this.categoriesPlayed = const [],
      this.averageScore = 0});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'avatar': avatar,
      'games_played': gamesPlayed,
      'correct_answers': correctAnswers,
      'categories_played': categoriesPlayed,
      'average_score': averageScore,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      username: data['username'],
      email: data['email'],
      avatar: data['avatar'] ??
          'assets/triviaplaceholdericon.png', //make sure to create this
      gamesPlayed: data['games_played'] ?? 0,
      correctAnswers: data['correct_answers'] ?? 0,
      categoriesPlayed: List<String>.from(data['categories_played'] ?? []),
      averageScore: data['average_score'] ?? 0,
    );
  }
}
