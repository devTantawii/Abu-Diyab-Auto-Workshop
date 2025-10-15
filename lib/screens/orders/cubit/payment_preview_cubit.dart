import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abu_diyab_workshop/screens/orders/repo/payment_service.dart';

import '../model/payment_preview_model.dart'; // make sure to import your model

part 'payment_preview_state.dart';

class PaymentPreviewCubit extends Cubit<PaymentPreviewState> {
  final PaymentService service;

  PaymentPreviewCubit(this.service) : super(PaymentPreviewInitial());

  Future<void> getPaymentPreview({
    required int selectedIndex,
    required String type,
    required String id,
  }) async {
    emit(PaymentPreviewLoading());

    try {
      final deliveryMethod = selectedIndex == 0 ? "towTruck" : "inWorkshop";

      final response = await service.previewPayment(
        deliveryMethod: deliveryMethod,
        type: type,
        id: id,
        quantity: 1,
      );

      final data = response['data'];
      final previewModel = PaymentPreviewModel.fromJson(data);

      emit(PaymentPreviewSuccess(previewModel));
    } catch (e) {
      emit(PaymentPreviewFailure(e.toString()));
    }
  }
}
