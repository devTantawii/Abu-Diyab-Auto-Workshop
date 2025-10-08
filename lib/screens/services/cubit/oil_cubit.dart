import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/oil_repo.dart';
import '../model/oil_model.dart';
import 'oil_state.dart';

class OilCubit extends Cubit<OilState> {
  final OilRepository repository;

  /// قائمة كل الزيوت (نستخدمها للفلترة)
  List<OilProduct> allOils = [];

  OilCubit(this.repository) : super(OilInitial());

  /// إعادة التهيئة
  void resetOils() {
    emit(OilInitial());
    allOils = [];
  }

  /// تحميل الزيوت من السيرفر
  Future<void> fetchOils() async {
    try {
      emit(OilLoading());
      final oils = await repository.getOils();
      allOils = oils; // حفظ النسخة الأصلية
      emit(OilLoaded(oils));
    } catch (e) {
      emit(OilError(e.toString()));
    }
  }

  /// فلترة الزيوت حسب اللزوجة
  void filterOilsByViscosity(String? viscosity) {
    if (viscosity == null || viscosity.isEmpty) {
      emit(OilLoaded(
        allOils,
        selections: List.filled(allOils.length, false),
      ));
    } else {
      final filtered = allOils
          .where((oil) =>
      oil.viscosty.toLowerCase() == viscosity.toLowerCase())
          .toList();

      emit(OilLoaded(
        filtered,
        selections: List.filled(filtered.length, false),
      ));
    }
  }

  void toggleSelection(int index, bool isSelected) {
    if (state is OilLoaded) {
      final currentState = state as OilLoaded;

      // ❌ نعمل reset لكل القيم إلى false
      final newSelections = List<bool>.filled(currentState.oils.length, false);

      // ✅ نحدد العنصر الحالي فقط لو المستخدم ضغط عليه
      if (isSelected) {
        newSelections[index] = true;
      }

      emit(currentState.copyWith(selections: newSelections));
    }
  }

}
