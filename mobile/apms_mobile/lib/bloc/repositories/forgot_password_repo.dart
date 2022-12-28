import 'dart:convert';

import 'package:http/http.dart';

import '../../constants/apis.dart' as apis;

class ForgotPasswordRepo {
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final Uri api = Uri.parse("${apis.forgotPassword}/$phoneNumber");
    Response res = await get(api);

    if (res.statusCode == 200) {
      Map body = json.decode(res.body);
      return body['data'];
    }
    return false;
  }

  Future<bool> createNewPassword(String phoneNumber, String password) async {
    final Uri api = Uri.parse(apis.createNewPassword);
    Map<String, String> headers = apis.headers;
    
    // request body
    Map<String, String> body = {
      "phoneNumber": phoneNumber,
      "password": password
    };
    final requestBody = json.encode(body);
    Response res = await put(api, headers: headers, body: requestBody);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
