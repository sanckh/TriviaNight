import 'package:flutter/material.dart';
import 'package:trivia_night/views/home_screen.dart';
import 'package:trivia_night/views/profile_screen.dart';
import 'package:trivia_night/views/settings_screen.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;

    return FutureBuilder<User?>(
      future: firebaseUser != null
          ? _userService.getUserProfile(firebaseUser.uid)
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          User user = snapshot.data!;
          final List<Widget> _screens = [
            HomeScreen(),
            ProfileScreen(user: user),
            SettingsScreen(),
          ];
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator(); // Show a loading indicator while fetching user data
      },
    );
  }
}
