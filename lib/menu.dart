import 'package:flutter/material.dart';
import 'package:minesweeperislands/difficulty.dart';
import 'package:minesweeperislands/game.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var difficulty = Difficulty.easy;
  var sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.blue, const Color.fromARGB(237, 54, 130, 244)],
                  [
                    const Color.fromARGB(255, 53, 160, 247),
                    const Color.fromARGB(236, 83, 152, 255)
                  ],
                  [
                    const Color.fromARGB(255, 31, 154, 255),
                    const Color.fromARGB(236, 42, 127, 255)
                  ],
                  [
                    const Color.fromARGB(236, 25, 117, 255),
                    const Color.fromARGB(237, 54, 130, 244)
                  ]
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.00001, 0.25, 0.5, 0.75],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              size: const Size(double.infinity, double.infinity),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 32,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    'MINESWEEPER:\nTreasure Islands',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.yellow,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          switch (difficulty) {
                            case Difficulty.easy:
                              difficulty = Difficulty.normal;
                              break;
                            case Difficulty.normal:
                              difficulty = Difficulty.hard;
                              break;
                            default:
                              difficulty = Difficulty.easy;
                              break;
                          }
                        });
                      },
                      child: Text(
                        'Difficulty: ${difficulty.diff}',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sound = !sound;
                        });
                      },
                      child: Text(
                        'Sound: ${sound ? "ON" : "OFF"}',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _showAbout,
                          child: const Icon(
                            Icons.info_outline,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: _showHowToPlay,
                          child: const Icon(
                            Icons.menu_book_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainApp(
                              difficulty: difficulty,
                              soundOn: sound,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'NEW GAME',
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse('https://roketstorm.com'),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'RoketStorm (c) 2024',
                      style: TextStyle(
                        fontFamily: 'RoadRage',
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'About',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Minesweeper: Treasure Islands v.1.0.2',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Developed by RoketStorm (c) 2024',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.done,
              color: Colors.black,
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void _showHowToPlay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'How to play?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: const [
              Text(
                '“Minesweeper: Treasure Islands” is a classic minesweeper game.\n\n'
                '1. Objective: The goal is to uncover all non-mine cells on the board.\n\n'
                '2. Game Field: The game field consists of a grid of clickable cells. '
                'Some cells hide mines, while others are safe.\n\n'
                '3. Numbers: Each cell with a number indicates how many neighboring'
                ' cells (including diagonals) have mines. Use this information to deduce mine locations.\n\n'
                '4. Tap on Field: Tap or Left-click on a cell to reveal it.\n\n'
                '5. Winning: Clear all non-mine cells to win.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.done,
              color: Colors.black,
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
