// oil_state.dart

import '../model/tire_model.dart';

abstract class TireState {}

class TireInitial extends TireState {}

class TireLoading extends TireState {}

class TireLoaded extends TireState {
  final List<SubTireService> services;
  TireLoaded(this.services);
}

class TireError extends TireState {
  final String message;
  TireError(this.message);
}
