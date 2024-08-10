import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? userId;
  String? caregiverId;

  @override
  void initState() {
    super.initState();
    getUserId();
    someFunction();
  }

  Future<String?> getUserId() async {
    try {
      // Get the current user's UID
      String currentUid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the document from the 'users' collection with the current UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .get();

      // Check if the document exists and contains the 'userId' field
      if (userDoc.exists) {
        String? userId = userDoc['userId']?.toString();
        print('User ID: $userId');
        return userId;
      } else {
        print('User document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  void someFunction() async {
    // Call the getUserId function and store the value in a variable
    userId = await getUserId();

    if (userId != null) {
      // Use the userId variable as needed
      print('Stored User ID: $userId');
    } else {
      print('Failed to retrieve User ID.');
    }
  }

  Future<void> _uploadReminder(String title, String description) async {
    try {
      if (userId != null) {
        await _firestore
            .collection('reminder')
            .doc(userId)
            .collection('reminders')
            .add({
          'title': title,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
          'caregiverId': userId,
        });
        print('Reminder uploaded successfully!');
      } else {
        print(
            'UserId or CaregiverId is null or empty. Cannot upload reminder.');
      }
    } catch (e) {
      print('Error uploading reminder: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff007BFF),
        centerTitle: true,
        title: Text(
          'Set Reminder',
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 173, 208, 237), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Title',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter reminder title',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Description',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter reminder description',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await _uploadReminder(
                        titleController.text, descriptionController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reminder uploaded successfully!'),
                        duration: Duration(seconds: 3),
                      ),
                    );

                    setState(() {
                      titleController.clear();
                      descriptionController.clear();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
