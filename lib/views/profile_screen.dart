import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text('Profile'),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue.shade300,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_user.avatar),
                        radius: 60,
                      ),
                      SizedBox(height: 15),
                      Text(
                        _user.username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.games),
                          title: Text('Games Played'),
                          trailing: Text('${_user.gamesPlayed}'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.check_circle_outline),
                          title: Text('Correct Answers'),
                          trailing: Text('${_user.correctAnswers}'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.category),
                          title: Text('Categories Played'),
                          trailing: Text('${_user.categoriesPlayed.length}'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
