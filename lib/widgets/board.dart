import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:wordle/widgets/character_box.dart';

class GameBoard extends StatelessWidget {
  final Function() onWin, onLose;
  final BoardController board = Get.find();
  GameBoard({
    Key? key,
    required this.onWin,
    required this.onLose,
  }) : super(key: key);

  handleCharInput(BuildContext context, String value, int colIdx) {
    if (value == "") {
      // on backspace jump to previous box & clear the char
      if (colIdx != 0) FocusScope.of(context).previousFocus();
      board.remove(colIdx: colIdx);
      return;
    }
    board.add(value, colIdx: colIdx);

    // jump to next box
    if (colIdx < board.columns - 1) {
      FocusScope.of(context).nextFocus();
    }
  }

  handleRowSubmit() {
    if (board.isRowComplete()) {
      if (board.isRowTargetWord()) {
        onWin();
      } else if (board.currentRow >= board.rows - 1) {
        onLose();
      } else {
        board.moveToNextRow();
      }
      return;
    }
  }

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
          color: board.getColor(rowIdx: i, colIdx: j),
          child: i == board.currentRow.value
              ? CharacterInput(
                  value: board.state[i][j],
                  onChange: (val) => handleCharInput(context, val, j),
                  onSubmit: handleRowSubmit,
                )
              : Text(
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
