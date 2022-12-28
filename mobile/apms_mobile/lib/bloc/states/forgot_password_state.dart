part of '../forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class CheckingPhoneNumber extends ForgotPasswordState {}

class PhoneNumberExist extends ForgotPasswordState {}

class PhoneNumberNotExist extends ForgotPasswordState {}

class CreatingNewPassword extends ForgotPasswordState {}

class NewPasswordCreated extends ForgotPasswordState {}

class CreateNewPasswordError extends ForgotPasswordState {}

class PhoneNumberError extends ForgotPasswordState {
  final String error;

  const PhoneNumberError(this.error);

  @override
  List<Object> get props => [error];
}
