// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppColors {
  // Input border
  final Color UNFOCUSED_BORDER_COLOR = const Color.fromARGB(255, 0, 0, 0);
  final Color FOCUSED_BORDER_COLOR = const Color(0xFFFFD43B);
  final Color FOCUSED_ERROR_BORDER_COLOR = Colors.redAccent;
  final Color UNFOCUSED_ERROR_BORDER_COLOR = const Color.fromARGB(
    31,
    239,
    114,
    5,
  );

  // Background
  final Color INPUT_BG_COLOR = Color.fromARGB(255, 243, 245, 247);

  // Label
  final Color FOCUSED_LABEL_COLOR = Colors.black;
  final Color LABEL_COLOR = Colors.black;
  final Color ERROR_LABEL = Colors.redAccent;

  // Button
  final Color PRIMARY_BUTTON_COLOR = Color.fromRGBO(255, 212, 59, 1);

  // Title
  final Color HEADER_PAGE_COLOR = Colors.black;

  // Text
  final Color ERROR_TEXT_COLOR = Colors.redAccent;

  //
  final Color PRIMARY_APP_COLOR = Color.fromRGBO(255, 212, 59, 1);
}
