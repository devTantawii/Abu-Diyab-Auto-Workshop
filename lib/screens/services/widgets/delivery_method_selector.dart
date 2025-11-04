import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class DeliveryMethodSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const DeliveryMethodSection({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    double width = (MediaQuery.of(context).size.width - 60.w) / 2;
    double height = MediaQuery.of(context).size.height * 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              (locale!.isDirectionRTL(context)
                  ? "طريقة التوصيل "
                  : "Delivery option "),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFBA1B1B),
              ),
            ),
            SizedBox(width: 7.w),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: const ShapeDecoration(
                color: accentColor,
                shape: OvalBorder(),
              ),
              child: Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _methodButton(
              context,
              0,
              (locale!.isDirectionRTL(context) ? " سطحة " : " Flatbed truck "),
              width,
              height,
            ),
            SizedBox(width: 14.w),
            _methodButton(
              context,
              1,
              (locale!.isDirectionRTL(context)
                  ? " في المركز "
                  : "In the center"),
              width,
              height,
            ),
          ],
        ),
      ],
    );
  }

  Widget _methodButton(
      BuildContext context,
      int index,
      String text,
      double width,
      double height,
      ) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: boxcolor(context),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 1.2.w,
            color: borderColor(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // النص في المنتصف تقريباً
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor(context),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // الدائرة في الطرف الأيمن
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFFBA1B1B)
                    : const Color(0xFF9B9B9B),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

}
