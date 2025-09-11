import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
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
            "Accept-Language": "ar",
          },
        ),
      );

      print('📡 Response status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['status'] == 200) {
        List<CarModel> models =
            (response.data['data'] as List)
                .map((json) => CarModel.fromJson(json))
                .toList();
        for (var car in models) {
          print('   - ID: ${car.id}, Name: ${car.name}');
        }
        emit(CarModelLoaded(models));
      } else {
        print('⚠️ API Error: ${response.data}');
        emit(CarModelError(response.data['msg'] ?? 'حدث خطأ في جلب الموديلات'));
      }
    } catch (e, stack) {
      print('❌ Exception occurred: $e');
      print('📜 Stack trace: $stack');
      emit(CarModelError('حدث خطأ: $e'));
    }
  }
}
