import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor/Screens/Authentication/Screens/forgot_password_screen.dart';
import 'package:mentor/Screens/Authentication/Screens/sign_up_screen.dart';
import 'package:mentor/Screens/Authentication/Widgets/text_form_field_widget.dart';
import 'package:mentor/Screens/DashBoard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String userRole = '';
  bool _isLoading = false;

//  Variable that are required inside, for UI Logic.
  late bool isPasswordVisible = false;
  bool isEmailFilled = false;
  bool _isValidEmailAddress = false;

  Future<void> login() async {
    try {
      setState(() {
        _isLoading = true; // when getting logic
      });

      _validateFields(); // Validate All the field before going to login.

      // Login current user present in Firebase .
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Check the user's role
      bool isRoleMatched = await checkUserRole();

      if (isRoleMatched) {
        // Navigate to the dashboard if the role matches
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashbaordScreen()),
        );
      } else {
        // Show an error message if the role does not match
        _showErrorDialog('No user found with the specified role.');
      }

      setState(() {
        _isLoading = false;
      });

      setState(() {
        // Clear text fields
        _emailController.clear();
        _passwordController.clear();
        // After User Registration Icons  variables will become false. Will show in Grey color.
        isPasswordVisible = false;
        _isValidEmailAddress = false;
        _isLoading = false;
      });

      showSuccessSnackbar(); // this function will call when a user succesfully login from firebase.

      print('User signed in successfully.');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'An error occurred while logging in.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
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

  // this function is used to validate Your Email on the bases of Given Pattran.
  bool _isValidEmail(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@gmail\.com$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // this will ensure that all the field are filled.
  void _validateFields() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        userRole.isEmpty) {
      throw Exception('Please fill in all the required fields.');
    }
  }

// this function is used to check the role of a user against their email.
  Future<bool> checkUserRole() async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    var snapshot = await ref.doc(user!.uid).get();

    if (snapshot.exists) {
      // Check if the role matches
      return snapshot['role'] == userRole;
    } else {
      return false;
    }
  }
  // this function is used to display success Message to user.

  void showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account login successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // used to show Error in dialogu box to user
  ///
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          title: const Text('Error Found!'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF6789CA),
                  Color(0xff281537),
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Hello\nSign in!',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 300, maxWidth: 600),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormFieldWidget(
                            controller: _emailController,
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
                            fieldName: 'Email',
                            obscureText: false),
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
                            fieldName: "Password",
                            obscureText: !isPasswordVisible),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                                value: 'caregiver',
                                groupValue: userRole,
                                onChanged: (value) {
                                  setState(() {
                                    userRole = value.toString();
                                  });
                                },
                                activeColor: const Color(0xFF6789CA)),
                            const Text(
                              'Caregiver',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF345FB4),
                              ),
                            ),
                            Radio(
                              value: 'patient',
                              groupValue: userRole,
                              onChanged: (value) {
                                setState(() {
                                  userRole = value.toString();
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
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Color(0xFF6789CA),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: login,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                // Color(0xffB81736),
                                // Color(0xff281537),
                                Color(0xFF6789CA),
                                Color(0xff281537),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
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
                              "Don't have account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(

                                    ///done login page
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFF6789CA)),
                              ),
                            ),
                          ],
                        )
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
