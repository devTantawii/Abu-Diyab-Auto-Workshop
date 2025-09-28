import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/offers_model.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final Dio dio;

  OffersCubit({required this.dio}) : super(OffersInitial());

  Future<void> fetchOffers() async {
    emit(OffersLoading());

    try {
      final response = await dio.get(
        "$mainApi/app/elwarsha/offers/get",
        options: Options(
          headers: {
            "Accept-Language": langCode == '' ? "en" : langCode
          },
        ),
      );
      if (response.statusCode == 200) {
        final offerResponse = OfferResponse.fromJson(response.data);
        emit(OffersLoaded(offerResponse.data));
      } else {
        emit(OffersError("خطأ في الاتصال بالسيرفر"));
      }
    } catch (e) {
      emit(OffersError(e.toString()));
    }
  }
}
