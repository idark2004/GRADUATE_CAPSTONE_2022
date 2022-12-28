part of '../login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LogedIn extends LoginState{
}

class Logingin extends LoginState{}

class LoginError extends LoginState {}