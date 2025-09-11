import 'package:flutter/material.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginFailure extends LoginState {
  final String message;
  LoginFailure({required this.message});
}

// ✅ أضف هذه الحالات الجديدة
class ForgotPasswordLoading extends LoginState {}
class ForgotPasswordSuccess extends LoginState {
  final String phone;
  final String otp;
  ForgotPasswordSuccess({required this.phone, required this.otp});
}

class ResetPasswordLoading extends LoginState {}
class ResetPasswordSuccess extends LoginState {}
class ResetPasswordFailure extends LoginState {
  final String message;
  ResetPasswordFailure({required this.message});
}


// Forgot/Reset states
class RequestResetLoading extends LoginState {}
class RequestResetSuccess extends LoginState {}
class RequestResetFailure extends LoginState {
  final String message;
  RequestResetFailure({required this.message});
}

class VerifyResetLoading extends LoginState {}
class VerifyResetSuccess extends LoginState {}
class VerifyResetFailure extends LoginState {
  final String message;
  VerifyResetFailure({required this.message});
}

class SubmitNewPasswordLoading extends LoginState {}
class SubmitNewPasswordSuccess extends LoginState {}
class SubmitNewPasswordFailure extends LoginState {
  final String message;
  SubmitNewPasswordFailure({required this.message});
}