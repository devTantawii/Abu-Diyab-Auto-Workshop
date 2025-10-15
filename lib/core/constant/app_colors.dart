import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Color borderColor (BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Color(0xffA4A4A4)
      : Color(0xff9B9B9B);
}
Color textColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Colors.black
      : Colors.white;
}
Color backgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Color(0xffEAEAEA)
      : Colors.black;
}
Color shadowcolor (BuildContext context ){
  return Theme.of(context).brightness == Brightness.light
      ? const Color(0x3F000000)
      : const Color(0xFF9B8989);
}
Color boxcolor (BuildContext context ){
  return Theme.of(context).brightness == Brightness.light
      ?  Colors.white
      : const Color(0xFF1D1D1D);
}
Color scaffoldBackgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? const Color(0xFFD27A7A)
      : const Color(0xFF6F5252);
}
const Color accentColor = Color(0xFFBA1B1B);
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(20, (index) {
        return Container(
          width: 12.w,
          height: 2.h,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
        );
      }),
    );
  }
}
