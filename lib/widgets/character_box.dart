import 'package:flutter/material.dart';

class CharacterBox extends StatelessWidget {
  final bool isFocused;
  final Color color;
  final Widget? child;
  final Function()? onTap;
  const CharacterBox({
    Key? key,
    this.child,
    this.onTap,
    this.isFocused = false,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isFocused ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        margin: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }
}
