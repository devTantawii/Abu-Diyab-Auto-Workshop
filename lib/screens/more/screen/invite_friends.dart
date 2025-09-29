import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFBFFD0), Color(0xFFBA1B1B)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Text(
                        locale!.isDirectionRTL(context)
                            ? 'شارك التطبيق واربح معنا !'
                            : 'Share the app and win !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      elevation: 3,
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Transform.translate(
                          offset: Offset(-2.w, 0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locale!.isDirectionRTL(context)
                          ? 'ادع أصدقائك وأحصل علي 20'
                          : 'Invite your friends and get 20',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF474747),
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset(
                      "assets/icons/ryal.png",
                      color: const Color(0xFF474747),
                      width: 14.w,
                      height: 14.h,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                /// خطوات المشاركة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepIcon(
                      icon: Icons.share,
                      label:
                          locale!.isDirectionRTL(context)
                              ? "1. شارك الرابط"
                              : "1. Share the link",
                      imagePath: "assets/images/vector_down.png",
                    ),
                    _StepIcon(
                      icon: Icons.person_add,
                      label:
                          locale!.isDirectionRTL(context)
                              ? "2. صديقك يسجل"
                              : "2. Your friend is registering",
                      imagePath: "assets/images/vector_up.png",
                    ),              SizedBox(width: 6.w),

                    _StepIcon(
                      icon: Icons.card_giftcard,
                      label:
                          locale!.isDirectionRTL(context)
                              ? "3. اربح مكافأت"
                              : "3. Earn rewards",
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                /// كود الدعوة
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: ShapeDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black87,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.5.w, color: Color(0xFF9B9B9B)),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        locale!.isDirectionRTL(context)
                            ? "كود الدعوة الخاص بك"
                            : "Your invitation code",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                          fontSize: 16.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15.h),

                      Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 40.h,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFBA1B1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Center(
                                child: Text(locale!.isDirectionRTL(context)
                                    ? "   نسخ"
                                    : "  Copy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Flexible(
                            flex: 6,
                            child: Container(
                              height: 40.h,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.w,
                                    color: Color(0xFFBA1B1B),
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ABUDIYAB2025',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0xFF474747)
                                            : Colors.white70,
                                    fontSize: 18.sp,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(locale!.isDirectionRTL(context)
                          ? "   مشاركة الآن"
                          : "  Share now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Image.asset(
                        "assets/icons/telegram.png",
                        width: 18.w,
                        height: 18.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.5.w, color: Color(0xFFBA1B1B)),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12.r,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Text(locale!.isDirectionRTL(context)
                            ? "   رصيدك الحالي"
                            : "  Your current balance",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                            fontSize: 20.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '150',
                              style: TextStyle(
                                color: const Color(0xFFBA1B1B),
                                fontSize: 25.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset(
                              "assets/icons/ryal.png",
                              width: 20.w,
                              height: 22.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 50.h,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFBA1B1B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(locale!.isDirectionRTL(context)
                                      ? "   عدد الإحالات الخاصه بك"
                                      : "  Your number of referrals",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),


                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50.h,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white70
                                          : Colors.black54,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5.w,
                                      color: const Color(0xFF9B9B9B),
                                    ),
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white70,
                                      fontSize: 18.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                Row(
                  children: [
                    Text(
                      locale!.isDirectionRTL(context)
                          ? "   سجل المكافأت"
                          : " Reward Record",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                Container(
                  width: 350.w,
                  height: 239.h,
                  decoration: ShapeDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.5.w,
                        color: const Color(0xFF9B9B9B),
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? imagePath;

  const _StepIcon({required this.icon, required this.label, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black87,
              child: Icon(icon, size: 28.sp, color: Color(0xFFBA1B1B)),
            ),
            if (imagePath != null) ...[
              SizedBox(width: 6.w),
              Image.asset(imagePath!, width: 60.w,fit: BoxFit.fill,),

            ],
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
