// login_cubit.dart
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../model/login_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio;

  LoginCubit({required this.dio}) : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoading());
    print('📡 جاري محاولة تسجيل الدخول...');
    print('➡️ البيانات المرسلة: phone $phone, password $password');

    try {
      final response = await dio.post(
        mainApi + loginApi,
        data: {'phone': phone, 'password': password},
      );

      print('📩 Status Code: ${response.statusCode}');
      print('📩 Response Data: ${response.data}');

      // تحقق من أن الرد ناجح
      final status = response.data['status'];
      if (response.statusCode == 200 && status == 200) {
        final data = response.data['data'];
        print('✅ الرد يحتوي على بيانات المستخدم: $data');

        // استخراج البيانات مباشرة من response
        final token = data['token'];
        final firstName = data['first_name'] ?? '';
        final lastName = data['last_name'] ?? '';
        final phoneNumber = data['phone'] ?? '';

        final prefs = await SharedPreferences.getInstance();

        // مسح أي توكين قديم قبل حفظ الجديد
        await prefs.remove('token');

        // حفظ بيانات المستخدم
        await prefs.setString('username', '$firstName $lastName');
        await prefs.setString('phone', phoneNumber.toString());
        await prefs.setString('token', token);
        await prefs.setBool('is_logged_in', true);

        print('🎉 تم تسجيل الدخول بنجاح! التوكن: $token');

        // تحديث initialToken في main.dart
        initialToken = token;

        emit(LoginSuccess());
      } else {
        final errorMessage = response.data['msg'] ?? 'فشل تسجيل الدخول';
        print('⚠️ فشل تسجيل الدخول: $errorMessage');
        emit(LoginFailure(message: errorMessage));
      }
    } on DioError catch (dioError) {
      // هندلة أخطاء Dio (زي Timeout أو Bad Response)
      print('❌ DioError: ${dioError.message}');
      if (dioError.response != null) {
        print('📩 DioError Response: ${dioError.response?.data}');
        emit(LoginFailure(message: dioError.response?.data['msg'] ?? 'خطأ من السيرفر'));
      } else {
        emit(LoginFailure(message: 'مشكلة في الاتصال بالسيرفر'));
      }
    } catch (e, stack) {
      // أي خطأ غير متوقع
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
        print("❌ Reset exception: ");

        emit(
          ResetPasswordFailure(
            message: res.data['message'] ?? 'تعذر إعادة تعيين كلمة المرور',
          ),
        );
      }
    } catch (e) {
      emit(ResetPasswordFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> forgotPassword({required String phone}) async {
    emit(ForgotPasswordLoading()); // ✅ صحح هنا
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
        print("✅ OTP from server: $otp");

        emit(ForgotPasswordSuccess(phone: phoneFromApi, otp: otp.toString()));
      } else {
        print("❌ Failure: ${res.data["message"]}");
        emit(
          ResetPasswordFailure(
            // ✅ صحح هنا
            message: res.data["message"] ?? "فشل إرسال الكود",
          ),
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      emit(
        ResetPasswordFailure(
          // ✅ صحح هنا
          message: "خطأ في الاتصال بالسيرفر",
        ),
      );
    }
  }


  Future<void> requestResetPassword(String phone) async {
    emit(RequestResetLoading());
    print("📡 [requestResetPassword] إرسال طلب إعادة تعيين كلمة المرور...");
    print("➡️ البيانات المرسلة: phone=$phone");

    try {
      final response = await dio.post(
        mainApi+request_resetApi,
        data: {"phone": phone},
      );

      print("📩 Response StatusCode: ${response.statusCode}");
      print("📩 Response Body: ${response.data}");

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        print("✅ [requestResetPassword] OTP تم إرساله بنجاح");
        emit(RequestResetSuccess());
      } else {
        print("⚠️ [requestResetPassword] فشل: $serverMsg");
        emit(RequestResetFailure(message: serverMsg ?? 'فشل إرسال الكود'));
      }
    } catch (e) {
      print("❌ [requestResetPassword] Exception: $e");
      emit(RequestResetFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> verifyResetPassword(String phone, String otp) async {
    emit(VerifyResetLoading());
    print("📡 [verifyResetPassword] التحقق من الكود...");
    print("➡️ البيانات المرسلة: phone=$phone, otp=$otp");

    try {
      final response = await dio.post(
        mainApi+ verify_resetApi,
        data: {"phone": phone, "otp": otp},
      );

      print("📩 Response StatusCode: ${response.statusCode}");
      print("📩 Response Body: ${response.data}");

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        print("✅ [verifyResetPassword] الكود صحيح ✔️");
        emit(VerifyResetSuccess());
      } else {
        print("⚠️ [verifyResetPassword] الكود غير صحيح: $serverMsg");
        emit(VerifyResetFailure(message: serverMsg ?? 'فشل التحقق من الكود'));
      }
    } catch (e) {
      print("❌ [verifyResetPassword] Exception: $e");
      emit(VerifyResetFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> submitNewPassword(
      String phone, String password, String confirmPassword) async {
    emit(SubmitNewPasswordLoading());
    print("📡 [submitNewPassword] تغيير كلمة المرور...");
    print(
        "➡️ البيانات المرسلة: phone=$phone, password=$password, confirm=$confirmPassword");

    try {
      final response = await dio.post(
        mainApi+submit_newApi,
        data: {
          "phone": phone,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      print("📩 Response StatusCode: ${response.statusCode}");
      print("📩 Response Body: ${response.data}");

      final serverStatus = response.data['status'];
      final serverMsg = response.data['msg'];

      if (response.statusCode == 200 && serverStatus == 200) {
        print("✅ [submitNewPassword] كلمة المرور اتغيرت بنجاح 🎉");
        emit(SubmitNewPasswordSuccess());
      } else {
        print("⚠️ [submitNewPassword] فشل تغيير الباسورد: $serverMsg");
        emit(SubmitNewPasswordFailure(
            message: serverMsg ?? 'فشل تغيير كلمة المرور'));
      }
    } catch (e) {
      print("❌ [submitNewPassword] Exception: $e");
      emit(SubmitNewPasswordFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }



















}
