import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/battery_model.dart';

class BatteryRepository {
  final Dio _dio;

  BatteryRepository() : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // دالة لتحديث الـ headers قبل كل طلب
  void _updateHeaders() {
    final lang = langCode.isEmpty ? 'en' : langCode; // من ملفك langCode.dart
    _dio.options.headers = {
      "Accept": "application/json",
      "Accept-Language": lang,
    };
  }

  Future<BatteryResponse> getBatteries({
    int page = 1,
    int perPage = 10,
    String? amper,
    String? search,
  }) async {
    _updateHeaders(); // ← حدّث اللغة قبل كل طلب

    final queryParams = {
      "page": page,
      "per_page": perPage,
      if (amper != null && amper.isNotEmpty) "amper": amper,
      if (search != null && search.isNotEmpty) "search": search,
    };

    try {
      final response = await _dio.get(
        batteriesApi,
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