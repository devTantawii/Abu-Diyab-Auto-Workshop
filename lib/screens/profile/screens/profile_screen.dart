import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/language/locale.dart';
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
      child: Scaffold(
        appBar:  CustomGradientAppBar(
          title_ar:  'الملف الشخصي',
          title_en: "profile",
          onBack: () => Navigator.pop(context),
        ),
      /*  appBar: AppBar(
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
                      locale!.isDirectionRTL(context)
                          ? 'الملف الشخصي'
                          : "profile",

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
        ),*/
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
                SnackBar(
                  content: Text(
                    locale!.isDirectionRTL(context)
                        ? "تم تحديث البيانات بنجاح ✅"
                        : "Data updated successfully ✅",
                  ),
                ),
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
                                      color: Color(0xFFBA1B1B),
                                    ),
                                    title: Text(
                                      locale!.isDirectionRTL(context)
                                          ? 'اختيار من المعرض'
                                          : 'Selection from the gallery',
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
                                      color: Color(0xFFBA1B1B),
                                    ),
                                    title: Text(
                                      locale!.isDirectionRTL(context)
                                          ? 'التقاط صورة بالكاميرا'
                                          : 'Take a picture with the camera',
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
                              locale!.isDirectionRTL(context)
                                  ? 'الإسم الأول'
                                  : "First name",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
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
                                color: Colors.black,
                                fontSize: 13,
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

                    // الاسم الثاني
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
                            color: Colors.black,
                            fontSize: 13,
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
                            // يجعل الحقل غير قابل للتحرير
                            textAlign: TextAlign.start,
                            // الرقم على اليسار
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
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        width: 350,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFBA1B1B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          locale!.isDirectionRTL(context) ? 'تحديث' : "Update",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
                          context.read<ProfileCubit>().fetchProfile();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text(
                          locale!.isDirectionRTL(context)
                              ? "حاول مرة أخرى"
                              : "Try again",),
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
