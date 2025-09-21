// lib/features/maintenance/cubit/maintenance_state.dart


abstract class MaintenanceState  {
  const MaintenanceState();

  @override
  List<Object?> get props => [];
}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceSuccess extends MaintenanceState {
  final dynamic data; // response data
  const MaintenanceSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

class MaintenanceFailure extends MaintenanceState {
  final String message;
  final int? statusCode;
  const MaintenanceFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
