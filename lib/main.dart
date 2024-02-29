// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentor/Database/firebase_options.dart';
import 'package:mentor/Screens/Authentication/Screens/welcomeScreen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_calls_and_chats_screen.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/screens/caregiver_home_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/patient_calls_and_chats_screen.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/patient_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MemoryMentorApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: ('roboto'),
        useMaterial3: true,
      ),
      // home: const CaregiverCallsAndChatsScreen(
      //   otherUserUid: "WUs3HHnAeTa55L2DPJCUz85ImaL2",
      // ),

      // home: const PatientCallsAndChatsScreen(otherUserUid: "857"),
      home: const WelcomeScreen(),
    );
  }
}
