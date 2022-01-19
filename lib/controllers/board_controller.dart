import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  RxList<List<String>> state;
  final String targetWord;
  final int rows, columns;
  var currentRow = 0.obs;

  BoardController(String targetWord, {int? rows})
      : targetWord = targetWord.toUpperCase(),
        columns = targetWord.length,
        rows = rows ?? targetWord.length,
        state = List.generate(
          rows ?? targetWord.length,
          (i) => List.generate(targetWord.length, (j) => ""),
        ).obs;

  add(String value, {int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow.value][colIdx] = value.toUpperCase();
  }

  remove({int? rowIdx, required int colIdx}) {
    state[rowIdx ?? currentRow.value][colIdx] = "";
  }

  moveToNextRow() => currentRow++;

  reset() {
    state.value = List.generate(
      rows,
      (i) => List.generate(columns, (j) => ""),
    ).obs;
    currentRow.value = 0;
  }

  bool isRowComplete({int? rowIdx}) {
    return state[rowIdx ?? currentRow.value].join("").length == columns;
  }

  bool isRowTargetWord({int? rowIdx}) {
    return state[rowIdx ?? currentRow.value].join("") == targetWord;
  }

  Color getColor({required int rowIdx, required int colIdx}) {
    final char = state[rowIdx][colIdx];

    if (rowIdx == currentRow.value) {
      return Colors.grey.shade600;
    } else if (char == targetWord[colIdx]) {
      return Colors.green;
    } else if (char != "" && targetWord.contains(char)) {
      return Colors.orange;
    }
    return Colors.grey.shade700;
  }
}
