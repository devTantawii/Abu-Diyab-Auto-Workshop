import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_setup.dart';
import '../../../core/langCode.dart';
import '../../../main.dart';
import '../model/login_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio;

  LoginCubit({required this.dio}) : super(LoginInitial());

  Future<void> _updateFcmToken(String fcmToken, String userToken) async {
    print('🔁 تحديث FCM Token...');

    try {
      final response = await dio.post(
        updateFcmApi,
        data: {"fcm": fcmToken},
        options: Options(
          headers: {
            "Authorization": "Bearer $userToken",
            "Accept": "application/json",
          },
        ),
      );

      print('📩 [updateFCM] Status: ${response.statusCode}');
      print('📩 [updateFCM] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 200) {
        print('✅ تم تحديث FCM Token بنجاح');
      } else {
        print('⚠️ فشل تحديث FCM Token: ${response.data['msg']}');
      }
    } catch (e) {
      print('❌ خطأ أثناء تحديث FCM Token: $e');
    }
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(LoginLoading());
    final firebaseMessaging = FirebaseMessaging.instance;

    await firebaseMessaging.requestPermission();

    String? fcmToken;
    try {
      fcmToken = await firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("🔑 FCM Token: $fcmToken");
      } else {
        print("⚠️ APNS token not available (running on simulator or not ready yet)");
      }
    } catch (e) {
      print("⚠️ Error getting FCM token: $e");
    }

    print('📡 جاري محاولة تسجيل الدخول...');
    print('➡️ البيانات المرسلة: phone $phone, password $password');
    print(' fcmToken $fcmToken');

    try {
      final response = await dio.post(
        mainApi + loginApi,
        data: {'phone': phone, 'password': password},
        options: Options(
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print('📩 Status Code: ${response.statusCode}');
      print('📩 Response Data: ${response.data}');

      final status = response.data['status'];
      if (response.statusCode == 200 && status == 200) {
        final data = response.data['data'];
        final token = data['token'];
        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';
        final phoneNumber = data['phone'] ?? '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', '$firstName $lastName');
        await prefs.setString('phone', phoneNumber.toString());
        await prefs.setString('token', token);
        await prefs.setBool('is_logged_in', true);

        print('🎉 تم تسجيل الدخول بنجاح! التوكن: $token');

        initialToken = token;

        if (fcmToken != null) {
          await _updateFcmToken(fcmToken, token);
        }

        emit(LoginSuccess());
      } else if (response.statusCode == 403 &&
          response.data["data"]?["needs_verification"] == true) {
        final phone = response.data["data"]["phone"];
        emit(LoginNeedsVerification(phone: phone));
      } else {
        final errorMessage = response.data['msg'] ?? 'فشل تسجيل الدخول';
        emit(LoginFailure(message: errorMessage));
      }
    } on DioError catch (dioError) {
      print('❌ DioError: ${dioError.message}');
      emit(LoginFailure(
          message:
          dioError.response?.data['msg'] ?? 'خطأ في الاتصال بالسيرفر'));
    } catch (e, stack) {
      print('❌ استثناء غير متوقع: $e');
      print('📝 Stacktrace: $stack');
      emit(LoginFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final res = await dio.post(
        "$mainApi/reset-password",
        data: {
          "phone": phone,
          "otp": otp,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Accept-Language": langCode == '' ? "en" : langCode
          },
        ),
      );

      print("📩 Reset response: ${res.data}");

      if (res.statusCode == 200) {
        final message = res.data["message"]?.toString() ?? "";
        if (message.toLowerCase().contains("success")) {
          emit(ResetPasswordSuccess());
        } else {
          emit(ResetPasswordFailure(message: message));
        }
      } else {
        emit(ResetPasswordFailure(
            message: res.data['message'] ?? 'تعذر إعادة تعيين كلمة المرور'));
      }
    } catch (e) {
      emit(ResetPasswordFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> forgotPassword({required String phone}) async {
    emit(ForgotPasswordLoading());
    print("📞 Sending forgot-password request for $phone");

    try {
      final res = await dio.post(
        "$mainApi/forgot-password",
        data: {"phone": phone},
      );

      print("📩 Response: ${res.data}");

      if (res.statusCode == 200 && res.data["otp"] != null) {
        final otp = res.data["otp"];
        final phoneFromApi = res.data["phone"] ?? phone;

        emit(
            ForgotPasswordSuccess(phone: phoneFromApi, otp: otp.toString()));
      } else {
        emit(ResetPasswordFailure(
            message: res.data["message"] ?? "فشل إرسال الكود"));
      }
    } catch (e) {
      emit(
        ResetPasswordFailure(message: "خطأ في الاتصال بالسيرفر"),
      );
    }
  }

  Future<void> requestResetPassword(String phone) async {
    emit(RequestResetLoading());
    print("📡 [requestResetPassword] إرسال طلب إعادة تعيين كلمة المرور...");
    print("➡️ البيانات المرسلة: phone=$phone");

    try {
      final response = await dio.post(
        mainApi + request_resetApi,
        data: {"phone": phone},
      );

      print("📩 Response StatusCode: ${response.statusCode}");
      print("📩 Response Body: ${response.data}");

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        emit(RequestResetSuccess());
      } else {
        emit(RequestResetFailure(
            message: serverMsg ?? 'فشل إرسال الكود'));
      }
    } catch (e) {
      emit(
          RequestResetFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> verifyResetPassword(String phone, String otp) async {
    emit(VerifyResetLoading());
    print("📡 [verifyResetPassword] التحقق من الكود...");
    print("➡️ البيانات المرسلة: phone=$phone, otp=$otp");

    try {
      final response = await dio.post(
        mainApi + verify_resetApi,
        data: {"phone": phone, "otp": otp},
      );

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        emit(VerifyResetSuccess());
      } else {
        emit(VerifyResetFailure(
            message: serverMsg ?? 'فشل التحقق من الكود'));
      }
    } catch (e) {
      emit(VerifyResetFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> submitNewPassword(
      String phone, String password, String confirmPassword) async {
    emit(SubmitNewPasswordLoading());
    print("📡 [submitNewPassword] تغيير كلمة المرور...");
    print(
        "➡️ البيانات: phone=$phone, password=$password, confirm=$confirmPassword");

    try {
      final response = await dio.post(
        mainApi + submit_newApi,
        data: {
          "phone": phone,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        emit(SubmitNewPasswordSuccess());
      } else {
        emit(SubmitNewPasswordFailure(
            message: serverMsg ?? 'فشل تغيير كلمة المرور'));
      }
    } catch (e) {
      emit(
          SubmitNewPasswordFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }
}
