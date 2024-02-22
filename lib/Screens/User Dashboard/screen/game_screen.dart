import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentor/Screens/User%20Dashboard/widgets/reusable_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        centerTitle: true,
        title: Text(
          'Cross-Word Game',
          style: GoogleFonts.aBeeZee(
            fontSize: 13,
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
                          'assets/crossword2.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ResuableButtonWidget(
              name: 'Play Game',
              imageUrl: 'assets/playicon.png',
              onTap: () {
                // this widget is design to move to play the game.
              },
            ),
            const SizedBox(
              height: 14,
            ),
            ResuableButtonWidget(
                name: 'Score Record',
                imageUrl: 'assets/recordicon.png',
                onTap: () {})
          ],
        ),
      ),
    );
  }
}
