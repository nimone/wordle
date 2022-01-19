import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/controllers/board_controller.dart';
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
                    Obx(() => Text("${board.targetWord}")),
                    SingleChildScrollView(
                      child: GameBoard(
                        onWin: () => Get.defaultDialog(
                          title: "You Guessed The Word!",
                          content: Column(
                            children: [
                              Text(
                                board.targetWord.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "in ${board.currentRow + 1}/${board.rows} guesses"),
                            ],
                          ),
                          confirm: ElevatedButton(
                            onPressed: () async {
                              board.reset(
                                await getRandomWord(wordLength),
                                rows: wordLength + 1,
                              );
                              Get.back();
                            },
                            child: const Text("Start New Game?"),
                          ),
                          radius: 10,
                        ),
                        onLose: () => Get.defaultDialog(
                          title: "The Secret Word was",
                          content: Column(
                            children: [
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
                          confirm: ElevatedButton(
                            onPressed: () async {
                              board.reset(
                                await getRandomWord(wordLength),
                                rows: wordLength + 1,
                              );
                              Get.back();
                            },
                            child: const Text("Try Another Word?"),
                          ),
                          radius: 10,
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
