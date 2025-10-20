
import 'package:flutter/material.dart';

import '../model/get_order_details_model.dart';

@immutable
abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderData order;
  OrderDetailsSuccess(this.order);
}

class OrderDetailsError extends OrderDetailsState {
  final String message;
  OrderDetailsError(this.message);
}
