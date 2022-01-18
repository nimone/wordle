import 'package:flutter/material.dart';
import 'package:wordle/models/board_model.dart';
import 'package:wordle/widgets/alert_dialog.dart';
import 'package:wordle/widgets/board.dart';
import 'package:wordle/widgets/character_box.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyApp(),
    ),
  );
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Wordle"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: GameBoard(
              board: board,
              onWin: () => showAlertDialog(
                context,
                title: "You Guessed The Word!",
                actionText: "Start New Game?",
                onAction: () => setState(board.reset),
                content: [
                  Text(
                    board.targetWord.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("in ${board.currentRow + 1}/${board.rows} guesses"),
                ],
              ),
              onLose: () => showAlertDialog(
                context,
                title: "The Secret Word was",
                actionText: "Try Another Word?",
                onAction: () => setState(board.reset),
                content: [
                  Text(
                    board.targetWord.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => setState(board.reset),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text("New Game"),
          ),
        ],
      ),
    );
  }
}
