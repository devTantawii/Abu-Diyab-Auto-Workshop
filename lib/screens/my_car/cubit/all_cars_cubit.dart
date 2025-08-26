import 'dart:convert';
import 'dart:io';

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../model/all_cars_model.dart';
import 'all_cars_state.dart';

class CarCubit extends Cubit<CarState> {
  CarCubit() : super(CarInitial());

  final Dio _dio = Dio();

  // Fetch all cars
  Future<void> fetchCars(String token) async {
    emit(CarLoading());
    try {
      final response = await _dio.get(
        "$mainApi/user-cars",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": "ar",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data =
            response.data is String
                ? List<Map<String, dynamic>>.from(jsonDecode(response.data))
                : List<Map<String, dynamic>>.from(response.data);
        final cars = data.map((e) => Car.fromJson(e)).toList();
        emit(CarLoaded(cars));
      } else {
        emit(CarError("Failed to load cars"));
      }
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  // Update a car
  // Update a car
  Future<void> updateCar({
    required int carId,
    required String token,
    int? carBrandId,
    int? carModelId,
    required String creationYear,
    required String boardNo,
    //   required String translationName,
    int? kiloRead,
    File? carDocs,
  }) async {
    emit(UpdateCarLoading());
    try {
      final brandId = carBrandId ?? 0;
      final modelId = carModelId ?? 0;
      //     final kilo = kiloRead ?? 0;

      FormData formData = FormData.fromMap({
        "car_brand_id": brandId,
        "car_model_id": modelId,
        "creation_year": creationYear,
        "board_no": boardNo,
        //  "name": translationName,   // 👈 الاسم الصحيح
        //  "kilo_read": kilo,         // 👈 اضفته هنا
        if (carDocs != null)
          "car_docs": await MultipartFile.fromFile(
            carDocs.path,
            filename: carDocs.path.split("/").last,
          ),
      });

      final response = await _dio.post(
        // 👈 جرب POST مع _method=PUT
        "$mainApi/user-cars/$carId?_method=PUT",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      // 🖨️ اطبع الريسبونس كامل في اللوج
      print("🔵 UpdateCar Response Status: ${response.statusCode}");
      print("🔵 UpdateCar Response Data: ${response.data}");
      print("🔵 UpdateCar Response Headers: ${response.headers}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // لو السيرفر بيرجع رسالة
        final message =
            response.data is Map && response.data['message'] != null
                ? response.data['message']
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
