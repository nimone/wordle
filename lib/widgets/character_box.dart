import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CharacterBox extends StatelessWidget {
  final Color color;
  final Widget? child;
  const CharacterBox({
    Key? key,
    this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class CharacterInput extends StatelessWidget {
  final String? value;
  final Function(String) onChange;
  final Function() onSubmit;
  const CharacterInput({
    Key? key,
    this.value = "",
    required this.onChange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 32),
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Get.isDarkMode ? Colors.white : Colors.grey.shade600,
            width: 3.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 2),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      ],
      showCursor: false,
      enableInteractiveSelection: false,
      textCapitalization: TextCapitalization.characters,
      onChanged: onChange,
      onFieldSubmitted: (value) => onSubmit(),
    );
  }
}
