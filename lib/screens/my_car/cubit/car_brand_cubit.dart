import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/car_brand_model.dart';
import 'car_brand_state.dart';

class CarBrandCubit extends Cubit<CarBrandState> {
  CarBrandCubit() : super(CarBrandInitial());
  Dio dio = Dio();

  Future<void> fetchCarBrands() async {
    print("🚀 fetchCarBrands called");


    emit(CarBrandLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // 👈 جبنا التوكن
      print("🔑 Token: $token");

      final response = await dio.get(
        mainApi + brandApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // 👈 هنا حطينا التوكن
            "Accept": "application/json",
          },
        ),
      );

      print("📡 Response status: ${response.statusCode}");
      print("📦 Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data =
        response.data is List ? response.data : response.data['data'];

        final brands = data.map((e) => CarBrandModel.fromJson(e)).toList();



        emit(CarBrandLoaded(brands));
      } else {
        print("❌ Failed with status code: ${response.statusCode}");
        emit(CarBrandError(
            'Failed to load car brands: ${response.statusCode}'));
      }
    } catch (e) {
      print("⚠️ Exception occurred: $e");
      emit(CarBrandError('Error: $e'));
    }
  }
}
