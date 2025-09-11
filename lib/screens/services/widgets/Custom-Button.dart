import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomButton extends StatelessWidget {
  final String textAr;
  final String textEn;
  final VoidCallback onPressed;

  const CustomBottomButton({
    Key? key,
    required this.textAr,
    required this.textEn,
    required this.onPressed,
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
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
              backgroundColor: const Color(0xFFBA1B1B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 3,
            ),
            onPressed: onPressed,
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
