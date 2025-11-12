// lib/features/rate_service/cubit/rate_service_cubit.dart

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'rate_service_state.dart';

class RateServiceCubit extends Cubit<RateServiceState> {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  RateServiceCubit() : super(const RateServiceState());

  void setRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void setComment(String comment) {
    emit(state.copyWith(comment: comment));
  }

  Future<void> submitReview(int serviceId) async {
    if (state.rating < 1) {
      emit(state.copyWith(
        status: RateServiceStatus.failure,
        errorMessage: 'اختر تقييمًا',
      ));
      return;
    }

    emit(state.copyWith(status: RateServiceStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await _dio.post(
        createReviewsApi,
        data: {
          'service_id': serviceId,
          'rating': state.rating,
          'comment': state.comment.trim(),
        },
        options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(status: RateServiceStatus.success));
      } else {
        emit(state.copyWith(
          status: RateServiceStatus.failure,
          errorMessage: 'فشل الإرسال',
        ));
      }
    } on DioException catch (e) {
      String msg = 'خطأ في الاتصال';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? msg;
      }
      emit(state.copyWith(
        status: RateServiceStatus.failure,
        errorMessage: msg,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RateServiceStatus.failure,
        errorMessage: 'خطأ غير متوقع',
      ));
    }
  }

  void reset() => emit(const RateServiceState());
}