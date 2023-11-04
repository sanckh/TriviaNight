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
    return 
    MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo.shade400, // A more vibrant color for the trivia theme
      brightness: Brightness.light,
      primary: Colors.indigo.shade600,
      secondary: Colors.amber.shade600, // Adding a complementary color for highlights
      error: Colors.red.shade400,
    ),
    fontFamily: 'Roboto', // Choose a readable font for body text
    textTheme: TextTheme(
      headlineMedium: TextStyle(fontFamily: 'FredokaOne', color: Colors.indigo.shade600), // Playful font for headlines
      bodyMedium: TextStyle(fontSize: 14.0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo.shade600,
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.amber.shade600, // Buttons should stand out
      textTheme: ButtonTextTheme.primary,
    ),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo.shade400,
      brightness: Brightness.dark,
      primary: Colors.indigo.shade700,
      secondary: Colors.amber.shade700,
      error: Colors.red.shade600,
    ),
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      headlineMedium: TextStyle(fontFamily: 'FredokaOne', color: Colors.indigo.shade300),
      bodyMedium: TextStyle(fontSize: 14.0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo.shade700,
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.amber.shade700,
      textTheme: ButtonTextTheme.primary,
    ),
  ),
      themeMode: themeProvider.themeMode,
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
