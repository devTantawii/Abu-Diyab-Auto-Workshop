import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';

import '../../../core/langCode.dart';
import '../model/search_model.dart';

class SearchApi {
  final Dio dio = Dio();

  Future<SearchResponse> search(String value) async {
    final response = await dio.get(
      '$mainApi/app/elwarsha/services/search-for-all',
      queryParameters: {'value': value},
      options: Options(
        headers: {
          "Accept-Language": langCode == '' ? "en" : langCode
        },
      ),
    );

    return SearchResponse.fromJson(response.data);
  }
}
