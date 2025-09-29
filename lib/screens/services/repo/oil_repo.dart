import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/oil_model.dart';

class OilRepository {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Accept": "application/json",
        "Accept-Language": langCode == '' ? "en" : langCode,

      },
    ),
  );

  Future<List<SubOil>> getOilsByModel(int modelId) async {
    try {
      final response = await _dio.get("$mainApi/app/elwarsha/services/get-subs-oilchange?car_model_id=${modelId}&service_id=6");
      print(response.data);
      print(modelId);

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['data'] is List) {
          final data = body['data'] as List;
          return data.map((e) => SubOil.fromJson(e)).toList();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data ?? e.message}");
      throw Exception(e.response?.data["msg"] ?? "Failed to load car oils");
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }
}
