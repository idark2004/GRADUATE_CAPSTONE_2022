import 'dart:convert';
import 'dart:async';

import 'package:apms_mobile/exceptions/exception.dart';
import 'package:apms_mobile/utils/utils.dart';
import 'package:apms_mobile/models/ticket_model.dart';

import '../../constants/paths.dart' as paths;
import 'package:http/http.dart' as http;

class BookingRepo {
  Future<TicketPreview> fectchTicketPreview(
      String plateNumber, DateTime arrivalTime, String carParkId) async {
    final getTicketPreview =
        Uri.http(paths.authority, "${paths.tickets}/preview");
    var body = json.encode({
      "plateNumber": plateNumber,
      "arriveTime": arrivalTime.toIso8601String(),
      "carParkId": carParkId
    });
    final headers = await Utils().getHeaderValues();

    final response =
        await http.post(getTicketPreview, headers: headers, body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      TicketPreview ticketPreview = TicketPreview.fromJson(body["data"]);
      return ticketPreview;
    } else {
      throw HttpException(response.body);
    }
  }

  Future<Map<String, dynamic>> bookParkingSlot(
      String plateNumber, DateTime arrivalTime, String carParkId) async {
    final headers = await Utils().getHeaderValues();
    final getTicketPreview = Uri.http(paths.authority, paths.tickets);
    var body = json.encode({
      "plateNumber": plateNumber,
      "arriveTime": arrivalTime.toIso8601String(),
      "carParkId": carParkId
    });

    final response =
        await http.post(getTicketPreview, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
    return jsonDecode(response.body);
  }

  Future<List<String>> getPreviouslyUsedPlateNumbersList() async {
    final headers = await Utils().getHeaderValues();
    final getPlateNumbersList =
        Uri.http(paths.authority, "${paths.licensePlates}/used-plate-numbers");

    final response = await http.get(getPlateNumbersList, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<String> plateNumbersList =
          List<String>.from(body["data"]["plateNumbers"]);
      return plateNumbersList;
    } else {
      throw Exception('Failed to load list');
    }
  }
}
