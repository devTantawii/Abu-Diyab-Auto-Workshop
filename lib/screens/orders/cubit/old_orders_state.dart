

import '../model/old_order_model.dart';

abstract class OldOrdersState {}

class OldOrdersInitial extends OldOrdersState {}

class OldOrdersLoading extends OldOrdersState {}

class OldOrdersSuccess extends OldOrdersState {
  final List<OldOrderModel> orders;
  OldOrdersSuccess(this.orders);
}

class OldOrdersError extends OldOrdersState {
  final String message;
  OldOrdersError(this.message);
}
