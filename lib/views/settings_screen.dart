import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/views/login_screen.dart';
import 'package:trivia_night/widgets/theme_provider.dart';
import 'package:trivia_night/widgets/update_password.dart';
import 'package:trivia_night/widgets/update_username.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User _user;

  void _updateUserUsername(String newUsername) {
    setState(() {
      _user.username = newUsername;
    });
  }

  void _signOut() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('Account', style: Theme.of(context).textTheme.headline6),
          ),
          _buildSettingsSection(
            title: 'Update Username',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateUsernameScreen(
                    onUpdateUsername: _updateUserUsername,
                  ),
                ),
              );
            },
          ),
          _buildSettingsSection(
            title: 'Update Password',
            icon: Icons.lock,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePasswordScreen(),
                ),
              );
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Preferences',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SwitchListTile(
            title: Text('Dark Theme'),
            secondary: Icon(Icons.dark_mode),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          // ... Add more settings sections here
        ],
      ),
    );
  }
}
