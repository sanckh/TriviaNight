import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/providers/user_provider.dart';
import 'package:trivia_night/views/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  Widget _buildProfileHeader(BuildContext context, User user) {
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
              backgroundImage: user.avatar.startsWith('http')
                  ? NetworkImage(user.avatar) as ImageProvider<Object>
                  : AssetImage(user.avatar),
              radius: 60,
            ),
            SizedBox(height: 15),
            Text(
              user.username,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildProfileStats(User user) {
    String convertTwoDecimalPlaces = user.averageScore.toStringAsFixed(2);

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatCard('Games Played', '${user.gamesPlayed}', Icons.games),
          Divider(),
          _buildStatCard('Average Score', '$convertTwoDecimalPlaces%',
              Icons.check_circle_outline),
        ],
      ),
    );
  }

  //signed in brought directly to settings, needs to go to home screen

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
              child: _buildProfileHeader(context, user),
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  _buildProfileStats(user),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
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
