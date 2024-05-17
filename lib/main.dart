import 'package:flutter/material.dart';
import 'package:minesweeperislands/menu.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
      theme: ThemeData(fontFamily: 'Chekharda'),
    ),
  );
}
