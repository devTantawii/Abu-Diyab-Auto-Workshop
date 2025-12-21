import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/langCode.dart';
import '../../../core/language/locale.dart';
import '../../home/screen/home_screen.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return;
    }

    try {

      final dio = Dio();
      final response = await dio.post(
        mainApi + logoutApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            "Accept-Language": langCode == '' ? "en" : langCode
          },
        ),
      );

      print("📩 Status Code: ${response.statusCode}");
      print("📩 Response Data: ${response.data}");

      if (response.statusCode == 200 &&
          (response.data['status'] == 200 || response.data['status'] == 'success')) {
        await prefs.clear();

        print("✅ تم تسجيل الخروج بنجاح ومسح البيانات المحلية.");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الخروج بنجاح ✅')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
      } else {
        final msg = response.data['msg'] ?? 'فشل تسجيل الخروج';
        print("⚠️ فشل تسجيل الخروج: $msg");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } on DioError catch (dioError) {
      print("❌ DioError: ${dioError.message}");
      if (dioError.response != null) {
        print("📩 DioError Response: ${dioError.response?.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              dioError.response?.data['msg'] ?? 'خطأ من السيرفر أثناء تسجيل الخروج',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('مشكلة في الاتصال بالسيرفر')),
        );
      }
    } catch (e, stack) {
      print("❌ استثناء غير متوقع: $e");
      print("📝 Stacktrace: $stack");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ غير متوقع أثناء تسجيل الخروج')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration:  BoxDecoration(
        color:Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.sp),
          topRight: Radius.circular(25.sp),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           SizedBox(height: 12.h),
           Text(
             locale!.isDirectionRTL(context) ? 'تسجيل الخروج ؟' : 'Log out?',

            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
              color:Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 130.w,
            height: 130.h,
            decoration: const BoxDecoration(
              color: Color(0xFFA9A9A9),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child:  Text(
              '👋',
              style: TextStyle(fontSize: 60.sp),
            ),
          ),
           SizedBox(height: 30.h),
           Text(
             locale.isDirectionRTL(context) ? 'هل أنت متأكد من رغبتك في تسجيل الخروج ؟' : 'Are you sure you want to log out?',
             textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color:Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
            ),
          ),
          const SizedBox(height: 30),
          Row(
            textDirection: locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
            children: [
              Expanded(
                flex: 5 ,
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:typographyMainColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(locale.isDirectionRTL(context) ? 'نعم، تسجيل الخروج' : 'Yes, log out',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Graphik Arabic',
                    ),
                  ),
                ),
              ),
               SizedBox(width: 4.w),
              Expanded(
                flex: 4,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side:  BorderSide(color: strokeGrayColor(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    locale.isDirectionRTL(context) ? 'لا، تراجع' : 'No, step back',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Graphik Arabic',
                    ),
                  ),
                ),
              ),
            ],
          ),
           SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
