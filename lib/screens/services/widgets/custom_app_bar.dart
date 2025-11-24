import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
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
      backgroundColor: Color(0xFF006D92),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Container(
          height: 100.h,
          padding: EdgeInsets.only(top: 10.h, right: 16.w, left: 16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF006D92),
                Color(0xFF419BBA),
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
