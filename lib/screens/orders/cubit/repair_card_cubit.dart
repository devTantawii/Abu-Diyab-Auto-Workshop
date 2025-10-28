import 'package:abu_diyab_workshop/screens/orders/cubit/repair_card_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/repair_card_model.dart';

class RepairCardsCubit extends Cubit<RepairCardsState> {
  RepairCardsCubit() : super(RepairCardsInitial());

  Future<void> getRepairCards(int orderId) async {
    print("🔹 [RepairCardsCubit] Starting getRepairCards(orderId: $orderId)");
    emit(RepairCardsLoading());

    try {
      final url = '$mainApi/app/elwarsha/orders/get-repair-cards';
      print("🌐 Request URL: $url");
      print("📦 Query Params: {order_id: $orderId}");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await Dio().get(
        url,
        queryParameters: {'order_id': orderId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": langCode == '' ? "en" : langCode
          },
        ),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Full Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data['data'] == null) {
          print("⚠️ Response data is null or empty");
          emit(RepairCardsError("No data found"));
          return;
        }

        final data = response.data['data'] as List;
        print("✅ Parsed List Length: ${data.length}");

        final cards = data.map((e) {
          print("🧩 Mapping RepairCard: $e");
          return RepairCardModel.fromJson(e);
        }).toList();

        print("✅ Successfully parsed ${cards.length} repair cards");
        emit(RepairCardsSuccess(cards));
      } else {
        print("❌ Unexpected status code: ${response.statusCode}");
        emit(RepairCardsError("Unexpected status code: ${response.statusCode}"));
      }
    } catch (e, s) {
      print("🔥 Exception in getRepairCards: $e");
      print("🧾 Stacktrace: $s");
      emit(RepairCardsError(e.toString()));
    }
  }

  Future<void> updateRepairCheck(int orderId, Map<String, int> data) async {
    try {
      final url = '$mainApi/app/elwarsha/orders/update-repair-check';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await Dio().post(
        url,
        data: data, // هنا نرسل الـ map
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": langCode == '' ? "en" : langCode,
            "Content-Type": "application/x-www-form-urlencoded", // أو application/json حسب الـ API
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Updated successfully");
      } else {
        print("❌ Failed to update: ${response.data}");
      }
    } catch (e, s) {
      print("🔥 Exception in updateRepairCheck: $e");
      print("🧾 Stacktrace: $s");
    }
  }

}
