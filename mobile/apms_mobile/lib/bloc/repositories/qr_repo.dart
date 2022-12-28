import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/qr_model.dart';
import '../../constants/apis.dart' as apis;

class QrRepo {
  Map<String, String> headers = apis.headers;

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token')!;
  }

  Future<String> checkIn(Qr qr) async {
    String token = await getToken();
    Object body = {
      "plateNumber": qr.plate,
      "plateNumberImageUrl": qr.firebaseUrl,
      "carParkId": qr.carParkId
    };
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    String jsonString = json.encode(body);
    Uri uri = Uri.parse(apis.checkIn);
    Response result = await post(uri, headers: headers, body: jsonString);
    if (result.statusCode == 201) {
      Map body = json.decode(result.body);
      return body['message'];
    } else {
      return result.body.toString();
    }
  }

  Future<String> checkOut(Qr qr) async {
    String token = await getToken();
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    Map<String, String> body = {
      "plateNumber": qr.plate!,
      "picOutUrl": qr.firebaseUrl!,
      "carParkId": qr.carParkId!
    };
    String jsonString = json.encode(body);
    Uri uri = Uri.parse(apis.checkOut);
    Response result = await put(uri, headers: headers, body: jsonString);
    if (result.statusCode == 200) {
      Map body = json.decode(result.body);
      return body['message'];
    } else {
      return result.body.toString();
    }
  }
}
