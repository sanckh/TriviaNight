import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Update Password')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                    onChanged: (value) => _currentPassword = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    onChanged: (value) => _newPassword = value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a new password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    onChanged: (value) => _confirmPassword = value,
                    validator: (value) {
                      if (value != _newPassword) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      bool isUpdated = await _updatePassword();
                      if (isUpdated) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Update Password'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<bool> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the current user
        final user = auth.FirebaseAuth.instance.currentUser;

        // Re-authenticate the user
        final credential = auth.EmailAuthProvider.credential(
          email: user!.email!,
          password: _currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(_newPassword);

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );

        return true; // Return true on successful update
      } catch (error) {
        // Handle errors: wrong current password, weak new password, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $error')),
        );

        return false; // Return false on error
      }
    }
    return false; // Return false if form validation fails
  }
}
