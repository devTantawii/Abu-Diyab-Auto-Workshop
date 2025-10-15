import 'package:abu_diyab_workshop/core/language/locale.dart';
import 'package:abu_diyab_workshop/screens/my_car/screen/widget/details_item.dart';
import 'package:abu_diyab_workshop/screens/my_car/screen/widget/edit_car.dart';
import 'package:abu_diyab_workshop/screens/reminds/screen/remind_car_screen.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/app_bar_widget.dart';
import '../../auth/cubit/login_cubit.dart';
import '../../auth/screen/login.dart';
import '../../main/screen/main_screen.dart';
import '../cubit/all_cars_cubit.dart';
import '../cubit/all_cars_state.dart';
import '../model/all_cars_model.dart';
import 'widget/add_car.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({super.key});

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  late CarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CarCubit();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    _cubit.fetchCars(token);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        backgroundColor:
        Theme.of(context).brightness == Brightness.light
            ? Color(0xFFEAEAEA)
            : Colors.black54,
        appBar: _buildAppBar(context, locale),
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child:
          BlocBuilder<CarCubit, CarState>(
            builder: (context, state) {
              if (state is CarLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.red,
                  ),
                );
              } else if (state is CarError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      SizedBox(height: 15.h),
                      //    Text(state.message),
                      ElevatedButton(
                        onPressed: () {
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
                        child: Text(
                          locale!.isDirectionRTL(context)
                              ? "سجل الدخول مره اخري من فضلك"
                              : "Log in again please",
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CarLoaded) {
                if (state.cars.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 120.h),
                      Image.asset(
                        'assets/icons/car_gar.png',
                        width: 115.w,
                        height: 115.h,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        locale!.isDirectionRTL(context)
                            ? 'خلّي سيارتك عندنا، وريح بالك'
                            : 'Leave your car with us, and relax',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white70,
                          fontSize: 18.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        locale!.isDirectionRTL(context)
                            ? 'عشان نخدمك صح، أضف سيارتك ونوفر لك كل اللي تحتاجه من صيانة، عروض، وتذكيرات.'
                            : "To serve you properly, add your car and we will provide you with everything you need from maintenance, offers, and reminders.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                          Theme.of(context).brightness == Brightness.light
                              ? Color(0xFF474747)
                              : Colors.white54,

                          fontSize: 16.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      _addCarButton(locale!),
                    ],
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.cars.map(
                            (car) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: _carCard(context, car, true, locale!),
                        ),
                      ),
                      _addCarButton(locale!),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      AppLocalizations? locale,
      ) {
    return AppBar(
      toolbarHeight: 130.h,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Directionality(
        textDirection:
        Localizations.localeOf(context).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          decoration: buildAppBarDecoration(context),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale!.isDirectionRTL(context)
                    ? "قائمة سياراتي"
                    : "My Cars List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carCard(
      BuildContext context,
      Car car,
      bool withEditNav,
      AppLocalizations locale,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RemindCarScreen(car: car)),
        );
      },
      child: Container(
        width: double.infinity,
        height: 180.h,
        decoration: BoxDecoration(
          color:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 12,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          textDirection:
          locale.isDirectionRTL(context)
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            Column(
              children: [
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 50.h,
                          left: 8.w,
                          right: 8.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6.h),
                            DetailItem(
                              labelAr: 'ماركــة السيـــارة:',
                              value: car.carBrand.name ?? '',
                              labelEn: 'car brand :',
                            ),
                            DetailItem(
                              labelAr: 'موديل السيـــارة:',
                              value: car.carModel.name ?? '',
                              labelEn: 'Car Model :',
                            ),
                            DetailItem(
                              labelAr: 'سنة الصنع:',
                              value: car.year?.toString() ?? '',
                              labelEn: 'Year :',
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                if (withEditNav) {
                                  // فتح شاشة التعديل وانتظار النتيجة
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditCar(carId: car.id),
                                    ),
                                  );

                                  // إذا تم الحذف، نعيد تحميل السيارات
                                  if (result == 'deleted' ||
                                      result == 'updated') {
                                    _loadCars(); // ⬅️ ريفريش في الحالتين
                                  }
                                }
                              },
                              child: Image.asset(
                                'assets/icons/edit.png',
                                height: 35.h,
                                width: 35.w,
                              ),
                            ),
                          ),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                width: 102.w,
                                height: 90.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      car.carBrand.icon ?? '',
                                    ),
                                    fit: BoxFit.contain,
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
                Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1B1B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        locale!.isDirectionRTL(context)
                            ?'رقم اللوحة :'
                            : "Plate number :",                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      SizedBox(width: 70.w),
                      Text(
                        car.licencePlate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 105.w,
                height: 50.h,
                padding: EdgeInsets.all(10.w),
                decoration: ShapeDecoration(
                  color: const Color(0xFFBA1B1B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    car.name ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addCarButton(AppLocalizations locale) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCar()),
        );

        if (result == true) {
          // ⬅️ اعمل ريفريش للبيانات
          _loadCars();
        }
      },
      child: Container(
        width: 226.w,
        height: 50.h,
        padding: EdgeInsets.all(10.w),
        decoration: ShapeDecoration(
          color: const Color(0xFFBA1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Center(
          child: Text(
            locale.isDirectionRTL(context)
                ? "أضف سيارتي الآن +"
                : "Add a new car +",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}