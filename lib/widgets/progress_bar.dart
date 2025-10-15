import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressBar extends StatelessWidget {
  final bool active;

  const ProgressBar({super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 6.h,
      decoration: ShapeDecoration(
        color: active ? const Color(0xFFBA1B1B) : const Color(0xFFAFAFAF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
