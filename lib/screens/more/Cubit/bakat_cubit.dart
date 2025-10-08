import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../Models/bakat_model.dart';

part 'bakat_state.dart';

class BakatCubit extends Cubit<BakatState> {
  BakatCubit() : super(BakatInitial());

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> getPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    emit(BakatLoading());
    try {
      final response = await _dio.get(
        '$mainApi/app/elwarsha/packages/get',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final packageResponse = PackageResponse.fromJson(jsonData);

        emit(BakatSuccess([packageResponse]));
      } else {
        emit(BakatError());
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      emit(BakatError());
    } catch (e) {
      print('Unexpected Error: $e');
      emit(BakatError());
    }
  }
}
