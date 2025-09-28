import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/language/locale.dart';

class CustomGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title_ar, title_en;
  final VoidCallback? onBack;
  final bool showBackIcon; // :point_left: باراميتر جديد
  const CustomGradientAppBar({
    Key? key,
    this.title_ar,
    this.onBack,
    this.title_en,
    this.showBackIcon = true, // :point_left: افتراضيًا يظهر
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Directionality(
        textDirection:
            locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
        child: Container(
          height: 100.h,
          padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  Theme.of(context).brightness == Brightness.light
                      ? [const Color(0xFFBA1B1B), const Color(0xFFD27A7A)]
                      : [const Color(0xFF690505), const Color(0xFF6F5252)],
            ),
          ),
          child: Row(
            children: [
              // :point_down: هنا الشرط
              if (showBackIcon)
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              if (showBackIcon) SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  locale.isDirectionRTL(context)
                      ? (title_ar ?? "")
                      : (title_en ?? ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
