import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../core/langCode.dart';
import '../model/register_request_model.dart';
import 'register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final Dio dio;
  RegisterCubit({required this.dio}) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel model) async {
    emit(RegisterLoading());


    try {
      final response = await dio.post(
        mainApi + registerApi,
        data: model.toJson(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            "Accept-Language": langCode == '' ? "en" : langCode

          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data["msg"]; // ✅ هنا
        final verificationMessage = response.data["verification_sms"];



        emit(RegisterSuccess(
          message: message ?? "تم التسجيل",
          verificationSms: verificationMessage,
        ));
      } else {
        emit(RegisterFailure("فشل التسجيل. حاول مرة أخرى"));
      }
    } on DioException catch (e) {

      String errorMessage = "حدث خطأ أثناء الاتصال";

      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data["msg"] ?? errorMessage; // ✅ هنا
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
      }

      emit(RegisterFailure(errorMessage));
    }
  }
}
