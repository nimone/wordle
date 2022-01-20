import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:wordle/controllers/theme_controller.dart';
import 'package:wordle/core/random_word.dart';
import 'package:wordle/widgets/board.dart';
import 'package:get/get.dart';
import 'package:wordle/widgets/keyboard.dart';

void main(List<String> args) {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
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

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Wordle"),
        leading: Obx(
          () => GestureDetector(
            onTap: () => theme.toggleDarkMode(),
            child: Icon(
                theme.isDarkMode.value ? Icons.light_mode : Icons.dark_mode),
          ),
        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Obx(() => GameBoard(
                              isDarkMode: theme.isDarkMode.value,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => ElevatedButton.icon(
                            onPressed: () async => board.currentRow > 0
                                ? board.reset(
                                    await getRandomWord(wordLength),
                                    rows: wordLength + 1,
                                  )
                                : null,
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
                          onPressed: board.handleRowSubmit,
                          icon: const Icon(Icons.keyboard_return),
                          label: const Text("Enter"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                      child: Obx(() {
                        // coludn't find another way to update keyboard colors on currentRow change (row submit)
                        print(board.currentRow);
                        return KeyBoard(isDarkMode: theme.isDarkMode.value);
                      }),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
