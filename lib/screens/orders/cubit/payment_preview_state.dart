part of 'payment_preview_cubit.dart';

abstract class PaymentPreviewState {}

class PaymentPreviewInitial extends PaymentPreviewState {}

class PaymentPreviewLoading extends PaymentPreviewState {}

class PaymentPreviewSuccess extends PaymentPreviewState {
  final PaymentPreviewModel preview;
  PaymentPreviewSuccess(this.preview);
}

class PaymentPreviewFailure extends PaymentPreviewState {
  final String message;
  PaymentPreviewFailure(this.message);
}
