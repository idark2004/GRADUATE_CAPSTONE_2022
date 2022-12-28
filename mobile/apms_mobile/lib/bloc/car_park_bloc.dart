
import 'package:apms_mobile/bloc/repositories/car_park_repo.dart';
import 'package:apms_mobile/models/car_park_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'events/car_park_event.dart';
part 'states/car_park_state.dart';

final CarParkRepo repo = CarParkRepo();

class CarParkBloc extends Bloc<CarParkEvent, CarParkState> {
  CarParkBloc() : super(CarParkInitial()) {
    on<GetCarParkList>(_fetchCarParkList);
    on<GetUserLocation>(_fetchUserLocation);
    on<UpdateCarParkSearchQuery>(_updateCarParkSearchQuery);
    on<GetRecentlyVisitedCarParkList>(_fetchRecentlyVisitedCarParkList);
  }

  _fetchCarParkList(GetCarParkList event, Emitter<CarParkState> emit) async {
    emit(CarParkFetching());
    List<CarParkModel> result = await repo.fetchCarParkList(event.searchQuery);
    emit((CarParkFetchedSuccessfully(result)));
  }

  _fetchUserLocation(GetUserLocation event, Emitter<CarParkState> emit) async {
    Position userLocation;
    List<Placemark> userPlacemark;
    try {
      emit(UserLocationFetching());
      userLocation = await repo.fetchUserLocation();
      userPlacemark = await placemarkFromCoordinates(
          userLocation.latitude, userLocation.longitude);
      emit(UserLocationFetchedSuccessfully(userLocation, userPlacemark));
    } catch (e) {
      emit(UserLocationFetchedFailed());
    }
  }

  _updateCarParkSearchQuery(
      UpdateCarParkSearchQuery event, Emitter<CarParkState> emit) {
    try {
      emit(CarParkSearchQueryUpdating());
      var additionalData = event.updatedQueryData;
      event.searchQuery.name = additionalData["name"] ?? event.searchQuery.name;
      event.searchQuery.latitude ??= additionalData["latitude"];
      event.searchQuery.longitude ??= additionalData["longitude"];
      emit(CarParkSearchQueryUpdatedSuccessfully());
    } catch (e) {
      emit(CarParkSearchQueryUpdatedFailed());
    }
  }

  _fetchRecentlyVisitedCarParkList(
      GetRecentlyVisitedCarParkList event, Emitter<CarParkState> emit) async {
    try {
      emit(RecentlyVisitedCarParkListFetching());
      List<CarParkModel> result = await repo.fetchRecentlyVisitedCarParkList();
      emit((RecentlyVisitedCarParkListFetchedSuccessfully(result)));
    } catch (e) {
      emit(RecentlyVisitedCarParkListFetchedFailed());
    }
  }
}
