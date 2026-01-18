import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../auth/cubit/login_cubit.dart';
import '../../auth/screen/login.dart';
import '../../home/screen/home_screen.dart';
import '../../main/screen/main_screen.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../repositorie/profile_repository.dart';
import '../widget/change_pass.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..fetchProfile(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(

          appBar: CustomGradientAppBar(
            title_ar: 'الملف الشخصي',
            title_en: "profile",
            onBack: () => Navigator.pop(context),
          ),
          body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                final user = state.user;
                _firstNameController.text = user.name.split(" ").first;
                _lastNameController.text = user.name
                    .split(" ")
                    .skip(1)
                    .join(" ");
                _phoneController.text = user.phone;
              }
              if (state is ProfileUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      locale!.isDirectionRTL(context)
                          ? "تم تحديث البيانات بنجاح ✅"
                          : "Data updated successfully ✅",
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is ProfileDeleted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("تم حذف الحساب بنجاح")));

                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.r),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          width: double.infinity,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          width: double.infinity,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileLoaded || state is ProfileUpdating) {
                final user =
                    (state is ProfileLoaded)
                        ? state.user
                        : (state as ProfileUpdating).user;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.photo_library,
                                        color: buttonPrimaryBgColor(context),
                                      ),
                                      title: Text(
                                        locale!.isDirectionRTL(context)
                                            ? 'اختيار من المعرض'
                                            : 'Selection from the gallery',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontFamily: 'Graphik Arabic',
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        final picker = ImagePicker();
                                        final picked = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _pickedImage = File(picked.path);
                                          });
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.camera_alt,
                                        color: buttonPrimaryBgColor(context),
                                      ),
                                      title: Text(
                                        locale!.isDirectionRTL(context)
                                            ? 'التقاط صورة بالكاميرا'
                                            : 'Take a picture with the camera',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontFamily: 'Graphik Arabic',
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        final picker = ImagePicker();
                                        final picked = await picker.pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _pickedImage = File(picked.path);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 140.r,
                              height: 140.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.grey, Colors.grey],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),

                                child: CircleAvatar(
                                  radius: 65.r,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage:
                                      _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : (user.image != null &&
                                                  user.image!.isNotEmpty
                                              ? NetworkImage(user.image!)
                                                  as ImageProvider
                                              : null),
                                  child:
                                      (_pickedImage == null &&
                                              (user.image == null ||
                                                  user.image!.isEmpty))
                                          ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey.shade600,
                                          )
                                          : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: buttonPrimaryBgColor(context),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale!.isDirectionRTL(context)
                                    ? 'الإسم الأول'
                                    : "First name",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: headingColor(context),
                                  fontSize: 13.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                width: 165.w,
                                height: 45.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5.w,
                                      color: Color(0xFFA4A4A4),
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: TextField(
                                  controller: _firstNameController,
                                  textAlign: TextAlign.right,

                                  textAlignVertical: TextAlignVertical.center,

                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontSize: 13.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),

                                    border: InputBorder.none,
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale!.isDirectionRTL(context)
                                    ? 'الإسم الثاني'
                                    : "Last name",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: headingColor(context),

                                  fontSize: 13.sp,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                width: 165.w,
                                height: 45.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5.w,
                                      color: Color(0xFFA4A4A4),
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: TextField(
                                  controller: _lastNameController,
                                  textAlign: TextAlign.right,

                                  textAlignVertical: TextAlignVertical.center,

                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontSize: 13.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),

                                    border: InputBorder.none,
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                      SizedBox(height: 12.h),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale!.isDirectionRTL(context)
                                ? 'رقم الجوال'
                                : "Mobile number",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: headingColor(context),

                              fontSize: 13.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: double.infinity,
                            height: 45.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.5.w,
                                  color: Color(0xFFA4A4A4),
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: TextField(
                              controller: _phoneController,
                              enabled: false,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                color: Color(0xFF707070),
                                fontSize: 13.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                border: InputBorder.none,
                                isCollapsed: true,
                                // suffixIcon: Icon(
                                //   Icons.lock,
                                //   size: 20.sp,
                                //   color: Colors.grey,
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                      ChangePasswordWidget(),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 60),
                        SizedBox(height: 12.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
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
                          icon: Icon(Icons.refresh),
                          label: Text(
                            locale!.isDirectionRTL(context)
                                ? "حاول مرة أخرى"
                                : "Try again",
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150.w, 48.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded || state is ProfileUpdating) {
                final user = (state is ProfileLoaded)
                    ? state.user
                    : (state as ProfileUpdating).user;
                final isLoading = state is ProfileUpdating;

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: ShapeDecoration(
                    color: buttonBgWhiteColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            context.read<ProfileCubit>().updateProfile(
                              id: user.id,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              imageFile: _pickedImage,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonPrimaryBgColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                            height: 22.h,
                            width: 22.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            locale!.isDirectionRTL(context) ? "تحديث" : "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50.h,

                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    locale!.isDirectionRTL(context)
                                        ? "هل أنت متأكد؟"
                                        : "Are you sure?",
                                  ),
                                  content: Text(
                                    locale.isDirectionRTL(context)
                                        ? "سيتم حذف حسابك بشكل نهائي ولا يمكن التراجع."
                                        : "Your account will be deleted permanently.",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        locale.isDirectionRTL(context) ? "إلغاء" : "Cancel",
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: Text(
                                        locale.isDirectionRTL(context) ? "حذف" : "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.read<ProfileCubit>().deleteAccount();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: buttonPrimaryBgColor(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            locale!.isDirectionRTL(context) ? "حذف الحساب" : "Delete Account",
                            style: TextStyle(
                              color: buttonPrimaryBgColor(context),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
