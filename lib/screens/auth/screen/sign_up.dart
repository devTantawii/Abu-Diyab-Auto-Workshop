import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/login_cubit.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../model/register_request_model.dart';
import '../widget/build_label.dart';
import '../widget/support_bottom_sheet.dart';
import 'login.dart';
import 'otp.dart';

class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({Key? key}) : super(key: key);

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _name2Controller.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return _isArabic(context)
          ? "يرجى إدخال رقم الهاتف"
          : "Please enter phone number";
    }
    if (value.length < 9 || value.length > 15) {
      return _isArabic(context)
          ? "رقم الهاتف غير صحيح"
          : "Invalid phone number";
    }
    return null;
  }

  bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabic(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FractionallySizedBox(
        widthFactor: 1, // عرض كامل
        child: BlocProvider(
          create: (_) => RegisterCubit(dio: Dio()),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder:
                      (context) => FractionallySizedBox(
                        widthFactor: 1,
                        child: OtpBottomSheet(phone: _phoneController.text),
                      ),
                );
              } else if (state is RegisterFailure) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(" خطأ"),
                    content: Text(state.error), // أو state.msg حسب اللي معرفه
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("موافق"),
                      ),
                    ],
                  ),
                );
              }


            },
            builder: (context, state) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors. white
                        : Colors. black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'انضم إلينا الآن !' : 'Join us now!',
                              style: TextStyle(
                                color:Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              isArabic
                                  ? 'يرجى إنشاء حساب لتتمكن من تقديم طلب جديد 🚀'
                                  : 'Please create an account to place a new request 🚀',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ?  Colors.black.withOpacity(0.7)
                                    : Colors.white,
                                fontSize: 14.h,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            build_label(text: isArabic ? 'الإسم الأول' : 'Frist Name'),
                            _buildTextField(
                              controller: _nameController,
                              hint: isArabic ? "XXXX " : "John Doe",
                              textInputType: TextInputType.name,
                            ),
                            SizedBox(height: 15.h),

                            build_label(text: isArabic ? 'اسم العائله' : 'Family Name'),
                            _buildTextField(
                              controller: _name2Controller,
                              hint: isArabic ? "XXXX " : "John Doe",
                              textInputType: TextInputType.name,
                            ),
                            SizedBox(height: 15.h),

                            build_label(
                              text: isArabic ? 'رقم الهاتف' : 'Phone Number',
                            ),
                            _buildTextField(
                              controller: _phoneController,
                              hint: isArabic ? "5XXXXXXX" : "5XXXXXXX",
                              textInputType: TextInputType.phone,
                              maxLength: 15,
                              validator: _validatePhone,
                            ),
                            SizedBox(height: 15.h),

                            build_label(
                              text: isArabic ? 'كلمة المرور' : 'Password',
                            ),
                            _buildTextField(
                              controller: _passwordController,
                              hint: "********",
                              textInputType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isArabic
                                      ? "يرجى إدخال كلمة المرور"
                                      : "Please enter password";
                                }
                                if (value.length < 6) {
                                  return isArabic
                                      ? "كلمة المرور يجب أن تكون 6 أحرف على الأقل"
                                      : "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),

                            SizedBox(
                              height: 50.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state is RegisterLoading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final model = RegisterRequestModel(
                                              name: _nameController.text.trim(),
                                              name2: _name2Controller.text.trim(),
                                              phone:
                                                  _phoneController.text.trim(),
                                              password:
                                                  _passwordController.text
                                                      .trim(),
                                            );
                                            context
                                                .read<RegisterCubit>()
                                                .register(model);
                                          }
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFBA1B1B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child:
                                    state is RegisterLoading
                                        ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : Text(
                                          isArabic
                                              ? 'أنشئ حسابك'
                                              : 'Create Account',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                              ),
                            ),

                            SizedBox(height: 10.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isArabic
                                      ? 'عندك حساب ؟ '
                                      : 'Already have an account? ',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 15.h,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder:
                                              (context) => FractionallySizedBox(
                                                widthFactor: 1,
                                                child: BlocProvider(
                                                  create:
                                                      (_) => LoginCubit(
                                                        dio: Dio(),
                                                      ),
                                                  child:
                                                      const LoginBottomSheet(),
                                                ),
                                              ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    isArabic ? 'سجّل دخولك' : 'Login',
                                    style: TextStyle(
                                      color: const Color(0xFFBA1B1B),
                                      fontSize: 16.h,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Text(
                                      isArabic ? "أو" : "OR",
                                      style: GoogleFonts.almarai(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/technical-support.png',
                                  height: 22.h,
                                  width: 22.w,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder:
                                          (context) => FractionallySizedBox(
                                            widthFactor: 1,
                                            child: const SupportBottomSheet(),
                                          ),
                                    );
                                  },
                                  child: Text(
                                    isArabic
                                        ? 'تواصل معنا لو تبي مساعدة'
                                        : 'Contact us for support',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFFBA1B1B),
                                      fontSize: 16.h,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType textInputType,
    String? Function(String?)? validator,
    int? maxLength,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText,
      inputFormatters:
          maxLength != null
              ? [LengthLimitingTextInputFormatter(maxLength)]
              : null,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        hintStyle: GoogleFonts.almarai(fontSize: 14.sp, color:  Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
