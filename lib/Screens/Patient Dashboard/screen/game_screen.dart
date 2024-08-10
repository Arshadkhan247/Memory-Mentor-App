import 'package:flutter/material.dart';
import 'package:mentor/Screens/Patient%20Dashboard/screen/game/crossword_game_screen.dart';
import 'package:mentor/Screens/Patient%20Dashboard/widgets/reusable_button.dart';

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
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Games Screen',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              height: 10,
            ),
            ReusableButtonWidget(
              name: 'Play Game',
              icon: Icons.play_circle_fill,
              onTap: () {
                // this widget is design to move to play the game.

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CrosswordGameScreen()));
              },
            ),
            const SizedBox(
              height: 14,
            ),
            ReusableButtonWidget(
              name: 'Score Record',
              icon: Icons.save_alt,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
