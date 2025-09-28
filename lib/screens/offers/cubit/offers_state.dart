
import '../model/offers_model.dart';

abstract class OffersState {
  const OffersState();

  @override
  List<Object?> get props => [];
}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<Offer> offers;

  const OffersLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class OffersError extends OffersState {
  final String message;

  const OffersError(this.message);

  @override
  List<Object?> get props => [message];
}
