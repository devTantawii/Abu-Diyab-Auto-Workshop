import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';

class OldBakat extends StatelessWidget {
  const OldBakat({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      width: 350.w,
      height: 454.h,
    //  alignment: AlignmentGeometry.center,
      // Makes container responsive
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(
          ' + باقات مركز ابو ذياب',
          style: TextStyle(color: Colors.red, fontSize: 16.sp),
        ),
      ),
    );
  }
}
