// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:trivia_night/models/users.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class EditProfileScreen extends StatefulWidget {
//   final User user;

//   EditProfileScreen({required this.user});

//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late User _user;
//   final picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _user = widget.user;
//   }

//   Future getImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       // Create a reference to the location you want to upload to in Firebase Storage
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('avatar')
//           .child('${_user.id}.png');

//       // Upload the file to Firebase Storage
//       final uploadTask = ref.putFile(File(pickedFile.path));

//       // Get the download URL of the uploaded file
//       final downloadURL = await (await uploadTask.whenComplete(() => null))
//           .ref
//           .getDownloadURL();

//       // Update the avatar URL in the user's document in Firestore
//       FirebaseFirestore.instance.collection('users').doc(_user.id).update({
//         'avatar': downloadURL,
//       });

//       // Update the local user model
//       _user.avatar = downloadURL;
//     } else {
//       print('No image selected.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             if (widget.user.avatar != null && widget.user.avatar.isNotEmpty)
//               Image(
//                 image: widget.user.avatar.startsWith('http')
//                     ? NetworkImage(widget.user.avatar)
//                     : AssetImage(widget.user.avatar),
//               )
//             else
//               Text('No avatar selected.'),
//             FloatingActionButton(
//               onPressed: getImage,
//               tooltip: 'Pick Image',
//               child: Icon(Icons.add_a_photo),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
