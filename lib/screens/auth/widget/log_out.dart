import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/screen/home_screen.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("⚠️ لا يوجد توكن محفوظ، المستخدم غير مسجل دخول.");
      return;
    }

    try {
      print("📡 جاري محاولة تسجيل الخروج...");
      print("🔑 التوكن المرسل: $token");

      final dio = Dio();
      final response = await dio.post(
        mainApi + logoutApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text(
            'تسجيل الخروج ؟',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
              color: Color(0xFFBA1B1B),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
              color: Color(0xFFA9A9A9),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '👋',
              style: TextStyle(fontSize: 80),
            ),
          ),
          const SizedBox(height: 30),
           Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج ؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color:  Theme.of(context).brightness == Brightness.light
                  ? Color(0xFF1D1D1D)
                  : Color(0xFF1D1D1D),
              fontWeight: FontWeight.w600,
              fontFamily: 'Graphik Arabic',
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'لا، تراجع',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Graphik Arabic',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _logout(context),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'نعم، تسجيل الخروج',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Graphik Arabic',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
