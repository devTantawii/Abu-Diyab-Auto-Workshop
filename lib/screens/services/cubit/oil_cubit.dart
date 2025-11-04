import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/oil_repo.dart';
import '../model/oil_model.dart';
import 'oil_state.dart';

class OilCubit extends Cubit<OilState> {
  final OilRepository repository;
  List<OilProduct> allOils = [];

  OilCubit(this.repository) : super(OilInitial());

  void resetOils() {
    emit(OilInitial());
    allOils.clear();
  }

  Future<void> fetchOils() async {
    try {
      emit(OilLoading());
      final oils = await repository.getOils();
      allOils = oils;
      emit(OilLoaded(oils));
    } catch (e) {
      emit(OilError(e.toString()));
    }
  }

  /// بحث + فلترة (يدعم كلاهما معًا)
  Future<void> searchOils({String? search, String? viscosity}) async {
    try {
      emit(OilLoading());

      // جلب الزيوت مع البحث
      final oils = await repository.getOils(search: search);

      // فلترة محلية باللزوجة (لو موجودة)
      final filtered = viscosity == null || viscosity.isEmpty
          ? oils
          : oils.where((oil) => oil.viscosty.toLowerCase() == viscosity.toLowerCase()).toList();

      allOils = oils; // نحتفظ بالنسخة الأصلية للفلترة لاحقًا
      emit(OilLoaded(filtered));
    } catch (e) {
      emit(OilError(e.toString()));
    }
  }

  void toggleSelection(int index, bool isSelected) {
    if (state is OilLoaded) {
      final current = state as OilLoaded;
      final newSelections = List<bool>.filled(current.oils.length, false);
      if (isSelected) newSelections[index] = true;
      emit(current.copyWith(selections: newSelections));
    }
  }
}