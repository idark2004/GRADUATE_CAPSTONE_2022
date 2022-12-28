part of '../change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class SubmittingPasswordChange extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const SubmittingPasswordChange(this.oldPassword, this.newPassword);
  
  @override
  List<Object> get props => [oldPassword, newPassword];
}
