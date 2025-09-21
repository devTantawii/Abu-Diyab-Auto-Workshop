import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
    return null;
  }

  /// 🔹 تحديث بيانات البروفايل
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
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: "profile.jpg",
          ),
      });
      debugPrint("FormData fields:");
      formData.fields.forEach((f) => debugPrint("${f.key}: ${f.value}"));
      formData.files.forEach(
        (f) => debugPrint("${f.key}: ${f.value.filename}"),
      );

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      debugPrint(
        "Response status: ${response.statusCode}, data: ${response.data}",
      );

      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data['data']);

        // 🔹 خزّن الاسم الجديد في SharedPreferences
        await prefs.setString('username', user.name);

        return user;
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
    return null;
  }
}
