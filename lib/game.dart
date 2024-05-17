import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:minesweeperislands/bomb.dart';
import 'package:minesweeperislands/difficulty.dart';
import 'package:minesweeperislands/number_box.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.difficulty,
    required this.soundOn,
  });

  final Difficulty difficulty;
  final bool soundOn;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final int numberOfColumns = 10;

  late int numberOfFields;

  bool gameOver = false;

  var fieldStatus = [];

  Set<int> bombFields = {};

  bool startTimer = false;
  int timer = 0;

  late AudioPlayer player;

  late Timer timerCallback;

  int numberOfBombs = 10;

  @override
  void initState() {
    player = AudioPlayer();

    numberOfFields = numberOfColumns * numberOfColumns;

    for (var i = 0; i < numberOfFields; i++) {
      fieldStatus.add([0, false]);
    }

    bombFieldGenerator();

    checkAroundField();

    timerCallback = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(
        () {
          if (startTimer) timer++;
        },
      ),
    );

    super.initState();
  }

  void openField(int index) {
    if (!startTimer) {
      setState(() {
        startTimer = true;
      });
    }
    showFieldBombCount(index);
  }

  void checkAroundField() {
    for (var i = 0; i < numberOfFields; i++) {
      int bombs = 0;

      if (bombFields.contains(i - 1) && i % numberOfColumns != 0) {
        bombs++;
      }

      if (bombFields.contains(i - 1 - numberOfColumns) &&
          i % numberOfColumns != 0 &&
          i >= numberOfColumns) {
        bombs++;
      }

      if (bombFields.contains(i - numberOfColumns) && i >= numberOfColumns) {
        bombs++;
      }

      if (bombFields.contains(i + 1 - numberOfColumns) &&
          i % numberOfColumns != numberOfColumns - 1 &&
          i >= numberOfColumns) {
        bombs++;
      }

      if (bombFields.contains(i + 1) &&
          i % numberOfColumns != numberOfColumns - 1) {
        bombs++;
      }

      if (bombFields.contains(i + 1 + numberOfColumns) &&
          i % numberOfColumns != numberOfColumns - 1 &&
          i < numberOfFields - numberOfColumns) {
        bombs++;
      }

      if (bombFields.contains(i + numberOfColumns) &&
          i < numberOfFields - numberOfColumns) {
        bombs++;
      }

      if (bombFields.contains(i - 1 + numberOfColumns) &&
          i % numberOfColumns != 0 &&
          i < numberOfFields - numberOfColumns) {
        bombs++;
      }

      setState(() {
        fieldStatus[i][0] = bombs;
      });
    }
  }

  void showFieldBombCount(int index) {
    if (fieldStatus[index][0] != 0) {
      setState(() {
        fieldStatus[index][1] = true;
      });
    } else {
      setState(() {
        fieldStatus[index][1] = true;
        if (index % numberOfColumns != 0) {
          if (fieldStatus[index - 1][0] == 0 &&
              fieldStatus[index - 1][1] == false) {
            showFieldBombCount(index - 1);
          }

          fieldStatus[index - 1][1] = true;
        }

        if (index % numberOfColumns != 0 && index >= numberOfColumns) {
          if (fieldStatus[index - 1 - numberOfColumns][0] == 0 &&
              fieldStatus[index - 1 - numberOfColumns][1] == false) {
            showFieldBombCount(index - 1 - numberOfColumns);
          }

          fieldStatus[index - 1 - numberOfColumns][1] = true;
        }

        if (index >= numberOfColumns) {
          if (fieldStatus[index - numberOfColumns][0] == 0 &&
              fieldStatus[index - numberOfColumns][1] == false) {
            showFieldBombCount(index - numberOfColumns);
          }

          fieldStatus[index - numberOfColumns][1] = true;
        }

        if (index % numberOfColumns != numberOfColumns - 1 &&
            index >= numberOfColumns) {
          if (fieldStatus[index + 1 - numberOfColumns][0] == 0 &&
              fieldStatus[index + 1 - numberOfColumns][1] == false) {
            showFieldBombCount(index + 1 - numberOfColumns);
          }

          fieldStatus[index + 1 - numberOfColumns][1] = true;
        }

        if (index % numberOfColumns != numberOfColumns - 1) {
          if (fieldStatus[index + 1][0] == 0 &&
              fieldStatus[index + 1][1] == false) {
            showFieldBombCount(index + 1);
          }

          fieldStatus[index + 1][1] = true;
        }

        if (index % numberOfColumns != numberOfColumns - 1 &&
            index < numberOfFields - numberOfColumns) {
          if (fieldStatus[index + 1 + numberOfColumns][0] == 0 &&
              fieldStatus[index + 1 + numberOfColumns][1] == false) {
            showFieldBombCount(index + 1 + numberOfColumns);
          }

          fieldStatus[index + 1 + numberOfColumns][1] = true;
        }

        if (index < numberOfFields - numberOfColumns) {
          if (fieldStatus[index + numberOfColumns][0] == 0 &&
              fieldStatus[index + numberOfColumns][1] == false) {
            showFieldBombCount(index + numberOfColumns);
          }

          fieldStatus[index + numberOfColumns][1] = true;
        }

        if (index % numberOfColumns != 0 &&
            index < numberOfFields - numberOfColumns) {
          if (fieldStatus[index - 1 + numberOfColumns][0] == 0 &&
              fieldStatus[index - 1 + numberOfColumns][1] == false) {
            showFieldBombCount(index - 1 + numberOfColumns);
          }

          fieldStatus[index - 1 + numberOfColumns][1] = true;
        }
      });
    }
  }

  void bombFieldGenerator() {
    if (widget.difficulty == Difficulty.easy) {
      numberOfBombs = Random().nextInt(10) + 5;
    }

    if (widget.difficulty == Difficulty.normal) {
      numberOfBombs = Random().nextInt(25) + 11;
    }

    if (widget.difficulty == Difficulty.hard) {
      numberOfBombs = Random().nextInt(40) + 26;
    }

    for (var i = 0; i < numberOfBombs; i++) {
      bombFields.add(Random().nextInt(numberOfFields));
    }
    if (bombFields.length != numberOfBombs) {
      bombFields = {};
      bombFieldGenerator();
    }
  }

  void playerLost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'Game Over!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              restartGame();
              Navigator.pop(context);
            },
            child: const Text('Restart'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void restartGame() {
    setState(() {
      gameOver = false;
      fieldStatus = [];
      bombFields = {};
      timer = 0;
      startTimer = false;

      for (var i = 0; i < numberOfFields; i++) {
        fieldStatus.add([0, false]);
      }
    });
    bombFieldGenerator();
    checkAroundField();
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'YOU WIN!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              restartGame();
              Navigator.pop(context);
            },
            child: const Text('New Game'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void checkWinner() {
    int potentialBombs = 0;
    for (var i = 0; i < numberOfFields; i++) {
      if (fieldStatus[i][1] == false) {
        potentialBombs++;
      }
    }

    if (potentialBombs == bombFields.length) {
      playerWon();
    }
  }

  void timerAction() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 67, 192, 255),
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
                heightPercentages: [0.05, 0.25, 0.5, 0.75],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              size: const Size(double.infinity, double.infinity),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            bombFields.length.toString(),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.yellow,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'BOMBS',
                            style: TextStyle(
                              color: Colors.yellow,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: restartGame,
                        child: Card(
                          color: gameOver ? Colors.red[200] : Colors.amber[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/pirate_icon_${gameOver ? "negative" : "positive"}.png',
                              width: 48,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timer.toString(),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.yellow,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'TIME',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth < 700
                          ? constraints.maxWidth
                          : constraints.maxWidth / 2.2;
                      return SizedBox(
                        width: width,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(
                            16,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: numberOfFields,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numberOfColumns,
                          ),
                          itemBuilder: (context, index) {
                            if (bombFields.contains(index)) {
                              return Bomb(
                                isOpened: gameOver,
                                callback: () {
                                  if (!gameOver) {
                                    setState(() {
                                      gameOver = true;
                                      startTimer = false;
                                    });
                                    if (widget.soundOn) {
                                      player.play(
                                        AssetSource('sounds/explosion.ogg'),
                                      );
                                    }
                                    playerLost();
                                  }
                                },
                              );
                            } else {
                              return NumberBox(
                                child: fieldStatus[index][0],
                                isOpened: fieldStatus[index][1],
                                callback: () {
                                  if (!gameOver) {
                                    openField(index);
                                    checkWinner();
                                  }
                                },
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timerCallback.cancel();
    super.dispose();
  }
}
