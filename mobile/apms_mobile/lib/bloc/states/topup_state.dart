part of '../topup_bloc.dart';

abstract class TopupState extends Equatable {
  const TopupState();

  @override
  List<Object> get props => [];
}

class TopupInitial extends TopupState {}

class ExchangeRateFetching extends TopupState {}

class ExchangeRateFetchedFailed extends TopupState {}

class ExchangeRateFetchedSuccessfully extends TopupState {
  final int exchangeRate;
  const ExchangeRateFetchedSuccessfully(this.exchangeRate);
}

class TopupTransactionProcessing extends TopupState {}

class TopupTransactionProcessedFailed extends TopupState {}

class TopupTransactionProcessedSuccessfully extends TopupState {
  final String message;
  const TopupTransactionProcessedSuccessfully(this.message);
}
