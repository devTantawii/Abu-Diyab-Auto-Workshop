import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/old_orders_repo.dart';
import 'old_orders_state.dart';


class OldOrdersCubit extends Cubit<OldOrdersState> {
  OldOrdersCubit() : super(OldOrdersInitial());

  Future<void> getOldOrders() async {
    final OldOrdersRepo repo = OldOrdersRepo();

    emit(OldOrdersLoading());
    try {
      final orders = await repo.fetchOldOrders();
      emit(OldOrdersSuccess(orders));
    } catch (e) {
      emit(OldOrdersError(e.toString()));
    }
  }
}
