import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIndex();
    _fetchUserData();
  }

  void _loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('currentIndex') ?? 0;
    });
  }

  void _saveIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', _currentIndex);
  }

 _fetchUserData() async {
  final firebaseUser = auth.FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    User? user = await _userService.getUserProfile(firebaseUser.uid);
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  } else {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    final List<Widget> _screens = [
      HomeScreen(),
      ProfileScreen(user: _user!),
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
}
