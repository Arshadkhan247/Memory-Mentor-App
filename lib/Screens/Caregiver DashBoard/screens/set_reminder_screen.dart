import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/User%20Dashboard/helper/text_styling.dart';

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
