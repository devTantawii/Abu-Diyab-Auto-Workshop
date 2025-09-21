import '../model/CarModel.dart';

abstract class CarModelState {}

class CarModelInitial extends CarModelState {}

class CarModelLoading extends CarModelState {}

class CarModelLoaded extends CarModelState {
  final List<CarModel> models;
  final String? message;

  CarModelLoaded(this.models, {this.message});
}

class CarModelError extends CarModelState {
  final String message;

  CarModelError(this.message);
}
