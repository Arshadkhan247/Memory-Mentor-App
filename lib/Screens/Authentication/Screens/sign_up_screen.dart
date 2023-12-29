// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _userType;
  bool _isLoading = false;

  // code for Register a user and their data validation..
  Future<void> _register() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validate the input fields
      _validateFields();

      // Create a new user in Firebase Authentication......
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        // Clear text fields
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // After User Registration Icons variables will become false. Will show in Grey color.
        isPasswordVisible = false;
        _isNameFilled = false;
        _isValidEmailAddress = false;
        _isPasswordMatch = false;

        _isLoading = false;
      });

      showSuccessSnackbar(); // this function will call when a user succesfully register in firebase.

      // Navigate to the next screen or perform other actions
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'weak-password') {
        _showErrorDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog('Account already exists for this email.');
      } else {
        _showErrorDialog('${e.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog(
        '$e',
      );
    }
  }

// this function is used to display success Message to user.
  void showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

// this will ensure that all the field are filled.
  void _validateFields() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      throw Exception('Please fill in all the required fields.');
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
          elevation: 20,
          title: const Text('Error Found!'),
          content: Text(
            message,
            style: const TextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF345FB4)),
              ),
            ),
          ],
        );
      },
    );
  }

  // this function is used to validate Your Email on the bases of Given Pattran.
  bool _isValidEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // Variables
  late bool isPasswordVisible = false;
  bool _isNameFilled = false;
  bool isEmailFilled = false;
  bool _isValidEmailAddress = false;
  bool _isPasswordMatch = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Used to unfocus keyboard by tap outside the TextField.
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6789CA),
                    Color(0xff281537),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 600, minWidth: 300),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, top: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Input field for Name ...
                        TextFormFieldWidget(
                            controller: _nameController,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              setState(() {
                                _isNameFilled = value.isNotEmpty;
                              });
                            },
                            suffixIcon: Icon(
                              Icons.check,
                              color: _isNameFilled ? Colors.green : Colors.grey,
                            ),
                            fieldName: 'Name'),

                        TextFormFieldWidget(
                            controller: _emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                isEmailFilled = value.isNotEmpty;
                                _isValidEmailAddress =
                                    _isValidEmail(_emailController.text);
                              });
                            },
                            suffixIcon: Icon(Icons.check,
                                color: _isValidEmailAddress
                                    ? Colors.green
                                    : Colors.grey),
                            fieldName: 'Email'),

                        TextFormFieldWidget(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                size: 25,
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: isPasswordVisible
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            fieldName: 'Password',
                            obscureText: !isPasswordVisible),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !isPasswordVisible,
                          cursorColor: const Color(0xFF6789CA),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                                size: 25,
                                Icons.check,
                                color: _isPasswordMatch
                                    ? Colors.green
                                    : Colors
                                        .grey // You can customize the color for empty input
                                ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF6789CA),
                                width: 2,
                              ),
                            ),
                            label: const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF345FB4),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Compare password and confirm password
                              if (_confirmPasswordController.text ==
                                  _passwordController.text) {
                                _isPasswordMatch =
                                    true; // Set to true if passwords match
                              } else {
                                _isPasswordMatch =
                                    false; // Set to false if passwords don't match
                              }
                            });
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // this Row is used for Radio Button Selection of Patient and caregiver.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 'caregiver',
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value.toString();
                                });
                              },
                              activeColor: const Color(0xFF6789CA),
                            ),
                            const Text(
                              'Caregiver',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF345FB4),
                              ),
                            ),
                            Radio(
                              value: 'patient',
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value.toString();
                                });
                              },
                              activeColor: const Color(0xFF6789CA),
                            ),
                            const Text(
                              'Patient',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF345FB4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: _register,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF6789CA),
                                Color(0xff281537),
                              ]),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.lineScale,
                                        colors: [Colors.white],
                                        strokeWidth: 0.5,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
