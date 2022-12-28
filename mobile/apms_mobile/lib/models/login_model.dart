// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String phoneNumber;
  final String password;
  String? error;

  LoginModel(this.phoneNumber, this.password);

  LoginModel.withError(
      {String errorMessage = '', this.phoneNumber = '', this.password = ''}) {
    error = errorMessage;
  }

  Map toJson() => {"phoneNumber": phoneNumber, "password": password};

  @override
  List<Object?> get props => [];
}
