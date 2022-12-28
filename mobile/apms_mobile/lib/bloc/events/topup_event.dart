part of '../topup_bloc.dart';

abstract class TopupEvent extends Equatable {
  const TopupEvent();

  @override
  List<Object> get props => [];
}

class FetchExchangeRate extends TopupEvent {}

class MakeTopupTransaction extends TopupEvent {
  final int amount;
  const MakeTopupTransaction(this.amount);
}
