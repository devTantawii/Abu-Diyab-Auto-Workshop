import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/get_order_model.dart';

class OrdersRepo {
  final Dio dio;

  OrdersRepo(this.dio);

  Future<OrdersResponse> getAllOrders() async {
    print('📦 [OrdersRepo] بدء جلب الطلبات الحالية...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('🔑 [OrdersRepo] تم الحصول على التوكن: $token');

      final url = '$mainApi/app/elwarsha/orders/current-orders';
      print('🌐 [OrdersRepo] سيتم الاتصال بالرابط: $url');

      final headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
        "Accept-Language": langCode == '' ? "en" : langCode,
      };
      print('🧾 [OrdersRepo] الهيدر المستخدم: $headers');

      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      print('📡 [OrdersRepo] تم استلام الرد من السيرفر. Status code: ${response.statusCode}');
      print('📨 [OrdersRepo] البيانات الخام من السيرفر: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ [OrdersRepo] تم جلب الطلبات بنجاح، يتم الآن تحويل الـ JSON إلى الموديل...');
        final result = OrdersResponse.fromJson(response.data);
        return result;
      } else {
        print('⚠️ [OrdersRepo] فشل تحميل الطلبات. Status: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    } catch (e, stack) {
      print('❌ [OrdersRepo] حدث خطأ أثناء جلب الطلبات: $e');
      print('🧱 Stack trace: $stack');
      rethrow;
    }
  }
}
