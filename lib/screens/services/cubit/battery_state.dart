
import '../model/battery_model.dart';

abstract class BatteryState {}

class BatteryInitial extends BatteryState {}
class BatteryLoading extends BatteryState {}

// بدل BatteryLoaded القديمة
class BatteryLoaded extends BatteryState {
  final List<Service> services; // <- هنا
  BatteryLoaded(this.services);
}

class BatteryError extends BatteryState {
  final String message;
  BatteryError(this.message);
}
