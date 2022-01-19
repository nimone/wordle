import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:wordle/widgets/alert_dialog.dart';
import 'package:wordle/widgets/board.dart';
import 'package:get/get.dart';

void main(List<String> args) {
  runApp(
    GetMaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final wordLength = 5;
  const MyApp({Key? key}) : super(key: key);

  Future<String> getRandomWord(int length) async {
    final words = jsonDecode(
      await rootBundle.loadString("assets/json/words.json"),
    )[length.toString()];
    return words[Random().nextInt(words.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Wordle"),
      ),
      body: FutureBuilder(
        future: getRandomWord(wordLength).then(
          (word) => Get.put(BoardController(word, rows: wordLength + 1)),
        ),
        builder: (context, AsyncSnapshot<BoardController> snapshot) {
          if (snapshot.data == null) return const Text("Cannot load game");

          final board = snapshot.data!;
          return snapshot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: GameBoard(
                        onWin: () => showAlertDialog(
                          context,
                          title: "You Guessed The Word!",
                          actionText: "Start New Game?",
                          onAction: () async => board.reset(
                            await getRandomWord(wordLength),
                            rows: wordLength + 1,
                          ),
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
                            Text(
                                "in ${board.currentRow + 1}/${board.rows} guesses"),
                          ],
                        ),
                        onLose: () => showAlertDialog(
                          context,
                          title: "The Secret Word was",
                          actionText: "Try Another Word?",
                          onAction: () async => board.reset(
                            await getRandomWord(wordLength),
                            rows: wordLength + 1,
                          ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => ElevatedButton.icon(
                            onPressed: () async => board.reset(
                              await getRandomWord(wordLength),
                              rows: wordLength + 1,
                            ),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text("New Game"),
                            style: ButtonStyle(
                              backgroundColor: board.currentRow > 0
                                  ? MaterialStateProperty.all(Colors.blue)
                                  : MaterialStateProperty.all(Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => board.isRowComplete()
                              ? board.moveToNextRow()
                              : null,
                          icon: const Icon(Icons.keyboard_return),
                          label: const Text("Enter"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        )
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
