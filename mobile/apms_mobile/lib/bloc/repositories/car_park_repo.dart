import 'dart:convert';
import 'dart:async';

import 'package:apms_mobile/models/car_park_model.dart';
import 'package:apms_mobile/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/paths.dart' as paths;
import 'package:http/http.dart' as http;

class CarParkRepo {
  Future<List<CarParkModel>> fetchCarParkList(
      CarParkSearchQuery searchQuery) async {
    var queryParameters = searchQuery.toJson();
    final getCarParksUri =
        Uri.http(paths.authority, paths.carPark, queryParameters);
    final headers = await Utils().getHeaderValues();
    final response = await http.get(getCarParksUri, headers: headers);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> carParkListDynamic = body["data"]["carParks"];
      // Convert to list of carParks
      List<CarParkModel> carParkList = carParkListDynamic
          .map((e) => CarParkModel.fromJson(e))
          .toList()
          .cast<CarParkModel>();
      return carParkList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load list');
    }
  }

  Future<Position> fetchUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<CarParkModel>> fetchRecentlyVisitedCarParkList() async {
    var queryParameters = {
      "pageSize": "4",
      "pageIndex": "1",
      "includeConfig": "true"
    };
    final getCarParksUri = Uri.http(
        paths.authority, "${paths.carPark}/most-used", queryParameters);
    final headers = await Utils().getHeaderValues();
    final response = await http.get(getCarParksUri, headers: headers);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> carParkListDynamic = body["data"]["carParks"];
      // Convert to list of carParks
      List<CarParkModel> carParkList = carParkListDynamic
          .map((e) => CarParkModel.fromJson(e))
          .toList()
          .cast<CarParkModel>();
      return carParkList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load list');
    }
  }
}
