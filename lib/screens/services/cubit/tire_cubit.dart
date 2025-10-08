import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/tire_repo.dart';
import 'tire_state.dart';
import '../model/tire_model.dart';

class TireCubit extends Cubit<TireState> {
  final TireRepository repository;
  List<Tire> allTires = []; // لتخزين كل الكفرات عند التحميل

  TireCubit(this.repository) : super(TireInitial());

  Future<void> fetchTires({String? size}) async {
    try {
      emit(TireLoading());
      final tires = await repository.getTires(size: size);
      emit(TireLoaded(tires));
    } catch (e) {
      emit(TireError(e.toString()));
    }
  }


  // فلترة حسب المقاس
  void filterTiresBySize(String? size) {
    if (size == null) {
      emit(TireLoaded(allTires)); // لو مفيش فلتر، عرض كل الكفرات
    } else {
      final filtered = allTires.where((t) => t.size == size).toList();
      emit(TireLoaded(filtered));
    }
  }

}
