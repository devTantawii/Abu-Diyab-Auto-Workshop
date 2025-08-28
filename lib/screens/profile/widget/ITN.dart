import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/profile_screen.dart';

class widget_ITN extends StatelessWidget {
  const widget_ITN({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  final String text;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.50, color: const Color(0xFFAFAFAF)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,

          children: [
            Image.asset(iconPath, width: 15, height: 15),
            SizedBox(width: 5.w),
            Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).brightness ==
                    Brightness.light
                    ? Colors.black
                    :Colors.white,
                fontSize: 15,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Color(0xFFBA1B1B)),
          ],
        ),
      ),
    );
  }
}
