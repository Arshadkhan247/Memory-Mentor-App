// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  _UserSignUpScreenState createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _userType;
  bool _isLoading = false;

  Future<void> _register() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validate the input fields
      _validateFields();

      // Create a new user in Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Now you can store additional user data or perform other actions

      setState(() {
        _isLoading = false;
      });

      // Navigate to the next screen or perform other actions
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'weak-password') {
        _showErrorDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog('The account already exists for that email.');
      } else {
        _showErrorDialog('Error: ${e.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('Error: $e');
    }
  }

  void _validateFields() {
    // Add your validation logic here
    // Example: Check if the email is empty or if the passwords match
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      throw Exception('Please fill in all the fields.');
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      throw Exception('Passwords do not match.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text('Error!'),
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
        title: const Text('Sign Up'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'caregiver',
                        groupValue: _userType,
                        onChanged: (value) {
                          setState(() {
                            _userType = value.toString();
                          });
                        },
                      ),
                      const Text('Caregiver'),
                      Radio(
                        value: 'patient',
                        groupValue: _userType,
                        onChanged: (value) {
                          setState(() {
                            _userType = value.toString();
                          });
                        },
                      ),
                      const Text('Patient'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
    );
  }
}
