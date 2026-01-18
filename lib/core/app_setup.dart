import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../main.dart';
import '../screens/auth/cubit/login_cubit.dart';
import '../screens/home/screen/home_screen.dart';
import '../screens/on_boarding/screen/on_boarding_screen.dart';

import '../core/language/locale.dart';
import '../core/theme.dart';
import '../language/languageCubit.dart';
final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();
String? initialToken;

class MyApp extends StatefulWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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


    if (currentToken == null || currentToken.isEmpty) {
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
    final cubit = context.read<LanguageCubit>();
    if (langCode == 'ar') {
      cubit.selectArabicLanguage();
    } else {
      cubit.selectEngLanguage();
    }
  }

  void changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    final cubit = context.read<LanguageCubit>();
    if (locale.languageCode == 'ar') {
      cubit.selectArabicLanguage();
    } else {
      cubit.selectEngLanguage();
    }
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return MaterialApp(
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: child!,
                    );
                  },
                  locale: locale,
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
                    textDirection: locale.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: widget.initialScreen,
                  ),
                );

              },
            );
          },
        );
      },
      child: widget.initialScreen,
    );
  }
}
