import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/cubit/login_cubit.dart';
import '../../auth/screen/login.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../repositorie/profile_repository.dart';
import '../model/user_model.dart';

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
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.h,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: 130.h,
              padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBA1B1B), Color(0xFFD27A7A)],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'الملف الشخصي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              final user = state.user;
              _firstNameController.text = user.name.split(" ").first;
              _lastNameController.text = user.name.split(" ").skip(1).join(" ");
              _phoneController.text = user.phone;
            }
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم تحديث البيانات بنجاح ✅")),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded || state is ProfileUpdating) {
              final user =
                  (state is ProfileLoaded)
                      ? state.user
                      : (state as ProfileUpdating).user;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // صورة البروفايل
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
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'اختيار من المعرض',
                                      style: TextStyle(fontSize: 16),
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
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'التقاط صورة بالكاميرا',
                                      style: TextStyle(fontSize: 16),
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
                          // الدائرة مع بوردر متدرج وظل
                          Container(
                            width: 140.r,
                            height: 140.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey,
                                  Colors.grey,
                                ],
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
                              // سمك البوردر الداخلي
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
                                color: Color(0xFFBA1B1B),

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
                              'الإسم الأول',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
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
                                // محاذاة النص لليمين
                                textAlignVertical: TextAlignVertical.center,
                                // يجعل النص في منتصف ارتفاع الحاوية
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
                                  // إزالة padding عمودي زائد
                                  border: InputBorder.none,
                                  isCollapsed: true, // يساعد على تمركز النص
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
                              'الإسم الثاني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),SizedBox(
                              height: 5.h,
                            ),
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
                                // محاذاة النص لليمين
                                textAlignVertical: TextAlignVertical.center,
                                // يجعل النص في منتصف ارتفاع الحاوية
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
                                  // إزالة padding عمودي زائد
                                  border: InputBorder.none,
                                  isCollapsed: true, // يساعد على تمركز النص
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // الاسم الثاني

                    SizedBox(height: 12.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(
                        'رقم الجوال',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),SizedBox(
                        height: 5.h,
                      ),
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
                            enabled: false, // يجعل الحقل غير قابل للتحرير
                            textAlign: TextAlign.start, // الرقم على اليسار
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Color(0xFF707070),
                              fontSize: 13.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                              border: InputBorder.none,
                              isCollapsed: true,
                              suffixIcon: Icon(
                                Icons.lock,
                                size: 20.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // زر التحديث
                    ElevatedButton.icon(
                      onPressed: () {
                        print('firstName: ${_firstNameController.text}');
                        print('lastName: ${_lastNameController.text}');
                        print('phone: ${_phoneController.text}');
                        print('imageFile: ${_pickedImage?.path}');

                        context.read<ProfileCubit>().updateProfile(
                          id: user.id,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          imageFile: _pickedImage,
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("تحديث"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48.h),
                      ),
                    ),
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
                          // إعادة المحاولة لجلب البيانات
                          context.read<ProfileCubit>().fetchProfile();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text("حاول مرة أخرى"),
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
      ),
    );
  }
}
