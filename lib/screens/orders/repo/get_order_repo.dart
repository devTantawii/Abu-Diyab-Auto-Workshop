import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/get_order_model.dart';

class OrdersRepo {
  final Dio dio;

  OrdersRepo(this.dio);

  Future<OrdersResponse> getAllOrders() async {
     try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = currentOrdersApi;

      final headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
        "Accept-Language": langCode == '' ? "en" : langCode,
      };

      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );



      if (response.statusCode == 200) {
         final result = OrdersResponse.fromJson(response.data);
        return result;
      } else {
         throw Exception('Failed to load orders');
      }
    } catch (e, stack) {
      rethrow;
    }
  }
}
