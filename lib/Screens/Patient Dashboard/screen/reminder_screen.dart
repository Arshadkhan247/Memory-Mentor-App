import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Patient%20Dashboard/helper/text_styling.dart';
import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_reminder_widget.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        centerTitle: true,
        title: Text(
          'Task-Reminder',
          style: GoogleFonts.aBeeZee(
            fontSize: 14,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today Reminder',
                  style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '25/Dec/2023',
                  style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const ReusableReminderWidget();
                },
              ),
            ),
            Container(
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
                  'Reminders History',
                  style: textStyling,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
