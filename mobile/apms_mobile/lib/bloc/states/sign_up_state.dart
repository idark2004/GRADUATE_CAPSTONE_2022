part of '../sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SigningUp extends SignUpState {}

class SignedUp extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError(this.message);

  @override
  List<Object> get props => [message];
}
