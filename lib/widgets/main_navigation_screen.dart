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
  late ValueNotifier<int> _currentIndexNotifier;
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier(0); // Initialize with default index
    _loadIndex();
    _fetchUserData();
  }

  void _loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _currentIndexNotifier.value = prefs.getInt('currentIndex') ?? 0;
  }

  Future<void> _saveIndex(int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', newIndex);
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
    return ValueListenableBuilder(
      valueListenable: _currentIndexNotifier,
      builder: (context, int currentIndex, _) {
        final List<Widget> _screens = [
          HomeScreen(),
          ProfileScreen(user: _user!),
          SettingsScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) async {
              await _saveIndex(index); // Wait for the index to be saved
              _currentIndexNotifier.value = index; // Then update the ValueNotifier
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
      },
    );
  }


  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
