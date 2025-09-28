import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/langCode.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final Dio _dio = Dio();

  Future<UserModel?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    final url = mainApi + profileApi;

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          "Accept-Language": langCode == '' ? "en" : langCode
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data['data']);
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio error: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? 'خطأ في جلب البروفايل');
    }
    return null;
  }

  Future<UserModel?> updateUserProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    final url = "$mainApi/app/elwarsha/profile/update";

    try {
      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        if (imageFile != null)
          "image": await MultipartFile.fromFile(imageFile.path, filename: "profile.jpg"),
      });

      debugPrint("📤 Sending formData: ${formData.fields}");

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          "Accept-Language": langCode == '' ? "en" : langCode
        }),
      );

      debugPrint("✅ Response: ${response.statusCode} → ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data['data']);
        await prefs.setString('username', user.name);
        if (user.image != null) {
          await prefs.setString('profile_image', user.image!);
        }
        return user;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio error: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? 'خطأ في تحديث البروفايل');
    }
    return null;
  }
}
