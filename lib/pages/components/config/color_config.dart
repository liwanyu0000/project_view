import 'dart:math';

import 'package:flutter/material.dart';

Color borderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 41, 43, 65)
    : const Color(0xFFE6E6E6);

Color labelColor(bool isDarkMode) =>
    isDarkMode ? const Color(0xFF999999) : const Color(0xffbcbfc4);

Color textColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 204, 204, 204)
    : const Color(0xff282a30);

Color logTextEmphasisColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 215, 216, 228).withOpacity(.8)
    : const Color.fromARGB(255, 40, 42, 48).withOpacity(.95);

Color logTextNoEmphasisColor = const Color.fromARGB(255, 107, 111, 118).withOpacity(.9);

const transparentColor = Color(0x00000000);

Color contentBlockColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 32, 33, 46)
    : const Color.fromARGB(255, 255, 255, 255);

Color contentBlockBorderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 41, 43, 60)
    : const Color.fromARGB(255, 237, 240, 243);

Color exquisiteButtonBorderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 49, 50, 72)
    : const Color.fromARGB(255, 223, 225, 228);

Color exquisiteButtonBackgroundColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 39, 41, 57)
    : const Color.fromARGB(255, 255, 255, 255);

Color exquisiteButtonHoverBorderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 62, 62, 74)
    : const Color.fromARGB(255, 223, 225, 228);

Color exquisiteButtonHoverBackgroundColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 43, 44, 68)
    : const Color.fromARGB(255, 244, 245, 248);

Color exquisiteSendButtonBorderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 108,119,229)
    : const Color.fromARGB(255, 161,167,222);

Color exquisiteSendButtonBackgroundColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255,  94,105,209)
    : const Color.fromARGB(255, 109,120,213);

Color exquisiteSendButtonHoverBorderColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 104,115,220)
    : const Color.fromARGB(255, 107,118,203);

Color exquisiteSendButtonHoverBackgroundColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 108,119,229)
    : const Color.fromARGB(255, 102,113,201);

Color okMarkColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 91, 101, 242)
    : const Color(0xFF444EEE);

Color errorMarkColor(bool isDarkMode) => isDarkMode
    ? const Color.fromARGB(255, 221, 84, 84)
    : const Color.fromARGB(255, 255, 20, 20);

Color markColor(bool isDarkMode, bool iserror) =>
    iserror ? errorMarkColor(isDarkMode) : okMarkColor(isDarkMode);

Color generateRandomColor() {
  Random random = Random();
  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

Map<String, Color> _avatarColor = {};
Color getAvatarColor(String name) {
  String firstName = name
      .split(' ')
      .where((e) => e.isNotEmpty)
      .take(2)
      .map((e) => e[0].toUpperCase())
      .join();

  if (_avatarColor[firstName] == null) {
    _avatarColor[firstName] = generateRandomColor();
  }
  return _avatarColor[firstName]!;
}
