import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/Patient%20Dashboard/helper/text_styling.dart';

class CheckGamesResultScreen extends StatefulWidget {
  const CheckGamesResultScreen({super.key});

  @override
  State<CheckGamesResultScreen> createState() => _CheckGamesResultScreenState();
}

class _CheckGamesResultScreenState extends State<CheckGamesResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        centerTitle: true,
        title: Text(
          'Patient-Score',
          style: GoogleFonts.aBeeZee(
            fontSize: 16,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Opacity(
                opacity: 0.9,
                child: Card(
                  elevation: 20,
                  child: Container(
                    height: 320,
                    width: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          12,
                        ),
                      ),
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/gamechart.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Container(
              height: 50,
              width: 340,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Center(
                child: Text(
                  'Daily Score History',
                  style: headingTextStyling,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 85,
              width: 340,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '10/01/2024',
                      style: textStyling,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Game Score = 40'),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 85,
              width: 340,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '10/01/2024',
                      style: textStyling,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Game Score = 42'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
