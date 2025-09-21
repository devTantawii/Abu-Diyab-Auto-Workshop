import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color:Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white54,
            fontSize: 14.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFBA1B1B),
            fontSize: 14.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
