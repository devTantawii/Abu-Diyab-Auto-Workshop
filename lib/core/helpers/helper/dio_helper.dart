// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../screens/auth/cubit/login_cubit.dart';
// import '../../../screens/auth/screen/login.dart';
// import '../../constant/api.dart';
//
// // 🔑 global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class DioHelper {
//   static Dio? _dio;
//
//   static Dio init() {
//     if (_dio != null) return _dio!;
//
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: mainApi, // ✅ استخدمه بدل ما تكتب اللينك يدوي
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         headers: {
//           'Accept': 'application/json',
//         },
//       ),
//     );
//
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final prefs = await SharedPreferences.getInstance();
//           final token = prefs.getString('token');
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           return handler.next(options);
//         },
//         onError: (DioError e, ErrorInterceptorHandler handler) async {
//           // ✅ لو السيرفر رجع Unauthorized
//           if (e.response?.statusCode == 401) {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.remove('token');
//
//             // 🔥 افتح BottomSheet تسجيل الدخول
//             final ctx = navigatorKey.currentContext;
//             if (ctx != null) {
//               showModalBottomSheet(
//                 context: ctx,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => FractionallySizedBox(
//                   widthFactor: 1,
//                   child: BlocProvider(
//                     create: (_) => LoginCubit(dio: DioHelper.init()),
//                     child: const LoginBottomSheet(),
//                   ),
//                 ),
//               );
//             }
//           }
//           return handler.next(e);
//         },
//       ),
//     );
//
//     _dio = dio;
//     return _dio!;
//   }
// }
//BlocProvider(create: (_) => LoginCubit(dio: DioHelper.init()),
