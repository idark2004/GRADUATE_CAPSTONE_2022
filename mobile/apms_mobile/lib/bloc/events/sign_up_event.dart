part of '../sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmiting extends SignUpEvent {
  final String phoneNumber;
  final String password;
  final String fullName;

  const SignUpSubmiting(this.phoneNumber, this.password, this.fullName);

  @override
  List<Object> get props => [phoneNumber,password,fullName];
}
