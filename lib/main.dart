import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:abu_diyab_workshop/screens/main/cubit/services_cubit.dart';
import 'package:abu_diyab_workshop/screens/more/Cubit/bakat_cubit.dart';
import 'package:abu_diyab_workshop/screens/more/cubit/reward_logs_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/CarModelCubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/add_car_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/all_cars_cubit.dart';
import 'package:abu_diyab_workshop/screens/my_car/cubit/car_brand_cubit.dart';
import 'package:abu_diyab_workshop/screens/on_boarding/screen/on_boarding_screen.dart';
import 'package:abu_diyab_workshop/screens/orders/cubit/get_order_cubit.dart';
import 'package:abu_diyab_workshop/screens/orders/cubit/old_orders_cubit.dart';
import 'package:abu_diyab_workshop/screens/orders/cubit/payment_preview_cubit.dart';
import 'package:abu_diyab_workshop/screens/orders/cubit/repair_card_cubit.dart';
import 'package:abu_diyab_workshop/screens/orders/repo/get_order_repo.dart';
import 'package:abu_diyab_workshop/screens/orders/repo/payment_service.dart';
import 'package:abu_diyab_workshop/screens/profile/cubit/profile_cubit.dart';
import 'package:abu_diyab_workshop/screens/profile/repositorie/profile_repository.dart';
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
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFBA1B1B),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  final prefs = await SharedPreferences.getInstance();
  initialToken = prefs.getString('token');

  print('🔑 Saved Token: $initialToken');

  final sharedPrefHelper = SharedPreferencesHelper();
  final dio = Dio();

  final repo = CarWashServiceRepo(dio);
  final profileRepository = ProfileRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(sharedPrefHelper),
        ),
        BlocProvider(create: (_) => ServicesCubit(dio: Dio())..fetchServices()),
        BlocProvider(
          create: (_) => OrdersCubit(OrdersRepo(Dio()))..getAllOrders(),
        ),

        BlocProvider(create: (_) => CarBrandCubit()..fetchCarBrands()),
        BlocProvider<CarModelCubit>(
          create: (_) => CarModelCubit(dio: Dio(), mainApi: mainApi),
        ),
        BlocProvider<AddCarCubit>(create: (_) => AddCarCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(dio: Dio())),
        BlocProvider(create: (_) => CarCubit()),
        BlocProvider(create: (_) => PaymentPreviewCubit(PaymentService())),
        BlocProvider(create: (_) => OilCubit(OilRepository())),
        BlocProvider(create: (_) => CarWashCubit(repo)),
        BlocProvider(create: (_) => RepairCardsCubit()),
        BlocProvider(create: (_) => CarCheckCubit(CarCheckRepository())),
        BlocProvider(create: (_) => TireCubit(TireRepository())),
        BlocProvider(create: (_) => BatteryCubit(BatteryRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => MaintenanceCubit()),
        BlocProvider(create: (_) => UserNotesCubit()..getUserNotes()),
        BlocProvider(create: (_) => BakatCubit()..getPackages()),
        BlocProvider(create: (_) => OldOrdersCubit()..getOldOrders()),
        BlocProvider<RewardLogsCubit>(
          create: (_) => RewardLogsCubit(profileRepository)..fetchRewardLogs(),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository())..fetchProfile(),
        ),
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
