// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_calls_and_chats_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_current_location_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/game_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/screen/reminder_screen.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PatientHomeScreen extends StatefulWidget {
//   PatientHomeScreen({super.key, caregiverId});

//   String? caregiverId;

//   @override
//   State<PatientHomeScreen> createState() => _PatientHomeScreenState();
// }

// class _PatientHomeScreenState extends State<PatientHomeScreen> {
//   String? userId;
//   // String? caregiverId;

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   Future<void> getUserData() async {
//     try {
//       userId = await _getUserIdFromFirestore();
//       // caregiverId = await fetchData();
//       setState(() {}); // Trigger a rebuild after obtaining userId
//     } catch (e) {
//       print('Error getting user data: $e');
//     }
//   }

//   Future<String?> _getUserIdFromFirestore() async {
//     try {
//       String userUid = FirebaseAuth.instance.currentUser!.uid;

//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUid)
//           .get();

//       if (userDoc.exists) {
//         return userDoc['userId']?.toString();
//       } else {
//         print('User document does not exist in Firestore.');
//         return null;
//       }
//     } catch (e) {
//       print('Error getting user ID from Firestore: $e');
//       return null;
//     }
//   }

//   // with help of this class i get the patient id which are in relation with the corresponding caregiver.

//   Future<String?> fetchData() async {
//     try {
//       DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
//           .collection('relationships')
//           .doc(userId)
//           .get();

//       String? caregiverId =
//           relationshipDoc.exists ? relationshipDoc.get('caregiverId') : null;

//       if (caregiverId != null) {
//         print('Caregiver ID: $caregiverId');
//         // Perform any actions with the patientId
//         return caregiverId;
//       } else {
//         print('Caregiver ID not found for the Patient.');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: const Drawer(backgroundColor: Colors.white, elevation: 10),
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text(
//           'Patient App',
//           style: GoogleFonts.aBeeZee(
//             fontSize: 20,
//             letterSpacing: 2,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue.shade100, Colors.white],
//           ),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: 200,
//               width: 380,
//               decoration: const BoxDecoration(
//                   // color: Colors.white60,
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.all(Radius.circular(30))),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 60, left: 30, right: 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Welcome To',
//                       style: GoogleFonts.aclonica(
//                         fontSize: 30,
//                         letterSpacing: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'Memory Mentor',
//                       style: GoogleFonts.aclonica(
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ReusableButtonWidget(
//                   name: 'Play Game',
//                   icon: Icons.games_outlined,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const GameScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 ReusableButtonWidget(
//                   name: 'Reminder',
//                   icon: Icons.remember_me,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ReminderScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ReusableButtonWidget(
//                   name: 'Location',
//                   icon: Icons.location_on_outlined,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const PatientCurrentLocationScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 ReusableButtonWidget(
//                   name: 'Call Caregiver',
//                   icon: Icons.call,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PatientCallsAndChatsScreen(
//                           // otherUserUid: caregiverId.toString(),
//                           otherUserUid: widget.caregiverId.toString(),
//                         ),
//                       ),
//                     );
//                   },
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 try {
//                   final FirebaseAuth auth = FirebaseAuth.instance;
//                   await auth.signOut();

//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   await prefs.remove('isLoggedIn');
//                   SharedPreferences rolePref =
//                       await SharedPreferences.getInstance();
//                   await prefs.remove('userRole');

//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const LoginScreen(),
//                     ),
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       duration: Duration(seconds: 2),
//                       content: Text('Account logout successful.'),
//                     ),
//                   );
//                 } catch (e) {
//                   // Handle logout error
//                 }
//               },
//               child: Container(
//                 height: 50,
//                 width: 350,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade300,
//                   borderRadius: BorderRadius.circular(
//                     14,
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'Logout',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Authentication/Screens/login_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_calls_and_chats_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/patient_current_location_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/game_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/reminder_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientHomeScreen extends StatefulWidget {
  PatientHomeScreen({super.key, this.caregiverId});

  String? caregiverId;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String? userId;
  String? caregiverName;
  String? caregiverUid;
  var savedID;

  @override
  void initState() {
    super.initState();
    getUserData();
    _loadSavedCaregiverId();
    fetchCaregiverDetails();
  }

  Future<void> getUserData() async {
    try {
      userId = await _getUserIdFromFirestore();
      await fetchCaregiverDetails();
      setState(
          () {}); // Trigger a rebuild after obtaining userId and caregiver details
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

  Future<void> fetchCaregiverDetails() async {
    try {
      if (userId != null) {
        // Fetch the relationship document
        DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
            .collection('relationships')
            .doc(savedID) // Use savedID directly
            .get();

        if (relationshipDoc.exists) {
          // Get the caregiver ID from the relationship document
          String caregiverUid = relationshipDoc.get('caregiverId');
          caregiverName = relationshipDoc.get('caregiverUserName');

          print(
              '<<<<<<<< caregiverUserName  >>>>>>>>>>>>>>>${caregiverName.toString()}');

          // Fetch caregiver details from the users collection
          DocumentSnapshot caregiverDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(caregiverUid)
              .get();

          if (caregiverDoc.exists) {
            // Extract caregiver details
            caregiverName = caregiverDoc.get('userName');
            widget.caregiverId = caregiverUid; // Update widget.caregiverId

            print("Caregiver Name: $caregiverName");
          } else {
            print('Caregiver document does not exist in Firestore.');
          }
        } else {
          print('Relationship document does not exist in Firestore.');
        }
      }
    } catch (e) {
      print('Error fetching caregiver details: $e');
    }
  }

  // Future<void> fetchCaregiverDetails() async {
  //   try {
  //     if (userId != null) {
  //       DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
  //           .collection('relationships')
  //           .doc(savedID)
  //           .get();

  //       if (relationshipDoc.exists) {
  //         caregiverUid = relationshipDoc.get('caregiverId');
  //         // Fetch caregiver details from users collection
  //         print(
  //             '<<<<<<<  CAREGIVER IDDDDDDD   >>>>>>${caregiverUid.toString()}');
  //         DocumentSnapshot caregiverDoc = await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(caregiverUid)
  //             .get();

  //         if (caregiverDoc.exists) {
  //           caregiverName = caregiverDoc['userName'];
  //           print("<<<<<<<<>>>>>>>>${caregiverName.toString()}");
  //           widget.caregiverId = caregiverUid; // Update widget.caregiverId
  //         }
  //       } else {
  //         print('Relationship document does not exist in Firestore.');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching caregiver details: $e');
  //   }
  // }

  Future<void> _loadSavedCaregiverId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var savedCaregiverId = prefs.getString('caregiverId');
      if (savedCaregiverId != null) {
        savedID = savedCaregiverId;
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
          'Patient App',
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
                      'Caregiver Name',
                      style: GoogleFonts.aclonica(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$caregiverName',
                      style: GoogleFonts.aclonica(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableButtonWidget(
                  name: 'Play Game',
                  icon: Icons.games_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ReusableButtonWidget(
                  name: 'Reminder',
                  icon: Icons.remember_me,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReminderScreen(
                          caregiverId: savedID,
                        ),
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
                  name: 'Location',
                  icon: Icons.location_on_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientCurrentLocationScreen(
                          caregiverId: savedID.toString(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ReusableButtonWidget(
                  name: 'Call Caregiver',
                  icon: Icons.call,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientCallsAndChatsScreen(
                          otherUserUid: savedID.toString(),
                          caregiverName: caregiverName.toString(),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
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

                  final caregiverPrefs = await SharedPreferences.getInstance();

                  await caregiverPrefs.remove('caregiverId');

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
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
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
