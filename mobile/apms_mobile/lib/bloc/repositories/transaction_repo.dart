import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/apis.dart' as apis;
import '../../models/transaction_model.dart';

class TransactionRepo {
  Future<TransactionModel?> getList(
      String from, String to, String typeValue, int pageIndex) async {
    //Get token
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    // Map of status
    Map<int, String> typeList = {
      0: "Top-up",
      1: "Booking",
      2: "Parking Fee",
    };
    int status = 0;
    if (typeValue != "All") {
      status = typeList.keys.firstWhere((e) => typeList[e] == typeValue);
    }
    var request = {
      "from": from,
      "to": to,
      "type": typeValue != "All" ? status.toString() : "",
      "pageSize": "10",
      "pageIndex": pageIndex.toString(),
    };
    final Uri url =
        Uri.parse(apis.transactionHistory).replace(queryParameters: request);
    Map<String, String> headers = apis.headers;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    Response res = await get(url, headers: headers);
    if (res.statusCode == 200) {
      Map body = json.decode(res.body);
      final TransactionModel transactions =
          TransactionModel.fromJson(body['data']);
      return transactions;
    }
    return null;
  }
}
