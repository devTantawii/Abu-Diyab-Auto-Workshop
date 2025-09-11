import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Responsive {
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static double h(BuildContext context, double portrait, double landscape) =>
      isPortrait(context) ? portrait.h : landscape.h;

  static double w(BuildContext context, double portrait, double landscape) =>
      isPortrait(context) ? portrait.w : landscape.w;

  static double sp(BuildContext context, double portrait, double landscape) =>
      isPortrait(context) ? portrait.sp : landscape.sp;
}
