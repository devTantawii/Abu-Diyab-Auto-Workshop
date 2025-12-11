import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../model/subscription_model.dart';

part 'subscriptions_state.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  late final Dio _dio;

  SubscriptionsCubit() : super(SubscriptionsInitial()) {
    _dio = Dio(
      BaseOptions(
        baseUrl: mainApi,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
      ),
    );
  }

  Future<void> loadSubscriptions() async {
    emit(SubscriptionsLoading());

    try {
      final subscriptions = await _fetchSubscriptions();
      emit(SubscriptionsLoaded(subscriptions: subscriptions));
    } catch (e) {
      emit(SubscriptionsError(message: e.toString()));
    }
  }

  Future<List<Subscription>> _fetchSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await _dio.get(
        '/app/elwarsha/subscriptions/get',options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          "Accept-Language": langCode == '' ? "en" : langCode,

        },
      ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final resp = SubscriptionResponse.fromJson(data);
        return resp.data;
      } else {
        throw Exception('Failed to load subscriptions: status ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
