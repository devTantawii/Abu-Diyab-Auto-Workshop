import 'package:flutter/material.dart';

BoxDecoration buildAppBarDecoration(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF006D92) /* Background-Linear-primary */,
        const Color(0xFF419BBA) /* Background-Linear-Color */,
      ],
    ),
  );
}
