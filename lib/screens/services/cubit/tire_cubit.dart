import 'package:abu_diyab_workshop/screens/services/cubit/tire_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/oil_repo.dart';
import '../repo/tire_repo.dart';
import 'oil_state.dart';
class TireCubit extends Cubit<TireState> {
  final TireRepository repository;

  TireCubit(this.repository) : super(TireInitial());

  Future<void> fetchTireServicesByModel(int modelId) async {
    try {
      emit(TireLoading());
      final services = await repository.getTireServicesByModel(modelId);
      emit(TireLoaded(services));
    } catch (e) {
      emit(TireError(e.toString()));
    }
  }
}
