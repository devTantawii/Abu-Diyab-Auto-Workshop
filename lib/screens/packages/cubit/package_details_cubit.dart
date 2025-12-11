import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:abu_diyab_workshop/screens/packages/cubit/package_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../model/package_details_model.dart';


class PackageDetailsCubit extends Cubit<PackageDetailsState> {
  PackageDetailsCubit() : super(PackageDetailsInitial());

  final Dio _dio = Dio();

  Future<void> getPackageDetails(int id) async {
    emit(PackageDetailsLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await _dio.get(
        "$mainApi/app/elwarsha/packages/package-details",
        queryParameters: {"package_id": id},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Accept-Language": langCode == '' ? "en" : langCode,

          },
        ),
      );


      final data = PackageDetailsResponse.fromJson(response.data["data"]);

      emit(PackageDetailsSuccess(data));
    } catch (e) {
      emit(PackageDetailsFailure("حدث خطأ أثناء جلب البيانات"));
    }
  }
}
