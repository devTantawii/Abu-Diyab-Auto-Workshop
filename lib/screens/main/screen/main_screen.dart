import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/login.dart';
import 'package:abu_diyab_workshop/screens/profile/screens/profile_screen.dart';
import 'package:abu_diyab_workshop/screens/services/screen/change_battery.dart';
import 'package:abu_diyab_workshop/screens/services/screen/change_oil.dart';
import 'package:abu_diyab_workshop/widgets/location.dart';
import 'package:abu_diyab_workshop/widgets/slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/Responsivemodel.dart';
import '../../../core/language/locale.dart';

import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/navigation.dart';
import '../../reminds/cubit/user_car_note_cubit.dart';
import '../../reminds/cubit/user_car_note_state.dart';
import '../../reminds/screen/remind_car_screen.dart';
import '../../services/screen/car_check.dart';
import '../../services/screen/change_tire.dart';
import '../../services/screen/washing.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../cubit/services_cubit.dart';
import '../cubit/services_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _username = 'زائر';
  String? _profileImagePath; // لإضافة رابط صورة البروفايل

  final Dio dio = Dio();
  List<Map<String, String>> services = [];
  bool showAllServices = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    context.read<ServicesCubit>().fetchServices();
    context.read<UserNotesCubit>().getUserNotes();

  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'زائر';
      _profileImagePath = prefs.getString(
        'profile_image',
      ); // لو خزنت الرابط عند التحديث
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
      appBar: AppBar(
        toolbarHeight: Responsive.h(context, 150, 200),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');

                        if (token != null && token.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          ).then((_) {
                            // لما ترجع من ProfileScreen، نعيد تحميل الاسم والصورة
                            _loadUsername();
                          });
                        } else {
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
                        }
                      },
                      child: Container(
                        height: Responsive.h(context, 48, 60),
                        width: Responsive.w(context, 48, 60),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              _profileImagePath != null &&
                                      _profileImagePath!.isNotEmpty
                                  ? NetworkImage(_profileImagePath!)
                                  : const AssetImage(
                                        'assets/images/profile_image.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (locale!.isDirectionRTL(context)
                                        ? "هلا $_username"
                                        : "Hello $_username")
                                    .substring(
                                      0,
                                      (locale!.isDirectionRTL(context)
                                                      ? "هلا $_username"
                                                      : "Hello $_username")
                                                  .length >
                                              20
                                          ? 20
                                          : (locale!.isDirectionRTL(context)
                                                  ? "هلا $_username"
                                                  : "Hello $_username")
                                              .length,
                                    ) +
                                ((locale!.isDirectionRTL(context)
                                                ? "هلا $_username"
                                                : "Hello $_username")
                                            .length >
                                        20
                                    ? "..."
                                    : ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 4.h),
                          SizedBox(height: 25.h, child: const LocationWidget()),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: ShapeDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Colors.black.withValues(alpha: 0.50),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          size: 28.sp,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      width: 282.w,
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: ShapeDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.5,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10.w),
                              Text(
                                'ابحث عن الخدمات',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                        border: Border.all(
                          width: 1.w, // responsive border
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ), // responsive radius
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: Icon(
                              Icons.ios_share_outlined,
                              size: 20.sp, // responsive icon size
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xFF474747)
                                      : Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h), // responsive spacing
                          Text(
                            'مشاركة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFBA1B1B),
                              fontSize: 10.sp, // responsive font size
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ServicesError) {
            print(state.message);
            return Center(child: Text(state.message));
          } else if (state is ServicesLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ImageSlider(),
                    SizedBox(height: 15.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection:
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                          children: [
                            Text(
                              locale.isDirectionRTL(context)
                                  ? "الخدمات "
                                  : "Services",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                fontSize: 20.sp,
                                fontFamily: 'GraphikArabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAllServices = !showAllServices;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    showAllServices
                                        ? (locale.isDirectionRTL(context)
                                            ? "إخفاء"
                                            : "Hide")
                                        : (locale.isDirectionRTL(context)
                                            ? "عرض الكل"
                                            : "Show All"),
                                    style: TextStyle(
                                      color: const Color(0xFFBA1B1B),
                                      fontSize: 16.h,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    showAllServices
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Color(0xFFBA1B1B),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              showAllServices
                                  ? state.services.length
                                  : (state.services.length > 3
                                      ? 3
                                      : state.services.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing:
                                    MediaQuery.of(context).size.width *
                                    0.01, // نسبة من العرض
                                crossAxisSpacing:
                                    MediaQuery.of(context).size.width *
                                    0.04, // نسبة من العرض
                                childAspectRatio: 1,
                              ),

                          itemBuilder: (context, index) {
                            final service = state.services[index];
                            return _buildServiceItem(
                              title: service.title,
                              imagePath: service.image,
                              serviceId: service.id,
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                        Center(
                          child: Image.asset(
                            'assets/images/main_pack.png',
                            width: double.infinity,
                            height: 140.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Text(
                              locale.isDirectionRTL(context)
                                  ? 'الصيانات القادمة'
                                  : "Upcoming maintenance",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset(
                              'assets/images/notifi.png',
                              width: 24.w,
                              height: 24.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          height: isTablet ? 140.h : 100.h,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(12.sp),
                            border: Border.all(
                              width: 1,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: GestureDetector(
                              ///
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/mintance_backg.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    locale.isDirectionRTL(context)
                                        ? "ذكّرني بصيانة سيارتي +"
                                        : "maintenance my car +",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        BlocBuilder<UserNotesCubit, UserNotesState>(
                          builder: (context, state) {
                            if (state is UserNotesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is UserNotesLoaded) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.notes.length,
                                itemBuilder: (context, index) {
                                  final note = state.notes[index];
                                  return Container(
                                    width: double.infinity,
                                    height: isTablet ? 120.h : 94.h,
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.white
                                              : Colors.black,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.transparent,
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 12.r,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      textDirection:
                                          Localizations.localeOf(
                                                    context,
                                                  ).languageCode ==
                                                  'ar'
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 10.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // السطر الأول (Change Tires + أيقونة)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      note.service!.name,
                                                      style: TextStyle(
                                                        color:
                                                            Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Colors.black
                                                                : Colors.white,
                                                        fontSize: 14.sp,
                                                        fontFamily:
                                                            'Graphik Arabic',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Image.network(
                                                      note.service!.icon,
                                                      // حط لينك الصورة هنا
                                                      width: 22.w,
                                                      height: 20.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ],
                                                ),

                                                // السطر الثاني (البراند والموديل والسنة)
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${note.userCar!.carBrand.name} , ${note.userCar!.carModel.name}",
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                      .withValues(
                                                                        alpha:
                                                                            0.70,
                                                                      )
                                                                  : Colors
                                                                      .white,
                                                          fontSize: 14.sp,
                                                          fontFamily:
                                                              'Graphik Arabic',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.60,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        note.userCar.year,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                      .withValues(
                                                                        alpha:
                                                                            0.70,
                                                                      )
                                                                  : Colors
                                                                      .white,
                                                          fontSize: 14.sp,
                                                          fontFamily:
                                                              'Graphik Arabic',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.60,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // السطر الثالث (التاريخ + التنبيه)
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .notifications_none,
                                                        size: 18,
                                                        color: Colors.red,
                                                      ),
                                                      Text(
                                                        // مجرد مثال بالتاريخ، ممكن تجيب من createdAt أو updatedAt
                                                        note.remindMe!
                                                            .split(" ")
                                                            .first,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                          fontSize: 14.21.sp,
                                                          fontFamily:
                                                              'Graphik Arabic',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.60,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        locale.isDirectionRTL(
                                                              context,
                                                            )
                                                            ? "صيانتك بعد ${note.daysAgo} أيام"
                                                            : "Your maintenance after ${note.daysAgo} days",
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFFBA1B1B,
                                                          ),
                                                          fontSize: 16.sp,
                                                          fontFamily:
                                                              'Graphik Arabic',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.60,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // لوجو العربية
                                        Container(
                                          width: 99.w,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.06,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.r),
                                              bottomLeft: Radius.circular(12.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.network(
                                              note.userCar.carBrand.icon,
                                              fit: BoxFit.contain,
                                              width: 40.w,
                                              height: 40.h,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons.directions_car,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (state is UserNotesError) {
                              return const SizedBox.shrink();
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),

                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          height: isTablet ? 120.h : 94.h,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.transparent,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12.r,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            textDirection:
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            locale.isDirectionRTL(context)
                                                ? "تغيير إطارات "
                                                : "Change tires",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Image.asset(
                                            "assets/icons/tire1.png",
                                            width: 22.w,
                                            height: 20.h,
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            locale.isDirectionRTL(context)
                                                ? 'جيلي , إمجراند'
                                                : "Geely, Emgrand",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black.withValues(
                                                        alpha: 0.70,
                                                      )
                                                      : Colors.white,

                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                              height: 1.60,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            '2024',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black.withValues(
                                                        alpha: 0.70,
                                                      )
                                                      : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                              height: 1.60,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.notifications_none,
                                              size: 18.sp,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              '17 / 9 / 2025',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.light
                                                        ? Colors.black
                                                        : Colors.white,
                                                fontSize: 14.21.sp,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w500,
                                                height: 1.60,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              locale.isDirectionRTL(context)
                                                  ? "صيانتك بعد 5 أيام"
                                                  : "Your maintenance after 5 days",
                                              style: TextStyle(
                                                color: const Color(0xFFBA1B1B),
                                                fontSize: 16.sp,
                                                fontFamily: 'Graphik Arabic',
                                                fontWeight: FontWeight.w600,
                                                height: 1.60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: 99.w,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/icons/car_logo.png",
                                    // width: 40.w, // حجم مناسب - تقدر تعدّله حسب الحاجة
                                    // height: 40.h,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox(); // Default return
        },
      ),
    );
  }

  Widget _buildServiceItem({
    required String title,
    required String imagePath,
    int? serviceId,
  }) {
    final isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        if (token != null && token.isNotEmpty) {
          // لو عنده توكين
          navigateToServiceScreen(context, serviceId, title);
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => FractionallySizedBox(
                  widthFactor: 1,
                  child: BlocProvider(
                    create: (_) => LoginCubit(dio: Dio()),
                    child: const LoginBottomSheet(),
                  ),
                ),
          );
        }
      },

      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.white,
                width: 1.5.sp,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45.w,
                  height: 45.h,
                  child:
                      isNetworkImage
                          ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/images/water_rinse.png',
                                ),
                          )
                          : Image.asset(imagePath, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1, // أقصى عدد أسطر
                  overflow: TextOverflow.ellipsis, // يحط "…" في الآخر
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                    fontSize: 14.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
}
