import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';

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
          //Testing github
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Your edit profile fields and widgets go here
            ],
          ),
        ),
      ),
    );
  }
}
