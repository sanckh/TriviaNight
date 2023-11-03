import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trivia_night/widgets/main_navigation_screen.dart';
import 'package:trivia_night/widgets/theme_provider.dart';
import 'firebase_options.dart';

//Screens
import 'package:trivia_night/views/home_screen.dart';
import 'package:trivia_night/views/login_screen.dart';
import 'package:trivia_night/views/profile_screen.dart';
import 'package:trivia_night/views/settings_screen.dart';

//Models
import 'package:trivia_night/models/users.dart';

//Services
import 'package:trivia_night/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..loadThemePreference(),
      child: MainApp(),
    )
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300)),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade300,
          brightness: Brightness.dark,
          ),
      ),
      themeMode: themeProvider.themeMode, //This will use the system theme
      home: StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            auth.User? firebaseUser = snapshot.data;
            if (firebaseUser == null) {
              return LoginScreen();
            } else {
              return MainNavigationScreen();
            }
          }
          return CircularProgressIndicator(); // Checking auth state
        },
      ),
    );
  }
}
