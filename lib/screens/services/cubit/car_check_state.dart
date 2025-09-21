

import '../model/car_check_model.dart';

abstract class CarCheckState{
  @override
  List<Object?> get props => [];
}

class CarCheckInitial extends CarCheckState {}

class CarCheckLoading extends CarCheckState {}

class CarCheckLoaded extends CarCheckState {
  final CarCheck carCheck;
  final List<bool> selections;

  CarCheckLoaded(
      this.carCheck, {
        List<bool>? selections,
      }) : selections = selections ?? List<bool>.filled(carCheck.data?.length ?? 0, false);

  CarCheckLoaded copyWith({
    CarCheck? carCheck,
    List<bool>? selections,
  }) {
    final newCarCheck = carCheck ?? this.carCheck;
    return CarCheckLoaded(
      newCarCheck,
      selections: selections ?? this.selections,
    );
  }

  @override
  List<Object?> get props => [carCheck, selections];
}

class CarCheckError extends CarCheckState {
  final String message;

  CarCheckError(this.message);

  @override
  List<Object?> get props => [message];
}
