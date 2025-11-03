//
// import 'package:dio/dio.dart';
//
// import '../../../core/constant/api.dart';
// import '../../../core/langCode.dart';
// import '../model/washing_model.dart';
//
// class WashingRepo {
//   final Dio _dio = Dio(
//     BaseOptions(
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {
//         "Accept": "application/json",
//         "Accept-Language": langCode == '' ? "en" : langCode,
//
//       },
//     ),
//   );
//
//   Future<List<CarWashing>> getWashingServicesByModel(int modelId) async {
//     try {
//       final response = await _dio.get(
//         "$mainApi/app/elwarsha/services/get-subs-carwashing?service_id=3",
//       );
//
//       if (response.statusCode == 200) {
//         final body = response.data;
//
//         // 👇 هنا تستخدم الـ CarWashResponse
//         final parsed = CarWashResponse.fromJson(body);
//
//         for (var item in parsed.data) {
//           print("🆔 ID: ${item.id} "
//               "| 💰 Price: ${item.price} "
//               "| 🏷️ Name: ${item.subService.name} "
//               "| 📄 Description: ${item.subService.description}");
//         }
//
//         return parsed.data;
//
//       } else {
//         throw Exception("Failed with status ${response.statusCode}");
//       }
//     } on DioException catch (e) {
//       throw Exception(e.response?.data["msg"] ?? "Failed to load car services");
//     } catch (e) {
//       throw Exception("Unexpected error: $e");
//     }
//   }
//
// }
import 'package:dio/dio.dart';

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/washing_model.dart';

class CarWashServiceRepo {
  final Dio dio;

  CarWashServiceRepo(this.dio);

  Future<CarWashServiceResponse> getCarWashServices({
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await dio.get(
        '$mainApi/app/elwarsha/services/car-washs',
        queryParameters: {
          'per_page': perPage,
          'page': page,
        },
        options: Options(
          headers: {
            "Accept-Language": langCode == '' ? "en" : langCode

          }
        )
      );

      return CarWashServiceResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
