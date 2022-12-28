import 'dart:convert';
import 'dart:io';

import 'package:apms_mobile/models/ticket_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/apis.dart' as apis;

class TicketRepo {
  Future<TicketModel?> getHistory(String from, String to, String plateNumber,
      String statusValue, int pageIndex) async {
    //Get token
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    // Map of status
    Map<int, String> statusList = {
      0: "Booking",
      1: "Parking",
      2: "Done",
      -1: "Cancel"
    };
    // Get key of status based on value
    int status =
        statusList.keys.firstWhere((e) => statusList[e] == statusValue);
    //Request params
    var request = {
      "from": from,
      "to": to,
      "plateNumber": plateNumber,
      "status": status.toString(),
      "pageSize": "4",
      "pageIndex": pageIndex.toString(),
      "includeCarPark": "true",
      "includePriceTable": "false"
    };
    final Uri url = Uri.parse(apis.history).replace(queryParameters: request);
    Map<String, String> headers = apis.headers;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    Response res = await get(url, headers: headers);
    if (res.statusCode == 200) {
      Map body = json.decode(res.body);
      final TicketModel ticket = TicketModel.fromJson(body['data']);
      return ticket;
    }
    return null;
  }

  Future<bool> cancelBooking(String ticketId) async {
    final Uri url = Uri.parse("${apis.tickets}/$ticketId");
    //Get token
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    Map<String, String> headers = apis.headers;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    Response res = await delete(url, headers: headers);
    if (res.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
