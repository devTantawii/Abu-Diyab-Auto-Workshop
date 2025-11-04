import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextIcon extends StatelessWidget {
  final String text;
  final String imagePath;

  const TextIcon({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 20.w, // ممكن تتحكم في الحجم
            height: 20.h,
          ),

          const SizedBox(width: 8), // مسافة صغيرة بين النص والصورة
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 15.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}