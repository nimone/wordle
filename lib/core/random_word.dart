import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

Future<String> getRandomWord(int length) async {
  final words = jsonDecode(
    await rootBundle.loadString("assets/json/words.json"),
  )[length.toString()];
  return words[Random().nextInt(words.length)];
}
