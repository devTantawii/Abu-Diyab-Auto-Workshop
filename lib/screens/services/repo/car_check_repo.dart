import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../model/car_check_model.dart';

class CarCheckRepository {

  CarCheckRepository();
Dio dio= Dio();
  Future<CarCheck> getCarChecks({required int carModelId}) async {
    try {
      final response = await dio.get(
        "$mainApi/app/elwarsha/services/get-subs-carchecks?car_model_id=$carModelId&service_id=9",
      );

      return CarCheck.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response?.data["msg"] ?? "Failed to load car checks");
    }
  }
}
