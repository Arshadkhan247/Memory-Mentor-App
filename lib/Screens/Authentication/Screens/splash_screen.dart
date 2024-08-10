// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
// import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_home_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   String? userRole;

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 2)); // Wait for 2 seconds

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     print("IsLoggin${isLoggedIn.toString()}");
//     SharedPreferences rolePref = await SharedPreferences.getInstance();
//     userRole = rolePref.getString('userRole') ?? '';
//     if (isLoggedIn) {
//       // Check the user's role
//       bool isRoleMatched = await checkUserRole();

//       if (isRoleMatched) {
//         // Navigate to the dashboard if the role matches
//         if (userRole == 'caregiver') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CaregiverHomeScreen(),
//             ),
//           );
//         } else if (userRole == 'patient') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const PatientHomeScreen(),
//             ),
//           );
//         } else {
//           Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => const LoginScreen()));
//         }
//       } else {
//         // Show an error message if the role does not match
//         // _showErrorDialog('No user found with the specified role.');
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const LoginScreen()));
//       }
//     }
//   }

//   // this function is used to check the role of a user against their email.
//   Future<bool> checkUserRole() async {
//     var user = FirebaseAuth.instance.currentUser;
//     CollectionReference ref = FirebaseFirestore.instance.collection('users');
//     var snapshot = await ref.doc(user!.uid).get();

//     if (snapshot.exists) {
//       // Check if the role matches
//       String? userRoleFromFirestore = snapshot['role'];
//       if (userRoleFromFirestore == userRole) {
//         return true;
//       } else {
//         print('User role does not match: $userRoleFromFirestore');
//         return false;
//       }
//     } else {
//       print('User document not found in Firestore');
//       return false;
//     }
//   }
// }

//<<<<<<<<<<<<<<<<  Woring code >>>>>>>>>>>>>>>>>>>>>>

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
// import 'package:mentor/Screens/Authentication/Screens/welcomeScreen.dart';
// import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_home_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart'; // Import your WelcomeScreen
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   String? userRole;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color.fromARGB(255, 38, 142, 226), Colors.white],
//           ),
//         ),
//         // decoration: const BoxDecoration(
//         //   gradient: LinearGradient(
//         //     colors: [
//         //       Color(0xFF6789CA),
//         //       // Color(0xffB81736),
//         //       Color(0xff281537),
//         //     ],
//         //   ),
//         // ),
//         child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image(
//               height: 200,
//               width: 200,
//               color: Colors.white,
//               image: AssetImage(
//                 'assets/BrainLogo.jpg',
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Center(
//               child: Text(
//                 '       Welcome To\nMemory Mentor App',
//                 style: TextStyle(fontSize: 25, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 2)); // Wait for 2 seconds

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     userRole = prefs.getString('userRole') ?? '';

//     print("IsLoggin ${isLoggedIn.toString()}");

//     if (!isLoggedIn && userRole!.isEmpty) {
//       // Navigate to WelcomeScreen if not logged in and userRole is empty
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const WelcomeScreen(),
//         ),
//       );
//     } else if (isLoggedIn) {
//       // Check the user's role if logged in
//       bool isRoleMatched = await checkUserRole();

//       if (isRoleMatched) {
//         // Navigate to the appropriate home screen based on the user's role
//         if (userRole == 'caregiver') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CaregiverHomeScreen(),
//             ),
//           );
//         } else if (userRole == 'patient') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PatientHomeScreen(),
//             ),
//           );
//         } else {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//           );
//         }
//       } else {
//         // Show an error message if the role does not match
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     } else {
//       // If the user is logged in but userRole is empty, navigate to the LoginScreen
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }

//   // this function is used to check the role of a user against their email.
//   Future<bool> checkUserRole() async {
//     var user = FirebaseAuth.instance.currentUser;
//     CollectionReference ref = FirebaseFirestore.instance.collection('users');
//     var snapshot = await ref.doc(user!.uid).get();

//     if (snapshot.exists) {
//       // Check if the role matches
//       String? userRoleFromFirestore = snapshot['role'];
//       if (userRoleFromFirestore == userRole) {
//         return true;
//       } else {
//         print('User role does not match: $userRoleFromFirestore');
//         return false;
//       }
//     } else {
//       print('User document not found in Firestore');
//       return false;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
import 'package:mentor/Screens/Authentication/Screens/welcomeScreen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_home_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 38, 142, 226), Colors.white],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 150,
              width: 150,
              image: AssetImage('assets/BrainLogo.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome To\nMemory Mentor App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait for 2 seconds

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    userRole = prefs.getString('userRole') ?? '';

    print("IsLoggin ${isLoggedIn.toString()}");

    if (!isLoggedIn && userRole!.isEmpty) {
      // Navigate to WelcomeScreen if not logged in and userRole is empty
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    } else if (isLoggedIn) {
      // Check the user's role if logged in
      bool isRoleMatched = await checkUserRole();

      if (isRoleMatched) {
        // Navigate to the appropriate home screen based on the user's role
        if (userRole == 'caregiver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CaregiverHomeScreen(),
            ),
          );
        } else if (userRole == 'patient') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatientHomeScreen(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        // Show an error message if the role does not match
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // If the user is logged in but userRole is empty, navigate to the LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // this function is used to check the role of a user against their email.
  Future<bool> checkUserRole() async {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    var snapshot = await ref.doc(user!.uid).get();

    if (snapshot.exists) {
      // Check if the role matches
      String? userRoleFromFirestore = snapshot['role'];
      if (userRoleFromFirestore == userRole) {
        return true;
      } else {
        print('User role does not match: $userRoleFromFirestore');
        return false;
      }
    } else {
      print('User document not found in Firestore');
      return false;
    }
  }
}
