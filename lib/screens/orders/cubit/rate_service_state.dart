// lib/features/rate_service/cubit/rate_service_state.dart

part of 'rate_service_cubit.dart';

enum RateServiceStatus { initial, loading, success, failure }

class RateServiceState extends Equatable {
  final RateServiceStatus status;
  final String? errorMessage;
  final int rating;
  final String comment;

  const RateServiceState({
    this.status = RateServiceStatus.initial,
    this.errorMessage,
    this.rating = 1,
    this.comment = '',
  });

  RateServiceState copyWith({
    RateServiceStatus? status,
    String? errorMessage,
    int? rating,
    String? comment,
  }) {
    return RateServiceState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, rating, comment];
}