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

  Future<List<OilProduct>> getOils() async {
    try {
      final response = await _dio.get("$mainApi/app/elwarsha/services/oils");

      print("📦 API Response: ${response.data}");

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['data'] is List) {
          final data = body['data'] as List;
          return data.map((e) => OilProduct.fromJson(e)).toList();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio error: ${e.response?.data ?? e.message}");
      throw Exception(e.response?.data["msg"] ?? "Failed to load oils");
    } catch (e) {
      print("⚠️ Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }
}
