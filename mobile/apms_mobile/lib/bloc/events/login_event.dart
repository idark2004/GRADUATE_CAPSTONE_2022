part of '../login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSumitting extends LoginEvent {
  final String phoneNumber;
  final String password;

  const LoginSumitting(this.phoneNumber, this.password);

  @override
  List<Object> get props => [phoneNumber, password];
}

