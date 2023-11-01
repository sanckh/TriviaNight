import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';

//Screens/Widgets
import 'package:trivia_night/widgets/update_password.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade400,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    textStyle: TextStyle(
      fontSize: 18,
    ),
  ),
  child: Text('Update Password'),
),

            ],
          ),
        ),
      ),
    );
  }
}
