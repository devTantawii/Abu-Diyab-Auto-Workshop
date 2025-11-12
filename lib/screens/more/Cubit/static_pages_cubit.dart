import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/static-pages-model.dart';

part 'static_pages_state.dart';

class StaticPagesCubit extends Cubit<StaticPagesState> {
  StaticPagesCubit() : super(StaticPagesInitial());

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "$elwarshaApi",
      headers: {
        "Accept": "application/json",
        "Accept-Language": langCode == '' ? "en" : langCode,
      },
    ),
  );

  Future<void> fetchStaticPages() async {
    emit(StaticPagesLoading());
    try {
      final response = await _dio.get("static-pages/get-static-pages");

      if (response.statusCode == 200 && response.data["data"] != null) {
        final data = response.data["data"][0];

        /// تنظيف الـ HTML قبل ما نحوله لـ model
        data["privacy_policy"] = _cleanHtml(data["privacy_policy"]);
        data["terms_and_conditions"] = _cleanHtml(data["terms_and_conditions"]);

        final pages = StaticPagesModel.fromJson(data);
        emit(StaticPagesLoaded(pages));
      } else {
        emit(StaticPagesError("فشل في تحميل الصفحات"));
      }
    } catch (e) {
      emit(StaticPagesError("خطأ: $e"));
    }
  }

  /// دالة بسيطة لتنظيف HTML من كل inline styles الغريبة
  String _cleanHtml(String html) {
    if (html.isEmpty) return "";

    final document = html_parser.parse(html);

    for (dom.Element element in document.querySelectorAll('*')) {
      // نحافظ على text-align فقط
      final textAlign = element.attributes['style']?.contains('text-align') == true
          ? _extractTextAlign(element.attributes['style']!)
          : null;

      element.attributes.clear();

      // لو كان فيه text-align رجّعه تاني
      if (textAlign != null) {
        element.attributes['style'] = 'text-align: $textAlign;';
      }
    }

    return document.body?.innerHtml.trim() ?? "";
  }

  String? _extractTextAlign(String style) {
    final regex = RegExp(r'text-align\s*:\s*(\w+)', caseSensitive: false);
    final match = regex.firstMatch(style);
    return match?.group(1);
  }
}
