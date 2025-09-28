import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/langCode.dart';
import '../../Models/contact-us-model.dart';

part 'contact_us_state.dart';

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
        "https://devapi.a-vsc.com/api/app/elwarsha/contact-us/create",
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

      final result = ContactUsResponse.fromJson(response.data);
      emit(ContactUsSuccess(result));
    } catch (e) {
      emit(ContactUsError(e.toString()));
    }
  }
}