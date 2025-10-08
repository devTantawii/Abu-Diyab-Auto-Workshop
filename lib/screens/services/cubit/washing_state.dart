// part of 'washing_cubit.dart';
//
// @immutable
// sealed class WashingState {}
//
// final class WashingInitial extends WashingState {}
// class WashingLoading extends WashingState {}
//
// class WashingLoaded extends WashingState {
//   final List<CarWashing> services;
//   final List<bool> selections;
//
//   WashingLoaded(this.services, this.selections);
// }
//
//
// class WashingError extends WashingState {
//   final String message;
//   WashingError(this.message);
// }

import '../model/washing_model.dart';

abstract class CarWashState  {
  @override
  List<Object?> get props => [];
}

class CarWashInitial extends CarWashState {}

class CarWashLoading extends CarWashState {}

class CarWashLoaded extends CarWashState {
  final List<CarWashService> services;
  final Pagination pagination;

  CarWashLoaded(this.services, this.pagination);

  @override
  List<Object?> get props => [services, pagination];
}

class CarWashError extends CarWashState {
  final String message;

  CarWashError(this.message);

  @override
  List<Object?> get props => [message];
}
