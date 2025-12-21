import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/battery_repo.dart';
import 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository repository;
  BatteryCubit(this.repository) : super(BatteryInitial());

  Future<void> fetchBatteries({
    int page = 1,
    int perPage = 100,
    String? amper,
    String? search,
  }) async {
    try {
      emit(BatteryLoading());

      final response = await repository.getBatteries(
        page: page,
        perPage: perPage,
        amper: amper,
        search: search,
      );

      for (var battery in response.data) {

      }

      emit(BatteryLoaded(response));
    } catch (e) {
      emit(BatteryError(e.toString()));
    }
  }
}
