import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:wordle/widgets/character_box.dart';

class GameBoard extends StatelessWidget {
  final BoardController board = Get.find();
  final bool isDarkMode;
  GameBoard({Key? key, this.isDarkMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: generateBoard(context),
      ),
    );
  }

  List<Widget> generateBoard(BuildContext context) {
    List<Widget> result = [];
    for (var i = 0; i < board.rows; i++) {
      List<Widget> newRow = [];

      for (var j = 0; j < board.columns; j++) {
        newRow.add(CharacterBox(
          onTap: () =>
              board.currentRow.value == i ? board.currentCol.value = j : null,
          isFocused:
              (board.currentRow.value == i && board.currentCol.value == j),
          color:
              board.getBoxColor(rowIdx: i, colIdx: j, isDarkMode: isDarkMode),
          child: Text(
            board.state[i][j],
            style: const TextStyle(fontSize: 32),
          ),
        ));
      }
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: newRow,
      ));
    }
    return result;
  }
}
