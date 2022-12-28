part of '../transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class GettingTransactionList extends TransactionState {}

class GotTransactionList extends TransactionState {
  final TransactionModel model;

  const GotTransactionList(this.model);

  @override
  List<Object> get props => [model];
}

class TransactionListError extends TransactionState {}
