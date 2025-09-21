import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/car_check_repo.dart';
import 'car_check_state.dart';

class CarCheckCubit extends Cubit<CarCheckState> {
  final CarCheckRepository repository;

  CarCheckCubit(this.repository) : super(CarCheckInitial());
  void resetCarChecks() {
    emit(CarCheckInitial());
  }
  Future<void> fetchCarChecks(
     int carModelId,
  ) async {
    emit(CarCheckLoading());
    try {
      final result = await repository.getCarChecks(
        carModelId: carModelId,
      );
      emit(CarCheckLoaded(result));
    } catch (e) {
      emit(CarCheckError(e.toString()));
    }
  }
  void toggleSelection(int index, bool value) {
    if (state is CarCheckLoaded) {
      final current = (state as CarCheckLoaded);
      final newSelections = List<bool>.from(current.selections);
      newSelections[index] = value;
      emit(current.copyWith(selections: newSelections));
    }
  }

}
