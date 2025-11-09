import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/tire_repo.dart';
import 'tire_state.dart';
import '../model/tire_model.dart';

class TireCubit extends Cubit<TireState> {
  final TireRepository repository;
  List<Tire> allTires = [];

  TireCubit(this.repository) : super(TireInitial());

  Future<void> fetchTires() async {
    try {
      emit(TireLoading());
      final tires = await repository.getTires();
      allTires = tires;
      emit(TireLoaded(tires));
    } catch (e) {
      emit(TireError(e.toString()));
    }
  }

  Future<void> searchAndFilter({String? search, String? size}) async {
    try {
      emit(TireLoading());
      final tires = await repository.getTires(size: size, search: search);
      allTires = tires;
      emit(TireLoaded(tires));
    } catch (e) {
      emit(TireError(e.toString()));
    }
  }
}