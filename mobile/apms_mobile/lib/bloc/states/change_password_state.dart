part of '../change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangingPassword extends ChangePasswordState {}

class PasswordChanged extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String error;

  const ChangePasswordError(this.error);
}
