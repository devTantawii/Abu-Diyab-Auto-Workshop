import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/langCode.dart';
import '../../model/faqmodel.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitial());

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "$mainApi/app/elwarsha/",
      headers: {
        "Accept": "application/json",
        "Accept-Language": langCode == '' ? "en" : langCode
      },
    ),
  );

  Future<void> fetchFaqs() async {
    emit(FaqLoading());
    try {
      final response = await _dio.get("static-pages/get-faqs");

      if (response.statusCode == 200 && response.data["data"] != null) {
        final List data = response.data["data"];
        final faqs = data.map((e) => FaqModel.fromJson(e)).toList();
        emit(FaqLoaded(faqs));
      } else {
        emit(FaqError("فشل في تحميل الأسئلة الشائعة"));
      }
    } catch (e) {
      emit(FaqError("خطأ: $e"));
    }
  }
}