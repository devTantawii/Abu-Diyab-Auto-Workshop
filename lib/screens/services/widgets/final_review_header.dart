// lib/screens/final_review/widgets/final_review_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';

class FinalReviewHeader extends StatelessWidget {
  final String title;
  final String icon;
  final String deliveryMethod;

  const FinalReviewHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.deliveryMethod,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor(context),
              ),
            ),
            SizedBox(width: 5),
            Image.network(
              icon,
              height: 20.h,
              width: 20.w,
              errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 20.h),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              "نوع الصيانه : $title",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            Text(
              "($deliveryMethod)",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(18, (_) => Container(width: 18.w, height: 2.h, color: Colors.grey)),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}