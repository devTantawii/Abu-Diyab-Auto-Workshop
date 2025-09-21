// oil_state.dart

import '../model/oil_model.dart';

abstract class OilState {}

class OilInitial extends OilState {}
class OilLoading extends OilState {}
class OilLoaded extends OilState {
  final List<SubOil> oils;
  final List<bool> selections;

  OilLoaded(
      this.oils, {
        List<bool>? selections,
      }) : selections = selections ?? List<bool>.filled(oils.length, false);

  OilLoaded copyWith({
    List<SubOil>? oils,
    List<bool>? selections,
  }) {
    final newOils = oils ?? this.oils;
    return OilLoaded(
      newOils,
      selections: selections ?? this.selections,
    );
  }
}

class OilError extends OilState {
  final String message;
  OilError(this.message);
}
