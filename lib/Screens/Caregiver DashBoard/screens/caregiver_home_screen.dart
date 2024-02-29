import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/User%20Dashboard/widgets/reusable_button.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_calls_and_chats_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/check_game_result_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/get_patient_location_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/set_reminder_screen.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(backgroundColor: Colors.white, elevation: 10),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff43443F), Color(0xff43443F)],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 316,
              width: 430,
              decoration: const BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    200,
                  ),
                  bottomLeft: Radius.circular(
                    200,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 81, left: 30, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To',
                      style: GoogleFonts.aclonica(
                        fontSize: 30,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Memory Mentor',
                      style: GoogleFonts.aclonica(
                        fontSize: 20,
                        color: Colors.grey.shade900,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ResuableButtonWidget(
              name: 'Patient Game',
              imageUrl: 'assets/game.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckGamesResultScreen(),
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Set Reminder',
              imageUrl: 'assets/reminder.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SetReminderScreen(),
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Current Location',
              imageUrl: 'assets/location.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Get(), // this screen will change into patient current location screen. Later
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Call Patient',
              imageUrl: 'assets/contact.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CaregiverCallsAndChatsScreen(
                        otherUserUid: "WUs3HHnAeTa55L2DPJCUz85ImaL2"),
                  ),
                );
              },
            ),
            ElevatedButton(
                onPressed: getUserIdFromFirestore, child: const Text('ID'))
          ],
        ),
      ),
    );
  }

  // this code is use for getting userId // practice purpose.
  void showUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? userUid = auth.currentUser?.uid;

    if (userUid != null) {
      print('User UID: $userUid');
      // You can display the UID in your UI or perform any other action with it.
    } else {
      print('User UID not available. User may not be logged in.');
      // Handle the case where the user is not logged in.
    }
  }

  Future<String?> getUserIdFromFirestore() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String userUid = auth.currentUser!.uid;

      // Access Firestore and get the user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        // Access the 'userId' field from the document
        String? userId = userDoc['userId'];

        if (userId != null) {
          print('User ID from Firestore: $userId');
          return userId;
        } else {
          print('User ID not found in Firestore document.');
          return null;
        }
      } else {
        print('User document does not exist in Firestore.');
        return null;
      }
    } catch (e) {
      print('Error getting user ID from Firestore: $e');
      return null;
    }
  }
}
