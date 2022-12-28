part of '../car_park_bloc.dart';

abstract class CarParkState extends Equatable {
  const CarParkState();

  @override
  List<Object> get props => [];
}

class CarParkInitial extends CarParkState {}

class CarParkFetching extends CarParkState {}

class CarParkFetchedSuccessfully extends CarParkState {
  final List<CarParkModel> carParkList;
  const CarParkFetchedSuccessfully(this.carParkList);
}

class CarParkFetchedFailed extends CarParkState {
  final String? message;
  const CarParkFetchedFailed(this.message);
}

class CarParkSearchQueryUpdating extends CarParkState {}

class CarParkSearchQueryUpdatedFailed extends CarParkState {}

class CarParkSearchQueryUpdatedSuccessfully extends CarParkState {}

class UserLocationInitial extends CarParkState {}

class UserLocationFetching extends CarParkState {}

class UserLocationFetchedSuccessfully extends CarParkState {
  final Position userLocation;
  final List<Placemark> userPlacemark;

  const UserLocationFetchedSuccessfully(this.userLocation, this.userPlacemark);

  @override
  List<Object> get props => [userLocation, userPlacemark];
}

class UserLocationFetchedFailed extends CarParkState {
  final String message =
      "Failed to get current location, please enable neccessary persmissions and try again!";
  @override
  List<Object> get props => [message];
}

class RecentlyVisitedCarParkListFetching extends CarParkState {}

class RecentlyVisitedCarParkListFetchedSuccessfully extends CarParkState {
  final List<CarParkModel> recentlyVisitedCarParkList;
  const RecentlyVisitedCarParkListFetchedSuccessfully(
      this.recentlyVisitedCarParkList);
}

class RecentlyVisitedCarParkListFetchedFailed extends CarParkState {}
