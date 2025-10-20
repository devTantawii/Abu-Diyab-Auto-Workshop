
import '../model/get_order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<OrderSummary> orders;

  OrdersSuccess(this.orders);
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);
}
