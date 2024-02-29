import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/patient_calls_and_chats_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/patient_current_location_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/game_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/reminder_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/widgets/reusable_button.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String? userId;
  String? patientId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      userId = await _getUserIdFromFirestore();
      patientId = await fetchData();
      setState(() {}); // Trigger a rebuild after obtaining userId
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<String?> _getUserIdFromFirestore() async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      if (userDoc.exists) {
        return userDoc['userId']?.toString();
      } else {
        print('User document does not exist in Firestore.');
        return null;
      }
    } catch (e) {
      print('Error getting user ID from Firestore: $e');
      return null;
    }
  }

  // with help of this class i get the patient id which are in relation with the corresponding caregiver.

  Future<String?> fetchData() async {
    try {
      DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
          .collection('relationships')
          .doc(userId)
          .get();

      String? patientId =
          relationshipDoc.exists ? relationshipDoc.get('patientId') : null;

      if (patientId != null) {
        print('Patient ID: $patientId');
        // Perform any actions with the patientId
        return patientId;
      } else {
        print('Patient ID not found for the caregiver.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

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
              name: 'Play Game',
              imageUrl: 'assets/game.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Reminder',
              imageUrl: 'assets/reminder.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReminderScreen(),
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Location',
              imageUrl: 'assets/location.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientCurrentLocationScreen(),
                  ),
                );
              },
            ),
            ResuableButtonWidget(
              name: 'Call Caregiver',
              imageUrl: 'assets/contact.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientCallsAndChatsScreen(
                      otherUserUid: '857',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
