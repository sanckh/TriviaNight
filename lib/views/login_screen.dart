// import 'package:flutter/material.dart';
// import 'package:trivia_night/views/player_configuration_screen.dart';

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           FlutterLogo(size: 100),
//           SizedBox(height: 20),
//           TextField(
//               decoration: InputDecoration(
//             labelText: 'Username',
//           )),
//           SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: 'Password',
//             ),
//             obscureText: true,
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PlayerConfigurationScreen(),
//                 ),
//               );
//             },
//             child: Text('Login'),
//           ),
//         ]),
//       ),
//     );
//   }
// }
