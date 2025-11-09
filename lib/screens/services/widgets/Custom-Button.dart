import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomButton extends StatelessWidget {
  final String textAr;
  final String textEn;
  final VoidCallback? onPressed;
  final bool isEnabled; // ✅ إضافة جديدة

  const CustomBottomButton({
    Key? key,
    required this.textAr,
    required this.textEn,
    required this.onPressed,
    this.isEnabled = true, // ✅ افتراضي الزر مفعل
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
          ),
          border: Border(
            top: BorderSide(
              color: paragraphColor(context),
              width: 1.5.w,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22FFFFFF),
              blurRadius: 15,
              offset: Offset(0, 0),
              spreadRadius: 15,
            ),
          ],
        ),
        child: SizedBox(
          height: 55.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              backgroundColor: isEnabled
                  ? const Color(0xFFBA1B1B) // اللون الطبيعي لو الزر شغال
                  : Colors.grey.shade400, // رمادي لو الزر مقفول
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 3,
            ),
            onPressed: isEnabled ? onPressed : null, // ✅ يتعطل الزر هنا
            child: Text(
              locale == 'ar' ? textAr : textEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
