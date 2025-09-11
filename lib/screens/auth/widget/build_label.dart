import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class build_label extends StatelessWidget {
  const build_label({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          color:Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontSize: 13.sp,
          fontFamily: 'Graphik Arabic',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
