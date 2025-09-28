import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/CarModel.dart';
import 'CarModelState.dart';

class CarModelCubit extends Cubit<CarModelState> {
  final Dio dio;
  final String mainApi;

  CarModelCubit({required this.dio, required this.mainApi})
    : super(CarModelInitial());

  Future<void> fetchCarModels(int brandId) async {
    emit(CarModelLoading());

    try {
      print('🚀 Fetching car models for brandId: $brandId');
      final url = '$mainApi/app/elwarsha/car-model/get/$brandId';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // 👈 جبنا التوكن
      print("🔑 Token: $token");

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // 👈 هنا حطينا التوكن
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      print('📡 Response status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['status'] == 200) {
        List<CarModel> models =
        (response.data['data'] as List)
            .map((json) => CarModel.fromJson(json))
            .toList();

        if (models.isEmpty) {
          // 🆕 لو مفيش موديلات
          emit(CarModelLoaded([], message: response.data['msg'] ?? "لا توجد موديلات"));
        } else {
          emit(CarModelLoaded(models));
        }
      } else {
        emit(CarModelError(response.data['msg'] ?? 'حدث خطأ في جلب الموديلات'));
      }

    } catch (e, stack) {
      print('❌ Exception occurred: $e');
      print('📜 Stack trace: $stack');
      emit(CarModelError('حدث خطأ: $e'));
    }
  }
}
