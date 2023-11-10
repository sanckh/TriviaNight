import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trivia_night/views/register_screen.dart';
import 'package:trivia_night/widgets/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '', _password = '';
  bool _isObscured = true; // Password visibility control
  bool _isLoading = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigationScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigationScreen(),
            ));
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              ClipOval(
                child: Image.asset('assets/triviaplaceholdericon.png',
                    width: 200, height: 200, fit: BoxFit.cover),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (input) => input!.isEmpty
                          ? 'Please enter your email address'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (input) => _email = input!,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (input) => input!.length < 6
                          ? 'Password should be at least 6 characters'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: _isObscured,
                      onSaved: (input) => _password = input!,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : login,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white))
                          : Text('Login',
                              style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen())),
                          child: Text('Register',
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
