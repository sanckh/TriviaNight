import 'package:flutter/material.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/views/edit_profile_screen.dart';

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

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50), top: Radius.circular(50)),
      ),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: _user.avatar.startsWith('http')
                  ? NetworkImage(_user.avatar) as ImageProvider<Object>
                  : AssetImage(_user.avatar),
              radius: 60,
            ),
            SizedBox(height: 15),
            Text(
              _user.username,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ), // Updated to use theme text style
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(value),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard('Games Played', '${_user.gamesPlayed}', Icons.games),
          Divider(),
          _buildStatCard('Average Score', '${_user.averageScore}%',
              Icons.check_circle_outline),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50)),
              ),
              child: _buildProfileHeader(context),
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context)
                  .scaffoldBackgroundColor, // Adapt to theme changes.
              child: Column(
                children: [
                  _buildProfileStats(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: _user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
