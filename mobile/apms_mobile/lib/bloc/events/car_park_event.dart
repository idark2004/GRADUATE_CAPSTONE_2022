part of '../car_park_bloc.dart';

abstract class CarParkEvent extends Equatable {
  const CarParkEvent();

  @override
  List<Object> get props => [];
}

class GetCarParkList extends CarParkEvent {
  final CarParkSearchQuery searchQuery;

  const GetCarParkList(this.searchQuery);

  @override
  List<Object> get props => [];
}

class GetRecentlyVisitedCarParkList extends CarParkEvent {}

class UpdateCarParkSearchQuery extends CarParkEvent {
  final CarParkSearchQuery searchQuery;
  final Map<String, dynamic> updatedQueryData;

  const UpdateCarParkSearchQuery(this.searchQuery, this.updatedQueryData);

  @override
  List<Object> get props => [searchQuery, updatedQueryData];
}

class GetUserLocation extends CarParkEvent {
  const GetUserLocation();

  @override
  List<Object> get props => [];
}
