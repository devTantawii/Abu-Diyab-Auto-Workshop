
import 'package:flutter/material.dart';

@immutable
abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final String message;
  ContactUsSuccess(this.message);
}


class ContactUsError extends ContactUsState {
  final String message;
  ContactUsError(this.message);
}