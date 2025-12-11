import '../model/get_pack_model.dart';

abstract class PackagesState {}

class PackagesInitial extends PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesSuccess extends PackagesState {
  final List<PackageModel> packages;

  PackagesSuccess(this.packages);
}

class PackagesFailure extends PackagesState {
  final String error;

  PackagesFailure(this.error);
}
