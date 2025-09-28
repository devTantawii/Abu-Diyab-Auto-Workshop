import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  Dio dio = Dio(BaseOptions(baseUrl: mainApi));
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      dio.options.headers["Accept"] = "application/json";
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
    });
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentController = TextEditingController();
    final TextEditingController newController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تغيير كلمة المرور"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: InputDecoration(labelText: "كلمة المرور الحالية"),
              ),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(labelText: "كلمة المرور الجديدة"),
              ),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(labelText: "تأكيد كلمة المرور الجديدة"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("تغيير"),
              onPressed: () async {
                final current = currentController.text.trim();
                final newPass = newController.text.trim();
                final confirm = confirmController.text.trim();

                if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("من فضلك املأ جميع الحقول")),
                  );
                  return;
                }

                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("كلمة المرور غير متطابقة")),
                  );
                  return;
                }

                try {
                  final body = {
                    "current_password": current,
                    "new_password": newPass,
                    "new_password_confirmation": confirm,
                  };

                  // اطبع قبل الإرسال
                  print("🔹 API Request:");
                  print("URL: ${dio.options.baseUrl}/app/elwarsha/profile/update-password");
                  print("Headers: ${dio.options.headers}");
                  print("Body: $body");

                  final response = await dio.post(
                    "/app/elwarsha/profile/update-password",
                    data: body,
                  );

                  // اطبع بعد الاستقبال
                  print("✅ API Response:");
                  print("Status Code: ${response.statusCode}");
                  print("Data: ${response.data}");

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    final msg = response.data['message'] ?? "تم تغيير كلمة المرور بنجاح ✅";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  } else {
                    final msg = response.data['message'] ?? "حدث خطأ غير متوقع ❌";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }
                } on DioError catch (e) {
                  print("❌ API Error:");
                  print("Status Code: ${e.response?.statusCode}");
                  print("Data: ${e.response?.data}");

                  String errorMsg = "حدث خطأ أثناء تغيير كلمة المرور";
                  if (e.response != null && e.response?.data != null) {
                    errorMsg = e.response?.data['message'] ?? errorMsg;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMsg)),
                  );
                } catch (e) {
                  print("⚠️ Unexpected Error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("خطأ غير متوقع: $e")),
                  );
                }

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: token == null
          ? null
          : () {
        _showChangePasswordDialog(context);
      },
      child: Text(
        'تغيير كلمه المرور !',
        style: TextStyle(
          color: token == null ? Colors.grey : Colors.red,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
