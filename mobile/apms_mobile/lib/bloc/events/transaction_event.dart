part of '../transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionHistory extends TransactionEvent {
  final String from;
  final String to;
  final String typeValue;
  final int pageIndex;
  final bool loadMore;

  const GetTransactionHistory(
      this.from, this.to, this.typeValue, this.pageIndex, this.loadMore);

  @override
  List<Object> get props => [from, to, typeValue, pageIndex, loadMore];
}

class ChangeHistoryDate extends TransactionEvent{}

class ChangeTransactionType extends TransactionEvent{}
