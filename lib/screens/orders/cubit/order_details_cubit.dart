import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/get_order_details_model.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(OrderDetailsInitial());

  final Dio _dio = Dio(BaseOptions(baseUrl: "$mainApi/app/elwarsha"));

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {

      final response = await _dio.get(
        '/orders/order-details',
        queryParameters: {'order_id': orderId},
        options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      );


      if (response.statusCode == 200) {
        try {
          final model = OrderResponse.fromJson(response.data);
          emit(OrderDetailsSuccess(model.data));
        } catch (parseError) {
          emit(OrderDetailsError("خطأ في تحليل البيانات"));
        }
      } else {
        emit(OrderDetailsError("خطأ في تحميل البيانات"));
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
      }
      emit(OrderDetailsError("خطأ في الاتصال بالسيرفر: ${dioError.message}"));
    } catch (e, stack) {

      emit(OrderDetailsError(e.toString()));
    }
  }
}
