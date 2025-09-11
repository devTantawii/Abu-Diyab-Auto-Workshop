import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:abu_diyab_workshop/screens/main/cubit/services_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/CarModelCubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/add_car_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/all_cars_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/car_brand_cubit.dart';
import 'package:abu_diyab_workshop/screens/on_boarding/screen/on_boarding_screen.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/oil_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/tire_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/repo/battery_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/oil_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/tire_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constant/api.dart';
import 'core/global.dart';
import 'core/language/locale.dart';
import 'core/theme.dart';

final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();
String? initialToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.redAccent),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferences.getInstance();
  String? savedToken = prefs.getString('token');

  // لو فيه | في التوكين، نشيل الجزء الأول ونخلي التاني بس
  if (savedToken != null && savedToken.contains('|')) {
    savedToken = savedToken.split('|')[1];
  }

  initialToken = savedToken;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServicesCubit(dio: Dio())..fetchServices()),
        BlocProvider(
          create: (_) => CarBrandCubit()..fetchCarBrands(), // 👈 هنا

        ),
        BlocProvider<CarModelCubit>(
          create:
              (_) => CarModelCubit(dio: Dio(), mainApi: mainApi),
        ),
        BlocProvider<AddCarCubit>(create: (_) => AddCarCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(dio: Dio())),
        BlocProvider(create: (_) => CarCubit()),
        BlocProvider(create: (_) => OilCubit(OilRepository())),
        BlocProvider(create: (_) => TireCubit(TireRepository())),
        BlocProvider(create: (_) => BatteryCubit(BatteryRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: MyApp(
        key: myAppKey,
        initialScreen:
            initialToken != null ? const HomeScreen() : OnboardingScreen(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocale();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final currentToken = prefs.getString('token');

    if (currentToken != initialToken) {
      await prefs.clear();
      initialToken = null;

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
          (route) => false,
        );
      }
    }
  }

  void navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkToken();
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'ar';
    setState(() => _locale = Locale(langCode));
  }

  void changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              locale: _locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              home: Directionality(
                textDirection:
                    _locale?.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: widget.initialScreen,
              ),
            );
          },
        );
      },
      child: widget.initialScreen,
    );
  }
}
