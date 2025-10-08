// import 'package:abu_diyab_workshop/screens/services/model/washing_model.dart';
// import 'package:abu_diyab_workshop/screens/services/repo/washing_repo.dart';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'washing_state.dart';
//
// class WashingCubit extends Cubit<WashingState> {
//   WashingCubit(this.repository) : super(WashingInitial());
//   final WashingRepo repository;
//   void resetCarWashing() {
//     emit(WashingInitial());
//   }
//   void toggleSelection(int index, bool value) {
//     if (state is WashingLoaded) {
//       final currentState = state as WashingLoaded;
//       final updatedSelections = List<bool>.from(currentState.selections);
//       updatedSelections[index] = value;
//       emit(WashingLoaded(currentState.services, updatedSelections));
//     }
//   }
//
//   Future<void> fetchWashingServicesByModel(int modelId) async {
//     try {
//       emit(WashingLoading());
//       final services = await repository.getWashingServicesByModel(modelId);
//       final selections = List<bool>.filled(services.length, false); // 👈 كلها false
//
//       emit(WashingLoaded(services, selections));
//
//     } catch (e) {
//       emit(WashingError(e.toString()));
//     }
//   }
// }
import 'package:abu_diyab_workshop/screens/services/cubit/washing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/washing_repo.dart';


class CarWashCubit extends Cubit<CarWashState> {
  final CarWashServiceRepo repo;

  CarWashCubit(this.repo) : super(CarWashInitial());

  Future<void> fetchCarWashServices({int page = 1}) async {
    emit(CarWashLoading());
    try {
      final response = await repo.getCarWashServices(page: page);
      emit(CarWashLoaded(response.data, response.pagination));
    } catch (e) {
      emit(CarWashError(e.toString()));
    }
  }
}
