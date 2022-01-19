import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:wordle/core/random_word.dart';
import 'package:wordle/widgets/board.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Wordle"),
        leading: GestureDetector(
          onTap: () => Get.changeTheme(
            Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
          ),
          child: const Icon(Icons.light_mode),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: GameBoard(),
                    ),
                    const SizedBox(height: 20),
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
