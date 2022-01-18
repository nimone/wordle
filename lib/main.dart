import 'package:flutter/material.dart';
import 'package:wordle/models/board_model.dart';
import 'package:wordle/widgets/board.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final String targetWord;
  late final BoardModel board;

  @override
  void initState() {
    super.initState();
    targetWord = "count";
    board = BoardModel(targetWord, rows: targetWord.length + 1);
  }

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameBoard(board: board),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(board.reset),
              child: const Text("Reset"),
            ),
          ],
        ),
        // TODO: Reset board button
      ),
    );
  }
}
