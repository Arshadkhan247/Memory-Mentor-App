// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
import 'package:mentor/Screens/Authentication/Screens/sign_up_screen.dart';
import 'package:mentor/Screens/Authentication/Widgets/signin_button_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6789CA),
              // Color(0xffB81736),
              Color(0xff281537),
            ],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Image(
                height: 200,
                width: 200,
                color: Colors.white,
                image: AssetImage(
                  'assets/BrainLogo.jpg',
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            SignInUpButtonWidget(
              targetScreen: const LoginScreen(),
              btnname: 'SIGN IN',
              btntextcolor: Colors.white,
            ),
            const SizedBox(
              height: 30,
            ),
            SignInUpButtonWidget(
              btntextcolor: Colors.black,
              btnname: 'SIGN UP',
              targetScreen: const SignUpScreen(),
              btnBkgdColor: Colors.white,
            ),
            const Spacer(),
            const Text(
              'Login with Social Media',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ), //
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // here will perform google login.
                    },
                    child: const CircleAvatar(
                      child: Card(
                        elevation: 50,
                        child: Image(
                          height: 50,
                          width: 50,
                          image: AssetImage(
                            "assets/google.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      // this btn will enable to login using phone no.
                    },
                    child: const CircleAvatar(
                      child: Card(
                        elevation: 50,
                        child: Image(
                          image: AssetImage(
                            "assets/phoneCall.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
