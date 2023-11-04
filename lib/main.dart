import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trivia_night/providers/user_provider.dart';
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemePreference()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: MainApp(),
  ));
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo.shade400,
          brightness: Brightness.light,
          primary: Colors.indigo.shade400,
          onPrimary: Colors.black,
          secondary: Colors.indigo.shade100,
          error: Colors.red.shade400,
        ),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
              fontFamily: 'FredokaOne', color: Colors.indigo.shade600),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade400,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigo.shade400),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo.shade400,
          brightness: Brightness.dark,
          primary: Colors.indigo.shade700,
          secondary: Colors.indigo.shade200,
          error: Colors.red.shade600,
          onPrimary: Colors.white,
        ),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
              fontFamily: 'FredokaOne', color: Colors.indigo.shade300),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade700,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigo.shade700),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
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
