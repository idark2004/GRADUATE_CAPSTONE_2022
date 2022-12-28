import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apis.dart' as apis;
import 'dart:convert';

class ChangePasswordRepo {
  Future<String> changePassword(String oldPassword, String newPassword) async {
    final Uri api = Uri.parse(apis.changePassword);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    Map<String, String> headers = apis.headers;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    // request body
    Map<String, String> body = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": newPassword
    };
    final requestBody = json.encode(body);

    Response res = await patch(api, headers: headers, body: requestBody);

    if (res.statusCode == 204) {
      return "Change password successfully!";
    } else {
      return res.body.toString();
    }
  }
}
