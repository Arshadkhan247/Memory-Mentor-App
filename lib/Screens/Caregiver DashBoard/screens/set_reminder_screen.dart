import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/User%20Dashboard/helper/text_styling.dart';

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        centerTitle: true,
        title: Text(
          'Set-Reminder',
          style: GoogleFonts.aBeeZee(
            fontSize: 14,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'Add Title',
              style: headingTextStyling,
            ),
            Container(
              height: 50,
              width: 320,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Removes the underline
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Add Description',
              style: headingTextStyling,
            ),
            Container(
              height: 100,
              width: 320,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Removes the underline
                    hintText: 'Enter Your Message',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Image(
              image: AssetImage(
                'assets/calendar.png',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 65,
                width: 280,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: headingTextStyling,
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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class SetReminderScreen extends StatefulWidget {
//   const SetReminderScreen({Key? key}) : super(key: key);

//   @override
//   _SetReminderScreenState createState() => _SetReminderScreenState();
// }

// class _SetReminderScreenState extends State<SetReminderScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   String? caregiverId;
//   String? patientId;
//   var userId;
//   final TextEditingController _reminderController = TextEditingController();

//   var myId;

//   @override
//   void initState()  {
//     super.initState();
//     initFirebaseNotifications();
//     getUserData();
    
//   }

//   Future<void> initFirebaseNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> getUserData() async {
//     try {
//       caregiverId = await _getUserIdFromFirestore();
//       patientId = await fetchData();
//       myId = GetMyId();
//     } catch (e) {
//       print('Error getting user data: $e');
//     }
//   }

//   String? GetMyId() {
//     String myId = _auth.currentUser!.uid;
//     return myId;
//   }

//   Future<String?> _getUserIdFromFirestore() async {
//     try {
//       String userUid = _auth.currentUser!.uid;

//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(userUid).get();

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

//       String? patientId =
//           relationshipDoc.exists ? relationshipDoc.get('patientId') : null;

//       if (patientId != null) {
//         print('Patient ID: $patientId');
//         // Perform any actions with the patientId
//         return patientId;
//       } else {
//         print('Patient ID not found for the caregiver.');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//     return null;
//   }

//   Future<void> setReminder() async {
//     try {
//       await _firestore.collection('reminders').add({
//         'caregiverId': caregiverId,
//         'patientId': patientId,
//         'reminderText': _reminderController.text,
//       });

//       _showNotification();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Reminder set successfully!'),
//           duration: Duration(seconds: 3),
//         ),
//       );

//       _reminderController.clear();
//     } catch (e) {
//       print('Error setting reminder: $e');
//     }
//   }

//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'caregiver_reminders',
//       'Caregiver Reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       'Reminder set!',
//       'You have a new reminder from your caregiver.',
//       platformChannelSpecifics,
//       payload: 'caregiver_reminder',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Set Reminder'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(patientId.toString()),
//             Text(myId),
//             TextField(
//               controller: _reminderController,
//               decoration: const InputDecoration(labelText: 'Enter Reminder'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: setReminder,
//               child: const Text('Set Reminder'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
