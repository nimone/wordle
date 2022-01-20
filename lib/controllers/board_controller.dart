import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/core/random_word.dart';

class BoardController extends GetxController {
  RxList<List<String>> state;
  RxString targetWord;
  final int rows, columns;
  var currentRow = 0.obs;
  var currentCol = 0.obs;

  BoardController(String targetWord, {int? rows})
      : targetWord = targetWord.toUpperCase().obs,
        columns = targetWord.length,
        rows = rows ?? targetWord.length,
        state = List.generate(
          rows ?? targetWord.length,
          (i) => List.generate(targetWord.length, (j) => ""),
        ).obs;

  add(String value, {int? rowIdx, int? colIdx}) {
    rowIdx ??= currentRow.value;
    colIdx ??= currentCol.value;

    state[rowIdx][colIdx] = value.toUpperCase();
    state.refresh(); // apparently updating a list index isn't reactive
    if (currentCol < columns - 1) currentCol++;
  }

  remove({int? rowIdx, int? colIdx}) {
    rowIdx ??= currentRow.value;
    colIdx ??= currentCol.value;

    if (state[rowIdx][colIdx] == "" && colIdx > 0) {
      state[rowIdx][colIdx - 1] = "";
    } else {
      state[rowIdx][colIdx] = "";
    }
    state.refresh();
    if (currentCol > 0) currentCol--;
  }

  moveToNextRow() => currentRow++;

  reset(String newTargetWord, {int? rows}) {
    final columns = newTargetWord.length;
    targetWord.value = newTargetWord.toUpperCase();
    state.value = List.generate(
      rows ?? columns,
      (i) => List.generate(columns, (j) => ""),
    ).obs;
    currentRow.value = 0;
  }

  bool isRowComplete({int? rowIdx}) {
    return state[rowIdx ?? currentRow.value].join("").length == columns;
  }

  bool isRowTargetWord({int? rowIdx}) {
    return state[rowIdx ?? currentRow.value].join("") == targetWord.value;
  }

  Color getBoxColor({required int rowIdx, required int colIdx}) {
    final char = state[rowIdx][colIdx];

    if (rowIdx == currentRow.value) {
      return Get.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
    } else if (char == targetWord.value[colIdx]) {
      return Colors.green;
    } else if (char != "" && targetWord.contains(char)) {
      return Colors.orange;
    }
    return Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
  }

  Color getKeyColor(String keyChar) {
    final isInState = state.any((row) => row.any((char) => keyChar == char));
    if (isInState && targetWord.contains(keyChar)) {
      return Colors.orange;
    } else if (isInState) {
      return Colors.grey.shade800;
    }
    return Colors.grey.shade700;
  }

  handleRowSubmit() {
    if (isRowComplete()) {
      if (isRowTargetWord()) {
        Get.defaultDialog(
          title: "You Guessed The Word!",
          content: Column(
            children: [
              Text(
                targetWord.toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text("in ${currentRow + 1}/$rows guesses"),
            ],
          ),
          confirm: ElevatedButton(
            onPressed: () async {
              reset(
                await getRandomWord(columns),
                rows: columns + 1,
              );
              Get.back();
            },
            child: const Text("Start New Game?"),
          ),
          radius: 10,
        );
      } else if (currentRow >= rows - 1) {
        Get.defaultDialog(
          title: "The Secret Word was",
          content: Column(
            children: [
              Text(
                targetWord.toUpperCase(),
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
              reset(
                await getRandomWord(columns),
                rows: columns + 1,
              );
              Get.back();
            },
            child: const Text("Try Another Word?"),
          ),
          radius: 10,
        );
      } else {
        moveToNextRow();
        currentCol.value = 0;
      }
      return;
    }
  }
}
