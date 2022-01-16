import 'package:flutter/material.dart';
import 'package:wordle/widgets/character_box.dart';

class GameBoard extends StatelessWidget {
  final int rows;
  final int columns;
  const GameBoard({
    Key? key,
    this.rows = 5,
    this.columns = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateBoard(),
    );
  }

  List<Widget> generateBoard() {
    return List.generate(columns, (i) => i)
        .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rows, (i) => i)
                  .map((e) => const CharacterBox())
                  .toList(),
            ))
        .toList();
  }
}
