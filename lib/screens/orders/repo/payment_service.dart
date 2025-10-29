import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';

class PaymentService {

  PaymentService();

  Future<Map<String, dynamic>> previewPayment({
    required String deliveryMethod,
    required String type,
    required String id,
    required int quantity,
  }) async {

    final url = "$mainApi/app/elwarsha/payments/preview";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final Dio dio =Dio();

    final data = {
      "payment_method": "card",
      "payload": {
        "delivery_method": deliveryMethod,
        "items": [
          {"type": type, "id": id, "quantity": quantity},
        ],
      },
      "points": 0,
    };

    final response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  }
}
