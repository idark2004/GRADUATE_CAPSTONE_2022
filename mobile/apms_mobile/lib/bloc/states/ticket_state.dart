part of '../ticket_bloc.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final TicketModel ticket;

  const TicketLoaded(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class TicketError extends TicketState {
  final String? message;

  const TicketError(this.message);
}

class TicketDateChanged extends TicketState{}

class TicketCanceled extends TicketState{}

class TicketCanceling extends TicketState{}
