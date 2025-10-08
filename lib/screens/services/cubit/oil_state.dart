import '../model/oil_model.dart';

abstract class OilState {}

class OilInitial extends OilState {}

class OilLoading extends OilState {}

class OilLoaded extends OilState {
  final List<OilProduct> oils;
  final List<bool> selections;

  OilLoaded(this.oils, {List<bool>? selections})
      : selections = selections ?? List<bool>.filled(oils.length, false);

  OilLoaded copyWith({
    List<OilProduct>? oils,
    List<bool>? selections,
  }) {
    return OilLoaded(
      oils ?? this.oils,
      selections: selections ?? this.selections,
    );
  }
}



class OilError extends OilState {
  final String message;
  OilError(this.message);
}
