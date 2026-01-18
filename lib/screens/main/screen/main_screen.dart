import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/login.dart';
import 'package:abu_diyab_workshop/screens/more/screen/invite_friends.dart';
import 'package:abu_diyab_workshop/screens/my_car/screen/my_cars_screen.dart';
import 'package:abu_diyab_workshop/screens/profile/screens/profile_screen.dart';
import 'package:abu_diyab_workshop/widgets/slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/Responsivemodel.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/navigation.dart';
import '../../notification/screen/notifications_screen.dart';
import '../../profile/repositorie/profile_repository.dart';
import '../../reminds/cubit/notes_details_cubit.dart';
import '../../reminds/cubit/user_car_note_cubit.dart';
import '../../reminds/cubit/user_car_note_state.dart';
import '../../reminds/screen/widget/notes_details.dart';
import '../../services/screen/search_screen.dart';
import '../cubit/services_cubit.dart';
import '../cubit/services_state.dart';
import '../model/service_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _username = 'زائر';
  String _usernameen = 'visitor';
  String? _profileImagePath;

  final Dio dio = Dio();
  List<Map<String, String>> services = [];
  bool showAllServices = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    context.read<ServicesCubit>().fetchServices();
    context.read<UserNotesCubit>().getUserNotes();
  }

  final _profileRepository = ProfileRepository();

  void _fetchUser() async {
    final user = await _profileRepository.getUserProfile();
    if (user != null) {
      setState(() {
        _username = user.name;
        _usernameen = user.name;
        _profileImagePath = user.image;
      });
    } else {
      _loadUsername();
    }
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'زائر';
      _usernameen = prefs.getString('username') ?? 'visitor';
      _profileImagePath = prefs.getString('profile_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor(context),
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
            padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (locale!.isDirectionRTL(context)
                                        ? "حيّاك $_username"
                                        : "Hello $_usernameen")
                                    .substring(
                                      0,
                                      (locale.isDirectionRTL(context)
                                                      ? "حيّاك $_username"
                                                      : "Hello $_usernameen")
                                                  .length >
                                              20
                                          ? 20
                                          : (locale.isDirectionRTL(context)
                                                  ? "حيّاك $_username"
                                                  : "Hello $_usernameen")
                                              .length,
                                    ) +
                                ((locale.isDirectionRTL(context)
                                                ? "حيّاك $_username"
                                                : "Hello $_usernameen")
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
                          //       SizedBox(height: 25.h, child: const LocationWidget()),
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
                          color: Colors.grey,
                          size: 28.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>   SearchScreen()),
                        );
                      },
                      child: Container(
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
                                  locale!.isDirectionRTL(context)
                                      ? 'ابحث عن الخدمات'
                                      : 'Search about services',

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
                            Image.asset(
                              "assets/icons/search_ai.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InviteFriends(),
                          ),
                        );
                      },
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: buttonBgWhiteColor(context),
                          border: Border.all(
                            width: 1.w,
                            color: buttonPrimaryBgColor(context),
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.h,
                              child: Icon(
                                Icons.ios_share_outlined,
                                size: 20.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              locale.isDirectionRTL(context)
                                  ? "مشاركة"
                                  : "Share",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: paragraphColor(context),
                                fontSize: 10.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color:backgroundColor(context),
        ),
        child: Padding(
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
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      children: [
                        Text(
                          locale.isDirectionRTL(context)
                              ? "الخدمات "
                              : "Services",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: headingColor(context),
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
                                  color: typographyMainColor(context),
                                  fontSize: 16.h,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                showAllServices
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: typographyMainColor(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    BlocBuilder<ServicesCubit, ServicesState>(
                      builder: (context, state) {
                        if (state is ServicesLoading) {
                          return Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 0.8,
                                  ),
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 12.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is ServicesError) {
                    //      return  Center(child: Text(state.message));
                         return const Center(child: Text('حدث خطأ ما'));
                        } else if (state is ServicesLoaded) {
                          final List<Map<String, dynamic>> allItems = [
                            ...state.products
                                .where((p) => p.status == 1)
                                .map(
                                  (p) => {
                                    'title': p.name,
                                    'icon': p.icon,
                                    'slug': p.slug,
                                    'description': p.description,
                                    'offer': p.offer,
                                  },
                                ),
                            ...state.services
                                .where((s) => s.status == 1)
                                .map(
                                  (s) => {
                                    'title': s.name,
                                    'icon': s.icon,
                                    'slug': s.slug,
                                    'description': s.description,
                                    'offer': s.offer,
                                  },
                                ),
                          ];

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                showAllServices
                                    ? allItems.length
                                    : (allItems.length > 3
                                        ? 3
                                        : allItems.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing:
                                      MediaQuery.of(context).size.width * 0.01,
                                  crossAxisSpacing:
                                      MediaQuery.of(context).size.width * 0.04,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              final item = allItems[index];
                              return _buildServiceItem(
                                title: item['title'].toString(),
                                imagePath: item['icon'].toString(),
                                slug: item['slug'].toString(),
                                description:
                                    item['description']?.toString() ?? '',
                                offer: item['offer'],
                                context: context,
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PackageScreen(),
                    //   ),
                    // );
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: false,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              height: 300.h,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  SizedBox(height: 30.h),

                                  Text(
                                    locale!.isDirectionRTL(context)
                                        ? "قريباً"
                                        : "Soon",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  SizedBox(height: 10),

                                  Text(
                                    locale!.isDirectionRTL(context)
                                        ? "انتظرونا بإصدار جديد!"
                                        : "Stay tuned for a new release!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  SizedBox(height: 25),

                                  SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5.w,
                                      color: buttonPrimaryBgColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                      child: Center(
                        child: Image.asset(
                          locale!.isDirectionRTL(context)
                              ? 'assets/images/main_pack.png'
                              : "assets/images/main_pack_en.png",
                          width: double.infinity,
                          height: 140.h,
                          fit: BoxFit.fill,
                        ),
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
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Image.asset(
                          'assets/images/notifi.png',
                          width: 25.w,
                          height: 25.h,
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: typographyMainColor(context).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.sp),
                        border: Border.all(
                          width: 2,
                          color: typographyMainColor(context),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyCarsScreen(showBack: true),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 20.sp,
                                color: typographyMainColor(context),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                locale!.isDirectionRTL(context)
                                    ? "ذكرني بصيانه سيارتي"
                                    : "Remind me about maintenance.",
                                style: TextStyle(
                                  color: typographyMainColor(context),
                                  fontSize: 18.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return BlocProvider(
                                        create:
                                            (_) =>
                                                UserNoteDetailsCubit()
                                                  ..fetchNoteDetails(note.id),
                                        child: NoteDetailsBottomSheet(
                                          noteId: note.id,
                                        ),
                                      );
                                    },
                                  );
                                },

                                child: Container(
                                  width: double.infinity,
                                  height: isTablet ? 120.h : 94.h,
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  decoration: BoxDecoration(
                                    color: buttonBgWhiteColor(context),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: strokeGrayColor(context),
                                      width: 1.50,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    note.service.name,
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
                                                  //  Image.network(
                                                  //    note.service.icon,
                                                  //    // حط لينك الصورة هنا
                                                  //    width: 22.w,
                                                  //    height: 20.h,
                                                  //    fit: BoxFit.fill,
                                                  //  ),
                                                ],
                                              ),

                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${note.userCar.carBrand.name} , ${note.userCar.carModel.name}",
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
                                                                : Colors.white,
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
                                                                : Colors.white,
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

                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.notifications_none,
                                                      size: 18.sp,
                                                      color:
                                                          typographyMainColor(
                                                            context,
                                                          ),
                                                    ),
                                                    SizedBox(width: 6.w),

                                                    Text(
                                                      note.remindMe
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
                                                                : Colors.white,
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
                                                        color:
                                                            typographyMainColor(
                                                              context,
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
                                          color: Colors.white.withOpacity(0.06),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      //
      // // Default return
      //
      //
    );
  }

  String formatNumber(String number) {
    // يحوّلها double
    double value = double.tryParse(number) ?? 0;

     if (value == value.toInt()) {
      return value.toInt().toString();
    }

     return value
        .toString()
        .replaceAll(RegExp(r"0+$"), "")
        .replaceAll(RegExp(r"\.$"), "");
  }

  Widget _buildServiceItem({
    required String title,
    required String imagePath,
    required String slug,
    required String description,
    bool isNetworkImage = true,
    required BuildContext context,
    OfferModel? offer,
  }) {
    String? offerText;
    Color badgeColor = accentColor;

    bool isPercentage = false;
    bool isFixed = false;

    if (offer != null) {
      if (offer.type == "percentage") {
        offerText = "${offer.discount}%";
        isPercentage = true;
      } else if (offer.type == "fixed") {
        offerText = offer.discount;
        isFixed = true;
      }
    }

    return GestureDetector(
      onTap: () {
        navigateToServiceScreen(
          context,
          slug,
          title,
          description,
          imagePath,
        );
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: buttonBgWhiteColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: buttonSecondaryBorderColor(context),
                    width: 1.5.sp,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 45.w,
                      height: 45.h,
                      child: isNetworkImage
                          ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            Image.asset('assets/images/water_rinse.png'),
                      )
                          : Image.asset(imagePath),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
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

          /// Badge
          if (offer != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    if (isPercentage)
                      Text(
                        offerText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isFixed) ...[
                      Text(
                        offerText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Image.asset(
                        "assets/icons/ryal.png",
                        width: 12.w,
                        height: 12.h,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

}
