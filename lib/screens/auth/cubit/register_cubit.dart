import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../model/register_request_model.dart';
import 'register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final Dio dio;
  RegisterCubit({required this.dio}) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel model) async {
    emit(RegisterLoading());

    // طباعة البيانات قبل الإرسال
    print("📤 Sending JSON to /register:");
    print(model.toJson());

    try {
      final response = await dio.post(
        mainApi+registerApi,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data["message"];
        final verificationMessage = response.data["verification_sms"];

        // طباعة الرد من السيرفر
        print("📩 Received Response:");
        print(response.data);
        print({
          "message": message,
          "verification_sms": verificationMessage,
        });

        emit(RegisterSuccess(
          message: message ?? "تم التسجيل",
          verificationSms: verificationMessage,
        ));
      } else {
        emit(RegisterFailure("فشل التسجيل. حاول مرة أخرى"));
      }
    } on DioException catch (e) {
      print("❌ DioException Occurred");
      print("📥 Response data: ${e.response?.data}");
      print("📥 Response type: ${e.response?.data.runtimeType}");

      String errorMessage = "حدث خطأ أثناء الاتصال";

      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data["message"] ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data;
      }

      emit(RegisterFailure(errorMessage));
    }
  }
}
