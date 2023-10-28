import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_night/models/users.dart';

class UserService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserProfile(User user) async {
    return _usersRef.doc(user.id).update(user.toJson());
  }

  Future<User?> getUserProfile(String userId) async {
    DocumentSnapshot doc = await _usersRef.doc(userId).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
  return {
    'username': username,
    'email': email,
    'nickname': nickname,
    'avatar': avatar,
    'games_played': gamesPlayed,
    'correct_answers': correctAnswers,
    'categories_played': categoriesPlayed,
  };
}

}
