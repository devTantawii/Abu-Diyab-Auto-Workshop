import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/screen/home_screen.dart';

class OtpBottomSheet extends StatefulWidget {
  final String phone;

  const OtpBottomSheet({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;

  Future<void> _verifyCode() async {
    if (_codeController.text.trim().length != 6) return;

    setState(() => _loading = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://devworkshop.abudiyabksa.com/api/verify-phone',
        data: {
          'phone': widget.phone,
          'code': _codeController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final token = response.data["token"];
        final user = response.data["user"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user["name"] ?? 'زائر');
        await prefs.setString('token', token);
        await prefs.setBool('is_logged_in', true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم التحقق بنجاح 🎉")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("رمز التحقق غير صحيح أو حدث خطأ")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
//687390

      @override
      Widget build(BuildContext context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              decoration: const ShapeDecoration(
                color: Color(0xFFEAEAEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 16,
                    offset: Offset(0, 2),
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // زر الإغلاق
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBA1B1B),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // العنوان
                  Text(
                    'تحققنا منك بس باقي خطوة',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // الشرح
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'دخل الكود اللي أرسلناه على رقمك ',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: widget.phone,
                          style: const TextStyle(
                            color: Color(0xFFBA1B1B),
                            fontSize: 12,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // مربعات الكود + حقل مخفي
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 48,
                              height: 63,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0x7FBA1B1B),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                index < _codeController.text.length
                                    ? _codeController.text[index]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // حقل الإدخال غير مرئي
                      Positioned.fill(
                        child: TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          onChanged: (_) => setState(() {}),
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(color: Colors.transparent),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h), // المسافة بين الكود والزر

                  // زر التحقق
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _codeController.text.length == 6 && !_loading
                          ? _verifyCode
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBA1B1B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                          : Text(
                        'تأكيد الرمز',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

  }

