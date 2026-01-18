import 'dart:io';

import 'package:abu_diyab_workshop/screens/main/screen/main_screen.dart';
import 'package:abu_diyab_workshop/screens/my_car/screen/my_cars_screen.dart';
import 'package:abu_diyab_workshop/screens/offers/screen/offers_screen.dart';
import 'package:abu_diyab_workshop/screens/orders/screen/orders_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import '../../../core/constant/api.dart';
import '../../../core/constant/app_colors.dart';
import '../../more/screen/more_screen.dart';
import '../../auth/screen/sign_up.dart';
import '../../../core/language/locale.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAuthStatus();
    });
    checkVersion();
  }

  Future<void> checkVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // استدعاء API
      var response = await Dio().get(checkVersionApi);
      var settings = response.data['data']; // لأن البيانات داخل key اسمه "data"

      // البحث عن القيم داخل اللستة
      String? serverAndroidVersion;
      String? serverIOSVersion;

      for (var item in settings) {
        if (item['key'] == 'android_version') {
          serverAndroidVersion = item['value'];
        } else if (item['key'] == 'iphone_version') {
          serverIOSVersion = item['value'];
        }
      }

      if (serverAndroidVersion == null || serverIOSVersion == null) {
        return;
      }

      Version current = Version.parse(currentVersion);

      if (Platform.isAndroid) {
        if (await _isHuaweiDevice()) {
          Version serverHuawei = Version.parse(serverAndroidVersion);
          if (current < serverHuawei) {
            _showUpdateDialog('huawei');
            print('🔔 Huawei version available');
          }
        } else {
          Version serverAndroid = Version.parse(serverAndroidVersion);
          if (current < serverAndroid) {
            _showUpdateDialog('android');
            print('🔔 Android version available');
          }
        }
      } else if (Platform.isIOS) {
        Version serverIOS = Version.parse(serverIOSVersion);
        if (current < serverIOS) {
          _showUpdateDialog('ios');
          print('🔔 iOS version available');
        }
      }
    } catch (e, stack) {
      print("⚠️ Error fetching version: $e");
      print(stack);
    }
  }

  Future<bool> _isHuaweiDevice() async {
    if (!Platform.isAndroid) return false;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer.toLowerCase() == 'huawei';
    } catch (e) {
      print("Error detecting Huawei device: $e");
      return false;
    }
  }

  void _showUpdateDialog(String platform) {
    String url = '';
    if (platform == 'android') {
      url =
          'https://play.google.com/store/apps/details?id=com.abudiyab.workshop';
      print("android version Available");
    } else if (platform == 'ios') {
      print("IOS version Available");
      url =
          'https://apps.apple.com/us/app/%D8%A3%D8%A8%D9%88%D8%B0%D9%8A%D8%A7%D8%A8-%D9%84%D8%AA%D8%A3%D8%AC%D9%8A%D8%B1-%D8%A7%D9%84%D8%B3%D9%8A%D8%A7%D8%B1%D8%A7%D8%AA/id1570665182';
    } else if (platform == 'huawei') {
      url = 'https://appgallery.huawei.com/#/app/C104414053';
      print("huawei version Available");
    }

    showDialog(
      context: context,
      builder: (context) {
        final locale = AppLocalizations.of(context);

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [const Color(0xFF006D92), const Color(0xFF419BBA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/icons/update_icon.png',
                  height: 70.h,
                  //  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                locale!.isDirectionRTL(context)
                    ? "✨ تحديث جديد متاح!"
                    : "✨ New Update Available!",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF419BBA),
                  fontFamily: "Cairo",
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                locale.isDirectionRTL(context)
                    ? "لقد تم إصدار نسخة جديدة من التطبيق تتضمن تحسينات وإصلاحات مهمة. قم بالتحديث الآن!"
                    : "A new version of the app is available with important improvements. Update now!",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  fontFamily: "Cairo",
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  _launchURL(url);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF006D92),
                        const Color(0xFF419BBA),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? "تحديث الآن"
                          : "Update Now",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<Widget> _screens = [
    MainScreen(),
    MyCarsScreen(),
    OffersScreen(),
    OrderScreen(),
    MoreScreen(),
  ];

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!isLoggedIn) {
      _showAuthSheet();
    }
  }

  void _showAuthSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return AuthBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isRTL = locale?.isDirectionRTL(context) ?? true;

    return Container(
      color: Color(0xFF006D92),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation, secondaryAnimation) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: Curves.easeInOut));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            child: _screens[_currentIndex],
          ),
          bottomNavigationBar: Container(
            color:backgroundColor(context),
            // height: 75.h, // responsive height
            child: _buildBottomNavigationBar(isRTL),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: shadowColor(context),
            blurRadius: 12,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        child: Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: BottomNavigationBar(
              iconSize: 25.sp,
              backgroundColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              currentIndex: _currentIndex,
              selectedItemColor: typographyMainColor(context),
              unselectedItemColor: navbarTextColor(context),
              selectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                height: 2,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
                color: typographyMainColor(context),
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                height: 2,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
                color: navbarTextColor(context),
              ),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/tab1.png')),
                  label: isRTL ? 'الرئيسية' : 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/tab2.png')),
                  label: isRTL ? 'سياراتي' : 'My Cars',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/tab3.png')),
                  label: isRTL ? 'العروض' : 'Offers',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/tab4.png')),
                  label: isRTL ? 'طلباتي' : 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/tab5.png')),
                  label: isRTL ? 'المزيد' : 'More',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
