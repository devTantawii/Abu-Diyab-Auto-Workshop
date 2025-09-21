import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/battery_repo.dart';
import 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository repository;
  BatteryCubit(this.repository) : super(BatteryInitial());

  Future<void> fetchServicesByModel(int modelId) async {
    try {
      emit(BatteryLoading());

      final services = await repository.getServicesByModel(modelId);

      // ✅ طباعة الداتا
      print("===== Fetched Services =====");
      for (var service in services) {
        print("Service: ${service.name}, Description: ${service.description}");
        for (var battery in service.batteryChanges) {
          print(
              "  Battery: ${battery.type}, Country: ${battery.country}, Price: ${battery.price}");
        }
      }
      print("===== End of Services =====");

      emit(BatteryLoaded(services));
    } catch (e) {
      print("Error fetching services: $e"); // طباعة الخطأ لو حصل
      emit(BatteryError(e.toString()));
    }
  }
}
