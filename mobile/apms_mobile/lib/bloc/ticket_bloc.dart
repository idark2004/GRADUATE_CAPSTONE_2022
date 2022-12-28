import 'package:apms_mobile/bloc/repositories/ticket_repo.dart';
import 'package:apms_mobile/models/ticket_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/ticket_event.dart';
part 'states/ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepo _repo;
  TicketBloc(this._repo) : super(TicketInitial()) {
    on<GetTicketList>(_getTicketList);
    on<ChangeTicketDate>((event, emit) => emit(TicketInitial()));
    on<CancelBooking>(_cancelBooking);
  }

  _getTicketList(GetTicketList event, Emitter<TicketState> emit) async {
    !event.loadMore ? emit(TicketLoading()) : "";
    List ticketModel = await Future.wait([
      _repo.getHistory(event.from, event.to, event.plateNumber,
          event.statusValue, event.pageIndex)
    ]);

    emit(TicketLoaded(ticketModel[0]));
  }

  _cancelBooking(CancelBooking event, Emitter<TicketState> emit) async {
    emit(TicketCanceling());
    List result = await Future.wait([_repo.cancelBooking(event.ticketId)]);
    if (result[0]) {
      emit(TicketCanceled());
    } else {
      emit(const TicketError('Cannot cancel booking'));
    }
  }
}
