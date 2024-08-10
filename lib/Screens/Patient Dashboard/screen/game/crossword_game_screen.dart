import 'dart:math';

import 'package:flutter/material.dart';

class CrosswordGameScreen extends StatefulWidget {
  const CrosswordGameScreen({super.key});

  @override
  _CrosswordGameScreenState createState() => _CrosswordGameScreenState();
}

class _CrosswordGameScreenState extends State<CrosswordGameScreen> {
  List<List<String>> crosswordGrid = [];

  List<String> words = [
    'CROSSWORD',
    'FLUTTER',
    'DEVELOPMENT',
    'PUZZLE',
    'WORD',
    'GAME'
  ];

  late List<String> selectedWords;
  late List<String> hints;

  @override
  void initState() {
    super.initState();
    generateCrosswordGrid();
  }

  void generateCrosswordGrid() {
    crosswordGrid.clear();

    // Initialize grid with random letters
    for (int i = 0; i < 9; i++) {
      crosswordGrid.add(List.generate(9, (index) => _getRandomLetter()));
    }

    // Randomly select words to place on the grid
    selectedWords = words.toList()..shuffle();
    hints = selectedWords.map((word) => word.toUpperCase()).toList();

    // Place words horizontally or vertically
    Random random = Random();
    for (String word in selectedWords) {
      bool placed = false;
      while (!placed) {
        int row = random.nextInt(9);
        int col = random.nextInt(9);
        bool horizontal = random.nextBool();

        // Check if word can fit horizontally
        if (horizontal && col + word.length <= 9) {
          placed = true;
          for (int i = 0; i < word.length; i++) {
            crosswordGrid[row][col + i] = word[i];
          }
          hints[selectedWords.indexOf(word)] =
              'H: ${hints[selectedWords.indexOf(word)]}';
        }
        // Check if word can fit vertically
        else if (!horizontal && row + word.length <= 9) {
          placed = true;
          for (int i = 0; i < word.length; i++) {
            crosswordGrid[row + i][col] = word[i];
          }
          hints[selectedWords.indexOf(word)] =
              'V: ${hints[selectedWords.indexOf(word)]}';
        }
      }
    }

    // Fill remaining cells with random letters
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (crosswordGrid[i][j] == '') {
          crosswordGrid[i][j] = _getRandomLetter();
        }
      }
    }
  }

  String _getRandomLetter() {
    Random random = Random();
    return String.fromCharCode(random.nextInt(26) + 'A'.codeUnitAt(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: crosswordGrid.length * crosswordGrid.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = (index / crosswordGrid.length).floor();
                  int col = (index % crosswordGrid.length);
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Text(
                      crosswordGrid[row][col],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bool isCorrect = checkAnswers();
                if (isCorrect) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Congratulations!'),
                        content: const Text('You solved the puzzle correctly!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Oops!'),
                        content: const Text(
                            'Some answers are incorrect. Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Check Answers'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hints:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Column(
              children: hints.map((hint) => Text(hint)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  bool checkAnswers() {
    for (int i = 0; i < selectedWords.length; i++) {
      String word = selectedWords[i];
      String hint = hints[i].split(':').last.trim().toLowerCase();
      int row = crosswordGrid.indexWhere((row) => row.contains(word[0]));
      int col = crosswordGrid[row].indexOf(word[0]);
      bool horizontal = hint == 'h';
      int index = 0;
      if (horizontal) {
        for (int j = col; j < col + word.length; j++) {
          if (j >= 9 || crosswordGrid[row][j] != word[index]) {
            return false;
          }
          index++;
        }
      } else {
        for (int j = row; j < row + word.length; j++) {
          if (j >= 9 || crosswordGrid[j][col] != word[index]) {
            return false;
          }
          index++;
        }
      }
    }
    return true;
  }
}
