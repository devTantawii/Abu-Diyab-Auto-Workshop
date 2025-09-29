import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/oil_model.dart';
import '../model/tire_model.dart';
class TireRepository {
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

  Future<List<SubTireService>> getTireServicesByModel(int modelId) async {
    try {
      final response = await _dio.get("$mainApi/app/elwarsha/services/get-subs-tires?car_model_id=$modelId&service_id=5");

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['data'] is List) {
          final data = body['data'] as List;
          return data.map((e) => SubTireService.fromJson(e)).toList();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["msg"] ?? "Failed to load car tires");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
