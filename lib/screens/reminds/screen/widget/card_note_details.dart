import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardNotesDetails extends StatelessWidget {
  final String imagePath; // مسار الصورة
  final String text;      // النص اللي هيظهر

  const CardNotesDetails({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          height: 22.h,
          width: 22.w,
        ),
        SizedBox(width: 3.w),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 15.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
