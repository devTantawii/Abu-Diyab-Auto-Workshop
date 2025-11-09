import 'package:dio/dio.dart';
import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/oil_model.dart';

class OilRepository {
  final Dio _dio;

  OilRepository()
      : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // دالة لتحديث الـ headers قبل كل طلب
  void _updateHeaders() {
    final lang = langCode.isEmpty ? 'en' : langCode;
    _dio.options.headers = {
      "Accept": "application/json",
      "Accept-Language": lang,
    };
  }

  /// جلب الزيوت مع إمكانية البحث
  Future<List<OilProduct>> getOils({String? search}) async {
    _updateHeaders(); // تحديث اللغة قبل الطلب

    final queryParams = {
      if (search != null && search.trim().isNotEmpty) "search": search.trim(),
    };

    try {
      final response = await _dio.get(
        "$mainApi/app/elwarsha/services/oils",
        queryParameters: queryParams,
      );


      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['data'] is List) {
          return (body['data'] as List)
              .map((e) => OilProduct.fromJson(e))
              .toList();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      final msg = e.response?.data["msg"] ?? e.message ?? "Unknown error";
      print("Dio error: $msg");
      throw Exception(msg);
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }
}