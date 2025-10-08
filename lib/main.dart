import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:abu_diyab_workshop/screens/main/cubit/services_cubit.dart';
import 'package:abu_diyab_workshop/screens/more/Cubit/bakat_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/CarModelCubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/add_car_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/all_cars_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/car_brand_cubit.dart';
import 'package:abu_diyab_workshop/screens/on_boarding/screen/on_boarding_screen.dart';
import 'package:abu_diyab_workshop/screens/reminds/cubit/maintenance_cubit.dart';
import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/car_check_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/oil_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/tire_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/cubit/washing_cubit.dart';
import 'package:abu_diyab_workshop/screens/services/repo/battery_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/car_check_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/oil_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/tire_repo.dart';
import 'package:abu_diyab_workshop/screens/services/repo/washing_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_setup.dart';
import 'core/constant/api.dart';
import 'core/helpers/SharedPreference/pereferences.dart';
import 'core/theme.dart';
import 'language/languageCubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.redAccent),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferences.getInstance();
  String? savedToken = prefs.getString('token');

  if (savedToken != null && savedToken.contains('|')) {
    savedToken = savedToken.split('|')[1];
  }

  initialToken = savedToken;
  print('🔑 Saved Token: $savedToken');

  final sharedPrefHelper = SharedPreferencesHelper();
  final dio = Dio();

  final repo = CarWashServiceRepo(dio);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(sharedPrefHelper),
        ),
        BlocProvider(create: (_) => ServicesCubit(dio: Dio())..fetchServices()),
        BlocProvider(create: (_) => CarBrandCubit()..fetchCarBrands()),
        BlocProvider<CarModelCubit>(
          create: (_) => CarModelCubit(dio: Dio(), mainApi: mainApi),
        ),
        BlocProvider<AddCarCubit>(create: (_) => AddCarCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(dio: Dio())),
        BlocProvider(create: (_) => CarCubit()),
        BlocProvider(create: (_) => OilCubit(OilRepository())),
        BlocProvider(create: (_) => CarWashCubit(repo)),
        BlocProvider(create: (_) => CarCheckCubit(CarCheckRepository())),
        BlocProvider(create: (_) => TireCubit(TireRepository())),
        BlocProvider(create: (_) => BatteryCubit(BatteryRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => MaintenanceCubit()),
        BlocProvider(create: (_) => UserNotesCubit()..getUserNotes()),
        BlocProvider(create: (_) => BakatCubit()..getPackages()),
      ],
      child: MyApp(
        key: myAppKey,
        initialScreen:
            initialToken != null ? const HomeScreen() : OnboardingScreen(),
      ),
    ),
  );
}

///
///
///             "Accept-Language": langCode == '' ? "en" : langCode
///
