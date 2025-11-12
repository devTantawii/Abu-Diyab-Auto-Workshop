import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';

class CustomGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title_ar, title_en;
  final VoidCallback? onBack;
  final bool showBackIcon;

  const CustomGradientAppBar({
    Key? key,
    this.title_ar,
    this.onBack,
    this.title_en,
    this.showBackIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isRTL = locale.isDirectionRTL(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: 100.h,
        padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: //Theme.of(context).brightness == Brightness.light
              //  ?
              [
                const Color(0xFF006D92),
                const Color(0xFF419BBA)]
            //    : [const Color(0xFFBA1B1B), const Color(0xFFD27A7A)]
            ,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // العنوان في النص دايمًا
            Center(
              child: Text(
                isRTL ? (title_ar ?? "") : (title_en ?? ""),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // الأيقونة على الطرف
            if (showBackIcon)
              Align(
                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
