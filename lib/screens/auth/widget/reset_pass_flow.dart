import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class ResetPasswordFlow {
  // 📌 BottomSheet رقم الهاتف
  void showPhoneBottomSheet(BuildContext context) {
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is RequestResetSuccess) {
              Navigator.pop(context);
              showOtpBottomSheet(context, phoneController.text.trim());
            } else if (state is RequestResetFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20.w,
                right: 20.w,
                top: 30.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "إعادة تعيين كلمة المرور",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Graphik Arabic',
                      color: Color(0xFFBA1B1B),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontFamily: 'Graphik Arabic', fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: "رقم الهاتف",
                      hintStyle: TextStyle(
                        fontFamily: 'Graphik Arabic',
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B), width: 2.w),
                      ),
                      prefixIcon: Icon(Icons.phone, color: Color(0xFFBA1B1B), size: 20.sp),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      backgroundColor: Color(0xFFBA1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: state is RequestResetLoading
                        ? null
                        : () async {
                      try {
                        if (phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "يرجى إدخال رقم الهاتف",
                                style: TextStyle(fontFamily: 'Graphik Arabic'),
                              ),
                            ),
                          );
                          return;
                        }

                        await context.read<LoginCubit>().requestResetPassword(
                          phoneController.text.trim(),
                        );
                      } catch (e) {
                        String errorMessage = "حدث خطأ غير متوقع";
                        if (e is DioError) errorMessage = e.message!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage, style: TextStyle(fontFamily: 'Graphik Arabic'))),
                        );
                      }
                    },
                    child: state is RequestResetLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "إرسال الكود",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Graphik Arabic',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 📌 BottomSheet OTP
  void showOtpBottomSheet(BuildContext context, String phone) {
    final otpControllers = List.generate(4, (_) => TextEditingController());
    final focusNodes = List.generate(4, (_) => FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is VerifyResetSuccess) {
              Navigator.pop(context);
              showNewPasswordBottomSheet(context, phone);
            } else if (state is VerifyResetFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20.w,
                right: 20.w,
                top: 30.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحققنا منك بس باقي خطوة ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'ادخل الكود اللي أرسلناه على رقمك ',
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: phone,
                          style: TextStyle(
                            color: const Color(0xFFBA1B1B),
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: TextDirection.ltr,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 45.w,
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          autofocus: index == 0,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Graphik Arabic',
                            color: Color(0xFFBA1B1B),
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Color(0xFFBA1B1B)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Color(0xFFBA1B1B), width: 2.w),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 25.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      backgroundColor: Color(0xFFBA1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: state is VerifyResetLoading
                        ? null
                        : () async {
                      try {
                        String otp = otpControllers.map((c) => c.text).join();
                        if (otp.length < 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("أدخل الكود كاملاً", style: TextStyle(fontFamily: 'Graphik Arabic'))),
                          );
                          return;
                        }

                        await context.read<LoginCubit>().verifyResetPassword(phone, otp);
                      } catch (e) {
                        String errorMessage = "حدث خطأ غير متوقع";
                        if (e is DioError) errorMessage = e.message!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage, style: TextStyle(fontFamily: 'Graphik Arabic'))),
                        );
                      }
                    },
                    child: state is VerifyResetLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "تأكيد",
                      style: TextStyle(
                        fontFamily: 'Graphik Arabic',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 📌 BottomSheet كلمة المرور الجديدة
  void showNewPasswordBottomSheet(BuildContext context, String phone) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is SubmitNewPasswordSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("تم تغيير كلمة المرور بنجاح", style: TextStyle(fontFamily: 'Graphik Arabic'))),
              );
            } else if (state is SubmitNewPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message, style: TextStyle(fontFamily: 'Graphik Arabic'))),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20.w,
                right: 20.w,
                top: 30.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "أدخل كلمة المرور الجديدة",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Graphik Arabic',
                      color: Color(0xFFBA1B1B),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontFamily: 'Graphik Arabic', fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: "كلمة المرور",
                      hintStyle: TextStyle(fontFamily: 'Graphik Arabic', fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B), width: 2.w),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color(0xFFBA1B1B), size: 20.sp),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    style: TextStyle(fontFamily: 'Graphik Arabic', fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: "تأكيد كلمة المرور",
                      hintStyle: TextStyle(fontFamily: 'Graphik Arabic', fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Color(0xFFBA1B1B), width: 2.w),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFBA1B1B), size: 20.sp),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      backgroundColor: Color(0xFFBA1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: state is SubmitNewPasswordLoading
                        ? null
                        : () async {
                      try {
                        if (passwordController.text.trim().isEmpty ||
                            confirmPasswordController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("املأ كل الحقول", style: TextStyle(fontFamily: 'Graphik Arabic'))),
                          );
                          return;
                        }
                        if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("كلمتا المرور غير متطابقتين", style: TextStyle(fontFamily: 'Graphik Arabic'))),
                          );
                          return;
                        }
                        await context.read<LoginCubit>().submitNewPassword(
                          phone,
                          passwordController.text.trim(),
                          confirmPasswordController.text.trim(),
                        );
                      } catch (e) {
                        String errorMessage = "حدث خطأ غير متوقع";
                        if (e is DioError) errorMessage = e.message!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage, style: TextStyle(fontFamily: 'Graphik Arabic'))),
                        );
                      }
                    },
                    child: state is SubmitNewPasswordLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "حفظ",
                      style: TextStyle(
                        fontFamily: 'Graphik Arabic',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
