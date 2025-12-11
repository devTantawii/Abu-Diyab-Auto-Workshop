part of 'subscriptions_cubit.dart';

abstract class SubscriptionsState {
  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {}

class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionsLoaded extends SubscriptionsState {
  final List<Subscription> subscriptions;

  SubscriptionsLoaded({required this.subscriptions});

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionsError extends SubscriptionsState {
  final String message;

  SubscriptionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
