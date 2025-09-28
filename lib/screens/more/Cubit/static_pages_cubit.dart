import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' ;
import '../../../core/langCode.dart';
import '../Models/static-pages-model.dart';

part 'static_pages_state.dart';

class StaticPagesCubit extends Cubit<StaticPagesState> {
  StaticPagesCubit() : super(StaticPagesInitial());

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://devapi.a-vsc.com/api/app/elwarsha/",
      headers: {
        "Accept": "application/json",
        "Accept-Language": langCode == '' ? "en" : langCode
        ,
      },
    ),
  );
  Future<void> fetchStaticPages() async {
    emit(StaticPagesLoading());
    try {
      final response = await _dio.get("static-pages/get-static-pages");

      if (response.statusCode == 200 && response.data["data"] != null) {
        final data = response.data["data"][0];
        final pages = StaticPagesModel.fromJson(data);
        emit(StaticPagesLoaded(pages));
      } else {
        emit(StaticPagesError("فشل في تحميل الصفحات"));
      }
    } catch (e) {
      emit(StaticPagesError("خطأ: $e"));
    }
  }
}