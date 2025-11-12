import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';

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
    final locale = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // العنوان
                Text(
                  locale!.isDirectionRTL(context)
                      ? "تغيير كلة السر ؟"
                      : "Change Password ?",
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // كلمة المرور الحالية
                TextField(
                  controller: currentController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: locale.isDirectionRTL(context)
                        ? "كلمة المرور الحالية"
                        : "Current Password",
                  ),
                ),
                const SizedBox(height: 15),

                // كلمة المرور الجديدة
                TextField(
                  controller: newController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: locale.isDirectionRTL(context)
                        ? "كلمة المرور الجديدة"
                        : "New Password",
                  ),
                ),
                const SizedBox(height: 15),

                // تأكيد كلمة المرور الجديدة
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: locale.isDirectionRTL(context)
                        ? "تأكيد كلمة المرور الجديدة"
                        : "Confirm New Password",
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        locale.isDirectionRTL(context) ? "إلغاء" : "Cancel",
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: typographyMainColor(context),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check),
                      label: Text(
                        locale.isDirectionRTL(context) ? "تغيير" : "Update",
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        final current = currentController.text.trim();
                        final newPass = newController.text.trim();
                        final confirm = confirmController.text.trim();

                        if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                locale.isDirectionRTL(context)
                                    ? "من فضلك املأ جميع الحقول"
                                    : "Please fill in all fields",
                              ),
                            ),
                          );
                          return;
                        }

                        if (newPass != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                locale.isDirectionRTL(context)
                                    ? "كلمة المرور غير متطابقة"
                                    : "Passwords do not match",
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          final body = {
                            "current_password": current,
                            "new_password": newPass,
                            "new_password_confirmation": confirm,
                          };

                          final response = await dio.post(
                            updatePasswordApi,
                            data: body,
                          );

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            final msg = response.data['message'] ??
                                (locale.isDirectionRTL(context)
                                    ? "تم تغيير كلمة المرور بنجاح ✅"
                                    : "Password changed successfully ✅");
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          } else {
                            final msg = response.data['message'] ??
                                (locale.isDirectionRTL(context)
                                    ? "حدث خطأ غير متوقع ❌"
                                    : "Unexpected error occurred ❌");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          }
                        } on DioError catch (e) {
                          String errorMsg = locale.isDirectionRTL(context)
                              ? "حدث خطأ أثناء تغيير كلمة المرور"
                              : "An error occurred while changing the password";
                          if (e.response != null && e.response?.data != null) {
                            errorMsg = e.response?.data['message'] ?? errorMsg;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMsg)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                locale.isDirectionRTL(context)
                                    ? "خطأ غير متوقع: $e"
                                    : "Unexpected error: $e",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return GestureDetector(
      onTap:
          token == null
              ? null
              : () {
                _showChangePasswordDialog(context);
              },
      child: Text(
        locale!.isDirectionRTL(context)
            ? "تغيير كلة السر ؟"
            : "Change Password ?",
        style: TextStyle(
          color: buttonPrimaryBgColor(context),
          fontWeight: FontWeight.w600,
          fontFamily: 'Graphik Arabic',
          fontSize: 18.sp

        ),
      ),
    );
  }
}
