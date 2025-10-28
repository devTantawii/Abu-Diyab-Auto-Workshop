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

      final response = await dio.get(
        '$mainApi/app/elwarsha/orders/current-orders',
        options: Options(headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
          "Accept-Language": langCode == '' ? "en" : langCode

        }),
      );

      if (response.statusCode == 200) {
        return OrdersResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      rethrow;
    }
  }
}
