// lib/features/services/presentation/cubit/services_state.dart



import '../model/service_model.dart';

abstract class ServicesState   {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;
  final List<ProductModel> products;

  const ServicesLoaded({
    required this.services,
    required this.products,
  });
}
class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object> get props => [message];
}