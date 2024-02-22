import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/User%20Dashboard/screen/caregiver_calls_and_chats_screen.dart';
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
                    builder: (context) => const CallsAndChatsScreen(),
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
