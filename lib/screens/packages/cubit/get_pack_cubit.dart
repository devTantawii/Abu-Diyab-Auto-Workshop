import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/langCode.dart';
import '../model/get_pack_model.dart';
import 'get_pack_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(PackagesInitial());

  static PackagesCubit of(context) => BlocProvider.of(context);

  Future<void> getPackages() async {
    emit(PackagesLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await Dio().get(
        "$mainApi/app/elwarsha/packages/get",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept-Language": langCode == '' ? "en" : langCode,

        }
        ),
      );

      final data = response.data["data"] as List;

      final packages = data.map((e) => PackageModel.fromJson(e)).toList();

      emit(PackagesSuccess(packages));
    } catch (e) {
      emit(PackagesFailure(e.toString()));
    }
  }
}
