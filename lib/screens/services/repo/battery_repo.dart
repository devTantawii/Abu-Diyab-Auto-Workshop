import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/battery_model.dart';

class BatteryRepository {
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

  Future<BatteryResponse> getBatteries({
    int page = 1,
    int perPage = 10,
    String? amper,
  }) async {
    try {
      final queryParams = {
        "page": page,
        "per_page": perPage,
        if (amper != null && amper.isNotEmpty) "amper": amper,
      };

      final response = await _dio.get(
        "$mainApi/app/elwarsha/services/batteries",
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['data'] is List) {
          return BatteryResponse.fromJson(Map<String, dynamic>.from(body));
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["msg"] ?? "Failed to load batteries");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
