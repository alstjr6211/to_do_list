import 'package:flutter/material.dart';

TextStyle textStyleBold() {
  return const TextStyle(
    fontFamily: "NanumBarunpen",
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyleNormal() {
  return const TextStyle(
    fontFamily: "NanumBarunpen",
    fontWeight: FontWeight.normal,
  );
}

Text settingsText(String text, bool normal) {
  return Text(
    text,
    style: normal ? textStyleNormal() : textStyleBold(),
  );
}