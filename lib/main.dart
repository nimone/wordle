import 'package:flutter/material.dart';
import 'package:wordle/widgets/board.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final targetWord = "count";
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Wordle"),
        ),
        body: GameBoard(
          targetWord,
          rows: targetWord.length + 1,
        ),
      ),
    );
  }
}
