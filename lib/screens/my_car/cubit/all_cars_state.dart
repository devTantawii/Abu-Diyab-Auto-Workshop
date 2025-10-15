import '../model/all_cars_model.dart';

abstract class CarState {}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<Car> cars;
  CarLoaded(this.cars);
}

class CarSingleLoaded extends CarState {
  final Car car;
  CarSingleLoaded(this.car);
}

class CarError extends CarState {
  final String message;
  CarError(this.message);
}

// States إضافية لتعديل السيارة
class UpdateCarLoading extends CarState {}

class UpdateCarSuccess extends CarState {
  final String message;
  UpdateCarSuccess({required this.message});
}

class UpdateCarError extends CarState {
  final String message;
  UpdateCarError({required this.message});
}
class SingleCarLoading extends CarState {}

class SingleCarLoaded extends CarState {
  final Car car;
  SingleCarLoaded(this.car);
}

class SingleCarError extends CarState {
  final String message;
  SingleCarError(this.message);
}
