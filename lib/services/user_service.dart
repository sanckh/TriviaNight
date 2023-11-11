import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> updateUserGameData(String userId,
      int correctAnswersFromCurrentGame, int totalQuestions) async {
    DocumentReference userRef = _usersRef.doc(userId);

    //Fetch current user data
    DocumentSnapshot userDoc = await userRef.get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    //Update user data
    int gamesPlayed = userData['games_played'] + 1;
    int totalCorrectAnswers =
        userData['correct_answers'] + correctAnswersFromCurrentGame;
    double averageScore =
        (totalCorrectAnswers / (gamesPlayed * totalQuestions)) * 100;

    //Save updated user data
    await userRef.update({
      'games_played': gamesPlayed,
      'correct_answers': totalCorrectAnswers,
      'average_score': averageScore,
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if(_file != null){
      return await _file.readAsBytes();
    }

    print('No image selected');
  }
}
