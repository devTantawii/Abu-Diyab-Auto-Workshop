import '../model/repair_card_model.dart';

abstract class RepairCardsState {}

class RepairCardsInitial extends RepairCardsState {}

class RepairCardsLoading extends RepairCardsState {}

class RepairCardsSuccess extends RepairCardsState {
  final List<RepairCardModel> cards;

  RepairCardsSuccess(this.cards);
}

class RepairCardsError extends RepairCardsState {
  final String message;

  RepairCardsError(this.message);
}
