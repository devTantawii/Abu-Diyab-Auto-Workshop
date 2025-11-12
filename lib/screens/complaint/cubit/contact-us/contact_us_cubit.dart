
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/langCode.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());

  final Dio _dio = Dio();

  Future<void> sendMessage({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    emit(ContactUsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.post(
        contactUsApi,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode,
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "message": message,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ContactUsSuccess(response.data['message'] ?? 'Success'));
      } else {
        emit(ContactUsError(response.data.toString()));
      }


    } catch (e) {
      if (e is DioException) {
        emit(ContactUsError(e.response?.data['message'] ?? e.message ?? "Unknown error"));
      } else {
        emit(ContactUsError(e.toString()));
      }
    }

  }
}