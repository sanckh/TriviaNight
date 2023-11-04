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

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: _user.avatar.startsWith('http')
                            ? NetworkImage(_user.avatar)
                                as ImageProvider<Object>
                            : AssetImage(_user.avatar),
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
          _buildStatCard('Average Score', '${_user.averageScore}%', Icons.check_circle_outline),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  var screenHeight = MediaQuery.of(context).size.height;
  var appBarHeight = AppBar().preferredSize.height;
  var statusBarHeight = MediaQuery.of(context).padding.top;

  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
      backgroundColor: Colors.blue.shade300,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      child: Container(
        color: Colors.blue.shade300,
        // Here, the height is set to be the screen height minus the appBar and statusBar height
        height: screenHeight - appBarHeight - statusBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Aligns children at the start of the column
          children: [
            _buildProfileHeader(),
            Expanded(
              // Wrapping in an Expanded widget to fill the available space.
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor, // This will adapt to theme changes.
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
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
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
