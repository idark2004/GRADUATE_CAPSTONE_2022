part of '../ticket_bloc.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class GetTicketList extends TicketEvent {
  final String from;
  final String to;
  final String plateNumber;
  final String statusValue;
  final int pageIndex;
  final bool loadMore;

  const GetTicketList(this.from, this.to, this.plateNumber, this.statusValue,
      this.pageIndex, this.loadMore);

  @override
  List<Object> get props => [from, to, plateNumber, statusValue,
      pageIndex, loadMore];
}

class ChangeTicketDate extends TicketEvent {}

class CancelBooking extends TicketEvent {
  final String ticketId;

  const CancelBooking(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}
