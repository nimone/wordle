import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterBox extends StatelessWidget {
  final String value;
  const CharacterBox({
    Key? key,
    this.value = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.all(4),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(fontSize: 20),
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ],
        showCursor: false,
        enableInteractiveSelection: false,
        textCapitalization: TextCapitalization.characters,
        onChanged: (value) {
          if (value == "") FocusScope.of(context).previousFocus();
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
