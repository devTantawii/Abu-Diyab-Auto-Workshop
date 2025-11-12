// lib/screens/final_review/widgets/packages_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';

class PackagesBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => print("تم الضغط على البانر"),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: typographyMainColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale!.isDirectionRTL(context) ? 'وفر أكثر مع باقات أبوذياب' : "Save more with Abu Diyab packages",
              style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500),
              textDirection: TextDirection.rtl,
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }
}