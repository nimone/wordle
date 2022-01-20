import 'package:flutter/material.dart';
import 'package:wordle/controllers/board_controller.dart';
import 'package:get/get.dart';

class KeyBoard extends StatelessWidget {
  final BoardController board = Get.find();
  KeyBoard({Key? key}) : super(key: key);

  static final keyrow1 = "qwertyuiop".toUpperCase().split("");
  static final keyrow2 = "asdfghjkl".toUpperCase().split("");
  static final keyrow3 = "zxcvbnm".toUpperCase().split("");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: keyrow1
              .map((k) => _Key(
                    onPressed: () => board.add(k),
                    child: Text(k, style: const TextStyle(fontSize: 16)),
                  ))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              ...keyrow2.map((k) => _Key(
                    onPressed: () => board.add(k),
                    child: Text(k, style: const TextStyle(fontSize: 16)),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              _Key(
                color: Colors.grey.shade600,
                onPressed: () => board.handleRowSubmit(),
                child: const Icon(
                  Icons.keyboard_return,
                  size: 19,
                ),
              ),
              ...keyrow3.map((k) => _Key(
                    onPressed: () => board.add(k),
                    child: Text(k, style: const TextStyle(fontSize: 16)),
                  )),
              _Key(
                color: Colors.grey.shade600,
                onPressed: () => board.remove(),
                child: const Icon(
                  Icons.backspace,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final Color? color;
  const _Key({
    Key? key,
    this.color,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
            color: color ?? Colors.grey.shade700,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                color: Colors.black26,
                blurRadius: 1,
              )
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
