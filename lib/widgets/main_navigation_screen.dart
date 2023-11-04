import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_night/providers/user_provider.dart';
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
  ValueNotifier<int> _currentIndexNotifier = ValueNotifier(-1);
  final UserService _userService = UserService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIndex();
    _fetchUserData();
  }

  void _loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('currentIndex') ?? 0;
    _currentIndexNotifier.value = savedIndex;
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
        Provider.of<UserProvider>(context, listen: false).setUser(user!);
        _isLoading = false;
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
    final userProvider = Provider.of<UserProvider>(context);
    return ValueListenableBuilder(
      valueListenable: _currentIndexNotifier,
      builder: (context, int currentIndex, _) {
        if (currentIndex == -1) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final List<Widget> _screens = [
          HomeScreen(),
          userProvider.user != null
              ? ProfileScreen()
              : CircularProgressIndicator(),
          SettingsScreen(),
        ];

        if (currentIndex >= 0 && currentIndex < _screens.length) {
          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) async {
                await _saveIndex(index);
                _currentIndexNotifier.value =
                    index; // Then update the ValueNotifier
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
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
