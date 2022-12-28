part of '../booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class ArrivalDateSelected extends BookingEvent {}

class ArrivalTimeSelected extends BookingEvent {}

class BookingFieldInitial extends BookingEvent {}

class PlateNumberFieldFocus extends BookingEvent {}

// At this step, only a confirmation screen will be shown
class SubmitBookingFormStep1 extends BookingEvent {
  final String plateNumber;
  final DateTime arrivalTime;
  final String carParkId;

  const SubmitBookingFormStep1(
      this.plateNumber, this.arrivalTime, this.carParkId);
  @override
  List<Object> get props => [plateNumber, arrivalTime, carParkId];
}

class SubmitBookingFormStep2 extends BookingEvent {
  final String plateNumber;
  final DateTime arrivalTime;
  final String carParkId;

  const SubmitBookingFormStep2(
      this.plateNumber, this.arrivalTime, this.carParkId);
  @override
  List<Object> get props => [plateNumber, arrivalTime, carParkId];
}
