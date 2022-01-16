import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:wordle/widgets/character_box.dart';

class GameBoard extends StatefulWidget {
  final int rows;
  final int columns;
  const GameBoard({
    Key? key,
    this.rows = 5,
    this.columns = 5,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final targetWord = "count";
  var currentRow = 1;
  late List<List<String>> board;

  @override
  void initState() {
    board = List.generate(
        widget.rows, (i) => List.generate(widget.columns, (j) => ""));
    super.initState();
  }

  handleCharInput(String value, int colIdx) {
    if (value == "") {
      if (colIdx != 0) FocusScope.of(context).previousFocus();
      return;
    }
    board[currentRow][colIdx] = value;
    if (colIdx + 1 == widget.columns) {
      checkWord();
      return;
    }
    FocusScope.of(context).nextFocus();
  }

  checkWord() {
    final word = board[currentRow].join("");
    targetWord == word ? print("you win") : print("try again");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: board
          .mapIndexed((rowIdx, rowVal) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowVal
                    .mapIndexed((colIdx, colVal) => CharacterBox(
                          color: rowIdx + 1 == currentRow
                              ? Colors.grey.shade600
                              : Colors.grey.shade700,
                          child: rowIdx + 1 == currentRow
                              ? CharacterInput(
                                  value: colVal,
                                  onChange: (val) =>
                                      handleCharInput(val, colIdx),
                                )
                              : null,
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
