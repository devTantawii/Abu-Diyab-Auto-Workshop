part of 'contact_us_cubit.dart';


@immutable
abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final ContactUsResponse response;
  ContactUsSuccess(this.response);
}

class ContactUsError extends ContactUsState {
  final String message;
  ContactUsError(this.message);
}