import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/oil_model.dart';
import '../model/tire_model.dart';
class TireRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  void _updateHeaders() {
    final lang = langCode.isEmpty ? 'en' : langCode;
    _dio.options.headers = {
      "Accept": "application/json",
      "Accept-Language": lang,
    };
  }

  Future<List<Tire>> getTires({String? size, String? search}) async {
    _updateHeaders(); // تحديث اللغة قبل كل طلب

    final queryParameters = <String, dynamic>{
      if (size != null && size.isNotEmpty) 'size': size,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    try {
      final response = await _dio.get(
        "$mainApi/app/elwarsha/services/tires",
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['data'] is List) {
          return (body['data'] as List).map((e) => Tire.fromJson(e)).toList();
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["msg"] ?? "Failed to load tires");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}