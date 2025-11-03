import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/langCode.dart';
import '../../more/model/reward_log_model.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final Dio _dio = Dio();

  Future<RewardLogsResponse?> getRewardLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await _dio.get(
        '$mainApi/app/elwarsha/profile/get-logs-points',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          "Accept-Language": langCode == '' ? "en" : langCode,
        }),
      );      if (response.statusCode == 200) {
        return RewardLogsResponse.fromJson(response.data);
      }
    } catch (e) {
      print('Error fetching reward logs: $e');
    }
    return null;
  }
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
        final user = UserModel.fromJson(response.data['data']);
        await prefs.setString('username', user.name);
        if (user.image != null) {
          await prefs.setString('profile_image', user.image!);
        }
        return user;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio error: ${e.response?.data}");

      // 👇 تحقق من حالة انتهاء التوكن
      if (e.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        debugPrint("🔒 Token expired and removed from storage.");
        return null;
      }

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
