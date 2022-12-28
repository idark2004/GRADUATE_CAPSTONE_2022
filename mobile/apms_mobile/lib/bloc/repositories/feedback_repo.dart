import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apis.dart' as apis;

class FeedbackRepo {
  Future<String> sendFeedback(String description) async {
    final Uri api = Uri.parse(apis.feedback);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    Map<String, String> headers = apis.headers;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    // request body
    Map<String, String> body = {"description": description};
    final requestBody = json.encode(body);
    Response res = await post(api, headers: headers, body: requestBody);

    if (res.statusCode == 201) {
      Map resBody = json.decode(res.body);
      return resBody['message'];
    } else {
      return res.body.toString();
    }
  }
}
