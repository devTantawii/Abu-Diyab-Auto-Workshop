import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class widget_ITN extends StatelessWidget {
  const widget_ITN({
    super.key,
    required this.textAr,
    required this.textEn,
    this.iconPath,
    required this.onTap,
  });

  final String textAr;
  final String textEn;
  final String? iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final bool isRTL = locale!.isDirectionRTL(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.h,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(width: 1.50.sp, color: const Color(0xff9B9B9B)),
        ),
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            if (iconPath != null) ...[
              Image.asset(iconPath!, width: 20.w, height: 20.h,fit: BoxFit.fill,),
              SizedBox(width: 5.w),
            ],
            Text(
              isRTL ? textAr : textEn,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 15.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              color: const Color(0xFFBA1B1B),
              size: 18.sp,
            )
          ],
        ),
      ),
    );
  }
}
