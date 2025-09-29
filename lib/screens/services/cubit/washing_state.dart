part of 'washing_cubit.dart';

@immutable
sealed class WashingState {}

final class WashingInitial extends WashingState {}
class WashingLoading extends WashingState {}

class WashingLoaded extends WashingState {
  final List<CarWashing> services;
  final List<bool> selections;

  WashingLoaded(this.services, this.selections);
}


class WashingError extends WashingState {
  final String message;
  WashingError(this.message);
}