import '../model/battery_model.dart';

abstract class BatteryState {}

class BatteryInitial extends BatteryState {}

class BatteryLoading extends BatteryState {}

class BatteryLoaded extends BatteryState {
  final BatteryResponse response; // يشمل data + pagination
  BatteryLoaded(this.response);
}

class BatteryError extends BatteryState {
  final String message;
  BatteryError(this.message);
}
