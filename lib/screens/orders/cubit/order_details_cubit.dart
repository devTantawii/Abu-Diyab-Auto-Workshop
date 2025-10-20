import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/get_order_details_model.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(OrderDetailsInitial());

  final Dio _dio = Dio(BaseOptions(baseUrl: "https://devapi.a-vsc.com/api/app/elwarsha"));

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    print("🔍 بدء جلب تفاصيل الطلب رقم: $orderId");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {

      final response = await _dio.get(
        '/orders/order-details',
        queryParameters: {'order_id': orderId},
        options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // ✅ إضافة التوكن هنا
        },
      ),
      );

      print("✅ تم الاتصال بالسيرفر بنجاح");
      print("📦 Status Code: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        try {
          final model = OrderResponse.fromJson(response.data);
          emit(OrderDetailsSuccess(model.data));
          print("🎉 تم تحويل البيانات بنجاح وإرسالها للـ UI");
        } catch (parseError) {
          print("❌ خطأ أثناء تحويل الـ JSON إلى موديل:");
          print(parseError);
          emit(OrderDetailsError("خطأ في تحليل البيانات"));
        }
      } else {
        print("⚠️ فشل الطلب - Status Code: ${response.statusCode}");
        emit(OrderDetailsError("خطأ في تحميل البيانات"));
      }
    } on DioException catch (dioError) {
      print("❗ DioException: ${dioError.message}");
      if (dioError.response != null) {
        print("📨 Response Error Data: ${dioError.response?.data}");
      }
      emit(OrderDetailsError("خطأ في الاتصال بالسيرفر: ${dioError.message}"));
    } catch (e, stack) {
      print("💥 Exception غير متوقعة: $e");
      print("🧱 Stack Trace: $stack");
      emit(OrderDetailsError(e.toString()));
    }
  }
}
