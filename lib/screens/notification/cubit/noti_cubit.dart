import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../model/noti_model.dart';
import 'noti_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  final Dio _dio = Dio();

  Future<void> fetchNotifications() async {
    print('🔹 Starting fetchNotifications...');
    emit(NotificationsLoading());

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔹 Retrieved token: $token');

    try {
      print('🔹 Sending GET request to: $fcmApi');
      final response = await _dio.get(
        fcmApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": langCode == '' ? "en" : langCode,
          },
        ),
      );

      print('🔹 Response status code: ${response.statusCode}');
      print('🔹 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print('🔹 Parsed data length: ${data.length}');
        final notifications =
        data.map((e) => NotificationModel.fromJson(e)).toList();
        print('✅ Notifications loaded successfully');
        emit(NotificationsLoaded(notifications));
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        emit(NotificationsError('Failed to fetch notifications'));
      }
    } catch (e) {
      print('🚨 Error fetching notifications: $e');
      emit(NotificationsError(e.toString()));
    }
  }
}
