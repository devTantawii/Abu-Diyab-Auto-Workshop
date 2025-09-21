import 'package:flutter/material.dart';

BoxDecoration buildAppBarDecoration(BuildContext context) {
  return BoxDecoration(
    gradient: Theme.of(context).brightness == Brightness.light
        ? const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFBA1B1B), // light start
        Color(0xFFD27A7A), // light end
      ],
    )
        : const LinearGradient(
      begin: Alignment(0.50, -0.00),
      end: Alignment(0.50, 1.00),
      colors: [
        Color(0xFF5B0000), // dark start
        Color(0xFF6F5252), // dark end
      ],
    ),
  );
}
