import 'package:abu_diyab_workshop/screens/main/screen/main_screen.dart';
import 'package:abu_diyab_workshop/screens/my_car/screen/my_cars_screen.dart';
import 'package:abu_diyab_workshop/screens/offers/screen/offers_screen.dart';
import 'package:abu_diyab_workshop/screens/orders/screen/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final List<Widget> _screens = [
    MainScreen(),
    MyCarsScreen(),
    OffersScreen(),
    OrderScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAuthStatus();
    });
  }

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

    return SafeArea(
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
        bottomNavigationBar: SizedBox(
          // height: 75.h, // responsive height
          child: _buildBottomNavigationBar(isRTL),
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
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10.r,
            offset: Offset(0, -1.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        child: Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: BottomNavigationBar(iconSize: 25.sp,
              backgroundColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              currentIndex: _currentIndex,
              selectedItemColor: buttonPrimaryBgColor(context),
              unselectedItemColor: navbarTextColor(context),
              selectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                height: 2,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w600,
                color: Color(0xFFBA1B1B),
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.sp,
                height: 2,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
                color: Color(0xFF474747),
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
