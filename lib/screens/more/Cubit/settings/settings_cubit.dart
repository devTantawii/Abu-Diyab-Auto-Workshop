import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/constant/api.dart';
import '../../model/Settingmodel.dart';
part 'settings_state.dart';




class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit() : super(AppSettingsInitial());

  final Dio _dio = Dio();

  Future<void> fetchAppSettings() async {
    emit(AppSettingsLoading());

    try {
      final response = await _dio.get(
        "$mainApi/app/elwarsha/settings/get",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"];

        final settings =
        data.map((e) => AppSetting.fromJson(e)).toList();

        final Map<String, String> settingsMap = {
          for (var item in settings) item.key: item.value,
        };

        emit(AppSettingsLoaded(settings: settingsMap));
      } else {
        emit(AppSettingsError("فشل تحميل البيانات"));
      }
    } catch (e) {
      emit(AppSettingsError(e.toString()));
    }
  }
}