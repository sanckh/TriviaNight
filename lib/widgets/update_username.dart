import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UpdateUsernameScreen extends StatefulWidget {
  @override
  _UpdateUsernameScreenState createState() => _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends State<UpdateUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  String _newUsername = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Username'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new username';
                  }
                  return null;
                },
                onSaved: (value) => _newUsername = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await updateUsername(_newUsername);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Username updated successfully')),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update username: $error')),
                      );
                    }
                  }
                },
                child: Text('Update Username'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newUsername);
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      throw Exception('Failed to update username: $error');
    }
  }
}
