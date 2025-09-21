// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../model/car_model_brand_model.dart';
// import 'car_state.dart';
//
// class UserCarsCubit extends Cubit<UserCarsState> {
//   UserCarsCubit() : super(UserCarsInitial());
//
//   Future<void> fetchUserCars() async {
//     emit(UserCarsLoading());
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     try {
//       final response = await Dio().get(
//         "https://devapi.a-vsc.com/api/app/elwarsha/user-cars/get",
//         options: Options(
//           headers: {
//
//             "Authorization": "Bearer $token",
//           },
//         ),
//       );
//
//       if (response.statusCode == 200 &&
//           response.data['data'] != null &&
//           response.data['data'] is List) {
//         final List<UserCarModel> cars = (response.data['data'] as List)
//             .map((e) => UserCarModel.fromJson(e))
//             .toList();
//
//         emit(UserCarsLoaded(cars));
//       } else {
//         emit(const UserCarsError("Unexpected response format"));
//       }
//     } catch (e) {
//       emit(UserCarsError(e.toString()));
//     }
//   }
// }
