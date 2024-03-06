import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  String? caregiverId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      userId = await _getUserIdFromFirestore();
      caregiverId = await fetchData();
      _loadReminders();
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

      return userDoc.exists ? userDoc['userId']?.toString() : null;
    } catch (e) {
      print('Error getting user ID from Firestore: $e');
      return null;
    }
  }

  Future<String?> fetchData() async {
    try {
      DocumentSnapshot relationshipDoc = await FirebaseFirestore.instance
          .collection('relationships')
          .doc(userId)
          .get();

      return relationshipDoc.exists ? relationshipDoc.get('caregiverId') : null;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  late Stream<QuerySnapshot> _remindersStream;

  void _loadReminders() {
    _remindersStream = _firestore
        .collection('reminders')
        .where('caregiverId', isEqualTo: caregiverId)
        .snapshots();
  }

  Widget _buildDateTimeText(Timestamp? timestamp) {
    if (timestamp == null) {
      return const Text('Time: N/A');
    } else {
      DateTime dateTime = timestamp.toDate();
      String formattedDateTime =
          DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
      return Text('Time: $formattedDateTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _remindersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var reminders = snapshot.data?.docs ?? [];
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  var reminder = reminders[index];
                  var title = reminder['title'];
                  var description = reminder['description'];
                  var timestamp = reminder['timestamp'];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: $title'),
                          Text('Description: $description'),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: _buildDateTimeText(timestamp),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}












// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/helper/text_styling.dart';
// import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_reminder_widget.dart';

// class ReminderScreen extends StatefulWidget {
//   const ReminderScreen({super.key});

//   @override
//   State<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(
//           0xffD9D9D9,
//         ),
//         centerTitle: true,
//         title: Text(
//           'Task-Reminder',
//           style: GoogleFonts.aBeeZee(
//             fontSize: 14,
//             letterSpacing: 2,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Today Reminder',
//                   style: GoogleFonts.aBeeZee(
//                       fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 Text(
//                   '25/Dec/2023',
//                   style: GoogleFonts.aBeeZee(
//                       fontWeight: FontWeight.w500, fontSize: 12),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Expanded(
//               flex: 2,
//               child: ListView.builder(
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   return const ReusableReminderWidget();
//                 },
//               ),
//             ),
//             Container(
//               height: 65,
//               width: 280,
//               decoration: BoxDecoration(
//                 color: const Color(0xffD9D9D9),
//                 borderRadius: BorderRadius.circular(
//                   15,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   'Reminders History',
//                   style: textStyling,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
