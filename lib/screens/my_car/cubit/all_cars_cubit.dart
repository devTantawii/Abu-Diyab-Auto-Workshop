import 'dart:convert';
import 'dart:io';

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../model/all_cars_model.dart';
import 'all_cars_state.dart';

class CarCubit extends Cubit<CarState> {
  CarCubit() : super(CarInitial());

  final Dio _dio = Dio();

  // Fetch all cars
  Future<void> fetchCars(String token) async {
    emit(CarLoading());
    print("Fetching cars...");
    print(token);

    try {
      final response = await _dio.get(
        carGetApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        print("responseData: $responseData");

        final data = List<Map<String, dynamic>>.from(responseData["data"]);
        print("Cars data: $data");

        print("Decoded data: $data");

        final cars = data.map((e) => Car.fromJson(e)).toList();
        print("Parsed cars: $cars");

        emit(CarLoaded(cars));
      } else {
        print("Non-200 response");
        emit(CarError("Failed to load cars"));
      }
    } catch (e, stackTrace) {
      print("Error caught: $e");
      print(stackTrace);
      emit(CarError(e.toString()));
    }
  }


  Future<void> getUserCar(int id) async {
    emit(SingleCarLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(SingleCarError("لم يتم العثور على التوكن"));
        return;
      }

      final response = await _dio.get(
        "$carShowApi$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final car = Car.fromJson(response.data['data']);
        emit(SingleCarLoaded(car));
        print("✅ تم جلب السيارة بنجاح: ${car.name}");
      } else {
        emit(SingleCarError("فشل في تحميل بيانات السيارة"));
      }
    } catch (e, stack) {
      print("⚠️ Exception: $e");
      print(stack);
      emit(SingleCarError("حدث خطأ أثناء تحميل السيارة"));
    }
  }
  Future<void> updateCar({
    required int carId,
    required String token,
    int? carBrandId,
    int? carModelId,
    required String creationYear,
    required String boardNo,
    required String translationName,
    int? kiloRead,
    File? carDocs,
  }) async {
    emit(UpdateCarLoading());
    try {
      final brandId = carBrandId ?? 0;
      final modelId = carModelId ?? 0;
      final kilo = kiloRead ?? 0;

      FormData formData = FormData.fromMap({
       // "_method": "PUT", // 👈 مهم للـ Laravel
        "car_brand_id": brandId,
        "car_model_id": modelId,
        "year": creationYear,
        "licence_plate": boardNo,
        "name": translationName,
        "kilometer": kilo,
        if (carDocs != null)
          "car_certificate": await MultipartFile.fromFile(
            carDocs.path,
            filename: carDocs.path.split("/").last,
          ),
      });

      final response = await _dio.post(
        "$carUpdateApi$carId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode
          },
        ),
      );

      print("🔵 UpdateCar Response Status: ${response.statusCode}");
      print("🔵 UpdateCar Response Data: ${response.data}");
      print("🔵 UpdateCar Response Headers: ${response.headers}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
        response.data is Map && response.data['msg'] != null
            ? response.data['msg']
            : "تم تعديل السيارة بنجاح";

        emit(UpdateCarSuccess(message: message));
        await fetchCars(token);
      } else {
        emit(
          UpdateCarError(
            message:
            "فشل تعديل السيارة (Status ${response.statusCode}) - ${response.data}",
          ),
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("❌ UpdateCar Error Status: ${e.response?.statusCode}");
        print("❌ UpdateCar Error Data: ${e.response?.data}");

        final serverMessage =
            e.response?.data['msg'] ??
                e.response?.data['message'] ??
                e.response?.data.toString() ??
                "فشل تعديل السيارة";

        emit(UpdateCarError(message: serverMessage));
      } else {
        print("❌ UpdateCar Error: $e");
        emit(UpdateCarError(message: "فشل تعديل السيارة: $e"));
      }
    }
  }

}
