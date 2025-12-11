import '../model/package_details_model.dart';

abstract class PackageDetailsState {}

class PackageDetailsInitial extends PackageDetailsState {}

class PackageDetailsLoading extends PackageDetailsState {}

class PackageDetailsSuccess extends PackageDetailsState {
  final PackageDetailsResponse data;

  PackageDetailsSuccess(this.data);
}

class PackageDetailsFailure extends PackageDetailsState {
  final String message;

  PackageDetailsFailure(this.message);
}
