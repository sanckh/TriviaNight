import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trivia_night/models/users.dart';
import 'package:trivia_night/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  final UserService _userService = UserService();

  final _picker = ImagePicker();
  File? _image;

  Future getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        uploadImageToFirebase(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _user.id;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("avatar/$fileName");
    UploadTask uploadTask = ref.putFile(_image!);
    await uploadTask.then((res) async {
      await res.ref.getDownloadURL().then((value) async {
        await _userService.updateUserAvatar(_user.id, value);
        setState(() {
          _user.avatar = value;
        });
      });
    });
  }

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
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(_image!),
                      radius: 60,
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                          "assets/triviaplaceholdericon.png"),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: getImage,
                  icon: Icon(Icons.add_a_photo),
                ),
              )
            ]),
            SizedBox(height: 15),
            Text(
              _user.username,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => EditProfileScreen(user: _user),
                  //       ),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue.shade400,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  //     textStyle: TextStyle(fontSize: 18),
                  //   ),
                  //   child: Text('Edit Profile'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
