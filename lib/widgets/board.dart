import 'package:flutter/material.dart';
import 'package:wordle/widgets/character_box.dart';

class GameBoard extends StatefulWidget {
  final String targetWord;
  final int rows, columns;
  const GameBoard(
    this.targetWord, {
    Key? key,
    int? rows,
  })  : columns = targetWord.length,
        rows = rows ?? targetWord.length,
        super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  var currentRowIdx = 0;
  late List<List<String>> board;

  @override
  void initState() {
    board = List.generate(
        widget.rows, (i) => List.generate(widget.columns, (j) => ""));
    super.initState();
  }

  handleCharInput(String value, int colIdx) {
    if (value == "") {
      // on backspace jump to previous box & clear the char
      if (colIdx != 0) FocusScope.of(context).previousFocus();
      setState(() => board[currentRowIdx][colIdx] = "");
      return;
    }
    setState(() => board[currentRowIdx][colIdx] = value);

    final word = board[currentRowIdx].join("");
    if (word.length == widget.targetWord.length) {
      checkWord(word);
      if (currentRowIdx >= widget.rows) {
        print("Game End");
      } else {
        setState(() => currentRowIdx++);
      }
      return;
    }
    // jump to next box
    FocusScope.of(context).nextFocus();
  }

  checkWord(String word) {
    widget.targetWord == word ? print("you win") : print("try again");
  }

  Color getBoxColor(int rowIdx, int colIdx) {
    final char = board[rowIdx][colIdx];

    if (rowIdx == currentRowIdx) {
      return Colors.grey.shade600;
    } else if (char == widget.targetWord[colIdx]) {
      return Colors.green;
    } else if (char != "" && widget.targetWord.contains(char)) {
      return Colors.orange;
    }
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateBoard(),
    );
  }

  List<Widget> generateBoard() {
    List<Widget> result = [];
    for (var i = 0; i < widget.rows; i++) {
      List<Widget> newRow = [];

      for (var j = 0; j < widget.columns; j++) {
        newRow.add(CharacterBox(
          color: getBoxColor(i, j),
          child: i == currentRowIdx
              ? CharacterInput(
                  value: board[i][j],
                  onChange: (val) => handleCharInput(val, j),
                )
              : Text(board[i][j], style: const TextStyle(fontSize: 32)),
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
