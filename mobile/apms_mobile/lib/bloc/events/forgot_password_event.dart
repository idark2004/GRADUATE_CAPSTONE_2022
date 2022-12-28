part of '../forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmitPhoneNumber extends ForgotPasswordEvent {
  final String phoneNumber;

  const SubmitPhoneNumber(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class SubmitNewPassword extends ForgotPasswordEvent {
  final String phoneNumber;
  final String password;

  const SubmitNewPassword(this.phoneNumber, this.password);

  @override
  List<Object> get props => [phoneNumber,password];
}
