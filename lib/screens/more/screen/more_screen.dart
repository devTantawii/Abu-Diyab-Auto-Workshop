import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/login.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/sign_up.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/log_out.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/support_bottom_sheet.dart';
import 'package:abu_diyab_workshop/screens/more/screen/bakat_screen.dart';
import 'package:abu_diyab_workshop/screens/more/screen/widget/privacy.dart';
import 'package:abu_diyab_workshop/screens/profile/screens/profile_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_setup.dart';
import '../../../core/language/locale.dart';
import '../../../core/theme.dart';
import '../../../main.dart';

import '../../profile/widget/ITN.dart';
import '../../services/widgets/custom_app_bar.dart';
import 'invite_friends.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      await prefs.clear();
      if (mounted) {
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (_) => OnboardingScreen()),
        //         (route) => false,
        //   );
      }
      return;
    }

    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final locale = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
     //   Theme.of(context).brightness == Brightness.light
          //  ?
        Color(0xFFD27A7A)
          //  :  Color(0xFF6F5252)
        ,
        appBar:  CustomGradientAppBar(
          title_ar:  "المزيد",
          title_en: " More",
          showBackIcon: false,

        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
            ),
            color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white: Colors.black,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: locale!.isDirectionRTL(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Text(
                        locale.isDirectionRTL(context) ? 'عام' : 'General',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 25.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (_isLoggedIn)
                    SizedBox(height: 10.h),
                  if (_isLoggedIn)
                    widget_ITN(
                      textAr: 'تعديل بيانات الحساب',
                      textEn:"Edit account information",
                      iconPath: 'assets/icons/edit.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  if (_isLoggedIn)
                    SizedBox(height: 10.h),
                  if (_isLoggedIn)
                    widget_ITN(
                      textAr: 'باقاتي',
                      textEn: "My Packages",
                      iconPath: 'assets/icons/gift_card1.png',
                      onTap: () {
                   //     Navigator.push(
                   //       context,
                   //       MaterialPageRoute(
                   //         builder: (context) => BakatScreen(),
                   //       ),
                   //     );
                      },
                    ),
                  if (_isLoggedIn)
                    SizedBox(height: 10.h),
                  if (_isLoggedIn)
                    widget_ITN(
                      textAr: 'ادع أصدقائك',
                      textEn: "Invite your friends",
                      iconPath: 'assets/icons/gift_card1.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InviteFriends(),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 10.h),
                    widget_ITN(
                      textAr: 'الخصوصيه',
                      textEn: "Privacy",
                      iconPath: 'assets/icons/user.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Privacy(),
                          ),
                        );
                      },
                    ),
                 SizedBox(height: 10.h),

                  widget_ITN(
                    textAr: 'تواصل معنا ',
                    textEn: "Contact us",
                    iconPath: 'assets/icons/technical-support.png',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const SupportBottomSheet(),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.50.sp, color: Color(0xff9B9B9B)),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    child: Row(
                      textDirection: locale!.isDirectionRTL(context)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Icon(Icons.language, color: Color(0xFFBA1B1B), size: 18.sp),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            locale.isDirectionRTL(context) ? 'لغة التطبيق' : 'App Language',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        LanguageToggle(
                          isArabic: isArabic,
                          onToggle: () {
                            myAppKey.currentState?.changeLanguage(
                              isArabic ? const Locale('en') : const Locale('ar'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sp),
                      border: Border.all(
                        width: 1.50.sp,
                        color: const Color(0xff9B9B9B),
                      ),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          textDirection: locale.isDirectionRTL(context)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          children: [
                            Icon(Icons.color_lens, color: const Color(0xFFBA1B1B), size: 18.sp),
                            SizedBox(width: 5.w),
                            Text(
                              locale.isDirectionRTL(context) ? "الوضع الليلي " : "Dark Theme",
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
                            AnimatedThemeToggleButton(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  _isLoggedIn
                      ? widget_ITN(
                        textAr: 'تسجيل الخروج',
                        textEn: "Log out",
                        iconPath: 'assets/icons/logout.png',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const LogoutBottomSheet(),
                          );
                        },
                      )
                      : Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AuthBottomSheet(),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFBA1B1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  locale!.isDirectionRTL(context)
                                      ? "إنشاء حساب جديد"
                                      : "Create a new account",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder:
                                    (context) => BlocProvider(
                                      create: (_) => LoginCubit(dio: Dio()),
                                      child: const LoginBottomSheet(),
                                    ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child:  Center(
                                child: Text(
                                  locale!.isDirectionRTL(context)
                                      ? "تسجيل الدخول"
                                      : "Log in",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
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
        ),
      ),
    );
  }
}

class LanguageToggle extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageToggle({
    Key? key,
    required this.isArabic,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 70.w,
        height: 30.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey, width: 1.w),
        ),
        child: Stack(
          children: [
            // النصوص AR / EN
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  "AR",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isArabic ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  "EN",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isArabic ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            AnimatedAlign(
              alignment:
                  isArabic ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: 30.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        return GestureDetector(
          onTap: () {
            if (isDark) {
              context.read<ThemeCubit>().setLightTheme();
            } else {
              context.read<ThemeCubit>().setDarkTheme();
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: 30.h,
            padding: EdgeInsets.only(left: 16, right: 16, top: 7, bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark ? Colors.white54 : Colors.black54.withOpacity(0.5),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    key: ValueKey<bool>(isDark),
                    color: isDark ? Colors.black : Colors.white,
                    size: 14.sp,
                  ),
                ),
                SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(isDark ? "Dark" : "Light"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
