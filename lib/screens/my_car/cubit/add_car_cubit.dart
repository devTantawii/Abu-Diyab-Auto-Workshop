import 'dart:io';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'add_car_state.dart';

class AddCarCubit extends Cubit<AddCarState> {
  AddCarCubit() : super(AddCarInitial());

  Dio dio = Dio();

  Future<void> addCar({
 //   required int userId,
    required File? carCertificate, // 👈 هنا اسم زي الـ API
    required String kilometre,     // 👈 String عشان الـ API بيرجع "50000"
    required String name,
    required String licencePlate,
    required String year,
    required int carModelId,
    required int carBrandId,
    required String token,
  }) async {
    emit(AddCarLoading());

    try {
      FormData formData = FormData.fromMap({
   //     "user_id": userId, // لو مش مطلوب من الـ backend ممكن تشيله
        "licence_plate": licencePlate,
        "name": name,
        "year": year,
        "kilometer": kilometre,
        "car_model_id": carModelId,
        "car_brand_id": carBrandId,
        if (carCertificate != null)
          "car_certificate": await MultipartFile.fromFile(
            carCertificate.path,
            filename: carCertificate.path.split("/").last,
          ),
      });

      debugPrint("📤 Sending fields: ${formData.fields}");
      debugPrint("📤 Sending files: ${formData.files}");

      final response = await dio.post(
        "$mainApi/app/elwarsha/user-cars/create",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      debugPrint("📥 Response: ${response.statusCode}");
      debugPrint("📥 Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddCarSuccess(response.data["msg"] ?? "Car added successfully ✅"));
      } else {
        emit(AddCarError("❌ Failed: ${response.statusCode} - ${response.statusMessage}"));
      }
    } catch (e, stack) {
      if (e is DioException && e.response != null) {
        debugPrint("🔥 Dio error data: ${e.response?.data}");
      }
      debugPrint("🔥 Error in AddCarCubit: $e");
      debugPrint(stack.toString());
      emit(AddCarError("Error: $e"));
    }
  }
}
