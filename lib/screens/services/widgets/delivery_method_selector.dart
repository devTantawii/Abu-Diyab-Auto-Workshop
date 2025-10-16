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
            _methodButton(context, 0,   (locale!.isDirectionRTL(context)
                ? " سطحة "
                : " Flatbed truck "), width, height),
            SizedBox(width: 14.w),
            _methodButton(context, 1, (locale!.isDirectionRTL(context)
                ? " في المركز "
                : "At the maintenance center "), width, height),
          ],
        ),
      ],
    );
  }

  Widget _methodButton(
      BuildContext context, int index, String text, double width, double height) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: boxcolor(context),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.2.w, color: borderColor(context)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor(context),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Positioned(
              right: 10.w,
              top: height / 2 - 10.h,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFFBA1B1B) : const Color(0xFF9B9B9B),
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
