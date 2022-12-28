import 'package:apms_mobile/bloc/repositories/booking_repo.dart';
import 'package:apms_mobile/models/ticket_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/booking_event.dart';
part 'states/booking_state.dart';

final BookingRepo repo = BookingRepo();

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<BookingFieldInitial>(_fetchPreviouslyUsedPlateNumbersList);
    on<SubmitBookingFormStep1>(_fetchBookingConfirmationScreen);
    on<SubmitBookingFormStep2>(_submitBookingForm);
  }

  _fetchBookingConfirmationScreen(
      SubmitBookingFormStep1 event, Emitter<BookingState> emit) async {
    emit(BookingPreviewFetching());
    try {
      TicketPreview ticketPreview = await repo.fectchTicketPreview(
          event.plateNumber, event.arrivalTime, event.carParkId);
      emit(BookingPreviewFetchedSuccessfully(ticketPreview));
    } catch (e) {
      emit(BookingPreviewFetchedFailed(e.toString()));
    }
  }

  _submitBookingForm(
      SubmitBookingFormStep2 event, Emitter<BookingState> emit) async {
    try {
      emit(BookingSubmitting());
      await repo.bookParkingSlot(
          event.plateNumber, event.arrivalTime, event.carParkId);
      emit(BookingSubmittedSuccessfully());
    } catch (e) {
      emit(BookingSubmittedFailed(e.toString()));
    }
  }

  _fetchPreviouslyUsedPlateNumbersList(
      BookingFieldInitial event, Emitter<BookingState> emit) async {
    emit(UsedPlateNumbersFetching());
    List<String> plateNumbers = await repo.getPreviouslyUsedPlateNumbersList();
    emit(UsedPlateNumbersFetchedSuccessfully(plateNumbers));
  }
}
