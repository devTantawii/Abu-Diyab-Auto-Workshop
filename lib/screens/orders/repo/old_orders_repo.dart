import 'dart:convert';
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/langCode.dart';
import '../model/old_order_model.dart';

class OldOrdersRepo {

  OldOrdersRepo();

  Future<List<OldOrderModel>> fetchOldOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$mainApi/app/elwarsha/orders/reservations-orders');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        "Accept-Language": langCode == '' ? "en" : langCode

      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'] as List;
      return data.map((e) => OldOrderModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل تحميل الطلبات القديمة');
    }
  }
}
