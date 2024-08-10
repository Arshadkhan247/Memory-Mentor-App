import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_calls_and_chats_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/get_patient_location_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/check_game_result_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/set_reminder_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  String? userId;
  String? patientName;
  String? patientUid;
  var savedID;

  @override
  void initState() {
    super.initState();
    getUserData();
    _loadSavedPatientId();
  }

  Future<void> getUserData() async {
    try {
      userId = await _getUserIdFromFirestore();
      await fetchPatientDetails();
      setState(
          () {}); // Trigger a rebuild after obtaining userId and patient details
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

  Future<void> fetchPatientDetails() async {
    try {
      if (userId != null) {
        String userUid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
            .collection('relationships')
            .doc(userId)
            .get();

        if (relationshipDoc.exists) {
          patientUid = relationshipDoc.get('patientId');
          // Fetch patient details from users collection
          DocumentSnapshot patientDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(patientUid)
              .get();

          if (patientDoc.exists) {
            patientName = patientDoc.get('userName');
            print("Patient Name: ${patientName.toString()}");
          }
        } else {
          print('Relationship document does not exist in Firestore.');
        }
      }
    } catch (e) {
      print('Error fetching patient details: $e');
    }
  }

  Future<void> _loadSavedPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var savedPatientId = prefs.getString('patientId');
      if (savedPatientId != null) {
        savedID = savedPatientId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text(
          'Caregiver App',
          style: GoogleFonts.aBeeZee(
            fontSize: 20,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: 380,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 0, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To',
                      style: GoogleFonts.aclonica(
                        fontSize: 30,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Memory Mentor',
                      style: GoogleFonts.aclonica(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Divider(
                      color: Colors.white54,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Text(
                      'Caregiver ID',
                      style: GoogleFonts.aclonica(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$userId',
                      style: GoogleFonts.aclonica(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableButtonWidget(
                  name: 'Patient Game',
                  icon: Icons.games_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckGamesResultScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                ReusableButtonWidget(
                  name: 'Set Reminder',
                  icon: Icons.remember_me_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetReminderScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableButtonWidget(
                  name: 'Current Location',
                  icon: Icons.location_on_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Get(
                          userId: userId.toString(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                ReusableButtonWidget(
                  name: 'Call Patient',
                  icon: Icons.call,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaregiverCallsAndChatsScreen(
                          otherUserUid: patientUid.toString(),
                          caregiverName: patientName.toString(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  SharedPreferences rolePref =
                      await SharedPreferences.getInstance();
                  await prefs.remove('userRole');

                  final patientPrefs = await SharedPreferences.getInstance();

                  await patientPrefs.remove('patientId');

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Account logout successful.'),
                    ),
                  );
                } catch (e) {
                  // Handle logout error
                }
              },
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
