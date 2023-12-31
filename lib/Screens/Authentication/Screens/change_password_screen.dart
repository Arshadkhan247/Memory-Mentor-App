// File will be change used when the user want to change their Old password from inside the app ,

// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validate input fields
      _validateFields();

      // Reauthenticate the user with their current password
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the user's password
      await user.updatePassword(_newPasswordController.text);

      // Show a success message or navigate to a success screen
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while changing your password.';

      switch (e.code) {
        case 'requires-recent-login':
          errorMessage =
              'For security reasons, you need to sign in again before changing your password.';
          break;
        case 'wrong-password':
          errorMessage = 'The current password is incorrect.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  void _validateFields() {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      throw Exception('Please fill in all the required fields.');
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      throw Exception('New passwords do not match.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Changed'),
          content: const Text('Your password has been successfully changed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
