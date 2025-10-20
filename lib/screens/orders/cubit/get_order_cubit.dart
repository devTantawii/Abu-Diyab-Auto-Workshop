

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/get_order_repo.dart';
import 'get_order_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo repo;

  OrdersCubit(this.repo) : super(OrdersInitial());

  Future<void> getAllOrders() async {
    emit(OrdersLoading());
    try {
      final result = await repo.getAllOrders();
      emit(OrdersSuccess(result.data));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
