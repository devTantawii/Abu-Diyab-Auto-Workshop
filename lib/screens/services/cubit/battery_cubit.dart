import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/battery_repo.dart';
import '../model/battery_model.dart';
import 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository repository;
  BatteryCubit(this.repository) : super(BatteryInitial());

  Future<void> fetchBatteries({
    int page = 1,
    int perPage = 100,
    String? amper,
    String? search,          // ← أضف الباراميتر
  }) async {
    try {
      emit(BatteryLoading());

      final response = await repository.getBatteries(
        page: page,
        perPage: perPage,
        amper: amper,
        search: search,      // ← مرره هنا
      );

      // طباعة النتائج (اختياري)
      print("===== Fetched Batteries =====");
      for (var battery in response.data) {
        print(
            "Battery: ${battery.name}, ${battery.amper}, Country: ${battery.country}, Price: ${battery.price}");
      }
      print("===== End of Batteries =====");

      emit(BatteryLoaded(response));
    } catch (e) {
      print("Error fetching batteries: $e");
      emit(BatteryError(e.toString()));
    }
  }
}
