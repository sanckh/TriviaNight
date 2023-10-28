import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display user's avatar, username, email, etc.
              // Add an option to edit the avatar and other details.
              // Display game statistics.
            ],
          ),
        ),
      ),
    );
  }
}
